CREATE FUNCTION public.get_lease_rent_tab_data(p_party_type text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    parties_json JSON;
    changes_json JSON;
BEGIN
    IF p_party_type = 'lease' THEN
        SELECT COALESCE(json_agg(sub ORDER BY sub.party_name_en), '[]'::json) INTO parties_json
        FROM (
            SELECT lp.*,
                json_build_object('name_en', prop.name_en, 'name_ar', prop.name_ar) as property,
                json_build_object('space_number', sp.space_number) as space
            FROM lease_rent_lease_parties lp
            LEFT JOIN lease_rent_properties prop ON prop.id = lp.property_id
            LEFT JOIN lease_rent_property_spaces sp ON sp.id = lp.property_space_id
        ) sub;
    ELSIF p_party_type = 'rent' THEN
        SELECT COALESCE(json_agg(sub ORDER BY sub.party_name_en), '[]'::json) INTO parties_json
        FROM (
            SELECT rp.*,
                json_build_object('name_en', prop.name_en, 'name_ar', prop.name_ar) as property,
                json_build_object('space_number', sp.space_number) as space
            FROM lease_rent_rent_parties rp
            LEFT JOIN lease_rent_properties prop ON prop.id = rp.property_id
            LEFT JOIN lease_rent_property_spaces sp ON sp.id = rp.property_space_id
        ) sub;
    ELSE
        parties_json := '[]'::json;
    END IF;
    SELECT COALESCE(json_agg(c ORDER BY c.created_at DESC), '[]'::json) INTO changes_json
    FROM lease_rent_special_changes c
    WHERE c.party_type = p_party_type;
    RETURN json_build_object('parties', parties_json, 'changes', changes_json);
END;
$$;


--
-- Name: get_mobile_dashboard_data(uuid); Type: FUNCTION; Schema: public; Owner: -
--

