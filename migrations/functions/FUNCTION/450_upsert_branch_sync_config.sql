CREATE FUNCTION public.upsert_branch_sync_config(p_branch_id bigint, p_local_supabase_url text, p_local_supabase_key text, p_tunnel_url text DEFAULT NULL::text) RETURNS bigint
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_id BIGINT;
BEGIN
    INSERT INTO branch_sync_config (branch_id, local_supabase_url, local_supabase_key, tunnel_url, is_active)
    VALUES (p_branch_id, p_local_supabase_url, p_local_supabase_key, p_tunnel_url, true)
    ON CONFLICT (branch_id) DO UPDATE SET
        local_supabase_url = EXCLUDED.local_supabase_url,
        local_supabase_key = EXCLUDED.local_supabase_key,
        tunnel_url = COALESCE(EXCLUDED.tunnel_url, branch_sync_config.tunnel_url),
        updated_at = now()
    RETURNING id INTO v_id;
    RETURN v_id;
END;
$$;


--
-- Name: upsert_branch_sync_config(bigint, text, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

