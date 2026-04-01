CREATE FUNCTION public.calculate_working_hours() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  start_minutes INTEGER;
  end_minutes INTEGER;
  hours_diff NUMERIC;
BEGIN
  -- Convert times to minutes since midnight
  start_minutes := EXTRACT(HOUR FROM NEW.shift_start_time)::INTEGER * 60 + 
                   EXTRACT(MINUTE FROM NEW.shift_start_time)::INTEGER;
  end_minutes := EXTRACT(HOUR FROM NEW.shift_end_time)::INTEGER * 60 + 
                 EXTRACT(MINUTE FROM NEW.shift_end_time)::INTEGER;

  -- Calculate hours
  IF NEW.is_shift_overlapping_next_day THEN
    -- If shift overlaps to next day: (1440 - start_minutes + end_minutes) / 60
    hours_diff := (1440 - start_minutes + end_minutes)::NUMERIC / 60;
  ELSE
    -- If shift doesn't overlap: (end_minutes - start_minutes) / 60
    hours_diff := (end_minutes - start_minutes)::NUMERIC / 60;
  END IF;

  NEW.working_hours := ROUND(hours_diff, 2);
  RETURN NEW;
END;
$$;


--
-- Name: calculate_working_hours(timestamp with time zone, timestamp with time zone); Type: FUNCTION; Schema: public; Owner: -
--

