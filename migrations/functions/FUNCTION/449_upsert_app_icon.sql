CREATE FUNCTION public.upsert_app_icon(p_icon_key text, p_name text, p_category text, p_storage_path text, p_mime_type text DEFAULT NULL::text, p_file_size bigint DEFAULT 0, p_description text DEFAULT NULL::text) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_id uuid;
BEGIN
    INSERT INTO public.app_icons (icon_key, name, category, storage_path, mime_type, file_size, description, created_by)
    VALUES (p_icon_key, p_name, p_category, p_storage_path, p_mime_type, p_file_size, p_description, auth.uid())
    ON CONFLICT (icon_key) DO UPDATE SET
        name = EXCLUDED.name,
        category = EXCLUDED.category,
        storage_path = EXCLUDED.storage_path,
        mime_type = EXCLUDED.mime_type,
        file_size = EXCLUDED.file_size,
        description = EXCLUDED.description,
        updated_at = now()
    RETURNING id INTO v_id;
    
    RETURN v_id;
END;
$$;


--
-- Name: upsert_branch_sync_config(bigint, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

