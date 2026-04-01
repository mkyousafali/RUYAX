CREATE FUNCTION public.calculate_next_visit_date(visit_type text, weekday_name text DEFAULT NULL::text, fresh_type text DEFAULT NULL::text, day_number integer DEFAULT NULL::integer, skip_days integer DEFAULT NULL::integer, start_date date DEFAULT NULL::date, current_next_date date DEFAULT NULL::date) RETURNS date
    LANGUAGE plpgsql
    AS $$
DECLARE
    next_date DATE;
    current_date DATE := CURRENT_DATE;
    weekday_num INTEGER;
BEGIN
    CASE visit_type
        WHEN 'weekly' THEN
            -- Calculate next occurrence of the specified weekday
            weekday_num := CASE weekday_name
                WHEN 'sunday' THEN 0
                WHEN 'monday' THEN 1
                WHEN 'tuesday' THEN 2
                WHEN 'wednesday' THEN 3
                WHEN 'thursday' THEN 4
                WHEN 'friday' THEN 5
                WHEN 'saturday' THEN 6
            END;
            
            -- If updating existing record, calculate from current next_date
            IF current_next_date IS NOT NULL THEN
                next_date := current_next_date + INTERVAL '7 days';
            ELSE
                -- Find next occurrence of weekday from today
                next_date := current_date + (weekday_num - EXTRACT(DOW FROM current_date))::INTEGER;
                IF next_date <= current_date THEN
                    next_date := next_date + INTERVAL '7 days';
                END IF;
            END IF;
            
        WHEN 'daily' THEN
            -- Daily visits: next day
            IF current_next_date IS NOT NULL THEN
                next_date := current_next_date + INTERVAL '1 day';
            ELSE
                next_date := current_date + INTERVAL '1 day';
            END IF;
            
        WHEN 'monthly' THEN
            -- Monthly visits on specific day number
            IF current_next_date IS NOT NULL THEN
                -- Add one month to current next date
                next_date := (current_next_date + INTERVAL '1 month')::DATE;
                -- Adjust to correct day of month
                next_date := DATE_TRUNC('month', next_date) + (day_number - 1) * INTERVAL '1 day';
            ELSE
                -- Calculate from current month
                next_date := DATE_TRUNC('month', current_date) + (day_number - 1) * INTERVAL '1 day';
                IF next_date <= current_date THEN
                    -- Move to next month
                    next_date := DATE_TRUNC('month', current_date + INTERVAL '1 month') + (day_number - 1) * INTERVAL '1 day';
                END IF;
            END IF;
            
        WHEN 'skip_days' THEN
            -- Skip specified number of days
            IF current_next_date IS NOT NULL THEN
                next_date := current_next_date + skip_days * INTERVAL '1 day';
            ELSE
                next_date := COALESCE(start_date, current_date) + skip_days * INTERVAL '1 day';
            END IF;
            
        ELSE
            -- Default: next day
            next_date := current_date + INTERVAL '1 day';
    END CASE;
    
    RETURN next_date;
END;
$$;


--
-- Name: calculate_profit(); Type: FUNCTION; Schema: public; Owner: -
--

