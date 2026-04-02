CREATE FUNCTION public.check_task_completion_criteria(task_uuid uuid, task_finished_val boolean, photo_uploaded_val boolean, erp_reference_val boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    task_record record;
BEGIN
    SELECT require_task_finished, require_photo_upload, require_erp_reference
    INTO task_record
    FROM tasks 
    WHERE id = task_uuid;
    
    -- Check if all required criteria are met
    IF (task_record.require_task_finished = false OR task_finished_val = true) AND
       (task_record.require_photo_upload = false OR photo_uploaded_val = true) AND
       (task_record.require_erp_reference = false OR erp_reference_val = true) THEN
        RETURN true;
    ELSE
        RETURN false;
    END IF;
END;
$$;


--
-- Name: check_user_permission(text, text); Type: FUNCTION; Schema: public; Owner: -
--

