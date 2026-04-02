CREATE FUNCTION public.get_incomplete_receiving_tasks() RETURNS TABLE(id uuid, receiving_record_id uuid, template_id uuid, role_type character varying, title text, description text, priority character varying, task_status character varying, task_completed boolean, due_date timestamp with time zone, assigned_user_id uuid, completed_at timestamp with time zone, completed_by_user_id uuid, clearance_certificate_url text, created_at timestamp with time zone, bill_number character varying, bill_amount numeric, vendor_name text, branch_name text, assigned_user_name text, is_overdue boolean, days_until_due integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    rt.id,
    rt.receiving_record_id,
    rt.template_id,
    rt.role_type,
    rt.title,
    rt.description,
    rt.priority,
    rt.task_status,
    rt.task_completed,
    rt.due_date,
    rt.assigned_user_id,
    rt.completed_at,
    rt.completed_by_user_id,
    rt.clearance_certificate_url,
    rt.created_at,
    rr.bill_number,
    rr.bill_amount,
    v.vendor_name,
    b.name_en as branch_name,
    u1.username as assigned_user_name,
    (rt.due_date < NOW() AND rt.task_status != 'completed') as is_overdue,
    EXTRACT(DAY FROM (rt.due_date - NOW()))::INTEGER as days_until_due
  FROM receiving_tasks rt
  LEFT JOIN receiving_records rr ON rr.id = rt.receiving_record_id
  LEFT JOIN vendors v ON v.erp_vendor_id = rr.vendor_id AND v.branch_id = rr.branch_id
  LEFT JOIN branches b ON b.id = rr.branch_id
  LEFT JOIN users u1 ON u1.id = rt.assigned_user_id
  WHERE rt.task_completed = false AND rt.task_status != 'completed'
  ORDER BY rt.due_date ASC, rt.priority DESC;
END;
$$;


--
-- Name: get_incomplete_receiving_tasks_breakdown(); Type: FUNCTION; Schema: public; Owner: -
--

