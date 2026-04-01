CREATE FUNCTION public.get_branch_sync_configs() RETURNS TABLE(id bigint, branch_id bigint, branch_name_en text, branch_name_ar text, local_supabase_url text, local_supabase_key text, tunnel_url text, ssh_user text, is_active boolean, last_sync_at timestamp with time zone, last_sync_status text, last_sync_details jsonb, sync_tables text[])
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT
    c.id, c.branch_id,
    b.name_en as branch_name_en,
    b.name_ar as branch_name_ar,
    c.local_supabase_url, c.local_supabase_key,
    c.tunnel_url, COALESCE(c.ssh_user, 'u') as ssh_user,
    c.is_active,
    c.last_sync_at, c.last_sync_status, c.last_sync_details,
    c.sync_tables
  FROM branch_sync_config c
  JOIN branches b ON b.id = c.branch_id
  WHERE c.is_active = true
  ORDER BY b.name_en;
$$;


--
-- Name: get_branch_visits_summary(uuid, date, date); Type: FUNCTION; Schema: public; Owner: -
--

