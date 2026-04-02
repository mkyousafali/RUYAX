CREATE FUNCTION public.get_paid_expense_payments(p_date_from date, p_date_to date) RETURNS TABLE(id bigint, amount numeric, is_paid boolean, paid_date timestamp with time zone, status text, branch_id bigint, payment_method text, expense_category_name_en text, expense_category_name_ar text, description text, schedule_type text, due_date date, co_user_name text, created_by uuid, requisition_id bigint, requisition_number text, payment_reference character varying, creator_username text)
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT
    e.id, e.amount, e.is_paid, e.paid_date, e.status,
    e.branch_id, e.payment_method,
    e.expense_category_name_en, e.expense_category_name_ar,
    e.description, e.schedule_type, e.due_date,
    e.co_user_name, e.created_by,
    e.requisition_id, e.requisition_number,
    e.payment_reference,
    u.username AS creator_username
  FROM expense_scheduler e
  LEFT JOIN public.users u ON u.id = e.created_by
  WHERE e.is_paid = true
    AND e.due_date >= p_date_from
    AND e.due_date <= p_date_to
  ORDER BY e.due_date DESC;
$$;


--
-- Name: get_paid_vendor_payments(date, date); Type: FUNCTION; Schema: public; Owner: -
--

