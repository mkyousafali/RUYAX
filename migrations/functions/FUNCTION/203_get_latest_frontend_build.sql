CREATE FUNCTION public.get_latest_frontend_build() RETURNS TABLE(id integer, version text, file_name text, file_size bigint, storage_path text, notes text, created_at timestamp with time zone, download_url text)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    SELECT 
        fb.id,
        fb.version,
        fb.file_name,
        fb.file_size,
        fb.storage_path,
        fb.notes,
        fb.created_at,
        '/storage/v1/object/public/frontend-builds/' || fb.storage_path as download_url
    FROM public.frontend_builds fb
    ORDER BY fb.created_at DESC
    LIMIT 1;
$$;


--
-- Name: get_lease_rent_properties_with_spaces(); Type: FUNCTION; Schema: public; Owner: -
--

