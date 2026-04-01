CREATE FUNCTION public.upsert_branch_sync_config(p_branch_id bigint, p_local_supabase_url text, p_local_supabase_key text, p_tunnel_url text DEFAULT NULL::text, p_ssh_user text DEFAULT 'u'::text) RETURNS bigint
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_id bigint;
BEGIN
  INSERT INTO branch_sync_config (branch_id, local_supabase_url, local_supabase_key, tunnel_url, ssh_user)
  VALUES (p_branch_id, p_local_supabase_url, p_local_supabase_key, p_tunnel_url, COALESCE(p_ssh_user, 'u'))
  ON CONFLICT (branch_id) DO UPDATE SET
    local_supabase_url = EXCLUDED.local_supabase_url,
    local_supabase_key = EXCLUDED.local_supabase_key,
    tunnel_url = COALESCE(EXCLUDED.tunnel_url, branch_sync_config.tunnel_url),
    ssh_user = COALESCE(EXCLUDED.ssh_user, branch_sync_config.ssh_user, 'u'),
    updated_at = now()
  RETURNING id INTO v_id;
  RETURN v_id;
END;
$$;


--
-- Name: upsert_erp_products_with_expiry(jsonb); Type: FUNCTION; Schema: public; Owner: -
--

