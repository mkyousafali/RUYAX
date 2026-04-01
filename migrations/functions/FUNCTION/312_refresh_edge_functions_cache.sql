CREATE FUNCTION public.refresh_edge_functions_cache(p_functions jsonb) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  DELETE FROM public.edge_functions_cache;
  INSERT INTO public.edge_functions_cache (func_name, func_size, file_count, last_modified, has_index, func_code)
  SELECT
    (f->>'func_name')::text,
    (f->>'func_size')::text,
    (f->>'file_count')::int,
    to_timestamp((f->>'last_modified')::bigint),
    (f->>'has_index')::boolean,
    (f->>'func_code')::text
  FROM jsonb_array_elements(p_functions) AS f;
END;
$$;


--
-- Name: refresh_expiry_cache(); Type: FUNCTION; Schema: public; Owner: -
--

