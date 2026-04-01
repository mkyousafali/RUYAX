CREATE FUNCTION public.calculate_schedule_details() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Auto-detect overnight shift if not explicitly set
    IF NEW.is_overnight IS NULL THEN
        NEW.is_overnight := is_overnight_shift(NEW.scheduled_start_time, NEW.scheduled_end_time);
    END IF;
    
    -- Auto-calculate working hours if not provided
    IF NEW.scheduled_hours IS NULL OR NEW.scheduled_hours = 0 THEN
        NEW.scheduled_hours := calculate_working_hours(
            NEW.scheduled_start_time, 
            NEW.scheduled_end_time, 
            NEW.is_overnight
        );
    END IF;
    
    -- Update timestamp
    NEW.updated_at := NOW();
    
    RETURN NEW;
END;
$$;


--
-- Name: calculate_working_hours(); Type: FUNCTION; Schema: public; Owner: -
--

