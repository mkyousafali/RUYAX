CREATE FUNCTION public.get_edge_functions() RETURNS TABLE(func_name text, func_size text, file_count integer, last_modified timestamp with time zone, has_index boolean, func_code text)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT func_name, func_size, file_count, last_modified, has_index, func_code
  FROM public.edge_functions_cache
  ORDER BY func_name;
$$;


--
-- Name: get_employee_basic_hours(bigint); Type: FUNCTION; Schema: public; Owner: -
--

