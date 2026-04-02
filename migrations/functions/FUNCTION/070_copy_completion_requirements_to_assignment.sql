CREATE FUNCTION public.copy_completion_requirements_to_assignment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update the assignment with completion requirements from the task
    UPDATE quick_task_assignments 
    SET 
        require_task_finished = (
            SELECT require_task_finished 
            FROM quick_tasks 
            WHERE id = NEW.quick_task_id
        ),
        require_photo_upload = (
            SELECT require_photo_upload 
            FROM quick_tasks 
            WHERE id = NEW.quick_task_id
        ),
        require_erp_reference = (
            SELECT require_erp_reference 
            FROM quick_tasks 
            WHERE id = NEW.quick_task_id
        )
    WHERE id = NEW.id;
    
    RETURN NEW;
END;
$$;


--
-- Name: count_bills_without_erp_reference(); Type: FUNCTION; Schema: public; Owner: -
--

