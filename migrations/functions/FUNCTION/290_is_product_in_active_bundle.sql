CREATE FUNCTION public.is_product_in_active_bundle(p_product_id uuid, p_exclude_offer_id integer DEFAULT NULL::integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_found BOOLEAN;
BEGIN
    SELECT EXISTS(
        SELECT 1
        FROM offer_bundles ob
        INNER JOIN offers o ON ob.offer_id = o.id
        WHERE o.is_active = true
          AND o.end_date > NOW()
          AND (p_exclude_offer_id IS NULL OR o.id != p_exclude_offer_id)
          AND ob.required_products::jsonb @> jsonb_build_array(
              jsonb_build_object('product_id', p_product_id::text)
          )
    ) INTO v_found;
    
    RETURN v_found;
END;
$$;


--
-- Name: is_quick_access_code_available(text); Type: FUNCTION; Schema: public; Owner: -
--

