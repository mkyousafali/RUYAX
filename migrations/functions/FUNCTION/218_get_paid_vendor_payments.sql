CREATE FUNCTION public.get_paid_vendor_payments(p_date_from date, p_date_to date) RETURNS TABLE(id uuid, bill_number character varying, vendor_name character varying, final_bill_amount numeric, bill_date date, branch_id integer, payment_method character varying, bank_name character varying, iban character varying, is_paid boolean, paid_date timestamp without time zone, due_date date, payment_reference character varying)
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT
    v.id, v.bill_number, v.vendor_name, v.final_bill_amount,
    v.bill_date, v.branch_id, v.payment_method, v.bank_name, v.iban,
    v.is_paid, v.paid_date, v.due_date, v.payment_reference
  FROM vendor_payment_schedule v
  WHERE v.is_paid = true
    AND v.due_date >= p_date_from
    AND v.due_date <= p_date_to
  ORDER BY v.due_date DESC;
$$;


--
-- Name: get_party_payment_data(text, uuid); Type: FUNCTION; Schema: public; Owner: -
--

