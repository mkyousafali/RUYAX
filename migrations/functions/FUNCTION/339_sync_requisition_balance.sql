CREATE FUNCTION public.sync_requisition_balance() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    scheduler_balance NUMERIC(10,2);
    original_amount NUMERIC(10,2);
BEGIN
    -- Only process if this is a requisition-related scheduler entry
    IF NEW.requisition_id IS NOT NULL AND NEW.schedule_type = 'expense_requisition' THEN
        
        -- Get the current balance from the scheduler (unpaid entry)
        SELECT COALESCE(amount, 0) INTO scheduler_balance
        FROM expense_scheduler
        WHERE requisition_id = NEW.requisition_id
        AND schedule_type = 'expense_requisition'
        AND is_paid = false
        LIMIT 1;
        
        -- Get the original request amount
        SELECT amount INTO original_amount
        FROM expense_requisitions
        WHERE id = NEW.requisition_id;
        
        -- Update the requisition table
        IF scheduler_balance = 0 OR NEW.is_paid = true THEN
            -- Balance is zero or marked as paid - close the request
            UPDATE expense_requisitions
            SET 
                remaining_balance = 0,
                used_amount = original_amount,
                status = 'closed',
                is_active = false,
                updated_at = NOW()
            WHERE id = NEW.requisition_id;
        ELSE
            -- Balance still exists - update the amounts
            UPDATE expense_requisitions
            SET 
                remaining_balance = scheduler_balance,
                used_amount = original_amount - scheduler_balance,
                updated_at = NOW()
            WHERE id = NEW.requisition_id;
        END IF;
        
    END IF;
    
    RETURN NEW;
END;
$$;


--
-- Name: sync_user_roles_from_positions(); Type: FUNCTION; Schema: public; Owner: -
--

