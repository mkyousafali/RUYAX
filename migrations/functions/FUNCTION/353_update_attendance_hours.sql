CREATE FUNCTION public.update_attendance_hours() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Calculate actual hours
    NEW.actual_hours = calculate_working_hours(NEW.check_in_time, NEW.check_out_time);
    
    -- Calculate overtime (if there's a duty schedule)
    IF NEW.duty_schedule_id IS NOT NULL THEN
        SELECT 
            GREATEST(0, NEW.actual_hours - ds.scheduled_hours)
        INTO NEW.overtime_hours
        FROM duty_schedules ds
        WHERE ds.id = NEW.duty_schedule_id;
    END IF;
    
    -- Update status based on attendance
    IF NEW.check_in_time IS NOT NULL AND NEW.check_out_time IS NOT NULL THEN
        NEW.status = 'present';
    ELSIF NEW.check_in_time IS NOT NULL THEN
        NEW.status = 'present';
    ELSE
        NEW.status = 'absent';
    END IF;
    
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: update_bank_reconciliations_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

