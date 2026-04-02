CREATE FUNCTION public.get_database_functions() RETURNS TABLE(func_name text, func_args text, return_type text, func_language text, func_type text, is_security_definer boolean, func_definition text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $_$
DECLARE
  rec RECORD;
  ddl text;
  arg_list text;
  ret text;
BEGIN
  FOR rec IN
    SELECT
      p.oid,
      p.proname::text AS fname,
      pg_get_function_arguments(p.oid) AS fargs,
      pg_get_function_result(p.oid) AS fresult,
      l.lanname::text AS flang,
      CASE p.prokind
        WHEN 'f' THEN 'FUNCTION'
        WHEN 'p' THEN 'PROCEDURE'
        WHEN 'a' THEN 'AGGREGATE'
        WHEN 'w' THEN 'WINDOW'
        ELSE 'FUNCTION'
      END AS ftype,
      p.prosecdef AS secdef,
      p.prosrc AS fsrc,
      p.proretset,
      p.provolatile,
      p.proisstrict
    FROM pg_proc p
    JOIN pg_namespace n ON n.oid = p.pronamespace
    JOIN pg_language l ON l.oid = p.prolang
    WHERE n.nspname = 'public'
    ORDER BY p.proname
  LOOP
    -- Build CREATE OR REPLACE
    ddl := 'CREATE OR REPLACE ' || rec.ftype || ' public.' || quote_ident(rec.fname) || '(' || rec.fargs || ')' || E'\n';
    ddl := ddl || 'RETURNS ' || rec.fresult || E'\n';
    ddl := ddl || 'LANGUAGE ' || rec.flang || E'\n';

    -- Volatility
    IF rec.provolatile = 'i' THEN
      ddl := ddl || 'IMMUTABLE' || E'\n';
    ELSIF rec.provolatile = 's' THEN
      ddl := ddl || 'STABLE' || E'\n';
    END IF;

    IF rec.proisstrict THEN
      ddl := ddl || 'STRICT' || E'\n';
    END IF;

    IF rec.secdef THEN
      ddl := ddl || 'SECURITY DEFINER' || E'\n';
    END IF;

    ddl := ddl || 'AS $func$' || E'\n' || rec.fsrc || E'\n' || '$func$;';

    func_name := rec.fname;
    func_args := rec.fargs;
    return_type := rec.fresult;
    func_language := rec.flang;
    func_type := rec.ftype;
    is_security_definer := rec.secdef;
    func_definition := ddl;
    RETURN NEXT;
  END LOOP;
END;
$_$;


--
-- Name: get_database_schema(); Type: FUNCTION; Schema: public; Owner: -
--

