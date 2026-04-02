CREATE FUNCTION public.insert_vendor_from_excel(p_erp_vendor_code character varying, p_vendor_name_english character varying, p_vendor_name_arabic character varying DEFAULT NULL::character varying, p_vat_number character varying DEFAULT NULL::character varying) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    vendor_id UUID;
    vendor_company CHARACTER VARYING(255);
BEGIN
    -- Use English name as company if provided, otherwise use the main vendor name
    vendor_company := COALESCE(p_vendor_name_english, p_vendor_name_arabic, 'Unknown Company');
    
    -- Insert vendor with Excel column mapping
    INSERT INTO public.vendors (
        erp_vendor_code,
        name,
        name_ar,
        vat_number,
        company,
        tax_id,
        category,
        status,
        payment_terms
    ) VALUES (
        p_erp_vendor_code,
        COALESCE(p_vendor_name_english, p_vendor_name_arabic),
        p_vendor_name_arabic,
        p_vat_number,
        vendor_company,
        p_vat_number, -- Map VAT number to tax_id as well
        'General',
        'active',
        'N/A'
    )
    ON CONFLICT (erp_vendor_code) 
    DO UPDATE SET
        name = EXCLUDED.name,
        name_ar = EXCLUDED.name_ar,
        vat_number = EXCLUDED.vat_number,
        company = EXCLUDED.company,
        tax_id = EXCLUDED.tax_id,
        payment_terms = EXCLUDED.payment_terms,
        updated_at = NOW()
    RETURNING id INTO vendor_id;
    
    RETURN vendor_id;
END;
$$;


--
-- Name: is_delivery_staff(uuid); Type: FUNCTION; Schema: public; Owner: -
--

