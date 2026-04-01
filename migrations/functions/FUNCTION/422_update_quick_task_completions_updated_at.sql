CREATE FUNCTION public.update_quick_task_completions_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    
    -- Auto-set verification timestamp
    IF NEW.completion_status = 'verified' AND OLD.completion_status != 'verified' AND NEW.verified_at IS NULL THEN
        NEW.verified_at = now();
    END IF;
    
    RETURN NEW;
END;
$$;


--
-- Name: update_quick_task_status(); Type: FUNCTION; Schema: public; Owner: -
--

