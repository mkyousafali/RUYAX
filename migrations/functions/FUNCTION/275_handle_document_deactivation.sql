CREATE FUNCTION public.handle_document_deactivation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- If document is being deactivated, clear the main document columns
    IF OLD.is_active = TRUE AND NEW.is_active = FALSE THEN
        IF NEW.document_type = 'health_card' THEN
            NEW.health_card_number := NULL;
            NEW.health_card_expiry := NULL;
        ELSIF NEW.document_type = 'resident_id' THEN
            NEW.resident_id_number := NULL;
            NEW.resident_id_expiry := NULL;
        ELSIF NEW.document_type = 'passport' THEN
            NEW.passport_number := NULL;
            NEW.passport_expiry := NULL;
        ELSIF NEW.document_type = 'driving_license' THEN
            NEW.driving_license_number := NULL;
            NEW.driving_license_expiry := NULL;
        ELSIF NEW.document_type = 'resume' THEN
            NEW.resume_uploaded := FALSE;
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$;


--
-- Name: handle_order_task_completion(); Type: FUNCTION; Schema: public; Owner: -
--

