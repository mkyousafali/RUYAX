CREATE FUNCTION public.record_fine_payment(warning_id_param uuid, payment_amount_param numeric, payment_method_param character varying, payment_reference_param character varying, processed_by_param uuid) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    payment_id UUID;
    total_paid DECIMAL(10,2);
    fine_amount DECIMAL(10,2);
BEGIN
    -- Get the fine amount
    SELECT ew.fine_amount INTO fine_amount
    FROM employee_warnings ew
    WHERE ew.id = warning_id_param;
    
    -- Insert payment record
    INSERT INTO employee_fine_payments (
        warning_id, payment_amount, payment_method, 
        payment_reference, processed_by
    ) VALUES (
        warning_id_param, payment_amount_param, payment_method_param,
        payment_reference_param, processed_by_param
    ) RETURNING id INTO payment_id;
    
    -- Calculate total paid
    SELECT COALESCE(SUM(payment_amount), 0) INTO total_paid
    FROM employee_fine_payments
    WHERE warning_id = warning_id_param;
    
    -- Update warning status based on payment
    UPDATE employee_warnings
    SET 
        fine_paid_amount = total_paid,
        fine_status = CASE 
            WHEN total_paid >= fine_amount THEN 'paid'
            WHEN total_paid > 0 THEN 'partial'
            ELSE 'pending'
        END,
        fine_paid_date = CASE 
            WHEN total_paid >= fine_amount THEN CURRENT_TIMESTAMP
            ELSE fine_paid_date
        END,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = warning_id_param;
    
    RETURN payment_id;
END;
$$;


--
-- Name: refresh_broadcast_status(uuid); Type: FUNCTION; Schema: public; Owner: -
--

