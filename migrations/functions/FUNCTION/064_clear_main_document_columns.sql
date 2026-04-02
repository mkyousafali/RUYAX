CREATE FUNCTION public.clear_main_document_columns() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Clear the dedicated columns based on document type
    IF OLD.document_type = 'health_card' THEN
        OLD.health_card_number := NULL;
        OLD.health_card_expiry := NULL;
    ELSIF OLD.document_type = 'resident_id' THEN
        OLD.resident_id_number := NULL;
        OLD.resident_id_expiry := NULL;
    ELSIF OLD.document_type = 'passport' THEN
        OLD.passport_number := NULL;
        OLD.passport_expiry := NULL;
    ELSIF OLD.document_type = 'driving_license' THEN
        OLD.driving_license_number := NULL;
        OLD.driving_license_expiry := NULL;
    ELSIF OLD.document_type = 'resume' THEN
        OLD.resume_uploaded := FALSE;
    END IF;
    
    RETURN OLD;
END;
$$;


--
-- Name: clear_sync_tables(text[]); Type: FUNCTION; Schema: public; Owner: -
--

