CREATE FUNCTION public.get_database_schema() RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  result jsonb;
BEGIN
  -- Get basic table and column information only
  SELECT jsonb_build_object(
    'tables', jsonb_agg(
      jsonb_build_object(
        'table_name', table_info.table_name,
        'columns', table_info.columns
      ) ORDER BY table_info.table_name
    )
  ) INTO result
  FROM (
    SELECT 
      t.table_name,
      jsonb_agg(
        jsonb_build_object(
          'column_name', c.column_name,
          'data_type', c.data_type,
          'is_nullable', c.is_nullable,
          'column_default', c.column_default
        ) ORDER BY c.ordinal_position
      ) as columns
    FROM information_schema.tables t
    LEFT JOIN information_schema.columns c 
      ON c.table_schema = t.table_schema 
      AND c.table_name = t.table_name
    WHERE t.table_schema = 'public'
      AND t.table_type = 'BASE TABLE'
    GROUP BY t.table_name
  ) as table_info;

  RETURN result;
END;
$$;


--
-- Name: get_database_triggers(); Type: FUNCTION; Schema: public; Owner: -
--

