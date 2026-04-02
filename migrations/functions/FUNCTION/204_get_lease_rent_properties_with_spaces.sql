CREATE FUNCTION public.get_lease_rent_properties_with_spaces() RETURNS TABLE(property_id uuid, property_name_en character varying, property_name_ar character varying, property_location_en character varying, property_location_ar character varying, property_is_leased boolean, property_is_rented boolean, space_id uuid, space_number character varying)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.id AS property_id,
        p.name_en AS property_name_en,
        p.name_ar AS property_name_ar,
        p.location_en AS property_location_en,
        p.location_ar AS property_location_ar,
        p.is_leased AS property_is_leased,
        p.is_rented AS property_is_rented,
        s.id AS space_id,
        s.space_number AS space_number
    FROM lease_rent_properties p
    LEFT JOIN lease_rent_property_spaces s ON s.property_id = p.id
    ORDER BY p.name_en, s.space_number;
END;
$$;


--
-- Name: get_lease_rent_tab_data(text); Type: FUNCTION; Schema: public; Owner: -
--

