CREATE FUNCTION public.reassign_task(assignment_id uuid, new_assignee uuid, reassigned_by uuid, reason text DEFAULT NULL::text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    UPDATE task_assignments 
    SET 
        assigned_to = new_assignee,
        reassigned_by = reassigned_by,
        reassignment_reason = reason,
        updated_at = NOW()
    WHERE id = assignment_id;
    
    RETURN FOUND;
END;
$$;


--
-- Name: reassign_task(uuid, text, text, uuid, text, boolean); Type: FUNCTION; Schema: public; Owner: -
--

