CREATE FUNCTION public.update_quick_task_status() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update main task status based on individual assignments
    IF TG_OP = 'UPDATE' THEN
        -- Check if all assignments are completed
        IF (SELECT COUNT(*) FROM quick_task_assignments 
            WHERE quick_task_id = NEW.quick_task_id AND status != 'completed') = 0 THEN
            
            UPDATE quick_tasks 
            SET status = 'completed', completed_at = NOW(), updated_at = NOW()
            WHERE id = NEW.quick_task_id;
            
        -- Check if task is overdue
        ELSIF NOW() > (SELECT deadline_datetime FROM quick_tasks WHERE id = NEW.quick_task_id) THEN
            UPDATE quick_tasks 
            SET status = 'overdue', updated_at = NOW()
            WHERE id = NEW.quick_task_id AND status != 'completed';
            
            -- Mark individual assignments as overdue if not completed
            UPDATE quick_task_assignments
            SET status = 'overdue', updated_at = NOW()
            WHERE quick_task_id = NEW.quick_task_id AND status IN ('pending', 'accepted', 'in_progress');
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$;


--
-- Name: update_receiving_records_pr_excel_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

