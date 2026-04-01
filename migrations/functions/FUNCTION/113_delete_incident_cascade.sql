CREATE FUNCTION public.delete_incident_cascade(p_incident_id text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_task_ids uuid[];
BEGIN
    -- Collect quick_task IDs linked to this incident
    SELECT ARRAY(SELECT id FROM quick_tasks WHERE incident_id = p_incident_id)
    INTO v_task_ids;

    -- Delete quick_task children
    IF array_length(v_task_ids, 1) > 0 THEN
        DELETE FROM quick_task_assignments WHERE quick_task_id = ANY(v_task_ids);
        DELETE FROM quick_task_comments    WHERE quick_task_id = ANY(v_task_ids);
        DELETE FROM quick_task_completions WHERE quick_task_id = ANY(v_task_ids);
        DELETE FROM quick_task_files       WHERE quick_task_id = ANY(v_task_ids);
    END IF;

    -- Delete quick_tasks
    DELETE FROM quick_tasks WHERE incident_id = p_incident_id;

    -- Delete incident_actions
    DELETE FROM incident_actions WHERE incident_id = p_incident_id;

    -- Delete the incident itself
    DELETE FROM incidents WHERE id = p_incident_id;
END;
$$;


--
-- Name: denomination_audit_trigger(); Type: FUNCTION; Schema: public; Owner: -
--

