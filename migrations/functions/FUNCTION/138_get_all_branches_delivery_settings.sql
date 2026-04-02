CREATE FUNCTION public.get_all_branches_delivery_settings() RETURNS TABLE(branch_id bigint, branch_name_en text, branch_name_ar text, minimum_order_amount numeric, delivery_service_enabled boolean, delivery_is_24_hours boolean, delivery_start_time time without time zone, delivery_end_time time without time zone, pickup_service_enabled boolean, pickup_is_24_hours boolean, pickup_start_time time without time zone, pickup_end_time time without time zone, delivery_message_ar text, delivery_message_en text, location_url text, latitude double precision, longitude double precision)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        b.id,
        b.name_en::text,
        b.name_ar::text,
        COALESCE(b.minimum_order_amount, 15.00)::numeric,
        COALESCE(b.delivery_service_enabled, true)::boolean,
        COALESCE(b.delivery_is_24_hours, true)::boolean,
        b.delivery_start_time,
        b.delivery_end_time,
        COALESCE(b.pickup_service_enabled, true)::boolean,
        COALESCE(b.pickup_is_24_hours, true)::boolean,
        b.pickup_start_time,
        b.pickup_end_time,
        COALESCE(b.delivery_message_ar, '╪º┘ä╪¬┘ê╪╡┘è┘ä ┘à╪¬╪º╪¡ ╪╣┘ä┘ë ┘à╪»╪º╪▒ ╪º┘ä╪│╪º╪╣╪⌐')::text,
        COALESCE(b.delivery_message_en, 'Delivery available 24/7')::text,
        b.location_url,
        b.latitude,
        b.longitude
    FROM public.branches b
    ORDER BY b.name_en;
END;
$$;


--
-- Name: get_all_breaks(date, date, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

