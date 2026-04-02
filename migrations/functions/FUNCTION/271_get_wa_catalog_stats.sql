CREATE FUNCTION public.get_wa_catalog_stats(p_account_id uuid) RETURNS TABLE(total_catalogs bigint, total_products bigint, active_products bigint, hidden_products bigint, total_orders bigint, pending_orders bigint, total_revenue numeric)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    SELECT
        (SELECT count(*) FROM wa_catalogs WHERE wa_account_id = p_account_id),
        (SELECT count(*) FROM wa_catalog_products WHERE wa_account_id = p_account_id),
        (SELECT count(*) FROM wa_catalog_products WHERE wa_account_id = p_account_id AND status = 'active' AND NOT is_hidden),
        (SELECT count(*) FROM wa_catalog_products WHERE wa_account_id = p_account_id AND is_hidden),
        (SELECT count(*) FROM wa_catalog_orders WHERE wa_account_id = p_account_id),
        (SELECT count(*) FROM wa_catalog_orders WHERE wa_account_id = p_account_id AND order_status = 'pending'),
        (SELECT COALESCE(sum(total), 0) FROM wa_catalog_orders WHERE wa_account_id = p_account_id AND order_status NOT IN ('cancelled', 'refunded'));
$$;


--
-- Name: get_wa_contacts(integer, integer, text); Type: FUNCTION; Schema: public; Owner: -
--

