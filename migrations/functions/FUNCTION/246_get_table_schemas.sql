CREATE FUNCTION public.get_table_schemas() RETURNS TABLE(table_name text, column_count bigint, row_estimate bigint, table_size text, total_size text, schema_ddl text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  rec RECORD;
  col RECORD;
  con RECORD;
  idx RECORD;
  trg RECORD;
  pol RECORD;
  ddl text;
  col_line text;
  first_col boolean;
  tbl_oid oid;
  rls_enabled boolean;
BEGIN
  FOR rec IN
    SELECT
      t.tablename::text AS tname,
      (SELECT count(*) FROM information_schema.columns c WHERE c.table_schema = 'public' AND c.table_name = t.tablename) AS col_cnt,
      COALESCE(s.n_live_tup, 0) AS row_est,
      pg_size_pretty(pg_table_size(('public.' || quote_ident(t.tablename))::regclass)) AS tbl_size,
      pg_size_pretty(pg_total_relation_size(('public.' || quote_ident(t.tablename))::regclass)) AS tot_size
    FROM pg_tables t
    LEFT JOIN pg_stat_user_tables s ON s.schemaname = 'public' AND s.relname = t.tablename
    WHERE t.schemaname = 'public'
    ORDER BY pg_total_relation_size(('public.' || quote_ident(t.tablename))::regclass) DESC
  LOOP
    -- Get table OID
    tbl_oid := ('public.' || quote_ident(rec.tname))::regclass::oid;

    -- ==================== COLUMNS ====================
    ddl := 'CREATE TABLE public.' || quote_ident(rec.tname) || ' (' || E'\n';
    first_col := true;

    FOR col IN
      SELECT
        c.column_name,
        c.data_type,
        c.character_maximum_length,
        c.column_default,
        c.is_nullable,
        c.udt_name
      FROM information_schema.columns c
      WHERE c.table_schema = 'public' AND c.table_name = rec.tname
      ORDER BY c.ordinal_position
    LOOP
      IF NOT first_col THEN
        ddl := ddl || ',' || E'\n';
      END IF;
      first_col := false;

      col_line := '  ' || quote_ident(col.column_name) || ' ';

      IF col.data_type = 'USER-DEFINED' THEN
        col_line := col_line || col.udt_name;
      ELSIF col.data_type = 'character varying' THEN
        IF col.character_maximum_length IS NOT NULL THEN
          col_line := col_line || 'varchar(' || col.character_maximum_length || ')';
        ELSE
          col_line := col_line || 'varchar';
        END IF;
      ELSIF col.data_type = 'ARRAY' THEN
        col_line := col_line || col.udt_name;
      ELSE
        col_line := col_line || col.data_type;
      END IF;

      IF col.is_nullable = 'NO' THEN
        col_line := col_line || ' NOT NULL';
      END IF;

      IF col.column_default IS NOT NULL THEN
        col_line := col_line || ' DEFAULT ' || col.column_default;
      END IF;

      ddl := ddl || col_line;
    END LOOP;

    -- ==================== TABLE CONSTRAINTS (PK, UNIQUE, FK, CHECK) ====================
    FOR con IN
      SELECT
        pg_get_constraintdef(c2.oid, true) AS condef,
        c2.conname,
        c2.contype
      FROM pg_constraint c2
      WHERE c2.conrelid = tbl_oid
      ORDER BY
        CASE c2.contype WHEN 'p' THEN 1 WHEN 'u' THEN 2 WHEN 'f' THEN 3 WHEN 'c' THEN 4 ELSE 5 END,
        c2.conname
    LOOP
      ddl := ddl || ',' || E'\n' || '  CONSTRAINT ' || quote_ident(con.conname) || ' ' || con.condef;
    END LOOP;

    ddl := ddl || E'\n);';

    -- ==================== INDEXES (non-constraint) ====================
    FOR idx IN
      SELECT pg_get_indexdef(i.indexrelid) || ';' AS idxdef
      FROM pg_index i
      JOIN pg_class ic ON ic.oid = i.indexrelid
      WHERE i.indrelid = tbl_oid
        AND NOT i.indisprimary
        AND NOT i.indisunique
      ORDER BY ic.relname
    LOOP
      ddl := ddl || E'\n' || idx.idxdef;
    END LOOP;

    -- Also include unique indexes that are NOT backing a constraint
    FOR idx IN
      SELECT pg_get_indexdef(i.indexrelid) || ';' AS idxdef
      FROM pg_index i
      JOIN pg_class ic ON ic.oid = i.indexrelid
      WHERE i.indrelid = tbl_oid
        AND i.indisunique
        AND NOT i.indisprimary
        AND NOT EXISTS (
          SELECT 1 FROM pg_constraint pgc
          WHERE pgc.conindid = i.indexrelid
        )
      ORDER BY ic.relname
    LOOP
      ddl := ddl || E'\n' || idx.idxdef;
    END LOOP;

    -- ==================== TRIGGERS ====================
    FOR trg IN
      SELECT pg_get_triggerdef(t2.oid, true) || ';' AS trgdef
      FROM pg_trigger t2
      WHERE t2.tgrelid = tbl_oid
        AND NOT t2.tgisinternal
      ORDER BY t2.tgname
    LOOP
      ddl := ddl || E'\n\n' || trg.trgdef;
    END LOOP;

    -- ==================== RLS POLICIES ====================
    SELECT c3.relrowsecurity INTO rls_enabled
    FROM pg_class c3
    WHERE c3.oid = tbl_oid;

    IF rls_enabled THEN
      ddl := ddl || E'\n\n' || 'ALTER TABLE public.' || quote_ident(rec.tname) || ' ENABLE ROW LEVEL SECURITY;';

      FOR pol IN
        SELECT
          p.polname,
          CASE p.polcmd
            WHEN 'r' THEN 'SELECT'
            WHEN 'a' THEN 'INSERT'
            WHEN 'w' THEN 'UPDATE'
            WHEN 'd' THEN 'DELETE'
            WHEN '*' THEN 'ALL'
          END AS cmd,
          CASE p.polpermissive WHEN true THEN 'PERMISSIVE' ELSE 'RESTRICTIVE' END AS permissive,
          pg_get_expr(p.polqual, p.polrelid, true) AS using_expr,
          pg_get_expr(p.polwithcheck, p.polrelid, true) AS check_expr,
          ARRAY(
            SELECT rolname FROM pg_roles WHERE oid = ANY(p.polroles)
          ) AS roles
        FROM pg_policy p
        WHERE p.polrelid = tbl_oid
        ORDER BY p.polname
      LOOP
        ddl := ddl || E'\n' || 'CREATE POLICY ' || quote_ident(pol.polname)
          || ' ON public.' || quote_ident(rec.tname);

        IF pol.permissive = 'RESTRICTIVE' THEN
          ddl := ddl || ' AS RESTRICTIVE';
        END IF;

        ddl := ddl || ' FOR ' || pol.cmd;

        IF array_length(pol.roles, 1) IS NOT NULL AND pol.roles != ARRAY['public']::name[] THEN
          ddl := ddl || ' TO ' || array_to_string(pol.roles, ', ');
        END IF;

        IF pol.using_expr IS NOT NULL THEN
          ddl := ddl || E'\n  USING (' || pol.using_expr || ')';
        END IF;

        IF pol.check_expr IS NOT NULL THEN
          ddl := ddl || E'\n  WITH CHECK (' || pol.check_expr || ')';
        END IF;

        ddl := ddl || ';';
      END LOOP;
    END IF;

    table_name := rec.tname;
    column_count := rec.col_cnt;
    row_estimate := rec.row_est;
    table_size := rec.tbl_size;
    total_size := rec.tot_size;
    schema_ddl := ddl;
    RETURN NEXT;
  END LOOP;
END;
$$;


--
-- Name: get_task_dashboard(text, uuid); Type: FUNCTION; Schema: public; Owner: -
--

