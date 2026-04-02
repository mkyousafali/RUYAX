CREATE FUNCTION public.get_ongoing_quick_assignment_count(p_user_id uuid) RETURNS bigint
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT count(*)
  FROM quick_task_assignments qta
  INNER JOIN quick_tasks qt ON qt.id = qta.quick_task_id
  WHERE qt.assigned_by = p_user_id
    AND qta.status NOT IN ('completed', 'cancelled');
$$;


--
-- Name: get_or_create_app_function(text, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

