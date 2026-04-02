-- ═══ TABLES (CREATE TABLE IF NOT EXISTS) ═══
    -- Export all public tables with columns, defaults, NOT NULL, and primary keys
    FOR r IN
        SELECT c.relname AS table_name,
               c.oid AS table_oid,
               c.relrowsecurity AS rls_enabled
        FROM pg_class c
        JOIN pg_namespace n ON c.relnamespace = n.oid
        WHERE n.nspname = 'public'
          AND c.relkind = 'r' -- regular tables only
        ORDER BY c.relname
    LOOP
        DECLARE
            v_cols text := '';

v_tables := v_tables || 'CREATE TABLE IF NOT EXISTS public.' || quote_ident(r.table_name) || ' (' || E'\n';