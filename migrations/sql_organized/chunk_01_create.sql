-- chunk_01_create.sql

BEGIN
    -- ═══ SEQUENCES ═══
    -- Export all sequences in public schema (must come before tables that reference them)
    FOR r IN
        SELECT c.relname AS seq_name,
               s.seqtypid,
               pg_catalog.format_type(s.seqtypid, NULL) AS seq_type,
               s.seqstart, s.seqincrement, s.seqmin, s.seqmax, s.seqcache, s.seqcycle
        FROM pg_class c
        JOIN pg_namespace n ON c.relnamespace = n.oid
        JOIN pg_sequence s ON s.seqrelid = c.oid
        WHERE n.nspname = 'public'
          AND c.relkind = 'S' -- sequences
        ORDER BY c.relname
    LOOP
        v_sequences := v_sequences || format(
            'CREATE SEQUENCE IF NOT EXISTS public.%I AS %s INCREMENT BY %s MINVALUE %s MAXVALUE %s START WITH %s CACHE %s%s;',
            r.seq_name, r.seq_type, r.seqincrement, r.seqmin, r.seqmax, r.seqstart, r.seqcache,
            CASE WHEN r.seqcycle THEN ' CYCLE' ELSE '' END
        ) || E'\n';

v_tables := v_tables || 'CREATE TABLE IF NOT EXISTS public.' || quote_ident(r.table_name) || ' (' || E'\n';