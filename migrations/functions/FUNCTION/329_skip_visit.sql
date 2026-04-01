CREATE FUNCTION public.skip_visit(visit_id uuid, skip_reason text DEFAULT ''::text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update the record to mark as handled (no date change for skip)
    UPDATE vendor_visits 
    SET updated_at = NOW()
    WHERE id = visit_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Visit schedule not found with id: %', visit_id;
    END IF;
    
    -- Note: In a full system, you might want to log this skip in a separate visits_log table
    -- For now, we just return success
    RETURN TRUE;
END;
$$;


--
-- Name: soft_delete_flyer_template(uuid); Type: FUNCTION; Schema: public; Owner: -
--

