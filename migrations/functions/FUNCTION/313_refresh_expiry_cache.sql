CREATE FUNCTION public.refresh_expiry_cache() RETURNS void
    LANGUAGE sql
    AS $$
  REFRESH MATERIALIZED VIEW CONCURRENTLY mv_expiry_products;
$$;


--
-- Name: refresh_user_roles_from_positions(); Type: FUNCTION; Schema: public; Owner: -
--

