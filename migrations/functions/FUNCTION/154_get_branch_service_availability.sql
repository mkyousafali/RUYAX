CREATE FUNCTION public.get_branch_service_availability(branch_id uuid) RETURNS TABLE(delivery_enabled boolean, pickup_enabled boolean, branch_name_en text, branch_name_ar text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        b.delivery_service_enabled,
        b.pickup_service_enabled,
        b.name_en,
        b.name_ar
    FROM public.branches b
    WHERE b.id = branch_id
    LIMIT 1;
END;
$$;


--
-- Name: FUNCTION get_branch_service_availability(branch_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_branch_service_availability(branch_id uuid) IS 'Check delivery and pickup service availability for a specific branch';


--
-- Name: get_branch_sync_configs(); Type: FUNCTION; Schema: public; Owner: -
--

