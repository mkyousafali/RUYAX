CREATE FUNCTION public.delete_app_icon(p_icon_key text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
    DELETE FROM public.app_icons WHERE icon_key = p_icon_key;
    RETURN FOUND;
END;
$$;


--
-- Name: delete_branch_sync_config(bigint); Type: FUNCTION; Schema: public; Owner: -
--

