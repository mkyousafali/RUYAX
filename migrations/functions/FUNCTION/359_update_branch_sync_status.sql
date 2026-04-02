CREATE FUNCTION public.update_branch_sync_status(p_branch_id bigint, p_status text, p_details jsonb DEFAULT '{}'::jsonb) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    UPDATE branch_sync_config
    SET last_sync_at = now(),
        last_sync_status = p_status,
        last_sync_details = p_details,
        updated_at = now()
    WHERE branch_id = p_branch_id;
$$;


--
-- Name: update_branches_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

