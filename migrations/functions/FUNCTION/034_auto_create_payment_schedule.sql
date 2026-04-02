CREATE FUNCTION public.auto_create_payment_schedule() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    schedule_date TIMESTAMPTZ;
    existing_schedule_id UUID;
    v_vendor_name TEXT;
    v_branch_name TEXT;
    v_final_amount NUMERIC;
BEGIN
    -- Only proceed if certificate_url was updated (from NULL to a value)
    IF (TG_OP = 'UPDATE' AND OLD.certificate_url IS NULL AND NEW.certificate_url IS NOT NULL) OR
       (TG_OP = 'INSERT' AND NEW.certificate_url IS NOT NULL) THEN
        
        -- Check if payment schedule already exists
        SELECT id INTO existing_schedule_id
        FROM vendor_payment_schedule
        WHERE receiving_record_id = NEW.id
        LIMIT 1;
        
        -- Only create if it doesn't exist
        IF existing_schedule_id IS NULL THEN
            -- Get vendor name from vendors table
            SELECT vendor_name INTO v_vendor_name
            FROM vendors
            WHERE erp_vendor_id = NEW.vendor_id
            LIMIT 1;
            
            -- Get branch name from branches table
            SELECT name_en INTO v_branch_name
            FROM branches
            WHERE id = NEW.branch_id
            LIMIT 1;
            
            -- Calculate final bill amount (bill_amount - total returns)
            v_final_amount := NEW.bill_amount - 
                COALESCE(NEW.expired_return_amount, 0) -
                COALESCE(NEW.near_expiry_return_amount, 0) -
                COALESCE(NEW.over_stock_return_amount, 0) -
                COALESCE(NEW.damage_return_amount, 0);
            
            -- Calculate schedule date based on due date or credit period
            IF NEW.due_date IS NOT NULL THEN
                schedule_date := NEW.due_date;
            ELSIF NEW.credit_period IS NOT NULL THEN
                schedule_date := (NEW.created_at + (NEW.credit_period || ' days')::INTERVAL);
            ELSE
                schedule_date := (NEW.created_at + INTERVAL '30 days'); -- Default 30 days
            END IF;
            
            -- Insert into vendor_payment_schedule
            INSERT INTO vendor_payment_schedule (
                receiving_record_id,
                bill_number,
                vendor_id,
                vendor_name,
                branch_id,
                branch_name,
                bill_date,
                bill_amount,
                final_bill_amount,
                payment_method,
                bank_name,
                iban,
                due_date,
                credit_period,
                vat_number,
                scheduled_date,
                is_paid,  -- Using is_paid instead of payment_status
                original_due_date,
                original_bill_amount,
                original_final_amount,
                receiver_user_id,
                created_at,
                updated_at
            ) VALUES (
                NEW.id,
                NEW.bill_number,
                NEW.vendor_id::text,  -- Cast integer to text
                v_vendor_name,
                NEW.branch_id,
                v_branch_name,
                NEW.bill_date,
                NEW.bill_amount,
                v_final_amount,
                NEW.payment_method,
                NEW.bank_name,
                NEW.iban,
                NEW.due_date,
                NEW.credit_period,
                NEW.vendor_vat_number,
                schedule_date,
                false,  -- Default to not paid
                NEW.due_date,
                NEW.bill_amount,
                v_final_amount,
                NEW.user_id,
                NOW(),
                NOW()
            );
            
            RAISE NOTICE 'Auto-created payment schedule for receiving record: % (certificate: %)', NEW.id, NEW.certificate_url;
        ELSE
            RAISE NOTICE 'Payment schedule already exists for receiving record: %', NEW.id;
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$;


--
-- Name: bulk_import_customers(text[]); Type: FUNCTION; Schema: public; Owner: -
--

