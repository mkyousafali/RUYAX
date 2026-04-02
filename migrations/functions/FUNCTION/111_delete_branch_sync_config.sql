CREATE FUNCTION public.delete_branch_sync_config(p_id bigint) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    DELETE FROM branch_sync_config WHERE id = p_id;
$$;


--
-- Name: delete_customer_account(uuid); Type: FUNCTION; Schema: public; Owner: -
--

