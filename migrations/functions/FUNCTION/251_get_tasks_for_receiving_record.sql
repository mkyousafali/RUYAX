CREATE FUNCTION public.get_tasks_for_receiving_record(receiving_record_id_param uuid) RETURNS TABLE(task_id uuid, receiving_record_id uuid, role_type text, title text, description text, priority text, task_status text, task_completed boolean, due_date timestamp with time zone, created_at timestamp with time zone, completed_at timestamp with time zone, completed_by_user_id uuid, assigned_user_id uuid, requires_erp_reference boolean, requires_original_bill_upload boolean, erp_reference_number text, original_bill_uploaded boolean, original_bill_file_path text, clearance_certificate_url text, is_overdue boolean, days_until_due integer, bill_number text, vendor_name text, branch_name text)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    rt.id AS task_id,
    rt.receiving_record_id,
    rt.role_type::TEXT,
    rt.title,
    rt.description,
    rt.priority::TEXT,
    rt.task_status::TEXT,
    rt.task_completed,
    rt.due_date,
    rt.created_at,
    rt.completed_at,
    rt.completed_by_user_id,
    rt.assigned_user_id,
    rt.requires_erp_reference,
    rt.requires_original_bill_upload,
    rt.erp_reference_number::TEXT,
    rt.original_bill_uploaded,
    rt.original_bill_file_path,
    rt.clearance_certificate_url,
    -- Calculate if overdue
    CASE 
      WHEN rt.task_completed = false AND rt.due_date < NOW() THEN true
      ELSE false
    END AS is_overdue,
    -- Calculate days until due
    CASE 
      WHEN rt.task_completed = false THEN 
        EXTRACT(DAY FROM (rt.due_date - NOW()))::INTEGER
      ELSE 
        NULL
    END AS days_until_due,
    rr.bill_number::TEXT,
    v.vendor_name::TEXT,
    b.name_en::TEXT AS branch_name
  FROM receiving_tasks rt
  LEFT JOIN receiving_records rr ON rr.id = rt.receiving_record_id
  LEFT JOIN vendors v ON v.erp_vendor_id = rr.vendor_id AND v.branch_id = rr.branch_id
  LEFT JOIN branches b ON b.id = rr.branch_id
  WHERE rt.receiving_record_id = receiving_record_id_param
  ORDER BY 
    CASE rt.task_status
      WHEN 'pending' THEN 1
      WHEN 'in_progress' THEN 2
      WHEN 'completed' THEN 3
      ELSE 4
    END,
    rt.due_date ASC;
END;
$$;


--
-- Name: get_todays_scheduled_visits(date); Type: FUNCTION; Schema: public; Owner: -
--

