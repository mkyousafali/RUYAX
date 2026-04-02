CREATE FUNCTION public.reschedule_visit(visit_id uuid, new_date date) RETURNS date
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update the visit with the new date
    UPDATE vendor_visits 
    SET next_visit_date = new_date, updated_at = NOW()
    WHERE id = visit_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Visit schedule not found with id: %', visit_id;
    END IF;
    
    RETURN new_date;
END;
$$;


--
-- Name: search_tasks(text, text, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

