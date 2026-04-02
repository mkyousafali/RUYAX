CREATE FUNCTION public.complete_visit_and_update_next(visit_id uuid) RETURNS date
    LANGUAGE plpgsql
    AS $$
DECLARE
    visit_record vendor_visits%ROWTYPE;
    new_next_date DATE;
BEGIN
    -- Get the visit record
    SELECT * INTO visit_record FROM vendor_visits WHERE id = visit_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Visit schedule not found with id: %', visit_id;
    END IF;
    
    -- Calculate new next visit date
    new_next_date := calculate_next_visit_date(
        visit_record.visit_type,
        visit_record.weekday_name,
        visit_record.fresh_type,
        visit_record.day_number,
        visit_record.skip_days,
        visit_record.start_date,
        visit_record.next_visit_date
    );
    
    -- Update the record with new next visit date
    UPDATE vendor_visits 
    SET next_visit_date = new_next_date, updated_at = NOW()
    WHERE id = visit_id;
    
    RETURN new_next_date;
END;
$$;


--
-- Name: copy_completion_requirements_to_assignment(); Type: FUNCTION; Schema: public; Owner: -
--

