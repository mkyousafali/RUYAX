CREATE FUNCTION public.insert_vendor_from_excel(p_erp_vendor_code character varying, p_vendor_name character varying, p_vat_number character varying DEFAULT NULL::character varying) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    vendor_id UUID;
BEGIN
    INSERT INTO public.vendors (
        erp_vendor_code,
        name,
        vat_number,
        company,
        category,
        status
    ) VALUES (
        p_erp_vendor_code,
        p_vendor_name,
        p_vat_number,
        COALESCE(p_vendor_name, 'Unknown Company'),
        'General',
        'active'
    )
    ON CONFLICT (erp_vendor_code) 
    DO UPDATE SET
        name = EXCLUDED.name,
        vat_number = EXCLUDED.vat_number,
        company = EXCLUDED.company,
        updated_at = NOW()
    RETURNING id INTO vendor_id;
    
    RETURN vendor_id;
END;
$$;


--
-- Name: insert_vendor_from_excel(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

