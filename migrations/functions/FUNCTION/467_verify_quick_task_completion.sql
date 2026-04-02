CREATE FUNCTION public.verify_quick_task_completion(completion_id_param uuid, verified_by_user_id_param uuid, verification_notes_param text DEFAULT NULL::text, is_approved boolean DEFAULT true) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_status VARCHAR(50);
BEGIN
    IF is_approved THEN
        new_status := 'verified';
    ELSE
        new_status := 'rejected';
    END IF;
    
    UPDATE quick_task_completions 
    SET completion_status = new_status,
        verified_by_user_id = verified_by_user_id_param,
        verified_at = now(),
        verification_notes = verification_notes_param,
        updated_at = now()
    WHERE id = completion_id_param;
    
    RETURN FOUND;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: access_code_otp; Type: TABLE; Schema: public; Owner: -
--

