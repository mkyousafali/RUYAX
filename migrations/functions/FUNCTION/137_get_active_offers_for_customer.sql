CREATE FUNCTION public.get_active_offers_for_customer(p_customer_id uuid, p_branch_id integer DEFAULT NULL::integer, p_service_type character varying DEFAULT 'both'::character varying) RETURNS TABLE(offer_id integer, offer_type character varying, name_ar character varying, name_en character varying, discount_type character varying, discount_value numeric, start_date timestamp with time zone, end_date timestamp with time zone, service_type character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        o.id,
        o.type,
        o.name_ar,
        o.name_en,
        o.discount_type,
        o.discount_value,
        o.start_date,
        o.end_date,
        o.service_type
    FROM offers o
    WHERE o.is_active = true
        AND NOW() BETWEEN o.start_date AND o.end_date
        AND (o.branch_id IS NULL OR o.branch_id = p_branch_id)
        AND (o.service_type = 'both' OR o.service_type = p_service_type)
        AND (
            -- General offers (not customer-specific)
            o.type != 'customer'
            OR
            -- Customer-specific offers assigned to this customer
            EXISTS (
                SELECT 1 FROM customer_offers co
                WHERE co.offer_id = o.id
                    AND co.customer_id = p_customer_id
                    AND co.is_used = false
            )
        )
        AND (
            -- Check max total uses not exceeded
            o.max_total_uses IS NULL OR o.current_total_uses < o.max_total_uses
        )
    ORDER BY o.priority DESC, o.created_at DESC;
END;
$$;


--
-- Name: get_all_branches_delivery_settings(); Type: FUNCTION; Schema: public; Owner: -
--

