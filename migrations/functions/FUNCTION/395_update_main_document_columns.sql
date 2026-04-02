CREATE FUNCTION public.update_main_document_columns() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update the dedicated columns based on document type
    IF NEW.document_type = 'health_card' THEN
        NEW.health_card_number := NEW.document_number;
        NEW.health_card_expiry := NEW.expiry_date;
    ELSIF NEW.document_type = 'resident_id' THEN
        NEW.resident_id_number := NEW.document_number;
        NEW.resident_id_expiry := NEW.expiry_date;
    ELSIF NEW.document_type = 'passport' THEN
        NEW.passport_number := NEW.document_number;
        NEW.passport_expiry := NEW.expiry_date;
    ELSIF NEW.document_type = 'driving_license' THEN
        NEW.driving_license_number := NEW.document_number;
        NEW.driving_license_expiry := NEW.expiry_date;
    ELSIF NEW.document_type = 'resume' THEN
        NEW.resume_uploaded := TRUE;
    END IF;
    
    RETURN NEW;
END;
$$;


--
-- Name: update_multi_shift_date_wise_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

