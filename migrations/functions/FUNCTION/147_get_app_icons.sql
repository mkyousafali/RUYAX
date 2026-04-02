CREATE FUNCTION public.get_app_icons() RETURNS TABLE(id uuid, name text, icon_key text, category text, storage_path text, mime_type text, file_size bigint, description text, is_active boolean, created_at timestamp with time zone, updated_at timestamp with time zone)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    SELECT id, name, icon_key, category, storage_path, mime_type, file_size, description, is_active, created_at, updated_at
    FROM public.app_icons
    ORDER BY category, name;
$$;


--
-- Name: get_approval_center_data(uuid); Type: FUNCTION; Schema: public; Owner: -
--

