--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 15.8

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA IF NOT EXISTS public;



--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: supabase_admin
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: audit_action_enum; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.audit_action_enum AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'LOGIN',
    'LOGOUT',
    'ACCESS',
    'PERMISSION_CHANGE',
    'PASSWORD_CHANGE'
);



--
-- Name: document_category_enum; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.document_category_enum AS ENUM (
    'warnings',
    'sick_leave',
    'special_leave',
    'resignation',
    'contract_objection',
    'annual_leave',
    'other'
);



--
-- Name: document_type_enum; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.document_type_enum AS ENUM (
    'contract',
    'id_copy',
    'resume',
    'certificate',
    'medical_report',
    'performance_review',
    'disciplinary_action',
    'other'
);



--
-- Name: employee_status_enum; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.employee_status_enum AS ENUM (
    'active',
    'inactive',
    'terminated',
    'on_leave',
    'suspended'
);



--
-- Name: fine_payment_status_enum; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.fine_payment_status_enum AS ENUM (
    'pending',
    'paid',
    'overdue',
    'cancelled',
    'waived'
);



--
-- Name: notification_priority_enum; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.notification_priority_enum AS ENUM (
    'low',
    'medium',
    'high',
    'urgent',
    'critical'
);



--
-- Name: notification_queue_status_enum; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.notification_queue_status_enum AS ENUM (
    'pending',
    'processing',
    'sent',
    'failed',
    'retrying',
    'cancelled'
);



--
-- Name: notification_status_enum; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.notification_status_enum AS ENUM (
    'draft',
    'scheduled',
    'published',
    'sent',
    'failed',
    'cancelled',
    'expired'
);



--
-- Name: notification_target_type_enum; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.notification_target_type_enum AS ENUM (
    'all_users',
    'specific_users',
    'specific_roles',
    'specific_branches',
    'specific_departments',
    'specific_positions'
);



--
-- Name: notification_type_enum; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.notification_type_enum AS ENUM (
    'info',
    'warning',
    'error',
    'success',
    'announcement',
    'task_assigned',
    'task_completed',
    'task_overdue',
    'task_assignment',
    'task_reminder',
    'employee_warning',
    'system_alert',
    'system_maintenance',
    'system_announcement',
    'policy_update',
    'birthday_reminder',
    'leave_approved',
    'leave_rejected',
    'document_uploaded',
    'meeting_scheduled',
    'assignment_updated',
    'deadline_reminder',
    'assignment_rejected',
    'assignment_approved',
    'marketing'
);



--
-- Name: payment_method_type; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.payment_method_type AS ENUM (
    'cash',
    'credit',
    'cpod',
    'bpod'
);



--
-- Name: pos_deduction_status; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.pos_deduction_status AS ENUM (
    'Proposed',
    'Deducted',
    'Forgiven',
    'Cancelled'
);



--
-- Name: push_subscription_status_enum; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.push_subscription_status_enum AS ENUM (
    'active',
    'inactive',
    'expired',
    'revoked'
);



--
-- Name: resolution_status; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.resolution_status AS ENUM (
    'reported',
    'claimed',
    'resolved'
);



--
-- Name: role_type_enum; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.role_type_enum AS ENUM (
    'Master Admin',
    'Admin',
    'Position-based'
);



--
-- Name: session_status_enum; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.session_status_enum AS ENUM (
    'active',
    'expired',
    'revoked',
    'inactive'
);



--
-- Name: task_priority_enum; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.task_priority_enum AS ENUM (
    'low',
    'medium',
    'high',
    'urgent',
    'critical'
);



--
-- Name: task_status_enum; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.task_status_enum AS ENUM (
    'pending',
    'in_progress',
    'completed',
    'overdue',
    'cancelled',
    'rejected',
    'approved'
);



--
-- Name: user_role; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.user_role AS ENUM (
    'master_admin',
    'admin',
    'user'
);



--
-- Name: user_status_enum; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.user_status_enum AS ENUM (
    'active',
    'inactive',
    'pending',
    'suspended',
    'locked'
);



--
-- Name: user_type_enum; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.user_type_enum AS ENUM (
    'global',
    'branch_specific'
);



--
-- Name: vendor_status_enum; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.vendor_status_enum AS ENUM (
    'active',
    'inactive',
    'suspended',
    'blacklisted'
);



--
-- Name: warning_status_enum; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.warning_status_enum AS ENUM (
    'active',
    'resolved',
    'escalated',
    'dismissed',
    'pending'
);



--
-- Name: accept_order(uuid, uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.accept_order(p_order_id uuid, p_user_id uuid) RETURNS TABLE(success boolean, message text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_current_status VARCHAR(50);
    v_user_name VARCHAR(255);
BEGIN
    -- Get current status
    SELECT order_status INTO v_current_status
    FROM orders
    WHERE id = p_order_id;
    
    IF NOT FOUND THEN
        RETURN QUERY SELECT FALSE, 'Order not found';
        RETURN;
    END IF;
    
    IF v_current_status != 'new' THEN
        RETURN QUERY SELECT FALSE, 'Order can only be accepted from new status';
        RETURN;
    END IF;
    
    -- Get user name
    SELECT username INTO v_user_name
    FROM users
    WHERE id = p_user_id;
    
    -- Update order
    UPDATE orders
    SET order_status = 'accepted',
        accepted_at = NOW(),
        updated_at = NOW(),
        updated_by = p_user_id
    WHERE id = p_order_id;
    
    -- Create audit log
    INSERT INTO order_audit_logs (
        order_id,
        action_type,
        from_status,
        to_status,
        performed_by,
        performed_by_name,
        notes
    ) VALUES (
        p_order_id,
        'status_changed',
        'new',
        'accepted',
        p_user_id,
        v_user_name,
        'Order accepted'
    );
    
    RETURN QUERY SELECT TRUE, 'Order accepted successfully';
END;
$$;



--
-- Name: FUNCTION accept_order(p_order_id uuid, p_user_id uuid); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.accept_order(p_order_id uuid, p_user_id uuid) IS 'Admin accepts a new order';


--
-- Name: acknowledge_warning(uuid, uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.acknowledge_warning(warning_id_param uuid, acknowledged_by_param uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    UPDATE employee_warnings 
    SET 
        warning_status = 'acknowledged',
        acknowledged_at = CURRENT_TIMESTAMP,
        acknowledged_by = acknowledged_by_param,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = warning_id_param
    AND warning_status = 'active';
    
    RETURN FOUND;
END;
$$;



--
-- Name: adjust_product_stock_on_order_insert(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.adjust_product_stock_on_order_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    current_quantity INTEGER;
BEGIN
    -- Validate that product_id exists
    IF NEW.product_id IS NULL THEN
        RAISE EXCEPTION 'product_id is required';
    END IF;

    -- Get current stock
    SELECT current_stock INTO current_quantity 
    FROM products 
    WHERE id = NEW.product_id;

    -- If product not found, raise error
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Product with id % does not exist', NEW.product_id;
    END IF;

    -- Decrease stock
    UPDATE products 
    SET current_stock = current_stock - NEW.quantity,
        updated_at = NOW()
    WHERE id = NEW.product_id;

    RAISE NOTICE 'Product % stock decreased by %. New stock: %', 
        NEW.product_id, NEW.quantity, (current_quantity - NEW.quantity);

    RETURN NEW;
END;
$$;



--
-- Name: approve_customer_account(uuid, text, text, uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.approve_customer_account(p_customer_id uuid, p_status text, p_notes text DEFAULT ''::text, p_approved_by uuid DEFAULT NULL::uuid) RETURNS TABLE(success boolean, message text, customer_id uuid)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_current_status TEXT;
    v_approved_by UUID;
    v_is_admin BOOLEAN;
    v_is_master_admin BOOLEAN;
BEGIN
    -- p_approved_by is required since we use custom auth (not Supabase Auth)
    IF p_approved_by IS NULL THEN
        RAISE EXCEPTION 'User ID (p_approved_by) is required.';
    END IF;

    -- Check if the user making the request has admin privileges
    SELECT is_admin, is_master_admin 
    INTO v_is_admin, v_is_master_admin
    FROM users 
    WHERE id = p_approved_by;

    -- Verify user exists and has admin privileges
    IF v_is_admin IS NULL THEN
        RAISE EXCEPTION 'User not found.';
    END IF;

    IF NOT (v_is_admin = true OR v_is_master_admin = true) THEN
        RAISE EXCEPTION 'Access denied. Admin privileges required.';
    END IF;

    -- Validate status parameter
    IF p_status NOT IN ('approved', 'rejected') THEN
        RETURN QUERY SELECT FALSE, 'Invalid status. Must be approved or rejected.', NULL::UUID;
        RETURN;
    END IF;

    -- Use the provided user ID
    v_approved_by := p_approved_by;

    -- Get current customer status
    SELECT registration_status INTO v_current_status
    FROM customers
    WHERE id = p_customer_id;

    -- Check if customer exists
    IF v_current_status IS NULL THEN
        RETURN QUERY SELECT FALSE, 'Customer not found.', NULL::UUID;
        RETURN;
    END IF;

    -- Check if customer is already processed
    IF v_current_status != 'pending' THEN
        RETURN QUERY SELECT FALSE, 'Customer has already been processed.', NULL::UUID;
        RETURN;
    END IF;

    -- Update customer status
    UPDATE customers
    SET 
        registration_status = p_status,
        approved_at = CURRENT_TIMESTAMP,
        approved_by = v_approved_by,
        registration_notes = p_notes,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_customer_id;

    -- Return success
    RETURN QUERY SELECT TRUE, 'Customer ' || p_status || ' successfully.', p_customer_id;
END;
$$;



--
-- Name: FUNCTION approve_customer_account(p_customer_id uuid, p_status text, p_notes text, p_approved_by uuid); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.approve_customer_account(p_customer_id uuid, p_status text, p_notes text, p_approved_by uuid) IS 'Approves or rejects a customer account. Requires admin privileges. Creates user account for approved customers.';


--
-- Name: approve_customer_registration(uuid, uuid, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.approve_customer_registration(p_customer_id uuid, p_approved_by uuid, p_notes text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_access_code text;
    v_customer_name text;
    v_whatsapp_number text;
    result json;
BEGIN
    -- Validate customer exists and is pending
    SELECT c.name, c.whatsapp_number
    INTO v_customer_name, v_whatsapp_number
    FROM public.customers c
    WHERE c.id = p_customer_id AND c.registration_status = 'pending';
    
    IF v_customer_name IS NULL THEN
        RAISE EXCEPTION 'Customer not found or not in pending status';
    END IF;
    
    -- Generate unique access code
    SELECT generate_unique_customer_access_code() INTO v_access_code;
    
    -- Update customer record
    UPDATE public.customers SET
        registration_status = 'approved',
        access_code = v_access_code,
        approved_by = p_approved_by,
        approved_at = now(),
        access_code_generated_at = now(),
        registration_notes = COALESCE(p_notes, registration_notes),
        updated_at = now()
    WHERE id = p_customer_id;
    
    -- Create approval notification
    INSERT INTO public.notifications (
        title,
        message,
        type,
        priority,
        metadata,
        deleted_at
    ) VALUES (
        'Customer Registration Approved',
        'Customer ' || v_customer_name || ' has been approved with access code ' || v_access_code,
        'customer_approved',
        'high',
        json_build_object(
            'customer_id', p_customer_id,
            'access_code', v_access_code,
            'approved_by', p_approved_by,
            'customer_name', v_customer_name,
            'whatsapp_number', v_whatsapp_number
        ),
        NULL
    );
    
    -- Return result
    result := json_build_object(
        'success', true,
        'access_code', v_access_code,
        'customer_name', v_customer_name,
        'whatsapp_number', v_whatsapp_number,
        'message', 'Customer registration approved successfully'
    );
    
    RETURN result;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'success', false,
            'error', SQLERRM
        );
END;
$$;



--
-- Name: assign_order_delivery(uuid, uuid, uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.assign_order_delivery(p_order_id uuid, p_delivery_person_id uuid, p_assigned_by uuid) RETURNS TABLE(success boolean, message text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_delivery_name VARCHAR(255);
    v_assigned_by_name VARCHAR(255);
BEGIN
    -- Get delivery person name
    SELECT username INTO v_delivery_name
    FROM users
    WHERE id = p_delivery_person_id;
    
    IF NOT FOUND THEN
        RETURN QUERY SELECT FALSE, 'Delivery person not found';
        RETURN;
    END IF;
    
    -- Get assigner name
    SELECT username INTO v_assigned_by_name
    FROM users
    WHERE id = p_assigned_by;
    
    -- Update order
    UPDATE orders
    SET delivery_person_id = p_delivery_person_id,
        delivery_assigned_at = NOW(),
        order_status = CASE 
            WHEN order_status = 'ready' THEN 'out_for_delivery'
            ELSE order_status
        END,
        updated_at = NOW(),
        updated_by = p_assigned_by
    WHERE id = p_order_id;
    
    -- Create audit log
    INSERT INTO order_audit_logs (
        order_id,
        action_type,
        assigned_user_id,
        assigned_user_name,
        assignment_type,
        performed_by,
        performed_by_name,
        notes
    ) VALUES (
        p_order_id,
        'assigned_delivery',
        p_delivery_person_id,
        v_delivery_name,
        'delivery',
        p_assigned_by,
        v_assigned_by_name,
        'Delivery person assigned to order'
    );
    
    RETURN QUERY SELECT TRUE, 'Delivery person assigned successfully';
END;
$$;



--
-- Name: FUNCTION assign_order_delivery(p_order_id uuid, p_delivery_person_id uuid, p_assigned_by uuid); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.assign_order_delivery(p_order_id uuid, p_delivery_person_id uuid, p_assigned_by uuid) IS 'Assigns delivery person to order';


--
-- Name: assign_order_picker(uuid, uuid, uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.assign_order_picker(p_order_id uuid, p_picker_id uuid, p_assigned_by uuid) RETURNS TABLE(success boolean, message text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_picker_name VARCHAR(255);
    v_assigned_by_name VARCHAR(255);
BEGIN
    -- Get picker name
    SELECT username INTO v_picker_name
    FROM users
    WHERE id = p_picker_id;
    
    IF NOT FOUND THEN
        RETURN QUERY SELECT FALSE, 'Picker not found';
        RETURN;
    END IF;
    
    -- Get assigner name
    SELECT username INTO v_assigned_by_name
    FROM users
    WHERE id = p_assigned_by;
    
    -- Update order
    UPDATE orders
    SET picker_id = p_picker_id,
        picker_assigned_at = NOW(),
        order_status = CASE 
            WHEN order_status = 'accepted' THEN 'in_picking'
            ELSE order_status
        END,
        updated_at = NOW(),
        updated_by = p_assigned_by
    WHERE id = p_order_id;
    
    -- Create audit log
    INSERT INTO order_audit_logs (
        order_id,
        action_type,
        assigned_user_id,
        assigned_user_name,
        assignment_type,
        performed_by,
        performed_by_name,
        notes
    ) VALUES (
        p_order_id,
        'assigned_picker',
        p_picker_id,
        v_picker_name,
        'picker',
        p_assigned_by,
        v_assigned_by_name,
        'Picker assigned to order'
    );
    
    RETURN QUERY SELECT TRUE, 'Picker assigned successfully';
END;
$$;



--
-- Name: FUNCTION assign_order_picker(p_order_id uuid, p_picker_id uuid, p_assigned_by uuid); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.assign_order_picker(p_order_id uuid, p_picker_id uuid, p_assigned_by uuid) IS 'Assigns picker to order for preparation';


--
-- Name: assign_task_simple(uuid, uuid, text, text, timestamp with time zone, text, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.assign_task_simple(task_id_param uuid, assigned_to_user_id_param uuid, assigned_by_param text, assigned_by_name_param text, deadline_datetime_param timestamp with time zone, priority_param text, notes_param text) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    assignment_id UUID;
BEGIN
    INSERT INTO task_assignments (
        task_id,
        assignment_type,
        assigned_to_user_id,
        assigned_by,
        assigned_by_name,
        deadline_datetime,
        priority_override,
        notes,
        status
    ) VALUES (
        task_id_param,
        'user',
        assigned_to_user_id_param,
        assigned_by_param,
        assigned_by_name_param,
        deadline_datetime_param,
        priority_param,
        notes_param,
        'assigned'
    ) RETURNING id INTO assignment_id;
    
    RETURN assignment_id;
END;
$$;



--
-- Name: authenticate_customer_access_code(text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.authenticate_customer_access_code(p_access_code text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'extensions'
    AS $$
DECLARE
    v_customer record;
    v_hashed_code text;
BEGIN
    v_hashed_code := encode(digest(p_access_code::bytea, 'sha256'), 'hex');

    SELECT id, name, whatsapp_number, registration_status
    INTO v_customer
    FROM public.customers
    WHERE access_code = v_hashed_code
    LIMIT 1;

    IF v_customer.id IS NULL THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'Invalid access code. Please check and try again.'
        );
    END IF;

    IF v_customer.registration_status = 'deleted' THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'ACCOUNT_DELETED',
            'message', 'This account has been deleted. Please register again.'
        );
    END IF;

    IF v_customer.registration_status != 'approved' THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'Your account is pending approval. Please wait for admin confirmation.'
        );
    END IF;

    RETURN jsonb_build_object(
        'success', true,
        'customer_id', v_customer.id,
        'customer_name', v_customer.name,
        'whatsapp_number', v_customer.whatsapp_number,
        'registration_status', v_customer.registration_status
    );
END;
$$;



--
-- Name: auto_create_payment_schedule(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

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
-- Name: bulk_import_customers(text[]); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.bulk_import_customers(p_phone_numbers text[]) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_phone text;
    v_formatted text;
    v_inserted int := 0;
    v_skipped int := 0;
    v_total int := array_length(p_phone_numbers, 1);
    v_exists boolean;
BEGIN
    IF v_total IS NULL OR v_total = 0 THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'No phone numbers provided'
        );
    END IF;

    FOREACH v_phone IN ARRAY p_phone_numbers
    LOOP
        -- Clean and format phone number
        v_formatted := regexp_replace(v_phone, '[^0-9]', '', 'g');
        
        -- Skip empty
        IF length(v_formatted) = 0 THEN
            v_skipped := v_skipped + 1;
            CONTINUE;
        END IF;
        
        -- Ensure 966 prefix
        IF length(v_formatted) = 9 THEN
            v_formatted := '966' || v_formatted;
        ELSIF length(v_formatted) = 10 AND v_formatted LIKE '0%' THEN
            v_formatted := '966' || substring(v_formatted from 2);
        END IF;
        
        -- Check if already exists (any format)
        SELECT EXISTS(
            SELECT 1 FROM public.customers
            WHERE regexp_replace(whatsapp_number, '[^0-9]', '', 'g') = v_formatted
               OR whatsapp_number = v_formatted
               OR whatsapp_number = '+' || v_formatted
        ) INTO v_exists;
        
        IF v_exists THEN
            v_skipped := v_skipped + 1;
            CONTINUE;
        END IF;
        
        -- Insert as pre_registered (no name, no access code)
        INSERT INTO public.customers (
            name, whatsapp_number, registration_status, created_at, updated_at
        ) VALUES (
            'Imported Customer', '+' || v_formatted, 'pre_registered', now(), now()
        );
        
        v_inserted := v_inserted + 1;
    END LOOP;

    RETURN jsonb_build_object(
        'success', true,
        'total', v_total,
        'inserted', v_inserted,
        'skipped', v_skipped,
        'message', v_inserted || ' customers imported, ' || v_skipped || ' skipped (duplicates or invalid)'
    );
END;
$$;



--
-- Name: bulk_toggle_customer_product(text[], boolean); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.bulk_toggle_customer_product(p_barcodes text[], p_value boolean) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_count INTEGER;
BEGIN
    UPDATE products
    SET is_customer_product = p_value
    WHERE barcode = ANY(p_barcodes);

    GET DIAGNOSTICS v_count = ROW_COUNT;

    RETURN json_build_object(
        'success', true,
        'updated_count', v_count
    );
END;
$$;



--
-- Name: calculate_category_days(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.calculate_category_days() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Auto-calculate days for leave categories
    IF NEW.document_category IN ('sick_leave', 'special_leave', 'annual_leave') 
       AND NEW.category_start_date IS NOT NULL 
       AND NEW.category_end_date IS NOT NULL THEN
        NEW.category_days := NEW.category_end_date - NEW.category_start_date + 1;
    END IF;
    
    RETURN NEW;
END;
$$;



--
-- Name: calculate_flyer_product_profit(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.calculate_flyer_product_profit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Calculate profit amount
  NEW.profit := NEW.sale_price - NEW.cost;
  
  -- Calculate profit percentage
  IF NEW.cost > 0 THEN
    NEW.profit_percentage := ((NEW.sale_price - NEW.cost) / NEW.cost) * 100;
  ELSE
    NEW.profit_percentage := 0;
  END IF;
  
  RETURN NEW;
END;
$$;



--
-- Name: calculate_next_visit_date(text, text, text, integer, integer, date, date); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.calculate_next_visit_date(visit_type text, weekday_name text DEFAULT NULL::text, fresh_type text DEFAULT NULL::text, day_number integer DEFAULT NULL::integer, skip_days integer DEFAULT NULL::integer, start_date date DEFAULT NULL::date, current_next_date date DEFAULT NULL::date) RETURNS date
    LANGUAGE plpgsql
    AS $$
DECLARE
    next_date DATE;
    current_date DATE := CURRENT_DATE;
    weekday_num INTEGER;
BEGIN
    CASE visit_type
        WHEN 'weekly' THEN
            -- Calculate next occurrence of the specified weekday
            weekday_num := CASE weekday_name
                WHEN 'sunday' THEN 0
                WHEN 'monday' THEN 1
                WHEN 'tuesday' THEN 2
                WHEN 'wednesday' THEN 3
                WHEN 'thursday' THEN 4
                WHEN 'friday' THEN 5
                WHEN 'saturday' THEN 6
            END;
            
            -- If updating existing record, calculate from current next_date
            IF current_next_date IS NOT NULL THEN
                next_date := current_next_date + INTERVAL '7 days';
            ELSE
                -- Find next occurrence of weekday from today
                next_date := current_date + (weekday_num - EXTRACT(DOW FROM current_date))::INTEGER;
                IF next_date <= current_date THEN
                    next_date := next_date + INTERVAL '7 days';
                END IF;
            END IF;
            
        WHEN 'daily' THEN
            -- Daily visits: next day
            IF current_next_date IS NOT NULL THEN
                next_date := current_next_date + INTERVAL '1 day';
            ELSE
                next_date := current_date + INTERVAL '1 day';
            END IF;
            
        WHEN 'monthly' THEN
            -- Monthly visits on specific day number
            IF current_next_date IS NOT NULL THEN
                -- Add one month to current next date
                next_date := (current_next_date + INTERVAL '1 month')::DATE;
                -- Adjust to correct day of month
                next_date := DATE_TRUNC('month', next_date) + (day_number - 1) * INTERVAL '1 day';
            ELSE
                -- Calculate from current month
                next_date := DATE_TRUNC('month', current_date) + (day_number - 1) * INTERVAL '1 day';
                IF next_date <= current_date THEN
                    -- Move to next month
                    next_date := DATE_TRUNC('month', current_date + INTERVAL '1 month') + (day_number - 1) * INTERVAL '1 day';
                END IF;
            END IF;
            
        WHEN 'skip_days' THEN
            -- Skip specified number of days
            IF current_next_date IS NOT NULL THEN
                next_date := current_next_date + skip_days * INTERVAL '1 day';
            ELSE
                next_date := COALESCE(start_date, current_date) + skip_days * INTERVAL '1 day';
            END IF;
            
        ELSE
            -- Default: next day
            next_date := current_date + INTERVAL '1 day';
    END CASE;
    
    RETURN next_date;
END;
$$;



--
-- Name: calculate_profit(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.calculate_profit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Calculate profit
    NEW.profit = NEW.sale_price - NEW.cost;
    
    -- Calculate profit percentage
    IF NEW.cost > 0 THEN
        NEW.profit_percentage = ((NEW.sale_price - NEW.cost) / NEW.cost) * 100;
    ELSE
        NEW.profit_percentage = 0;
    END IF;
    
    RETURN NEW;
END;
$$;



--
-- Name: calculate_receiving_amounts(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.calculate_receiving_amounts() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Calculate total_return_amount
    NEW.total_return_amount := 
        COALESCE(NEW.expired_return_amount, 0) +
        COALESCE(NEW.near_expiry_return_amount, 0) +
        COALESCE(NEW.over_stock_return_amount, 0) +
        COALESCE(NEW.damage_return_amount, 0);
    
    -- Calculate final_bill_amount (bill_amount - total_return_amount)
    NEW.final_bill_amount := NEW.bill_amount - NEW.total_return_amount;
    
    -- Ensure final amount is not negative
    IF NEW.final_bill_amount < 0 THEN
        NEW.final_bill_amount := 0;
    END IF;
    
    RETURN NEW;
END;
$$;



--
-- Name: calculate_return_totals(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.calculate_return_totals() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Calculate total return amount
  NEW.total_return_amount = COALESCE(NEW.expired_return_amount, 0) + 
                           COALESCE(NEW.near_expiry_return_amount, 0) + 
                           COALESCE(NEW.over_stock_return_amount, 0) + 
                           COALESCE(NEW.damage_return_amount, 0);
  
  -- Calculate final bill amount
  NEW.final_bill_amount = COALESCE(NEW.bill_amount, 0) - NEW.total_return_amount;
  
  RETURN NEW;
END;
$$;



--
-- Name: calculate_schedule_details(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.calculate_schedule_details() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Auto-detect overnight shift if not explicitly set
    IF NEW.is_overnight IS NULL THEN
        NEW.is_overnight := is_overnight_shift(NEW.scheduled_start_time, NEW.scheduled_end_time);
    END IF;
    
    -- Auto-calculate working hours if not provided
    IF NEW.scheduled_hours IS NULL OR NEW.scheduled_hours = 0 THEN
        NEW.scheduled_hours := calculate_working_hours(
            NEW.scheduled_start_time, 
            NEW.scheduled_end_time, 
            NEW.is_overnight
        );
    END IF;
    
    -- Update timestamp
    NEW.updated_at := NOW();
    
    RETURN NEW;
END;
$$;



--
-- Name: calculate_working_hours(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.calculate_working_hours() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  start_minutes INTEGER;
  end_minutes INTEGER;
  hours_diff NUMERIC;
BEGIN
  -- Convert times to minutes since midnight
  start_minutes := EXTRACT(HOUR FROM NEW.shift_start_time)::INTEGER * 60 + 
                   EXTRACT(MINUTE FROM NEW.shift_start_time)::INTEGER;
  end_minutes := EXTRACT(HOUR FROM NEW.shift_end_time)::INTEGER * 60 + 
                 EXTRACT(MINUTE FROM NEW.shift_end_time)::INTEGER;

  -- Calculate hours
  IF NEW.is_shift_overlapping_next_day THEN
    -- If shift overlaps to next day: (1440 - start_minutes + end_minutes) / 60
    hours_diff := (1440 - start_minutes + end_minutes)::NUMERIC / 60;
  ELSE
    -- If shift doesn't overlap: (end_minutes - start_minutes) / 60
    hours_diff := (end_minutes - start_minutes)::NUMERIC / 60;
  END IF;

  NEW.working_hours := ROUND(hours_diff, 2);
  RETURN NEW;
END;
$$;



--
-- Name: calculate_working_hours(timestamp with time zone, timestamp with time zone); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.calculate_working_hours(check_in timestamp with time zone, check_out timestamp with time zone) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF check_in IS NULL OR check_out IS NULL THEN
        RETURN 0.00;
    END IF;
    
    IF check_out <= check_in THEN
        RETURN 0.00;
    END IF;
    
    RETURN ROUND(
        EXTRACT(EPOCH FROM (check_out - check_in)) / 3600.0,
        2
    );
END;
$$;



--
-- Name: calculate_working_hours(time without time zone, time without time zone, boolean); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.calculate_working_hours(start_time time without time zone, end_time time without time zone, is_overnight_shift boolean DEFAULT false) RETURNS numeric
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
    IF is_overnight_shift THEN
        -- For overnight shifts: (24:00 - start_time) + end_time
        RETURN ROUND(
            (EXTRACT(EPOCH FROM (TIME '24:00:00' - start_time)) + 
             EXTRACT(EPOCH FROM end_time)) / 3600.0, 2
        );
    ELSE
        -- For regular shifts: end_time - start_time
        RETURN ROUND(
            EXTRACT(EPOCH FROM (end_time - start_time)) / 3600.0, 2
        );
    END IF;
END;
$$;



--
-- Name: cancel_order(uuid, uuid, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.cancel_order(p_order_id uuid, p_user_id uuid, p_cancellation_reason text) RETURNS TABLE(success boolean, message text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_current_status VARCHAR(50);
    v_user_name VARCHAR(255);
BEGIN
    -- Get current status
    SELECT order_status INTO v_current_status
    FROM orders
    WHERE id = p_order_id;
    
    IF NOT FOUND THEN
        RETURN QUERY SELECT FALSE, 'Order not found';
        RETURN;
    END IF;
    
    IF v_current_status = 'delivered' THEN
        RETURN QUERY SELECT FALSE, 'Cannot cancel delivered order';
        RETURN;
    END IF;
    
    IF v_current_status = 'cancelled' THEN
        RETURN QUERY SELECT FALSE, 'Order is already cancelled';
        RETURN;
    END IF;
    
    -- Get user name
    SELECT username INTO v_user_name
    FROM users
    WHERE id = p_user_id;
    
    -- Update order
    UPDATE orders
    SET order_status = 'cancelled',
        cancelled_at = NOW(),
        cancelled_by = p_user_id,
        cancellation_reason = p_cancellation_reason,
        updated_at = NOW(),
        updated_by = p_user_id
    WHERE id = p_order_id;
    
    -- Create audit log
    INSERT INTO order_audit_logs (
        order_id,
        action_type,
        from_status,
        to_status,
        performed_by,
        performed_by_name,
        notes
    ) VALUES (
        p_order_id,
        'cancelled',
        v_current_status,
        'cancelled',
        p_user_id,
        v_user_name,
        p_cancellation_reason
    );
    
    RETURN QUERY SELECT TRUE, 'Order cancelled successfully';
END;
$$;



--
-- Name: FUNCTION cancel_order(p_order_id uuid, p_user_id uuid, p_cancellation_reason text); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.cancel_order(p_order_id uuid, p_user_id uuid, p_cancellation_reason text) IS 'Cancels order with reason';


--
-- Name: check_accountant_dependency(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.check_accountant_dependency(receiving_record_id_param uuid) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_receiving_record RECORD;
  missing_files TEXT[];
BEGIN
  -- Get the receiving record
  SELECT * INTO v_receiving_record
  FROM receiving_records
  WHERE id = receiving_record_id_param;
  
  IF NOT FOUND THEN
    RETURN jsonb_build_object(
      'can_complete', false,
      'error', 'Receiving record not found',
      'error_code', 'RECORD_NOT_FOUND',
      'message', 'Receiving record not found'
    );
  END IF;
  
  missing_files := ARRAY[]::TEXT[];
  
  -- Check if original bill URL exists (not the boolean flag)
  IF v_receiving_record.original_bill_url IS NULL OR 
     TRIM(v_receiving_record.original_bill_url) = '' THEN
    missing_files := array_append(missing_files, 'Original Bill');
  END IF;
  
  -- Check if PR Excel URL exists (not the boolean flag)
  IF v_receiving_record.pr_excel_file_url IS NULL OR 
     TRIM(v_receiving_record.pr_excel_file_url) = '' THEN
    missing_files := array_append(missing_files, 'PR Excel File');
  END IF;
  
  -- If any files are missing, return error
  IF array_length(missing_files, 1) > 0 THEN
    RETURN jsonb_build_object(
      'can_complete', false,
      'error', 'Missing required files: ' || array_to_string(missing_files, ', ') || '. Please ensure all files are uploaded before completing this task.',
      'error_code', 'REQUIRED_FILES_NOT_UPLOADED',
      'message', 'Missing required files: ' || array_to_string(missing_files, ', ') || '. Please ensure all files are uploaded before completing this task.',
      'missing_files', missing_files
    );
  END IF;
  
  -- All files present, accountant can complete
  RETURN jsonb_build_object(
    'can_complete', true,
    'message', 'All required files are uploaded'
  );
  
EXCEPTION WHEN OTHERS THEN
  RETURN jsonb_build_object(
    'can_complete', false,
    'error', SQLERRM,
    'error_code', 'INTERNAL_ERROR',
    'message', 'Error checking accountant dependencies: ' || SQLERRM
  );
END;
$$;



--
-- Name: check_and_notify_recurring_schedules(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.check_and_notify_recurring_schedules() RETURNS TABLE(schedule_id integer, notification_sent boolean, message text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    rec RECORD;
    notification_exists BOOLEAN;
BEGIN
    -- Process all scheduled single_bill occurrences that are 2 days away
    -- These occurrences were created by generate_recurring_occurrences() function
    FOR rec IN 
        SELECT 
            id,
            branch_id,
            branch_name,
            expense_category_id,
            expense_category_name_en,
            expense_category_name_ar,
            co_user_id,
            co_user_name,
            payment_method,
            amount,
            description,
            bill_type,
            due_date,
            recurring_metadata,
            approver_id,
            approver_name,
            'non_approved_payment_scheduler' as source_table
        FROM non_approved_payment_scheduler
        WHERE schedule_type = 'single_bill'
        AND approval_status = 'pending'
        AND due_date = CURRENT_DATE + INTERVAL '2 days'
        AND recurring_metadata->>'parent_schedule_id' IS NOT NULL -- Only recurring occurrences
        
        UNION ALL
        
        SELECT 
            id,
            branch_id,
            branch_name,
            expense_category_id,
            expense_category_name_en,
            expense_category_name_ar,
            co_user_id,
            co_user_name,
            payment_method,
            amount,
            description,
            bill_type,
            due_date,
            recurring_metadata,
            NULL::INTEGER as approver_id,
            NULL::TEXT as approver_name,
            'expense_scheduler' as source_table
        FROM expense_scheduler
        WHERE schedule_type = 'single_bill'
        AND status = 'pending'
        AND is_paid = FALSE
        AND due_date = CURRENT_DATE + INTERVAL '2 days'
        AND recurring_metadata->>'parent_schedule_id' IS NOT NULL -- Only recurring occurrences
    LOOP
        -- Check if notification already sent for this occurrence
        SELECT EXISTS(
            SELECT 1 FROM notifications
            WHERE metadata->>'schedule_id' = rec.id::TEXT
            AND metadata->>'occurrence_date' = rec.due_date::TEXT
            AND type = 'approval_request'
            AND created_at >= CURRENT_DATE
        ) INTO notification_exists;
        
        -- Send notification if not already sent
        IF NOT notification_exists THEN
            INSERT INTO notifications (
                title,
                message,
                type,
                priority,
                target_type,
                target_users,
                created_by,
                metadata
            ) VALUES (
                'Upcoming Expense Payment Due',
                FORMAT(
                    'A scheduled expense payment is due in 2 days (%s).

Branch: %s
Category: %s
Amount: %s SAR
Payment Method: %s
Recurring Type: %s

Please review and ensure timely payment.',
                    rec.due_date::TEXT,
                    rec.branch_name,
                    rec.expense_category_name_en,
                    rec.amount::TEXT,
                    COALESCE(REPLACE(rec.payment_method, '_', ' '), 'N/A'),
                    REPLACE(rec.recurring_metadata->>'recurring_type', '_', ' ')
                ),
                'approval_request',
                'high',
                'specific_users',
                ARRAY[COALESCE(rec.approver_id, rec.co_user_id)], -- Send to approver or CO user
                'system',
                jsonb_build_object(
                    'schedule_id', rec.id,
                    'occurrence_date', rec.due_date,
                    'parent_schedule_id', rec.recurring_metadata->>'parent_schedule_id',
                    'recurring_type', rec.recurring_metadata->>'recurring_type',
                    'source_table', rec.source_table
                )
            );
            
            schedule_id := rec.id;
            notification_sent := TRUE;
            message := FORMAT('Sent reminder notification for schedule ID %s (due date: %s)', rec.id, rec.due_date);
            RETURN NEXT;
        END IF;
    END LOOP;
    
    RETURN;
END;
$$;



--
-- Name: FUNCTION check_and_notify_recurring_schedules(); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.check_and_notify_recurring_schedules() IS 'Sends reminder notifications to approvers/users 2 days before scheduled payment occurrences. Occurrences are pre-created by generate_recurring_occurrences() function.';


--
-- Name: check_and_notify_recurring_schedules_with_logging(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.check_and_notify_recurring_schedules_with_logging() RETURNS TABLE(schedules_checked integer, notifications_sent integer, execution_date date, message text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    checked_count INTEGER := 0;
    notified_count INTEGER := 0;
    rec RECORD;
BEGIN
    -- Run the notification check
    FOR rec IN SELECT * FROM check_and_notify_recurring_schedules()
    LOOP
        checked_count := checked_count + 1;
        IF rec.notification_sent THEN
            notified_count := notified_count + 1;
        END IF;
    END LOOP;
    
    -- Log the execution
    INSERT INTO recurring_schedule_check_log (
        check_date,
        schedules_checked,
        notifications_sent
    ) VALUES (
        CURRENT_DATE,
        checked_count,
        notified_count
    )
    ON CONFLICT (check_date) 
    DO UPDATE SET
        schedules_checked = recurring_schedule_check_log.schedules_checked + EXCLUDED.schedules_checked,
        notifications_sent = recurring_schedule_check_log.notifications_sent + EXCLUDED.notifications_sent;
    
    -- Return summary
    schedules_checked := checked_count;
    notifications_sent := notified_count;
    execution_date := CURRENT_DATE;
    message := FORMAT('Checked %s schedules, sent %s notifications', checked_count, notified_count);
    RETURN NEXT;
END;
$$;



--
-- Name: FUNCTION check_and_notify_recurring_schedules_with_logging(); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.check_and_notify_recurring_schedules_with_logging() IS 'Wrapper function that calls check_and_notify_recurring_schedules() and logs execution. Use this for cron jobs or manual execution.';


--
-- Name: check_erp_sync_status(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.check_erp_sync_status() RETURNS TABLE(total_inventory_completions bigint, synced_records bigint, unsynced_records bigint, sync_percentage numeric, status text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*) as total_completions,
        COUNT(CASE WHEN rr.erp_purchase_invoice_reference IS NOT NULL THEN 1 END) as synced,
        COUNT(CASE WHEN rr.erp_purchase_invoice_reference IS NULL THEN 1 END) as unsynced,
        ROUND(
            (COUNT(CASE WHEN rr.erp_purchase_invoice_reference IS NOT NULL THEN 1 END)::NUMERIC / 
             COUNT(*)::NUMERIC) * 100, 2
        ) as percentage,
        CASE 
            WHEN COUNT(CASE WHEN rr.erp_purchase_invoice_reference IS NULL THEN 1 END) = 0 
            THEN '✅ ALL SYNCED'
            ELSE '⚠️ SOME UNSYNCED'
        END as sync_status
    FROM task_completions tc
    JOIN receiving_tasks rt ON tc.task_id = rt.task_id AND tc.assignment_id = rt.assignment_id
    JOIN receiving_records rr ON rt.receiving_record_id = rr.id
    WHERE tc.erp_reference_completed = true 
      AND tc.erp_reference_number IS NOT NULL 
      AND tc.erp_reference_number != ''
      AND rt.role_type = 'inventory_manager';
END;
$$;



--
-- Name: check_erp_sync_status_for_record(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.check_erp_sync_status_for_record(receiving_record_id_param uuid) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    status_record RECORD;
    result_json JSONB;
    has_tasks BOOLEAN := false;
BEGIN
    RAISE NOTICE 'Checking sync status for receiving_record_id: %', receiving_record_id_param;
    
    -- Check if this record has any receiving tasks
    SELECT EXISTS (
        SELECT 1 FROM receiving_tasks rt 
        WHERE rt.receiving_record_id = receiving_record_id_param
    ) INTO has_tasks;
    
    RAISE NOTICE 'Record has receiving tasks: %', has_tasks;
    
    IF has_tasks THEN
        -- Get task-based sync status information
        SELECT 
            rr.erp_purchase_invoice_reference,
            tc.erp_reference_number as task_erp_reference,
            tc.erp_reference_completed,
            tc.completed_at as task_completed_at,
            tc.completed_by,
            rt.role_type,
            rt.task_completed as receiving_task_completed,
            CASE 
                WHEN tc.erp_reference_completed = true 
                     AND tc.erp_reference_number IS NOT NULL 
                     AND TRIM(tc.erp_reference_number) != ''
                     AND rr.erp_purchase_invoice_reference = TRIM(tc.erp_reference_number)
                THEN 'SYNCED'
                WHEN tc.erp_reference_completed = true 
                     AND tc.erp_reference_number IS NOT NULL 
                     AND TRIM(tc.erp_reference_number) != ''
                     AND (rr.erp_purchase_invoice_reference IS NULL 
                          OR rr.erp_purchase_invoice_reference != TRIM(tc.erp_reference_number))
                THEN 'NEEDS_SYNC'
                WHEN tc.erp_reference_completed = false 
                     OR tc.erp_reference_number IS NULL 
                     OR TRIM(tc.erp_reference_number) = ''
                THEN 'NO_ERP_REFERENCE'
                ELSE 'UNKNOWN'
            END as sync_status
        INTO status_record
        FROM receiving_records rr
        LEFT JOIN receiving_tasks rt ON rr.id = rt.receiving_record_id AND rt.role_type = 'inventory_manager'
        LEFT JOIN task_completions tc ON rt.task_id = tc.task_id AND rt.assignment_id = tc.assignment_id
        WHERE rr.id = receiving_record_id_param
        ORDER BY tc.completed_at DESC
        LIMIT 1;
    ELSE
        -- For legacy records without tasks, check if they have ERP references
        SELECT 
            rr.erp_purchase_invoice_reference,
            NULL::text as task_erp_reference,
            NULL::boolean as erp_reference_completed,
            NULL::timestamptz as task_completed_at,
            NULL::text as completed_by,
            NULL::text as role_type,
            NULL::boolean as receiving_task_completed,
            CASE 
                WHEN rr.erp_purchase_invoice_reference IS NOT NULL 
                     AND TRIM(rr.erp_purchase_invoice_reference) != ''
                THEN 'LEGACY_WITH_ERP'
                ELSE 'LEGACY_NO_ERP'
            END as sync_status
        INTO status_record
        FROM receiving_records rr
        WHERE rr.id = receiving_record_id_param;
    END IF;

    RAISE NOTICE 'Status check - FOUND: %, Current ERP: %, Task ERP: %, Status: %', 
                 FOUND, status_record.erp_purchase_invoice_reference, 
                 status_record.task_erp_reference, status_record.sync_status;

    IF FOUND THEN
        result_json := jsonb_build_object(
            'success', true,
            'receiving_record_id', receiving_record_id_param,
            'current_erp_reference', status_record.erp_purchase_invoice_reference,
            'task_erp_reference', status_record.task_erp_reference,
            'task_erp_completed', status_record.erp_reference_completed,
            'task_completed_at', status_record.task_completed_at,
            'task_completed_by', status_record.completed_by,
            'receiving_task_completed', status_record.receiving_task_completed,
            'sync_status', status_record.sync_status,
            'sync_needed', status_record.sync_status = 'NEEDS_SYNC',
            'can_sync', status_record.sync_status IN ('NEEDS_SYNC', 'SYNCED', 'LEGACY_WITH_ERP'),
            'has_tasks', has_tasks
        );
    ELSE
        RAISE NOTICE 'No record found for receiving_record_id: %', receiving_record_id_param;
        result_json := jsonb_build_object(
            'success', false,
            'error', 'Receiving record not found'
        );
    END IF;
    
    RETURN result_json;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'ERROR in status check function: %', SQLERRM;
        RETURN jsonb_build_object(
            'success', false,
            'error', SQLERRM,
            'error_code', SQLSTATE
        );
END;
$$;



--
-- Name: FUNCTION check_erp_sync_status_for_record(receiving_record_id_param uuid); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.check_erp_sync_status_for_record(receiving_record_id_param uuid) IS 'Check ERP sync status for a specific receiving record';


--
-- Name: check_offer_eligibility(integer, uuid, numeric, integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.check_offer_eligibility(p_offer_id integer, p_customer_id uuid, p_cart_total numeric DEFAULT 0, p_cart_quantity integer DEFAULT 0) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_offer RECORD;
    v_customer_usage_count INTEGER;
BEGIN
    -- Get offer details
    SELECT * INTO v_offer FROM offers WHERE id = p_offer_id;
    
    IF NOT FOUND THEN
        RETURN false;
    END IF;
    
    -- Check if offer is active
    IF v_offer.is_active = false THEN
        RETURN false;
    END IF;
    
    -- Check date range
    IF NOW() NOT BETWEEN v_offer.start_date AND v_offer.end_date THEN
        RETURN false;
    END IF;
    
    -- Check minimum amount
    IF v_offer.min_amount IS NOT NULL AND p_cart_total < v_offer.min_amount THEN
        RETURN false;
    END IF;
    
    -- Check minimum quantity
    IF v_offer.min_quantity IS NOT NULL AND p_cart_quantity < v_offer.min_quantity THEN
        RETURN false;
    END IF;
    
    -- Check max uses per customer
    IF v_offer.max_uses_per_customer IS NOT NULL THEN
        SELECT COUNT(*) INTO v_customer_usage_count
        FROM offer_usage_logs
        WHERE offer_id = p_offer_id AND customer_id = p_customer_id;
        
        IF v_customer_usage_count >= v_offer.max_uses_per_customer THEN
            RETURN false;
        END IF;
    END IF;
    
    -- Check max total uses
    IF v_offer.max_total_uses IS NOT NULL AND v_offer.current_total_uses >= v_offer.max_total_uses THEN
        RETURN false;
    END IF;
    
    -- If customer-specific, check assignment
    IF v_offer.type = 'customer' THEN
        IF NOT EXISTS (
            SELECT 1 FROM customer_offers
            WHERE offer_id = p_offer_id AND customer_id = p_customer_id
        ) THEN
            RETURN false;
        END IF;
    END IF;
    
    RETURN true;
END;
$$;



--
-- Name: check_orphaned_variations(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.check_orphaned_variations() RETURNS TABLE(barcode text, product_name_en text, product_name_ar text, parent_product_barcode text, reason text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    p.barcode,
    p.product_name_en,
    p.product_name_ar,
    p.parent_product_barcode,
    CASE 
      WHEN p.parent_product_barcode IS NOT NULL 
           AND NOT EXISTS (
             SELECT 1 FROM products parent 
             WHERE parent.barcode = p.parent_product_barcode
           ) THEN 'Parent product does not exist'
      WHEN p.parent_product_barcode = p.barcode THEN 'Self-referencing parent'
      ELSE 'Unknown issue'
    END as reason
  FROM products p
  WHERE p.is_variation = true
    AND (
      (p.parent_product_barcode IS NOT NULL 
       AND NOT EXISTS (
         SELECT 1 FROM products parent 
         WHERE parent.barcode = p.parent_product_barcode
       ))
      OR p.parent_product_barcode = p.barcode
    )
  ORDER BY p.product_name_en;
END;
$$;



--
-- Name: check_overdue_tasks_and_send_reminders(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.check_overdue_tasks_and_send_reminders() RETURNS TABLE(task_id uuid, task_title text, user_id uuid, user_name text, hours_overdue numeric, reminder_sent boolean)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  task_record RECORD;
  notification_id UUID;
  reminder_count INTEGER := 0;
BEGIN
  RAISE NOTICE 'Starting overdue task reminder check at %', NOW();

  -- ========================================
  -- Check regular task assignments
  -- ========================================
  FOR task_record IN
    SELECT 
      ta.id as assignment_id,
      t.id as task_id,
      t.title as task_title,
      ta.assigned_to_user_id,
      u.username as user_name,
      COALESCE(ta.deadline_datetime, ta.deadline_date, t.due_datetime) as deadline,
      EXTRACT(EPOCH FROM (NOW() - COALESCE(ta.deadline_datetime, ta.deadline_date, t.due_datetime))) / 3600 as hours_overdue
    FROM task_assignments ta
    JOIN tasks t ON t.id = ta.task_id
    JOIN users u ON u.id = ta.assigned_to_user_id
    LEFT JOIN task_completions tc ON tc.assignment_id = ta.id
    WHERE tc.id IS NULL  -- Not completed
      AND COALESCE(ta.deadline_datetime, ta.deadline_date, t.due_datetime) IS NOT NULL  -- Has deadline
      AND COALESCE(ta.deadline_datetime, ta.deadline_date, t.due_datetime) < NOW()  -- Overdue
      AND NOT EXISTS (  -- No reminder sent yet
        SELECT 1 FROM task_reminder_logs trl 
        WHERE trl.task_assignment_id = ta.id
      )
    ORDER BY hours_overdue DESC
  LOOP
    BEGIN
      -- Insert notification
      INSERT INTO notifications (
        title,
        message,
        type,
        target_users,
        target_type,
        status,
        sent_at,
        created_at,
        created_by,
        created_by_name,
        created_by_role,
        task_id,
        priority,
        read_count,
        total_recipients,
        metadata
      ) VALUES (
        '⚠️ Overdue Task Reminder',
        'Task: "' || task_record.task_title || '" | Assigned to: ' || task_record.user_name || ' | Deadline: ' || TO_CHAR(task_record.deadline, 'YYYY-MM-DD HH24:MI') || ' | Overdue by: ' || ROUND(task_record.hours_overdue::NUMERIC, 1) || ' hours. Please complete it as soon as possible.',
        'task_overdue',
        jsonb_build_array(task_record.assigned_to_user_id::text),
        'specific_users',
        'published',
        NOW(),
        NOW(),
        'system',
        'System',
        'system',
        task_record.task_id,
        'medium',
        0,
        1,
        jsonb_build_object(
          'task_assignment_id', task_record.assignment_id,
          'task_title', task_record.task_title,
          'hours_overdue', ROUND(task_record.hours_overdue::NUMERIC, 1),
          'deadline', task_record.deadline,
          'reminder_type', 'automatic'
        )
      ) RETURNING id INTO notification_id;

      -- Log the reminder
      INSERT INTO task_reminder_logs (
        task_assignment_id,
        task_title,
        assigned_to_user_id,
        deadline,
        hours_overdue,
        notification_id,
        status
      ) VALUES (
        task_record.assignment_id,
        task_record.task_title,
        task_record.assigned_to_user_id,
        task_record.deadline,
        ROUND(task_record.hours_overdue::NUMERIC, 1),
        notification_id,
        'sent'
      );

      reminder_count := reminder_count + 1;

      -- Return the result
      RETURN QUERY SELECT 
        task_record.task_id,
        task_record.task_title,
        task_record.assigned_to_user_id,
        task_record.user_name,
        ROUND(task_record.hours_overdue::NUMERIC, 1),
        TRUE;

      RAISE NOTICE 'Sent reminder for task "%" to user "%"', task_record.task_title, task_record.user_name;

    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'Failed to send reminder for task %: %', task_record.assignment_id, SQLERRM;
      CONTINUE;
    END;
  END LOOP;

  -- ========================================
  -- Check quick task assignments
  -- ========================================
  FOR task_record IN
    SELECT 
      qa.id as assignment_id,
      qt.id as task_id,
      qt.title as task_title,
      qa.assigned_to_user_id,
      u.username as user_name,
      qt.deadline_datetime as deadline,
      EXTRACT(EPOCH FROM (NOW() - qt.deadline_datetime)) / 3600 as hours_overdue
    FROM quick_task_assignments qa
    JOIN quick_tasks qt ON qt.id = qa.quick_task_id
    JOIN users u ON u.id = qa.assigned_to_user_id
    LEFT JOIN quick_task_completions qc ON qc.assignment_id = qa.id
    WHERE qc.id IS NULL  -- Not completed
      AND qt.deadline_datetime < NOW()  -- Overdue
      AND NOT EXISTS (  -- No reminder sent yet
        SELECT 1 FROM task_reminder_logs trl 
        WHERE trl.quick_task_assignment_id = qa.id
      )
    ORDER BY hours_overdue DESC
  LOOP
    BEGIN
      -- Insert notification
      INSERT INTO notifications (
        title,
        message,
        type,
        target_users,
        target_type,
        status,
        sent_at,
        created_at,
        created_by,
        created_by_name,
        created_by_role,
        task_id,
        priority,
        read_count,
        total_recipients,
        metadata
      ) VALUES (
        '⚠️ Overdue Quick Task Reminder',
        'Quick Task: "' || task_record.task_title || '" | Assigned to: ' || task_record.user_name || ' | Deadline: ' || TO_CHAR(task_record.deadline, 'YYYY-MM-DD HH24:MI') || ' | Overdue by: ' || ROUND(task_record.hours_overdue::NUMERIC, 1) || ' hours. Please complete it as soon as possible.',
        'task_overdue',
        jsonb_build_array(task_record.assigned_to_user_id::text),
        'specific_users',
        'published',
        NOW(),
        NOW(),
        'system',
        'System',
        'system',
        task_record.task_id,
        'medium',
        0,
        1,
        jsonb_build_object(
          'quick_task_assignment_id', task_record.assignment_id,
          'task_title', task_record.task_title,
          'hours_overdue', ROUND(task_record.hours_overdue::NUMERIC, 1),
          'deadline', task_record.deadline,
          'reminder_type', 'automatic'
        )
      ) RETURNING id INTO notification_id;

      -- Log the reminder
      INSERT INTO task_reminder_logs (
        quick_task_assignment_id,
        task_title,
        assigned_to_user_id,
        deadline,
        hours_overdue,
        notification_id,
        status
      ) VALUES (
        task_record.assignment_id,
        task_record.task_title,
        task_record.assigned_to_user_id,
        task_record.deadline,
        ROUND(task_record.hours_overdue::NUMERIC, 1),
        notification_id,
        'sent'
      );

      reminder_count := reminder_count + 1;

      -- Return the result
      RETURN QUERY SELECT 
        task_record.task_id,
        task_record.task_title,
        task_record.assigned_to_user_id,
        task_record.user_name,
        ROUND(task_record.hours_overdue::NUMERIC, 1),
        TRUE;

      RAISE NOTICE 'Sent reminder for quick task "%" to user "%"', task_record.task_title, task_record.user_name;

    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'Failed to send reminder for quick task %: %', task_record.assignment_id, SQLERRM;
      CONTINUE;
    END;
  END LOOP;

  RAISE NOTICE 'Completed overdue task reminder check. Sent % reminders.', reminder_count;
  RETURN;
END;
$$;



--
-- Name: FUNCTION check_overdue_tasks_and_send_reminders(); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.check_overdue_tasks_and_send_reminders() IS 'Automatic task reminder system - runs hourly via pg_cron. Uses SECURITY DEFINER to bypass RLS.';


--
-- Name: check_receiving_task_dependencies(uuid, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.check_receiving_task_dependencies(receiving_record_id_param uuid, role_type_param text) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  template_record RECORD;
  dependency_role TEXT;
  missing_dependencies TEXT[] := ARRAY[]::TEXT[];
  blocking_roles TEXT[] := ARRAY[]::TEXT[];
  completed_dependencies TEXT[] := ARRAY[]::TEXT[];
  v_total_tasks INT;
  v_completed_tasks INT;
BEGIN
  -- Get the template for the role
  SELECT * INTO template_record
  FROM receiving_task_templates
  WHERE role_type = role_type_param;

  IF NOT FOUND THEN
    RETURN json_build_object(
      'can_complete', false,
      'error', 'Template not found for role: ' || role_type_param,
      'missing_dependencies', ARRAY[]::TEXT[],
      'blocking_roles', ARRAY[]::TEXT[],
      'completed_dependencies', ARRAY[]::TEXT[]
    );
  END IF;

  -- If no dependencies, can complete
  IF template_record.depends_on_role_types IS NULL OR array_length(template_record.depends_on_role_types, 1) = 0 THEN
    RETURN json_build_object(
      'can_complete', true,
      'missing_dependencies', ARRAY[]::TEXT[],
      'blocking_roles', ARRAY[]::TEXT[],
      'completed_dependencies', ARRAY[]::TEXT[]
    );
  END IF;

  -- Check each dependency
  -- For array roles (shelf_stocker, warehouse_handler, night_supervisor),
  -- ALL tasks must be completed before the dependent role can proceed
  FOREACH dependency_role IN ARRAY template_record.depends_on_role_types
  LOOP
    -- Count total and completed tasks for this role
    SELECT
      COUNT(*),
      COUNT(*) FILTER (WHERE task_completed = true)
    INTO v_total_tasks, v_completed_tasks
    FROM receiving_tasks
    WHERE receiving_record_id = receiving_record_id_param
      AND role_type = dependency_role;

    IF v_total_tasks = 0 OR v_completed_tasks < v_total_tasks THEN
      -- Either no tasks exist or not ALL are completed
      missing_dependencies := array_append(missing_dependencies, dependency_role);

      CASE dependency_role
        WHEN 'inventory_manager' THEN
          blocking_roles := array_append(blocking_roles, 'Inventory Manager must complete their task first');
        WHEN 'purchase_manager' THEN
          blocking_roles := array_append(blocking_roles, 'Purchase Manager must complete their task first');
        WHEN 'shelf_stocker' THEN
          IF v_total_tasks > 1 THEN
            blocking_roles := array_append(blocking_roles, 'All Shelf Stockers must complete their tasks first (' || v_completed_tasks || '/' || v_total_tasks || ' done)');
          ELSE
            blocking_roles := array_append(blocking_roles, 'Shelf Stocker must complete their task first');
          END IF;
        WHEN 'warehouse_handler' THEN
          IF v_total_tasks > 1 THEN
            blocking_roles := array_append(blocking_roles, 'All Warehouse Handlers must complete their tasks first (' || v_completed_tasks || '/' || v_total_tasks || ' done)');
          ELSE
            blocking_roles := array_append(blocking_roles, 'Warehouse Handler must complete their task first');
          END IF;
        WHEN 'night_supervisor' THEN
          IF v_total_tasks > 1 THEN
            blocking_roles := array_append(blocking_roles, 'All Night Supervisors must complete their tasks first (' || v_completed_tasks || '/' || v_total_tasks || ' done)');
          ELSE
            blocking_roles := array_append(blocking_roles, 'Night Supervisor must complete their task first');
          END IF;
        ELSE
          blocking_roles := array_append(blocking_roles, dependency_role || ' must complete their task first');
      END CASE;
    ELSE
      completed_dependencies := array_append(completed_dependencies, dependency_role);
    END IF;
  END LOOP;

  -- Return result
  IF array_length(missing_dependencies, 1) > 0 THEN
    RETURN json_build_object(
      'can_complete', false,
      'missing_dependencies', missing_dependencies,
      'blocking_roles', blocking_roles,
      'completed_dependencies', completed_dependencies
    );
  ELSE
    RETURN json_build_object(
      'can_complete', true,
      'missing_dependencies', ARRAY[]::TEXT[],
      'blocking_roles', ARRAY[]::TEXT[],
      'completed_dependencies', completed_dependencies
    );
  END IF;
END;
$$;



--
-- Name: check_task_completion_criteria(uuid, boolean, boolean, boolean); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.check_task_completion_criteria(task_uuid uuid, task_finished_val boolean, photo_uploaded_val boolean, erp_reference_val boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    task_record record;
BEGIN
    SELECT require_task_finished, require_photo_upload, require_erp_reference
    INTO task_record
    FROM tasks 
    WHERE id = task_uuid;
    
    -- Check if all required criteria are met
    IF (task_record.require_task_finished = false OR task_finished_val = true) AND
       (task_record.require_photo_upload = false OR photo_uploaded_val = true) AND
       (task_record.require_erp_reference = false OR erp_reference_val = true) THEN
        RETURN true;
    ELSE
        RETURN false;
    END IF;
END;
$$;



--
-- Name: check_user_permission(text, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.check_user_permission(p_function_code text, p_permission text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  -- Old role system removed - this function is deprecated
  -- Return false since we now use button_permissions system
  -- TODO: Remove calls to this function from application code
  RETURN false;
END;
$$;



--
-- Name: check_visit_conflicts(uuid, date, time without time zone, integer, uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.check_visit_conflicts(branch_uuid uuid, visit_date_param date, visit_time_param time without time zone, duration_minutes integer DEFAULT 60, exclude_visit_id uuid DEFAULT NULL::uuid) RETURNS TABLE(conflict_count integer, conflicting_visits text[])
    LANGUAGE plpgsql
    AS $$
DECLARE
    start_time TIME;
    end_time TIME;
BEGIN
    -- Calculate time range
    start_time := visit_time_param;
    end_time := visit_time_param + (duration_minutes || ' minutes')::INTERVAL;
    
    RETURN QUERY
    SELECT 
        COUNT(*)::INTEGER as conflict_count,
        ARRAY_AGG(
            'Visit with ' || v.company || ' at ' || vv.visit_time::TEXT
        ) as conflicting_visits
    FROM vendor_visits vv
    JOIN vendors v ON vv.vendor_id = v.id
    WHERE vv.branch_id = branch_uuid 
    AND vv.visit_date = visit_date_param
    AND vv.status IN ('scheduled', 'confirmed', 'in_progress')
    AND (exclude_visit_id IS NULL OR vv.id != exclude_visit_id)
    AND vv.visit_time IS NOT NULL
    AND (
        -- Check for time overlap
        (vv.visit_time BETWEEN start_time AND end_time) OR
        (vv.visit_time + (vv.expected_duration_minutes || ' minutes')::INTERVAL BETWEEN start_time AND end_time) OR
        (start_time BETWEEN vv.visit_time AND vv.visit_time + (vv.expected_duration_minutes || ' minutes')::INTERVAL)
    );
END;
$$;



--
-- Name: claim_coupon(uuid, character varying, uuid, bigint, uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.claim_coupon(p_campaign_id uuid, p_mobile_number character varying, p_product_id uuid, p_branch_id bigint, p_user_id uuid) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_claim_id UUID;
  v_product_details JSONB;
  v_stock_remaining INTEGER;
  v_max_claims_per_customer INTEGER;
  v_current_claim_count INTEGER;
BEGIN
  -- Get max claims per customer for this campaign
  SELECT COALESCE(max_claims_per_customer, 1)
  INTO v_max_claims_per_customer
  FROM coupon_campaigns
  WHERE id = p_campaign_id;
  
  -- Count current claims
  SELECT COUNT(*)
  INTO v_current_claim_count
  FROM coupon_claims
  WHERE campaign_id = p_campaign_id
    AND customer_mobile = p_mobile_number;
  
  -- Check if reached maximum claims
  IF v_current_claim_count >= v_max_claims_per_customer THEN
    RETURN jsonb_build_object(
      'success', false,
      'error_message', 'Customer has already claimed ' || v_current_claim_count || ' time(s). Maximum allowed: ' || v_max_claims_per_customer
    );
  END IF;
  
  -- Check product stock
  SELECT stock_remaining INTO v_stock_remaining
  FROM coupon_products
  WHERE id = p_product_id
    AND is_active = true
    AND deleted_at IS NULL
  FOR UPDATE;
  
  IF v_stock_remaining IS NULL OR v_stock_remaining <= 0 THEN
    RETURN jsonb_build_object(
      'success', false,
      'error_message', 'Product is out of stock'
    );
  END IF;
  
  -- Insert claim record
  INSERT INTO coupon_claims (
    campaign_id,
    customer_mobile,
    product_id,
    branch_id,
    claimed_by_user,
    validity_date,
    status
  ) VALUES (
    p_campaign_id,
    p_mobile_number,
    p_product_id,
    p_branch_id,
    p_user_id,
    CURRENT_DATE,
    'claimed'
  )
  RETURNING id INTO v_claim_id;
  
  -- Decrement stock
  UPDATE coupon_products
  SET 
    stock_remaining = stock_remaining - 1,
    updated_at = now()
  WHERE id = p_product_id;
  
  -- Get product details for receipt
  SELECT jsonb_build_object(
    'product_id', id,
    'product_name_en', product_name_en,
    'product_name_ar', product_name_ar,
    'product_image_url', product_image_url,
    'original_price', original_price,
    'offer_price', offer_price,
    'special_barcode', special_barcode,
    'savings', (original_price - offer_price)
  )
  INTO v_product_details
  FROM coupon_products
  WHERE id = p_product_id;
  
  -- Return success with details
  RETURN jsonb_build_object(
    'success', true,
    'claim_id', v_claim_id,
    'product_details', v_product_details,
    'validity_date', CURRENT_DATE,
    'current_claims', v_current_claim_count + 1,
    'remaining_claims', v_max_claims_per_customer - v_current_claim_count - 1
  );
END;
$$;



--
-- Name: cleanup_expired_otps(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.cleanup_expired_otps() RETURNS void
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  DELETE FROM access_code_otp WHERE expires_at < NOW();
$$;



--
-- Name: cleanup_expired_sessions(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.cleanup_expired_sessions() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Clean up expired device sessions
    UPDATE user_device_sessions
    SET is_active = false
    WHERE expires_at < NOW()
    AND is_active = true;
    
    -- Mark old push subscriptions as inactive
    UPDATE push_subscriptions
    SET is_active = false
    WHERE last_seen < NOW() - INTERVAL '30 days'
    AND is_active = true;
    
    -- Clean up old notification queue entries
    DELETE FROM notification_queue
    WHERE created_at < NOW() - INTERVAL '7 days'
    AND status IN ('sent', 'delivered', 'failed');
    
    -- Clean up old audit logs (keep last 90 days)
    DELETE FROM user_audit_logs
    WHERE created_at < NOW() - INTERVAL '90 days';
END;
$$;



--
-- Name: clear_analytics_logs(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.clear_analytics_logs() RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  tbl record;
  cnt int := 0;
  total_freed bigint := 0;
  tbl_size bigint;
  db_size_before bigint;
  db_size_after bigint;
BEGIN
  -- Get _supabase database size before
  SELECT pg_database_size('_supabase') INTO db_size_before;

  -- Use dblink to truncate tables in _supabase database
  PERFORM dblink_connect('analytics_conn', 'dbname=_supabase user=supabase_admin');

  FOR tbl IN
    SELECT t.tablename FROM dblink('analytics_conn',
      'SELECT tablename::text FROM pg_tables WHERE schemaname = ''_analytics'' AND tablename LIKE ''log_events_%'''
    ) AS t(tablename text)
  LOOP
    PERFORM dblink_exec('analytics_conn', format('TRUNCATE TABLE _analytics.%I', tbl.tablename));
    cnt := cnt + 1;
  END LOOP;

  -- Vacuum to reclaim space
  IF cnt > 0 THEN
    PERFORM dblink_exec('analytics_conn', 'VACUUM FULL');
  END IF;

  PERFORM dblink_disconnect('analytics_conn');

  -- Get _supabase database size after
  SELECT pg_database_size('_supabase') INTO db_size_after;

  RETURN format('Cleared %s log tables, freed ~%s', cnt, pg_size_pretty(GREATEST(db_size_before - db_size_after, 0)));
END;
$$;



--
-- Name: clear_main_document_columns(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.clear_main_document_columns() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Clear the dedicated columns based on document type
    IF OLD.document_type = 'health_card' THEN
        OLD.health_card_number := NULL;
        OLD.health_card_expiry := NULL;
    ELSIF OLD.document_type = 'resident_id' THEN
        OLD.resident_id_number := NULL;
        OLD.resident_id_expiry := NULL;
    ELSIF OLD.document_type = 'passport' THEN
        OLD.passport_number := NULL;
        OLD.passport_expiry := NULL;
    ELSIF OLD.document_type = 'driving_license' THEN
        OLD.driving_license_number := NULL;
        OLD.driving_license_expiry := NULL;
    ELSIF OLD.document_type = 'resume' THEN
        OLD.resume_uploaded := FALSE;
    END IF;
    
    RETURN OLD;
END;
$$;



--
-- Name: clear_sync_tables(text[]); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.clear_sync_tables(p_tables text[]) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_table text;
    v_allowed_tables text[] := ARRAY[
        'branches', 'users', 'user_sessions', 'user_device_sessions',
        'button_permissions', 'sidebar_buttons', 'button_main_sections', 'button_sub_sections',
        'interface_permissions', 'user_favorite_buttons',
        'erp_synced_products', 'product_categories', 'products', 'product_units',
        'offers', 'offer_products', 'offer_names', 'offer_bundles', 'offer_cart_tiers',
        'bogo_offer_rules', 'flyer_offers', 'flyer_offer_products',
        'customers', 'privilege_cards_master', 'privilege_cards_branch',
        'desktop_themes', 'user_theme_assignments',
        'erp_connections', 'erp_sync_logs'
    ];
BEGIN
    -- Disable FK constraint triggers
    PERFORM set_config('session_replication_role', 'replica', true);
    
    FOREACH v_table IN ARRAY p_tables LOOP
        IF v_table = ANY(v_allowed_tables) THEN
            EXECUTE format('DELETE FROM %I', v_table);
        END IF;
    END LOOP;
    
    -- Re-enable
    PERFORM set_config('session_replication_role', 'origin', true);
EXCEPTION WHEN OTHERS THEN
    PERFORM set_config('session_replication_role', 'origin', true);
    RAISE;
END;
$$;



--
-- Name: complete_receiving_task(uuid, uuid, character varying, text, boolean, boolean, boolean, text, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.complete_receiving_task(receiving_task_id_param uuid, user_id_param uuid, erp_reference_param character varying DEFAULT NULL::character varying, original_bill_file_path_param text DEFAULT NULL::text, has_erp_purchase_invoice boolean DEFAULT false, has_pr_excel_file boolean DEFAULT false, has_original_bill boolean DEFAULT false, completion_photo_url_param text DEFAULT NULL::text, completion_notes_param text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_task RECORD;
  v_receiving_record_id UUID;
  v_template RECORD;
  dependency_check_result JSONB;  -- Changed from JSON to JSONB
  accountant_dependency_result JSONB;  -- Changed from JSON to JSONB
  blocking_roles_array TEXT[];
BEGIN
  -- Get the task
  SELECT * INTO v_task
  FROM receiving_tasks
  WHERE id = receiving_task_id_param;
  
  IF NOT FOUND THEN
    RETURN jsonb_build_object(  -- Changed from json_build_object
      'success', false,
      'error', 'Task not found',
      'error_code', 'TASK_NOT_FOUND'
    );
  END IF;

  v_receiving_record_id := v_task.receiving_record_id;

  -- Get template for requirements
  SELECT * INTO v_template
  FROM receiving_task_templates
  WHERE role_type = v_task.role_type;

  -- SPECIAL CHECK FOR ACCOUNTANT: Must wait for files to be uploaded
  IF v_task.role_type = 'accountant' THEN
    accountant_dependency_result := check_accountant_dependency(v_receiving_record_id);
    
    IF NOT (accountant_dependency_result->>'can_complete')::BOOLEAN THEN
      RETURN jsonb_build_object(  -- Changed from json_build_object
        'success', false,
        'error', accountant_dependency_result->>'error',
        'error_code', accountant_dependency_result->>'error_code',
        'message', accountant_dependency_result->>'message'
      );
    END IF;
  END IF;

  -- Check photo requirement (for non-exempt tasks)
  IF v_template.require_photo_upload AND completion_photo_url_param IS NULL THEN
    -- Check if task is exempt from new rules (backward compatibility)
    IF v_task.rule_effective_date IS NOT NULL THEN
      RETURN jsonb_build_object(  -- Changed from json_build_object
        'success', false,
        'error', 'Photo upload is required for this role',
        'error_code', 'PHOTO_REQUIRED'
      );
    END IF;
  END IF;

  -- Check other dependencies (existing logic) - FIXED VERSION
  IF v_template.depends_on_role_types IS NOT NULL AND array_length(v_template.depends_on_role_types, 1) > 0 THEN
    dependency_check_result := check_receiving_task_dependencies(
      v_receiving_record_id, 
      v_task.role_type
    );

    IF NOT (dependency_check_result->>'can_complete')::BOOLEAN THEN
      -- Extract blocking roles properly from JSONB
      IF dependency_check_result ? 'blocking_roles' THEN
        -- Convert JSONB array to PostgreSQL array
        SELECT ARRAY(
          SELECT jsonb_array_elements_text(dependency_check_result->'blocking_roles')
        ) INTO blocking_roles_array;
      ELSE
        blocking_roles_array := ARRAY[]::TEXT[];
      END IF;

      RETURN jsonb_build_object(  -- Changed from json_build_object
        'success', false,
        'error', 'Cannot complete task. Missing dependencies: ' || 
                COALESCE(array_to_string(blocking_roles_array, ', '), 'Unknown dependencies'),
        'error_code', 'DEPENDENCIES_NOT_MET',
        'blocking_roles', blocking_roles_array,
        'dependency_details', dependency_check_result
      );
    END IF;
  END IF;

  -- Validation for Inventory Manager role
  IF v_task.role_type = 'inventory_manager' THEN
    IF erp_reference_param IS NULL OR erp_reference_param = '' THEN
      RETURN jsonb_build_object(  -- Changed from json_build_object
        'success', false,
        'error', 'ERP reference is required for Inventory Manager',
        'error_code', 'MISSING_ERP_REFERENCE'
      );
    END IF;
    
    IF NOT has_pr_excel_file THEN
      RETURN jsonb_build_object(  -- Changed from json_build_object
        'success', false,
        'error', 'PR Excel file is required for Inventory Manager',
        'error_code', 'MISSING_PR_EXCEL'
      );
    END IF;
    
    IF NOT has_original_bill THEN
      RETURN jsonb_build_object(  -- Changed from json_build_object
        'success', false,
        'error', 'Original bill is required for Inventory Manager',
        'error_code', 'MISSING_ORIGINAL_BILL'
      );
    END IF;
  END IF;

  -- For Purchase Manager, check PR Excel upload and verification status
  IF v_task.role_type = 'purchase_manager' THEN
    DECLARE
      v_receiving_record RECORD;
      v_payment_schedule RECORD;
    BEGIN
      -- Get receiving record details
      SELECT * INTO v_receiving_record
      FROM receiving_records
      WHERE id = v_task.receiving_record_id;
      
      -- Check if PR Excel file is uploaded
      IF v_receiving_record.pr_excel_file_url IS NULL OR v_receiving_record.pr_excel_file_url = '' THEN
        RETURN jsonb_build_object(  -- Changed from json_build_object
          'success', false,
          'error', 'PR Excel not uploaded',
          'error_code', 'PR_EXCEL_NOT_UPLOADED'
        );
      END IF;
      
      -- Get payment schedule to check verification status
      SELECT * INTO v_payment_schedule
      FROM vendor_payment_schedules
      WHERE receiving_record_id = v_task.receiving_record_id;
      
      IF NOT FOUND THEN
        RETURN jsonb_build_object(  -- Changed from json_build_object
          'success', false,
          'error', 'Payment schedule not found. PR Excel may not be processed yet.',
          'error_code', 'PAYMENT_SCHEDULE_NOT_FOUND'
        );
      END IF;
      
      IF v_payment_schedule.verification_status != 'verified' THEN
        RETURN jsonb_build_object(  -- Changed from json_build_object
          'success', false,
          'error', 'Payment schedule not verified. Current status: ' || COALESCE(v_payment_schedule.verification_status, 'unverified'),
          'error_code', 'PAYMENT_SCHEDULE_NOT_VERIFIED'
        );
      END IF;
    END;
  END IF;

  -- Update the task
  UPDATE receiving_tasks
  SET 
    task_status = 'completed',
    task_completed = true,
    completed_at = NOW(),
    completed_by_user_id = user_id_param,
    completion_photo_url = COALESCE(completion_photo_url_param, completion_photo_url),
    completion_notes = COALESCE(completion_notes_param, completion_notes),
    erp_reference_number = CASE 
      WHEN v_task.role_type = 'inventory_manager' THEN erp_reference_param 
      ELSE erp_reference_number
    END,
    original_bill_uploaded = CASE 
      WHEN v_task.role_type = 'inventory_manager' THEN has_original_bill
      ELSE original_bill_uploaded
    END,
    updated_at = NOW()
  WHERE id = receiving_task_id_param;
  
  -- If this is an Inventory Manager task, update the receiving_records table
  IF v_task.role_type = 'inventory_manager' THEN
    UPDATE receiving_records
    SET 
      erp_purchase_invoice_uploaded = has_erp_purchase_invoice,
      pr_excel_file_uploaded = has_pr_excel_file,
      original_bill_uploaded = has_original_bill,
      updated_at = NOW()
    WHERE id = v_receiving_record_id;
  END IF;
  
  RETURN jsonb_build_object(  -- Changed from json_build_object
    'success', true,
    'task_id', receiving_task_id_param,
    'role_type', v_task.role_type,
    'completed_at', NOW(),
    'completed_by', user_id_param,
    'message', 'Task completed successfully'
  );
  
EXCEPTION WHEN OTHERS THEN
  RETURN jsonb_build_object(  -- Changed from json_build_object
    'success', false,
    'error', SQLERRM,
    'error_code', 'INTERNAL_ERROR'
  );
END;
$$;



--
-- Name: complete_receiving_task_fixed(uuid, uuid, text, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.complete_receiving_task_fixed(receiving_task_id_param uuid, user_id_param uuid, completion_photo_url_param text DEFAULT NULL::text, completion_notes_param text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_task RECORD;
  v_receiving_record RECORD;
  v_payment_schedule RECORD;
  v_result JSONB;
BEGIN
  -- Get task details
  SELECT * INTO v_task
  FROM receiving_tasks
  WHERE id = receiving_task_id_param
    AND assigned_user_id = user_id_param;
  
  IF NOT FOUND THEN
    RETURN json_build_object(
      'success', false,
      'error', 'Task not found or not assigned to user',
      'error_code', 'TASK_NOT_FOUND'
    );
  END IF;
  
  -- Check if task is already completed
  IF v_task.task_completed THEN
    RETURN json_build_object(
      'success', false,
      'error', 'Task is already completed',
      'error_code', 'TASK_ALREADY_COMPLETED'
    );
  END IF;
  
  -- Get receiving record
  SELECT * INTO v_receiving_record
  FROM receiving_records
  WHERE id = v_task.receiving_record_id;
  
  IF NOT FOUND THEN
    RETURN json_build_object(
      'success', false,
      'error', 'Receiving record not found',
      'error_code', 'RECEIVING_RECORD_NOT_FOUND'
    );
  END IF;

  -- Role-specific validations
  IF v_task.role_type = 'inventory_manager' THEN
    -- Check inventory manager requirements
    IF NOT v_receiving_record.erp_purchase_invoice_uploaded THEN
      RETURN json_build_object(
        'success', false,
        'error', 'ERP purchase invoice not uploaded',
        'error_code', 'ERP_INVOICE_REQUIRED'
      );
    END IF;
    
    IF NOT v_receiving_record.pr_excel_file_uploaded THEN
      RETURN json_build_object(
        'success', false,
        'error', 'PR Excel file not uploaded',
        'error_code', 'PR_EXCEL_REQUIRED'
      );
    END IF;
    
    IF NOT v_receiving_record.original_bill_uploaded THEN
      RETURN json_build_object(
        'success', false,
        'error', 'Original bill not uploaded',
        'error_code', 'ORIGINAL_BILL_REQUIRED'
      );
    END IF;
    
  ELSIF v_task.role_type = 'purchase_manager' THEN
    -- Check purchase manager requirements
    IF NOT v_receiving_record.pr_excel_file_uploaded THEN
      RETURN json_build_object(
        'success', false,
        'error', 'PR Excel file not uploaded by inventory manager',
        'error_code', 'PR_EXCEL_REQUIRED'
      );
    END IF;
    
    -- Check payment schedule verification status - FIXED TABLE NAME
    SELECT * INTO v_payment_schedule
    FROM vendor_payment_schedule  -- CORRECTED: singular form
    WHERE receiving_record_id = v_task.receiving_record_id;
    
    -- For now, skip the payment schedule check if table doesn't exist
    -- This allows purchase managers to complete tasks
    -- IF NOT FOUND THEN
    --   RETURN json_build_object(
    --     'success', false,
    --     'error', 'Payment schedule not found. PR Excel may not be processed yet.',
    --     'error_code', 'PAYMENT_SCHEDULE_NOT_FOUND'
    --   );
    -- END IF;
    
  ELSIF v_task.role_type = 'accountant' THEN
    -- Check accountant dependency on inventory manager original bill upload
    IF NOT v_receiving_record.original_bill_uploaded OR v_receiving_record.original_bill_url IS NULL THEN
      RETURN json_build_object(
        'success', false,
        'error', 'Original bill not uploaded by the inventory manager – please follow up.',
        'error_code', 'DEPENDENCIES_NOT_MET'
      );
    END IF;
  END IF;

  -- Update the task as completed
  UPDATE receiving_tasks
  SET 
    task_completed = true,
    completed_at = CURRENT_TIMESTAMP,
    completion_photo_url = completion_photo_url_param,
    completion_notes = completion_notes_param
  WHERE id = receiving_task_id_param;
  
  -- Return success
  v_result := json_build_object(
    'success', true,
    'message', 'Task completed successfully',
    'task_id', receiving_task_id_param,
    'role_type', v_task.role_type,
    'completed_at', CURRENT_TIMESTAMP
  );
  
  RETURN v_result;
  
EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object(
    'success', false,
    'error', SQLERRM,
    'error_code', 'INTERNAL_ERROR'
  );
END;
$$;



--
-- Name: complete_receiving_task_simple(uuid, uuid, text, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.complete_receiving_task_simple(receiving_task_id_param uuid, user_id_param uuid, completion_photo_url_param text DEFAULT NULL::text, completion_notes_param text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_task RECORD;
  v_receiving_record RECORD;
  v_result JSONB;
BEGIN
  -- Get task details
  SELECT * INTO v_task
  FROM receiving_tasks
  WHERE id = receiving_task_id_param
    AND assigned_user_id = user_id_param;
  
  IF NOT FOUND THEN
    RETURN json_build_object(
      'success', false,
      'error', 'Task not found or not assigned to user',
      'error_code', 'TASK_NOT_FOUND'
    );
  END IF;
  
  -- Check if task is already completed
  IF v_task.task_completed THEN
    RETURN json_build_object(
      'success', false,
      'error', 'Task is already completed',
      'error_code', 'TASK_ALREADY_COMPLETED'
    );
  END IF;
  
  -- Get receiving record
  SELECT * INTO v_receiving_record
  FROM receiving_records
  WHERE id = v_task.receiving_record_id;
  
  IF NOT FOUND THEN
    RETURN json_build_object(
      'success', false,
      'error', 'Receiving record not found',
      'error_code', 'RECEIVING_RECORD_NOT_FOUND'
    );
  END IF;

  -- Simplified role-specific validations (no payment schedule checks!)
  IF v_task.role_type = 'purchase_manager' THEN
    -- Purchase manager ONLY needs PR Excel URL to exist (not the boolean flag!)
    -- CHANGED: Check URL column instead of boolean flag
    IF v_receiving_record.pr_excel_file_url IS NULL OR v_receiving_record.pr_excel_file_url = '' THEN
      RETURN json_build_object(
        'success', false,
        'error', 'PR Excel file not uploaded by inventory manager',
        'error_code', 'PR_EXCEL_REQUIRED'
      );
    END IF;
  ELSIF v_task.role_type = 'accountant' THEN
    -- Check accountant dependency on inventory manager original bill upload
    -- CHANGED: Also check URL column for accountant
    IF v_receiving_record.original_bill_url IS NULL OR v_receiving_record.original_bill_url = '' THEN
      RETURN json_build_object(
        'success', false,
        'error', 'Original bill not uploaded by the inventory manager – please follow up.',
        'error_code', 'DEPENDENCIES_NOT_MET'
      );
    END IF;
  END IF;

  -- Update the task as completed (update BOTH fields)
  UPDATE receiving_tasks
  SET 
    task_completed = true,
    task_status = 'completed',
    completed_at = CURRENT_TIMESTAMP,
    completion_photo_url = completion_photo_url_param,
    completion_notes = completion_notes_param
  WHERE id = receiving_task_id_param;
  
  -- Return success
  v_result := json_build_object(
    'success', true,
    'message', 'Task completed successfully',
    'task_id', receiving_task_id_param,
    'role_type', v_task.role_type,
    'completed_at', CURRENT_TIMESTAMP
  );
  
  RETURN v_result;
  
EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object(
    'success', false,
    'error', SQLERRM,
    'error_code', 'INTERNAL_ERROR'
  );
END;
$$;



--
-- Name: complete_visit_and_update_next(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.complete_visit_and_update_next(visit_id uuid) RETURNS date
    LANGUAGE plpgsql
    AS $$
DECLARE
    visit_record vendor_visits%ROWTYPE;
    new_next_date DATE;
BEGIN
    -- Get the visit record
    SELECT * INTO visit_record FROM vendor_visits WHERE id = visit_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Visit schedule not found with id: %', visit_id;
    END IF;
    
    -- Calculate new next visit date
    new_next_date := calculate_next_visit_date(
        visit_record.visit_type,
        visit_record.weekday_name,
        visit_record.fresh_type,
        visit_record.day_number,
        visit_record.skip_days,
        visit_record.start_date,
        visit_record.next_visit_date
    );
    
    -- Update the record with new next visit date
    UPDATE vendor_visits 
    SET next_visit_date = new_next_date, updated_at = NOW()
    WHERE id = visit_id;
    
    RETURN new_next_date;
END;
$$;



--
-- Name: copy_completion_requirements_to_assignment(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.copy_completion_requirements_to_assignment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update the assignment with completion requirements from the task
    UPDATE quick_task_assignments 
    SET 
        require_task_finished = (
            SELECT require_task_finished 
            FROM quick_tasks 
            WHERE id = NEW.quick_task_id
        ),
        require_photo_upload = (
            SELECT require_photo_upload 
            FROM quick_tasks 
            WHERE id = NEW.quick_task_id
        ),
        require_erp_reference = (
            SELECT require_erp_reference 
            FROM quick_tasks 
            WHERE id = NEW.quick_task_id
        )
    WHERE id = NEW.id;
    
    RETURN NEW;
END;
$$;



--
-- Name: count_bills_without_erp_reference(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.count_bills_without_erp_reference() RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    no_erp_count INTEGER;
BEGIN
    -- Count receiving records where erp_purchase_invoice_reference is NULL or empty
    SELECT COUNT(*) INTO no_erp_count
    FROM receiving_records rr
    WHERE rr.erp_purchase_invoice_reference IS NULL 
    OR rr.erp_purchase_invoice_reference = ''
    OR TRIM(rr.erp_purchase_invoice_reference) = '';
    
    RETURN COALESCE(no_erp_count, 0);
END;
$$;



--
-- Name: count_bills_without_erp_reference_by_branch(bigint); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.count_bills_without_erp_reference_by_branch(branch_id_param bigint DEFAULT NULL::bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result_count INTEGER;
BEGIN
    IF branch_id_param IS NULL THEN
        -- If no branch specified, return all
        SELECT COUNT(*) INTO result_count
        FROM receiving_records
        WHERE erp_purchase_invoice_reference IS NULL OR erp_purchase_invoice_reference = '' OR TRIM(erp_purchase_invoice_reference) = '';
    ELSE
        -- Count for specific branch
        SELECT COUNT(*) INTO result_count
        FROM receiving_records
        WHERE (erp_purchase_invoice_reference IS NULL OR erp_purchase_invoice_reference = '' OR TRIM(erp_purchase_invoice_reference) = '')
        AND branch_id = branch_id_param;
    END IF;
    
    RETURN COALESCE(result_count, 0);
END;
$$;



--
-- Name: FUNCTION count_bills_without_erp_reference_by_branch(branch_id_param bigint); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.count_bills_without_erp_reference_by_branch(branch_id_param bigint) IS 'Counts receiving records without ERP purchase invoice reference, optionally filtered by branch';


--
-- Name: count_bills_without_original(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.count_bills_without_original() RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    no_original_count INTEGER;
BEGIN
    -- Count receiving records where original_bill_url is NULL or empty
    SELECT COUNT(*) INTO no_original_count
    FROM receiving_records rr
    WHERE rr.original_bill_url IS NULL 
    OR rr.original_bill_url = ''
    OR TRIM(rr.original_bill_url) = '';
    
    RETURN COALESCE(no_original_count, 0);
END;
$$;



--
-- Name: count_bills_without_original_by_branch(bigint); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.count_bills_without_original_by_branch(branch_id_param bigint DEFAULT NULL::bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result_count INTEGER;
BEGIN
    IF branch_id_param IS NULL THEN
        -- If no branch specified, return all
        SELECT COUNT(*) INTO result_count
        FROM receiving_records
        WHERE original_bill_url IS NULL OR original_bill_url = '' OR TRIM(original_bill_url) = '';
    ELSE
        -- Count for specific branch
        SELECT COUNT(*) INTO result_count
        FROM receiving_records
        WHERE (original_bill_url IS NULL OR original_bill_url = '' OR TRIM(original_bill_url) = '')
        AND branch_id = branch_id_param;
    END IF;
    
    RETURN COALESCE(result_count, 0);
END;
$$;



--
-- Name: FUNCTION count_bills_without_original_by_branch(branch_id_param bigint); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.count_bills_without_original_by_branch(branch_id_param bigint) IS 'Counts receiving records without original bill file, optionally filtered by branch';


--
-- Name: count_bills_without_pr_excel(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.count_bills_without_pr_excel() RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN (
        SELECT COUNT(*)
        FROM receiving_records
        WHERE pr_excel_file_url IS NULL 
           OR pr_excel_file_url = ''
    );
END;
$$;



--
-- Name: count_bills_without_pr_excel_by_branch(bigint); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.count_bills_without_pr_excel_by_branch(branch_id_param bigint DEFAULT NULL::bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result_count INTEGER;
BEGIN
    IF branch_id_param IS NULL THEN
        -- If no branch specified, return all
        SELECT COUNT(*) INTO result_count
        FROM receiving_records
        WHERE pr_excel_file_url IS NULL OR pr_excel_file_url = '';
    ELSE
        -- Count for specific branch
        SELECT COUNT(*) INTO result_count
        FROM receiving_records
        WHERE (pr_excel_file_url IS NULL OR pr_excel_file_url = '')
        AND branch_id = branch_id_param;
    END IF;
    
    RETURN COALESCE(result_count, 0);
END;
$$;



--
-- Name: FUNCTION count_bills_without_pr_excel_by_branch(branch_id_param bigint); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.count_bills_without_pr_excel_by_branch(branch_id_param bigint) IS 'Counts receiving records without PR Excel file, optionally filtered by branch';


--
-- Name: count_completed_receiving_tasks(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.count_completed_receiving_tasks() RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    completed_count INTEGER;
BEGIN
    -- Simple logic: if task_id from receiving_tasks exists in task_completions table, count as completed
    SELECT COUNT(DISTINCT rt.id) INTO completed_count
    FROM receiving_tasks rt
    WHERE EXISTS (
        SELECT 1 
        FROM task_completions tc 
        WHERE tc.task_id = rt.task_id
    );
    
    RETURN COALESCE(completed_count, 0);
END;
$$;



--
-- Name: count_finished_receiving_tasks(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.count_finished_receiving_tasks() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    finished_count INTEGER;
BEGIN
    -- Count receiving tasks that are marked as task_finished_completed = true
    SELECT COUNT(DISTINCT rt.id) INTO finished_count
    FROM receiving_tasks rt
    WHERE EXISTS (
        SELECT 1 
        FROM task_completions tc 
        WHERE tc.task_id = rt.task_id 
        AND tc.task_finished_completed = true
    );
    
    RETURN COALESCE(finished_count, 0);
END;
$$;



--
-- Name: count_incomplete_receiving_tasks(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.count_incomplete_receiving_tasks() RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    incomplete_count INTEGER;
BEGIN
    -- Take task_id from receiving_tasks and check if NOT completed in task_completions table
    -- Count as incomplete if there's no matching task_completion OR task_finished_completed = false
    SELECT COUNT(DISTINCT rt.id) INTO incomplete_count
    FROM receiving_tasks rt
    WHERE NOT EXISTS (
        SELECT 1 
        FROM task_completions tc 
        WHERE tc.task_id = rt.task_id 
        AND tc.task_finished_completed = true
    );
    
    RETURN COALESCE(incomplete_count, 0);
END;
$$;



--
-- Name: count_incomplete_receiving_tasks_detailed(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.count_incomplete_receiving_tasks_detailed() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    incomplete_count INTEGER;
BEGIN
    -- Count receiving tasks where either:
    -- 1. The receiving task is not marked as completed, OR
    -- 2. The task itself is not completed, OR
    -- 3. There's no task_completion record, OR
    -- 4. The task_completion is not fully finished
    SELECT COUNT(*) INTO incomplete_count
    FROM receiving_tasks rt
    LEFT JOIN tasks t ON rt.task_id = t.id
    LEFT JOIN task_completions tc ON rt.task_id = tc.task_id AND rt.assignment_id = tc.assignment_id
    WHERE (
        rt.task_completed = false 
        OR t.status != 'completed'
        OR tc.id IS NULL
        OR tc.task_finished_completed = false
    );
    
    RETURN COALESCE(incomplete_count, 0);
END;
$$;



--
-- Name: create_customer_order(uuid, bigint, jsonb, character varying, character varying, numeric, numeric, numeric, numeric, numeric, integer, integer, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.create_customer_order(p_customer_id uuid, p_branch_id bigint, p_selected_location jsonb, p_fulfillment_method character varying, p_payment_method character varying, p_subtotal_amount numeric, p_delivery_fee numeric, p_discount_amount numeric, p_tax_amount numeric, p_total_amount numeric, p_total_items integer, p_total_quantity integer, p_customer_notes text DEFAULT NULL::text) RETURNS TABLE(order_id uuid, order_number character varying, success boolean, message text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_order_id UUID;
    v_order_number VARCHAR(50);
    v_customer_name VARCHAR(255);
    v_customer_phone VARCHAR(20);
    v_customer_whatsapp VARCHAR(20);
BEGIN
    -- Get customer information
    SELECT name, whatsapp_number, whatsapp_number
    INTO v_customer_name, v_customer_phone, v_customer_whatsapp
    FROM customers
    WHERE id = p_customer_id;
    
    IF NOT FOUND THEN
        RETURN QUERY SELECT NULL::UUID, NULL::VARCHAR, FALSE, 'Customer not found';
        RETURN;
    END IF;
    
    -- Generate order number
    v_order_number := generate_order_number();
    
    -- Create order (will bypass RLS due to SECURITY DEFINER)
    INSERT INTO orders (
        order_number,
        customer_id,
        customer_name,
        customer_phone,
        customer_whatsapp,
        branch_id,
        selected_location,
        order_status,
        fulfillment_method,
        subtotal_amount,
        delivery_fee,
        discount_amount,
        tax_amount,
        total_amount,
        payment_method,
        payment_status,
        total_items,
        total_quantity,
        customer_notes
    ) VALUES (
        v_order_number,
        p_customer_id,
        v_customer_name,
        v_customer_phone,
        v_customer_whatsapp,
        p_branch_id,
        p_selected_location,
        'new',
        p_fulfillment_method,
        p_subtotal_amount,
        p_delivery_fee,
        p_discount_amount,
        p_tax_amount,
        p_total_amount,
        p_payment_method,
        'pending',
        p_total_items,
        p_total_quantity,
        p_customer_notes
    )
    RETURNING id INTO v_order_id;
    
    -- Create audit log
    INSERT INTO order_audit_logs (
        order_id,
        action_type,
        to_status,
        notes
    ) VALUES (
        v_order_id,
        'created',
        'new',
        'Order created by customer'
    );
    
    RETURN QUERY SELECT v_order_id, v_order_number, TRUE, 'Order created successfully';
END;
$$;



--
-- Name: FUNCTION create_customer_order(p_customer_id uuid, p_branch_id bigint, p_selected_location jsonb, p_fulfillment_method character varying, p_payment_method character varying, p_subtotal_amount numeric, p_delivery_fee numeric, p_discount_amount numeric, p_tax_amount numeric, p_total_amount numeric, p_total_items integer, p_total_quantity integer, p_customer_notes text); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.create_customer_order(p_customer_id uuid, p_branch_id bigint, p_selected_location jsonb, p_fulfillment_method character varying, p_payment_method character varying, p_subtotal_amount numeric, p_delivery_fee numeric, p_discount_amount numeric, p_tax_amount numeric, p_total_amount numeric, p_total_items integer, p_total_quantity integer, p_customer_notes text) IS 'Creates a new customer order (SECURITY DEFINER to bypass RLS)';


--
-- Name: create_customer_registration(text, text, uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.create_customer_registration(p_name text, p_whatsapp_number text, p_branch_id uuid DEFAULT NULL::uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'extensions'
    AS $$
DECLARE
    v_customer_id uuid;
    v_access_code text;
    v_hashed_code text;
    v_formatted_number text;
    v_existing_customer record;
    v_system_user_id uuid := 'e1fdaee2-97f0-4fc1-872f-9d99c6bd684b';
BEGIN
    v_formatted_number := regexp_replace(p_whatsapp_number, '[^0-9]', '', 'g');
    IF length(v_formatted_number) = 9 THEN
        v_formatted_number := '966' || v_formatted_number;
    END IF;

    SELECT id, name, registration_status, access_code
    INTO v_existing_customer
    FROM public.customers
    WHERE regexp_replace(whatsapp_number, '[^0-9]', '', 'g') = v_formatted_number
       OR whatsapp_number = v_formatted_number
       OR whatsapp_number = '+' || v_formatted_number
    LIMIT 1;

    IF v_existing_customer.id IS NOT NULL THEN
        -- Pre-registered or deleted: upgrade to approved
        IF v_existing_customer.registration_status IN ('pre_registered', 'deleted') THEN
            v_access_code := generate_unique_customer_access_code();
            v_hashed_code := encode(digest(v_access_code::bytea, 'sha256'), 'hex');

            UPDATE public.customers
            SET name = p_name,
                access_code = v_hashed_code,
                access_code_generated_at = now(),
                registration_status = 'approved',
                updated_at = now()
            WHERE id = v_existing_customer.id
            RETURNING id INTO v_customer_id;

            INSERT INTO public.customer_access_code_history (
                customer_id, old_access_code, new_access_code,
                generated_by, reason, notes
            ) VALUES (
                v_customer_id, v_existing_customer.access_code, v_hashed_code,
                v_system_user_id,
                CASE WHEN v_existing_customer.registration_status = 'deleted'
                     THEN 're_registration'
                     ELSE 'pre_registered_upgrade'
                END,
                CASE WHEN v_existing_customer.registration_status = 'deleted'
                     THEN 'Re-registration after account deletion'
                     ELSE 'Pre-registered contact completed self-registration'
                END
            );

            RETURN jsonb_build_object(
                'success', true,
                'customer_id', v_customer_id,
                'access_code', v_access_code,
                'whatsapp_number', v_formatted_number,
                'customer_name', p_name,
                'message', 'Registration successful! Your access code has been sent to your WhatsApp.'
            );
        ELSE
            -- Already exists with active status
            RETURN jsonb_build_object(
                'success', false,
                'error', 'already_exists',
                'message', 'An account with this WhatsApp number already exists.',
                'customer_name', v_existing_customer.name,
                'registration_status', v_existing_customer.registration_status
            );
        END IF;
    END IF;

    -- Brand new customer
    v_access_code := generate_unique_customer_access_code();
    v_hashed_code := encode(digest(v_access_code::bytea, 'sha256'), 'hex');

    INSERT INTO public.customers (
        name, whatsapp_number, access_code, access_code_generated_at,
        registration_status, created_at, updated_at
    ) VALUES (
        p_name, v_formatted_number, v_hashed_code, now(),
        'approved', now(), now()
    )
    RETURNING id INTO v_customer_id;

    INSERT INTO public.customer_access_code_history (
        customer_id, new_access_code,
        generated_by, reason, notes
    ) VALUES (
        v_customer_id, v_hashed_code,
        v_system_user_id, 'initial_generation', 'Auto-generated during WhatsApp registration'
    );

    RETURN jsonb_build_object(
        'success', true,
        'customer_id', v_customer_id,
        'access_code', v_access_code,
        'whatsapp_number', v_formatted_number,
        'customer_name', p_name,
        'message', 'Registration successful! Your access code has been sent to your WhatsApp.'
    );
END;
$$;



--
-- Name: create_default_auto_schedule_config(bigint, time without time zone, time without time zone); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.create_default_auto_schedule_config(p_branch_id bigint, p_start_time time without time zone DEFAULT '09:00:00'::time without time zone, p_end_time time without time zone DEFAULT '17:00:00'::time without time zone) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO auto_schedule_config (
        branch_id,
        default_start_time,
        default_end_time,
        default_hours
    ) VALUES (
        p_branch_id,
        p_start_time,
        p_end_time,
        calculate_working_hours(p_start_time, p_end_time, FALSE)
    ) ON CONFLICT (branch_id) DO NOTHING;
END;
$$;



--
-- Name: create_default_auto_schedule_config(uuid, time without time zone, time without time zone); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.create_default_auto_schedule_config(p_branch_id uuid, p_start_time time without time zone DEFAULT '09:00:00'::time without time zone, p_end_time time without time zone DEFAULT '17:00:00'::time without time zone) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO auto_schedule_config (
        branch_id,
        default_start_time,
        default_end_time,
        default_hours,
        basic_hours
    ) VALUES (
        p_branch_id,
        p_start_time,
        p_end_time,
        calculate_working_hours(p_start_time, p_end_time, FALSE),
        calculate_working_hours(p_start_time, p_end_time, FALSE)
    ) ON CONFLICT (branch_id) DO NOTHING;
END;
$$;



--
-- Name: create_default_interface_permissions(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.create_default_interface_permissions() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO public.interface_permissions (user_id, updated_by)
    VALUES (NEW.id, NEW.id)
    ON CONFLICT (user_id) DO NOTHING;
    RETURN NEW;
END;
$$;



--
-- Name: create_notification_recipients(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.create_notification_recipients() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_user_id uuid;
    v_role text;
    v_branch_id uuid;
BEGIN
    -- Handle specific users
    IF NEW.target_type = 'specific_users' AND NEW.target_users IS NOT NULL THEN
        FOR v_user_id IN
            SELECT (jsonb_array_elements_text(NEW.target_users))::uuid
        LOOP
            INSERT INTO notification_recipients (
                notification_id,
                user_id,
                delivery_status,
                created_at
            ) VALUES (
                NEW.id,
                v_user_id,
                'pending',
                NOW()
            );
        END LOOP;
    END IF;

    -- Handle roles
    IF NEW.target_type = 'roles' AND NEW.target_roles IS NOT NULL THEN
        FOR v_user_id IN
            SELECT id FROM users
            WHERE role IN (SELECT jsonb_array_elements_text(NEW.target_roles))
            AND deleted_at IS NULL
        LOOP
            INSERT INTO notification_recipients (
                notification_id,
                user_id,
                delivery_status,
                created_at
            ) VALUES (
                NEW.id,
                v_user_id,
                'pending',
                NOW()
            );
        END LOOP;
    END IF;

    -- Handle branches
    IF NEW.target_type = 'branches' AND NEW.target_branches IS NOT NULL THEN
        FOR v_user_id IN
            SELECT DISTINCT user_id FROM user_branches
            WHERE branch_id IN (SELECT (jsonb_array_elements_text(NEW.target_branches))::uuid)
            AND deleted_at IS NULL
        LOOP
            INSERT INTO notification_recipients (
                notification_id,
                user_id,
                delivery_status,
                created_at
            ) VALUES (
                NEW.id,
                v_user_id,
                'pending',
                NOW()
            );
        END LOOP;
    END IF;

    -- Handle all users
    IF NEW.target_type = 'all_users' THEN
        FOR v_user_id IN
            SELECT id FROM users
            WHERE deleted_at IS NULL
        LOOP
            INSERT INTO notification_recipients (
                notification_id,
                user_id,
                delivery_status,
                created_at
            ) VALUES (
                NEW.id,
                v_user_id,
                'pending',
                NOW()
            );
        END LOOP;
    END IF;

    RAISE NOTICE 'Created recipients for notification %', NEW.id;
    RETURN NEW;
END;
$$;



--
-- Name: create_notification_simple(text, text, text, text, uuid, uuid, uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.create_notification_simple(title_param text, message_param text, created_by_param text, created_by_name_param text, target_user_id_param uuid, task_id_param uuid, assignment_id_param uuid) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    notification_id UUID;
BEGIN
    INSERT INTO notifications (
        title,
        message,
        created_by,
        created_by_name,
        target_type,
        target_users,
        type,
        priority,
        task_id,
        task_assignment_id
    ) VALUES (
        title_param,
        message_param,
        created_by_param,
        created_by_name_param,
        'specific_users',
        to_jsonb(ARRAY[target_user_id_param::TEXT]),
        'task',
        'high',
        task_id_param,
        assignment_id_param
    ) RETURNING id INTO notification_id;
    
    RETURN notification_id;
END;
$$;



--
-- Name: create_quick_task_notification(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.create_quick_task_notification() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    assigned_by_name TEXT;
    assigned_to_name TEXT;
BEGIN
    -- Get the name of who assigned the task (from hr_employees if available, otherwise username)
    SELECT COALESCE(he.name, u.username, 'Admin') INTO assigned_by_name
    FROM users u
    LEFT JOIN hr_employees he ON u.employee_id = he.id
    WHERE u.id = (SELECT assigned_by FROM quick_tasks WHERE id = NEW.quick_task_id);
    
    -- Get the name of who the task is assigned to (from hr_employees if available, otherwise username)
    SELECT COALESCE(he.name, u.username, 'User') INTO assigned_to_name
    FROM users u
    LEFT JOIN hr_employees he ON u.employee_id = he.id
    WHERE u.id = NEW.assigned_to_user_id;
    
    -- Insert notification for each assigned user
    INSERT INTO notifications (
        title,
        message,
        type,
        priority,
        target_type,
        target_users,
        created_by,
        created_by_name,
        metadata,
        created_at
    )
    SELECT 
        'New Quick Task: ' || qt.title,
        'You have been assigned a new quick task: "' || qt.title || 
        '" by ' || COALESCE(assigned_by_name, 'Admin') || 
        '. Priority: ' || qt.priority || 
        '. Deadline: ' || to_char(qt.deadline_datetime, 'YYYY-MM-DD HH24:MI') ||
        CASE 
            WHEN qt.description IS NOT NULL AND qt.description != '' 
            THEN E'\n\nDescription: ' || qt.description
            ELSE ''
        END,
        'task_assignment',
        qt.priority,
        'specific_users',
        jsonb_build_array(NEW.assigned_to_user_id),
        qt.assigned_by::text,
        COALESCE(assigned_by_name, 'Admin'),
        jsonb_build_object(
            'quick_task_id', qt.id,
            'task_title', qt.title,
            'deadline', qt.deadline_datetime,
            'priority', qt.priority,
            'issue_type', qt.issue_type,
            'assigned_by', qt.assigned_by,
            'assigned_by_name', assigned_by_name,
            'assigned_to_user_id', NEW.assigned_to_user_id,
            'assigned_to_name', assigned_to_name,
            'quick_task_assignment_id', NEW.id,
            'assignment_details', 'Assigned by ' || COALESCE(assigned_by_name, 'Admin') || ' to ' || COALESCE(assigned_to_name, 'User')
        ),
        NOW()
    FROM quick_tasks qt
    WHERE qt.id = NEW.quick_task_id;
    
    RETURN NEW;
END;
$$;



--
-- Name: FUNCTION create_quick_task_notification(); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.create_quick_task_notification() IS 'Enhanced notification function that includes assignment details showing who assigned the task to whom';


--
-- Name: create_quick_task_with_assignments(character varying, text, character varying, timestamp with time zone, uuid, uuid[], boolean, boolean, boolean); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.create_quick_task_with_assignments(title_param character varying, description_param text, priority_param character varying DEFAULT 'medium'::character varying, deadline_param timestamp with time zone DEFAULT NULL::timestamp with time zone, created_by_param uuid DEFAULT NULL::uuid, assigned_user_ids uuid[] DEFAULT NULL::uuid[], require_task_finished_param boolean DEFAULT true, require_photo_upload_param boolean DEFAULT false, require_erp_reference_param boolean DEFAULT false) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    task_id UUID;
    user_id UUID;
BEGIN
    -- Create the quick task with completion requirements
    INSERT INTO quick_tasks (
        title,
        description,
        priority,
        deadline_datetime,
        created_by_user_id,
        require_task_finished,
        require_photo_upload,
        require_erp_reference,
        status
    ) VALUES (
        title_param,
        description_param,
        priority_param,
        deadline_param,
        created_by_param,
        require_task_finished_param,
        require_photo_upload_param,
        require_erp_reference_param,
        'active'
    ) RETURNING id INTO task_id;
    
    -- Create assignments for each user if provided
    IF assigned_user_ids IS NOT NULL THEN
        FOREACH user_id IN ARRAY assigned_user_ids
        LOOP
            INSERT INTO quick_task_assignments (
                quick_task_id,
                assigned_to_user_id,
                require_task_finished,
                require_photo_upload,
                require_erp_reference,
                status
            ) VALUES (
                task_id,
                user_id,
                require_task_finished_param,
                require_photo_upload_param,
                require_erp_reference_param,
                'pending'
            );
        END LOOP;
    END IF;
    
    RETURN task_id;
END;
$$;



--
-- Name: create_recurring_assignment(uuid, uuid, uuid, character varying, date, date); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.create_recurring_assignment(task_id uuid, assigned_to uuid, assigned_by uuid, recurrence_pattern character varying, start_date date, end_date date DEFAULT NULL::date) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    schedule_id UUID;
BEGIN
    INSERT INTO recurring_assignment_schedules (
        task_id,
        assigned_to,
        assigned_by,
        recurrence_pattern,
        start_date,
        end_date,
        is_active,
        created_at,
        updated_at
    ) VALUES (
        task_id,
        assigned_to,
        assigned_by,
        recurrence_pattern,
        start_date,
        end_date,
        true,
        NOW(),
        NOW()
    ) RETURNING id INTO schedule_id;
    
    RETURN schedule_id;
END;
$$;



--
-- Name: create_recurring_assignment(uuid, text, text, text, text, uuid, text, integer, integer[], time without time zone, date, date, integer, text, boolean); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.create_recurring_assignment(p_task_id uuid, p_assignment_type text, p_assigned_by text, p_repeat_type text, p_assigned_to_user_id text DEFAULT NULL::text, p_assigned_to_branch_id uuid DEFAULT NULL::uuid, p_assigned_by_name text DEFAULT NULL::text, p_repeat_interval integer DEFAULT 1, p_repeat_on_days integer[] DEFAULT NULL::integer[], p_execute_time time without time zone DEFAULT '09:00:00'::time without time zone, p_start_date date DEFAULT CURRENT_DATE, p_end_date date DEFAULT NULL::date, p_max_occurrences integer DEFAULT NULL::integer, p_notes text DEFAULT NULL::text, p_is_reassignable boolean DEFAULT true) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    assignment_id UUID;
    next_exec_time TIMESTAMP WITH TIME ZONE;
BEGIN
    -- Calculate first execution time
    next_exec_time := (p_start_date::text || ' ' || p_execute_time::text)::timestamp with time zone;
    
    -- Create the assignment record
    INSERT INTO public.task_assignments (
        task_id,
        assignment_type,
        assigned_to_user_id,
        assigned_to_branch_id,
        assigned_by,
        assigned_by_name,
        is_recurring,
        is_reassignable,
        notes
    ) VALUES (
        p_task_id,
        p_assignment_type,
        p_assigned_to_user_id,
        p_assigned_to_branch_id,
        p_assigned_by,
        p_assigned_by_name,
        true,
        p_is_reassignable,
        p_notes
    )
    RETURNING id INTO assignment_id;
    
    -- Create the recurring schedule
    INSERT INTO public.recurring_assignment_schedules (
        assignment_id,
        repeat_type,
        repeat_interval,
        repeat_on_days,
        execute_time,
        start_date,
        end_date,
        max_occurrences,
        next_execution_at,
        created_by
    ) VALUES (
        assignment_id,
        p_repeat_type,
        p_repeat_interval,
        p_repeat_on_days,
        p_execute_time,
        p_start_date,
        p_end_date,
        p_max_occurrences,
        next_exec_time,
        p_assigned_by
    );
    
    RETURN assignment_id;
END;
$$;



--
-- Name: FUNCTION create_recurring_assignment(p_task_id uuid, p_assignment_type text, p_assigned_by text, p_repeat_type text, p_assigned_to_user_id text, p_assigned_to_branch_id uuid, p_assigned_by_name text, p_repeat_interval integer, p_repeat_on_days integer[], p_execute_time time without time zone, p_start_date date, p_end_date date, p_max_occurrences integer, p_notes text, p_is_reassignable boolean); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.create_recurring_assignment(p_task_id uuid, p_assignment_type text, p_assigned_by text, p_repeat_type text, p_assigned_to_user_id text, p_assigned_to_branch_id uuid, p_assigned_by_name text, p_repeat_interval integer, p_repeat_on_days integer[], p_execute_time time without time zone, p_start_date date, p_end_date date, p_max_occurrences integer, p_notes text, p_is_reassignable boolean) IS 'Creates a recurring task assignment with schedule configuration';


--
-- Name: create_schedule_template(bigint, character varying, time without time zone, time without time zone, boolean); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.create_schedule_template(p_branch_id bigint, p_template_name character varying, p_start_time time without time zone, p_end_time time without time zone, p_weekdays_only boolean DEFAULT true) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE
    template_id BIGINT;
BEGIN
    INSERT INTO schedule_templates (
        branch_id,
        template_name,
        default_start_time,
        default_end_time,
        is_overnight,
        default_hours,
        applies_to_weekdays,
        applies_to_weekends
    ) VALUES (
        p_branch_id,
        p_template_name,
        p_start_time,
        p_end_time,
        is_overnight_shift(p_start_time, p_end_time),
        calculate_working_hours(p_start_time, p_end_time, is_overnight_shift(p_start_time, p_end_time)),
        p_weekdays_only,
        NOT p_weekdays_only
    ) RETURNING id INTO template_id;
    
    RETURN template_id;
END;
$$;



--
-- Name: create_schedule_template(uuid, character varying, time without time zone, time without time zone, boolean); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.create_schedule_template(p_branch_id uuid, p_template_name character varying, p_start_time time without time zone, p_end_time time without time zone, p_weekdays_only boolean DEFAULT true) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    template_id UUID;
BEGIN
    INSERT INTO schedule_templates (
        branch_id,
        template_name,
        default_start_time,
        default_end_time,
        is_overnight,
        default_hours,
        applies_to_weekdays,
        applies_to_weekends
    ) VALUES (
        p_branch_id,
        p_template_name,
        p_start_time,
        p_end_time,
        is_overnight_shift(p_start_time, p_end_time),
        calculate_working_hours(p_start_time, p_end_time, is_overnight_shift(p_start_time, p_end_time)),
        p_weekdays_only,
        NOT p_weekdays_only
    ) RETURNING id INTO template_id;
    
    RETURN template_id;
END;
$$;



--
-- Name: create_scheduled_assignment(uuid, uuid, uuid, timestamp with time zone, character varying); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.create_scheduled_assignment(task_id uuid, assigned_to uuid, assigned_by uuid, scheduled_for timestamp with time zone, priority character varying DEFAULT 'medium'::character varying) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    assignment_id UUID;
BEGIN
    INSERT INTO task_assignments (
        task_id,
        assigned_to,
        assigned_by,
        status,
        priority,
        assigned_at,
        created_at,
        updated_at
    ) VALUES (
        task_id,
        assigned_to,
        assigned_by,
        'pending',
        priority,
        scheduled_for,
        NOW(),
        NOW()
    ) RETURNING id INTO assignment_id;
    
    RETURN assignment_id;
END;
$$;



--
-- Name: create_scheduled_assignment(uuid, text, text, text, uuid, text, date, time without time zone, date, time without time zone, boolean, text, text, boolean, boolean, boolean); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.create_scheduled_assignment(p_task_id uuid, p_assignment_type text, p_assigned_by text, p_assigned_to_user_id text DEFAULT NULL::text, p_assigned_to_branch_id uuid DEFAULT NULL::uuid, p_assigned_by_name text DEFAULT NULL::text, p_schedule_date date DEFAULT NULL::date, p_schedule_time time without time zone DEFAULT NULL::time without time zone, p_deadline_date date DEFAULT NULL::date, p_deadline_time time without time zone DEFAULT NULL::time without time zone, p_is_reassignable boolean DEFAULT true, p_notes text DEFAULT NULL::text, p_priority_override text DEFAULT NULL::text, p_require_task_finished boolean DEFAULT true, p_require_photo_upload boolean DEFAULT false, p_require_erp_reference boolean DEFAULT false) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    assignment_id UUID;
BEGIN
    INSERT INTO public.task_assignments (
        task_id,
        assignment_type,
        assigned_to_user_id,
        assigned_to_branch_id,
        assigned_by,
        assigned_by_name,
        schedule_date,
        schedule_time,
        deadline_date,
        deadline_time,
        is_reassignable,
        notes,
        priority_override,
        require_task_finished,
        require_photo_upload,
        require_erp_reference
    ) VALUES (
        p_task_id,
        p_assignment_type,
        p_assigned_to_user_id,
        p_assigned_to_branch_id,
        p_assigned_by,
        p_assigned_by_name,
        p_schedule_date,
        p_schedule_time,
        p_deadline_date,
        p_deadline_time,
        p_is_reassignable,
        p_notes,
        p_priority_override,
        p_require_task_finished,
        p_require_photo_upload,
        p_require_erp_reference
    )
    RETURNING id INTO assignment_id;
    
    RETURN assignment_id;
END;
$$;



--
-- Name: FUNCTION create_scheduled_assignment(p_task_id uuid, p_assignment_type text, p_assigned_by text, p_assigned_to_user_id text, p_assigned_to_branch_id uuid, p_assigned_by_name text, p_schedule_date date, p_schedule_time time without time zone, p_deadline_date date, p_deadline_time time without time zone, p_is_reassignable boolean, p_notes text, p_priority_override text, p_require_task_finished boolean, p_require_photo_upload boolean, p_require_erp_reference boolean); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.create_scheduled_assignment(p_task_id uuid, p_assignment_type text, p_assigned_by text, p_assigned_to_user_id text, p_assigned_to_branch_id uuid, p_assigned_by_name text, p_schedule_date date, p_schedule_time time without time zone, p_deadline_date date, p_deadline_time time without time zone, p_is_reassignable boolean, p_notes text, p_priority_override text, p_require_task_finished boolean, p_require_photo_upload boolean, p_require_erp_reference boolean) IS 'Creates a one-time task assignment with optional scheduling and deadline';


--
-- Name: create_system_admin(text, text, text, boolean, public.user_type_enum); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.create_system_admin(p_username text, p_password text, p_quick_access_code text DEFAULT NULL::text, p_is_master_admin boolean DEFAULT true, p_user_type public.user_type_enum DEFAULT 'global'::public.user_type_enum) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    password_salt TEXT;
    qr_salt TEXT;
    admin_user_id UUID;
    main_branch_id BIGINT;
    final_quick_code TEXT;
BEGIN
    -- Get main branch ID (or any branch)
    SELECT id INTO main_branch_id FROM branches WHERE is_main_branch = true LIMIT 1;
    IF main_branch_id IS NULL THEN
        SELECT id INTO main_branch_id FROM branches LIMIT 1;
    END IF;
    
    -- Generate salts
    password_salt := generate_salt();
    qr_salt := generate_salt();
    
    -- Use provided quick access code or generate unique one
    IF p_quick_access_code IS NOT NULL THEN
        IF EXISTS (SELECT 1 FROM users WHERE quick_access_code = p_quick_access_code) THEN
            RAISE EXCEPTION 'Quick access code % is already in use', p_quick_access_code;
        END IF;
        final_quick_code := p_quick_access_code;
    ELSE
        final_quick_code := generate_unique_quick_access_code();
    END IF;
    
    -- Insert the admin user with is_master_admin flag instead of role_type
    INSERT INTO users (
        username, 
        password_hash, 
        salt,
        quick_access_code, 
        quick_access_salt,
        user_type,
        branch_id,
        is_master_admin,
        is_admin,
        status,
        is_first_login,
        password_expires_at
    ) VALUES (
        p_username,
        hash_password(p_password, password_salt),
        password_salt,
        final_quick_code,
        hash_password(final_quick_code, qr_salt),
        p_user_type,
        main_branch_id,
        p_is_master_admin,
        p_is_master_admin,
        'active',
        true,
        NOW() + INTERVAL '90 days'
    ) RETURNING id INTO admin_user_id;
    
    RAISE NOTICE 'System admin user created with ID: %', admin_user_id;
    RAISE NOTICE 'Username: %, Is Master Admin: %, Quick Access: %', p_username, p_is_master_admin, final_quick_code;
    
    RETURN admin_user_id;
END;
$$;



--
-- Name: create_system_admin(text, text, text, public.role_type_enum, public.user_type_enum); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.create_system_admin(p_username text, p_password text, p_quick_access_code text DEFAULT NULL::text, p_role_type public.role_type_enum DEFAULT 'Master Admin'::public.role_type_enum, p_user_type public.user_type_enum DEFAULT 'global'::public.user_type_enum) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    password_salt TEXT;
    qr_salt TEXT;
    admin_user_id UUID;
    main_branch_id BIGINT;
    final_quick_code TEXT;
BEGIN
    -- Get main branch ID (or any branch)
    SELECT id INTO main_branch_id FROM branches WHERE is_main_branch = true LIMIT 1;
    IF main_branch_id IS NULL THEN
        SELECT id INTO main_branch_id FROM branches LIMIT 1;
    END IF;
    
    -- Generate salts
    password_salt := generate_salt();
    qr_salt := generate_salt();
    
    -- Use provided quick access code or generate unique one
    IF p_quick_access_code IS NOT NULL THEN
        -- Check if provided code is already in use
        IF EXISTS (SELECT 1 FROM users WHERE quick_access_code = p_quick_access_code) THEN
            RAISE EXCEPTION 'Quick access code % is already in use', p_quick_access_code;
        END IF;
        final_quick_code := p_quick_access_code;
    ELSE
        final_quick_code := generate_unique_quick_access_code();
    END IF;
    
    -- Insert the admin user
    INSERT INTO users (
        username, 
        password_hash, 
        salt,
        quick_access_code, 
        quick_access_salt,
        user_type,
        branch_id,
        role_type, 
        status,
        is_first_login,
        password_expires_at
    ) VALUES (
        p_username,
        hash_password(p_password, password_salt),
        password_salt,
        final_quick_code,
        hash_password(final_quick_code, qr_salt),
        p_user_type,
        main_branch_id,
        p_role_type,
        'active',
        true,
        NOW() + INTERVAL '90 days'
    ) RETURNING id INTO admin_user_id;
    
    RAISE NOTICE 'System admin user created with ID: %', admin_user_id;
    RAISE NOTICE 'Username: %, Role: %, Quick Access: %', p_username, p_role_type, final_quick_code;
    
    RETURN admin_user_id;
END;
$$;



--
-- Name: create_task(text, text, text, text, text, text, date, time without time zone, boolean, boolean, boolean, boolean, boolean); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.create_task(title_param text, description_param text, created_by_param text, created_by_name_param text, created_by_role_param text, priority_param text, due_date_param date, due_time_param time without time zone, require_task_finished_param boolean, require_photo_upload_param boolean, require_erp_reference_param boolean, can_escalate_param boolean, can_reassign_param boolean) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    task_id UUID;
    calculated_due_datetime TIMESTAMPTZ;
BEGIN
    -- Calculate due_datetime if due_date is provided
    IF due_date_param IS NOT NULL THEN
        calculated_due_datetime := due_date_param + COALESCE(due_time_param, '23:59:59'::TIME);
    END IF;
    
    -- Insert only columns that exist in the tasks table
    INSERT INTO tasks (
        title,
        description,
        created_by,
        created_by_name,
        created_by_role,
        priority,
        due_date,
        due_time,
        due_datetime,
        require_task_finished,
        require_photo_upload,
        require_erp_reference,
        can_escalate,
        can_reassign,
        status
    ) VALUES (
        title_param,
        description_param,
        created_by_param,
        created_by_name_param,
        created_by_role_param,
        priority_param,
        due_date_param,
        due_time_param,
        calculated_due_datetime,
        require_task_finished_param,
        require_photo_upload_param,
        require_erp_reference_param,
        can_escalate_param,
        can_reassign_param,
        'active'
    ) RETURNING id INTO task_id;
    
    RETURN task_id;
END;
$$;



--
-- Name: create_user(character varying, character varying, boolean, boolean, character varying, bigint, uuid, uuid, character varying); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.create_user(p_username character varying, p_password character varying, p_is_master_admin boolean DEFAULT false, p_is_admin boolean DEFAULT false, p_user_type character varying DEFAULT 'branch_specific'::character varying, p_branch_id bigint DEFAULT NULL::bigint, p_employee_id uuid DEFAULT NULL::uuid, p_position_id uuid DEFAULT NULL::uuid, p_quick_access_code character varying DEFAULT NULL::character varying) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_user_id UUID;
  v_quick_access_code VARCHAR(6);
  v_quick_access_hash TEXT;
  v_password_hash TEXT;
  v_salt TEXT;
  v_quick_access_salt TEXT;
BEGIN
  v_salt := extensions.gen_salt('bf');
  v_quick_access_salt := extensions.gen_salt('bf');

  IF p_quick_access_code IS NULL THEN
    -- Generate a unique random 6-digit code
    v_quick_access_code := LPAD(FLOOR(RANDOM() * 1000000)::TEXT, 6, '0');

    -- Loop until we find a unique code (check against hashed values)
    WHILE EXISTS (
      SELECT 1 FROM users 
      WHERE extensions.crypt(v_quick_access_code, quick_access_code) = quick_access_code
    ) LOOP
      v_quick_access_code := LPAD(FLOOR(RANDOM() * 1000000)::TEXT, 6, '0');
    END LOOP;
  ELSE
    v_quick_access_code := p_quick_access_code;

    -- Check if this code already exists (by hashing and comparing)
    IF EXISTS (
      SELECT 1 FROM users 
      WHERE extensions.crypt(v_quick_access_code, quick_access_code) = quick_access_code
    ) THEN
      RETURN json_build_object(
        'success', false,
        'message', 'Quick access code already exists'
      );
    END IF;
  END IF;

  IF EXISTS (SELECT 1 FROM users WHERE username = p_username) THEN
    RETURN json_build_object(
      'success', false,
      'message', 'Username already exists'
    );
  END IF;

  v_password_hash := extensions.crypt(p_password, v_salt);
  
  -- Hash the quick access code with bcrypt
  v_quick_access_hash := extensions.crypt(v_quick_access_code, v_quick_access_salt);

  INSERT INTO users (
    username,
    password_hash,
    salt,
    quick_access_code,
    quick_access_salt,
    is_master_admin,
    is_admin,
    user_type,
    branch_id,
    employee_id,
    position_id,
    status,
    is_first_login,
    failed_login_attempts,
    created_at,
    updated_at
  ) VALUES (
    p_username,
    v_password_hash,
    v_salt,
    v_quick_access_hash,        -- Store hashed code instead of plain text
    v_quick_access_salt,
    p_is_master_admin,
    p_is_admin,
    p_user_type::user_type_enum,
    p_branch_id,
    p_employee_id,
    p_position_id,
    'active',
    true,
    0,
    NOW(),
    NOW()
  )
  RETURNING id INTO v_user_id;

  RETURN json_build_object(
    'success', true,
    'user_id', v_user_id,
    'quick_access_code', v_quick_access_code,   -- Return plain code to show to user
    'message', 'User created successfully'
  );

EXCEPTION
  WHEN OTHERS THEN
    RETURN json_build_object(
      'success', false,
      'message', SQLERRM
    );
END;
$$;



--
-- Name: create_user_profile(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.create_user_profile() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO user_profiles (user_id)
    VALUES (NEW.id);
    RETURN NEW;
END;
$$;



--
-- Name: create_variation_group(text, text[], text, text, text, uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.create_variation_group(p_parent_barcode text, p_variation_barcodes text[], p_group_name_en text, p_group_name_ar text, p_image_override text DEFAULT NULL::text, p_user_id uuid DEFAULT NULL::uuid) RETURNS TABLE(success boolean, message text, affected_count integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_affected_count INTEGER := 0;
  v_barcode TEXT;
  v_order INTEGER := 1;
BEGIN
  -- Validate parent product exists
  IF NOT EXISTS (SELECT 1 FROM products WHERE barcode = p_parent_barcode) THEN
    RETURN QUERY SELECT false, 'Parent product barcode does not exist', 0;
    RETURN;
  END IF;

  -- Validate no circular references
  IF p_parent_barcode = ANY(p_variation_barcodes) THEN
    -- Remove parent from variations array if present
    p_variation_barcodes := array_remove(p_variation_barcodes, p_parent_barcode);
  END IF;

  -- Update parent product
  UPDATE products
  SET 
    is_variation = true,
    parent_product_barcode = p_parent_barcode,
    variation_group_name_en = p_group_name_en,
    variation_group_name_ar = p_group_name_ar,
    variation_order = 0,
    variation_image_override = p_image_override,
    created_by = COALESCE(p_user_id, created_by),
    modified_by = p_user_id,
    modified_at = NOW()
  WHERE barcode = p_parent_barcode;

  v_affected_count := v_affected_count + 1;

  -- Update variation products
  FOREACH v_barcode IN ARRAY p_variation_barcodes
  LOOP
    UPDATE products
    SET 
      is_variation = true,
      parent_product_barcode = p_parent_barcode,
      variation_group_name_en = p_group_name_en,
      variation_group_name_ar = p_group_name_ar,
      variation_order = v_order,
      created_by = COALESCE(p_user_id, created_by),
      modified_by = p_user_id,
      modified_at = NOW()
    WHERE barcode = v_barcode;

    v_order := v_order + 1;
    v_affected_count := v_affected_count + 1;
  END LOOP;

  -- Log to audit trail (if table exists)
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'variation_audit_log') THEN
    INSERT INTO variation_audit_log (
      action_type,
      affected_barcodes,
      parent_barcode,
      group_name_en,
      group_name_ar,
      user_id,
      details
    ) VALUES (
      'create_group',
      array_prepend(p_parent_barcode, p_variation_barcodes),
      p_parent_barcode,
      p_group_name_en,
      p_group_name_ar,
      p_user_id,
      jsonb_build_object(
        'image_override', p_image_override,
        'variation_count', array_length(p_variation_barcodes, 1) + 1
      )
    );
  END IF;

  RETURN QUERY SELECT true, 'Variation group created successfully', v_affected_count;
END;
$$;



--
-- Name: create_warning_history(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.create_warning_history() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Handle different trigger operations
    IF TG_OP = 'INSERT' THEN
        INSERT INTO employee_warning_history (
            warning_id,
            action_type,
            new_values,
            changed_by,
            changed_by_username,
            change_reason
        ) VALUES (
            NEW.id,
            'created',
            row_to_json(NEW),
            NEW.issued_by,
            NEW.issued_by_username,
            'Warning created'
        );
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO employee_warning_history (
            warning_id,
            action_type,
            old_values,
            new_values,
            changed_by,
            changed_by_username,
            change_reason
        ) VALUES (
            NEW.id,
            'updated',
            row_to_json(OLD),
            row_to_json(NEW),
            NEW.issued_by,
            NEW.issued_by_username,
            'Warning updated'
        );
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO employee_warning_history (
            warning_id,
            action_type,
            old_values,
            changed_by,
            changed_by_username,
            change_reason
        ) VALUES (
            OLD.id,
            'deleted',
            row_to_json(OLD),
            OLD.deleted_by,
            'system',
            'Warning deleted'
        );
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$;



--
-- Name: current_user_is_admin(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.current_user_is_admin() RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN current_setting('app.is_master_admin', true)::BOOLEAN 
         OR current_setting('app.is_admin', true)::BOOLEAN;
EXCEPTION
  WHEN OTHERS THEN
    RETURN false;
END;
$$;



--
-- Name: daily_erp_sync_maintenance(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.daily_erp_sync_maintenance() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    sync_result RECORD;
    result_text TEXT;
BEGIN
    -- Run the sync function
    SELECT * INTO sync_result FROM sync_all_missing_erp_references();
    
    result_text := format('Daily ERP sync maintenance completed: %s records synced', 
                         sync_result.synced_count);
    
    IF sync_result.synced_count > 0 THEN
        result_text := result_text || format('. Details: %s', sync_result.details);
    END IF;
    
    RETURN result_text;
END;
$$;



--
-- Name: deactivate_expired_media(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.deactivate_expired_media() RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    UPDATE customer_app_media
    SET 
        is_active = false,
        deactivated_at = NOW(),
        updated_at = NOW()
    WHERE 
        is_active = true
        AND is_infinite = false
        AND expiry_date <= NOW();
END;
$$;



--
-- Name: FUNCTION deactivate_expired_media(); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.deactivate_expired_media() IS 'Automatically deactivates media that has passed its expiry date';


--
-- Name: debug_get_dependency_photos(uuid, text[]); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.debug_get_dependency_photos(receiving_record_id_param uuid, dependency_role_types text[]) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  result_photos JSONB := '{}'::JSONB;
  role_type TEXT;
  task_record RECORD;
  found_count INTEGER := 0;
BEGIN
  RAISE NOTICE 'Debug: Starting function with receiving_record_id = %, roles = %', receiving_record_id_param, dependency_role_types;
  
  -- Loop through each dependency role type
  FOREACH role_type IN ARRAY dependency_role_types
  LOOP
    RAISE NOTICE 'Debug: Looking for role_type = %', role_type;
    
    -- Get the completion photo for this role type
    SELECT completion_photo_url, role_type as task_role_type INTO task_record
    FROM receiving_tasks
    WHERE receiving_record_id = receiving_record_id_param
      AND role_type = role_type
      AND task_completed = true
      AND completion_photo_url IS NOT NULL
    LIMIT 1;
    
    IF FOUND THEN
      found_count := found_count + 1;
      RAISE NOTICE 'Debug: Found task with photo for role %, URL = %', role_type, task_record.completion_photo_url;
      
      result_photos := result_photos || jsonb_build_object(
        task_record.task_role_type, task_record.completion_photo_url
      );
    ELSE
      RAISE NOTICE 'Debug: No photo found for role %', role_type;
    END IF;
  END LOOP;
  
  RAISE NOTICE 'Debug: Found % photos, returning %', found_count, result_photos;
  
  -- Convert JSONB to JSON for return
  RETURN result_photos::JSON;
  
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'Debug: Error occurred - %', SQLERRM;
  RETURN '{}'::JSON;
END;
$$;



--
-- Name: debug_receiving_tasks_data(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.debug_receiving_tasks_data() RETURNS TABLE(total_receiving_tasks integer, total_task_completions integer, receiving_task_ids text, task_completion_task_ids text, matching_completed_tasks integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        (SELECT COUNT(*)::INTEGER FROM receiving_tasks) as total_receiving_tasks,
        (SELECT COUNT(*)::INTEGER FROM task_completions) as total_task_completions,
        (SELECT string_agg(rt.task_id::TEXT, ', ') FROM receiving_tasks rt LIMIT 10) as receiving_task_ids,
        (SELECT string_agg(tc.task_id::TEXT, ', ') FROM task_completions tc WHERE tc.task_finished_completed = true LIMIT 10) as task_completion_task_ids,
        (SELECT COUNT(DISTINCT rt.id)::INTEGER 
         FROM receiving_tasks rt 
         WHERE EXISTS (
             SELECT 1 FROM task_completions tc 
             WHERE tc.task_id = rt.task_id 
             AND tc.task_finished_completed = true
         )) as matching_completed_tasks;
END;
$$;



--
-- Name: debug_users(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.debug_users() RETURNS TABLE(user_id uuid, username character varying, status character varying, employee_id uuid, branch_id bigint, position_id uuid)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        u.id as user_id,
        u.username,
        u.status::VARCHAR,
        u.employee_id,
        u.branch_id,
        u.position_id
    FROM users u
    ORDER BY u.created_at DESC;
END;
$$;



--
-- Name: decrement_voucher_stock(numeric, integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.decrement_voucher_stock(voucher_value numeric, decrement_amount integer DEFAULT 1) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    UPDATE purchase_voucher_stock
    SET quantity = quantity - decrement_amount,
        updated_at = NOW()
    WHERE value = voucher_value
      AND quantity >= decrement_amount;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Insufficient stock for voucher value %', voucher_value;
    END IF;
END;
$$;



--
-- Name: delete_app_icon(text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.delete_app_icon(p_icon_key text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
    DELETE FROM public.app_icons WHERE icon_key = p_icon_key;
    RETURN FOUND;
END;
$$;



--
-- Name: delete_branch_sync_config(bigint); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.delete_branch_sync_config(p_id bigint) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    DELETE FROM branch_sync_config WHERE id = p_id;
$$;



--
-- Name: delete_customer_account(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.delete_customer_account(p_customer_id uuid) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_customer record;
BEGIN
    -- Check if customer exists
    SELECT id, name, is_deleted
    INTO v_customer
    FROM public.customers
    WHERE id = p_customer_id;
    
    IF v_customer.id IS NULL THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Customer not found'
        );
    END IF;
    
    IF v_customer.is_deleted = true THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Account already deleted'
        );
    END IF;
    
    -- Soft delete: mark as deleted, clear access code so it can be reused
    UPDATE public.customers
    SET is_deleted = true,
        deleted_at = now(),
        access_code = NULL,
        registration_status = 'suspended',
        updated_at = now()
    WHERE id = p_customer_id;
    
    RETURN json_build_object(
        'success', true,
        'message', 'Account deleted successfully'
    );
END;
$$;



--
-- Name: delete_incident_cascade(text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

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
-- Name: denomination_audit_trigger(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.denomination_audit_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO denomination_audit_log (
            record_id, branch_id, user_id, action, record_type, box_number,
            old_counts, new_counts,
            old_erp_balance, new_erp_balance,
            old_grand_total, new_grand_total,
            old_difference, new_difference
        ) VALUES (
            NEW.id, NEW.branch_id, NEW.user_id, 'INSERT', NEW.record_type, NEW.box_number,
            NULL, NEW.counts,
            NULL, NEW.erp_balance,
            NULL, NEW.grand_total,
            NULL, NEW.difference
        );
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO denomination_audit_log (
            record_id, branch_id, user_id, action, record_type, box_number,
            old_counts, new_counts,
            old_erp_balance, new_erp_balance,
            old_grand_total, new_grand_total,
            old_difference, new_difference
        ) VALUES (
            NEW.id, NEW.branch_id, NEW.user_id, 'UPDATE', NEW.record_type, NEW.box_number,
            OLD.counts, NEW.counts,
            OLD.erp_balance, NEW.erp_balance,
            OLD.grand_total, NEW.grand_total,
            OLD.difference, NEW.difference
        );
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO denomination_audit_log (
            record_id, branch_id, user_id, action, record_type, box_number,
            old_counts, new_counts,
            old_erp_balance, new_erp_balance,
            old_grand_total, new_grand_total,
            old_difference, new_difference
        ) VALUES (
            OLD.id, OLD.branch_id, OLD.user_id, 'DELETE', OLD.record_type, OLD.box_number,
            OLD.counts, NULL,
            OLD.erp_balance, NULL,
            OLD.grand_total, NULL,
            OLD.difference, NULL
        );
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$;



--
-- Name: duplicate_flyer_template(uuid, character varying, uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.duplicate_flyer_template(template_id uuid, new_name character varying, user_id uuid DEFAULT NULL::uuid) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  new_template_id UUID;
  template_record RECORD;
BEGIN
  -- Get the original template
  SELECT * INTO template_record
  FROM flyer_templates
  WHERE id = template_id
    AND deleted_at IS NULL;
  
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Template not found';
  END IF;
  
  -- Create duplicate
  INSERT INTO flyer_templates (
    name,
    description,
    first_page_image_url,
    sub_page_image_urls,
    first_page_configuration,
    sub_page_configurations,
    metadata,
    is_active,
    is_default,
    category,
    tags,
    created_by,
    updated_by
  ) VALUES (
    new_name,
    'Copy of: ' || COALESCE(template_record.description, template_record.name),
    template_record.first_page_image_url,
    template_record.sub_page_image_urls,
    template_record.first_page_configuration,
    template_record.sub_page_configurations,
    template_record.metadata,
    true,
    false, -- Duplicates are never default
    template_record.category,
    template_record.tags,
    user_id,
    user_id
  )
  RETURNING id INTO new_template_id;
  
  RETURN new_template_id;
END;
$$;



--
-- Name: end_break(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.end_break(p_user_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_break RECORD;
  v_duration INTEGER;
BEGIN
  SELECT id, start_time INTO v_break
  FROM break_register
  WHERE user_id = p_user_id AND status = 'open'
  LIMIT 1;

  IF v_break IS NULL THEN
    RETURN jsonb_build_object('success', false, 'error', 'No open break found');
  END IF;

  v_duration := EXTRACT(EPOCH FROM (NOW() - v_break.start_time))::INTEGER;

  UPDATE break_register
  SET end_time = NOW(),
      duration_seconds = v_duration,
      status = 'closed'
  WHERE id = v_break.id;

  RETURN jsonb_build_object('success', true, 'break_id', v_break.id, 'duration_seconds', v_duration);
END;
$$;



--
-- Name: end_break(uuid, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.end_break(p_user_id uuid, p_security_code text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_break_id uuid;
    v_start_time timestamptz;
    v_duration integer;
BEGIN
    -- Validate security code (required)
    IF p_security_code IS NULL OR p_security_code = '' THEN
        RETURN jsonb_build_object('success', false, 'error', 'Security code is required. Please scan the QR code.');
    END IF;
    
    IF NOT validate_break_code(p_security_code) THEN
        RETURN jsonb_build_object('success', false, 'error', 'Invalid or expired QR code. Please scan the current QR code displayed on the screen.');
    END IF;

    -- Find the open break
    SELECT id, start_time INTO v_break_id, v_start_time
    FROM break_register
    WHERE user_id = p_user_id AND status = 'open'
    ORDER BY start_time DESC
    LIMIT 1;

    IF v_break_id IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'No open break found');
    END IF;

    -- Calculate duration
    v_duration := EXTRACT(EPOCH FROM (NOW() - v_start_time))::integer;

    -- Close the break
    UPDATE break_register
    SET end_time = NOW(),
        duration_seconds = v_duration,
        status = 'closed'
    WHERE id = v_break_id;

    RETURN jsonb_build_object('success', true, 'break_id', v_break_id, 'duration_seconds', v_duration);
END;
$$;



--
-- Name: ensure_single_default_flyer_template(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.ensure_single_default_flyer_template() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.is_default = true THEN
    -- Unset all other default templates
    UPDATE flyer_templates 
    SET is_default = false 
    WHERE id != NEW.id 
      AND is_default = true 
      AND deleted_at IS NULL;
  END IF;
  RETURN NEW;
END;
$$;



--
-- Name: export_schema_ddl(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.export_schema_ddl() RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $_$
DECLARE
    v_functions text := '';
    v_triggers text := '';
    v_types text := '';
    v_policies text := '';
    v_grants text := '';
    v_tables text := '';
    v_indexes text := '';
    v_sequences text := '';
    v_columns text := '';
    r record;
BEGIN
    -- ═══ SEQUENCES ═══
    -- Export all sequences in public schema (must come before tables that reference them)
    FOR r IN
        SELECT c.relname AS seq_name,
               s.seqtypid,
               pg_catalog.format_type(s.seqtypid, NULL) AS seq_type,
               s.seqstart, s.seqincrement, s.seqmin, s.seqmax, s.seqcache, s.seqcycle
        FROM pg_class c
        JOIN pg_namespace n ON c.relnamespace = n.oid
        JOIN pg_sequence s ON s.seqrelid = c.oid
        WHERE n.nspname = 'public'
          AND c.relkind = 'S' -- sequences
        ORDER BY c.relname
    LOOP
        v_sequences := v_sequences || format(
            'CREATE SEQUENCE IF NOT EXISTS public.%I AS %s INCREMENT BY %s MINVALUE %s MAXVALUE %s START WITH %s CACHE %s%s;',
            r.seq_name, r.seq_type, r.seqincrement, r.seqmin, r.seqmax, r.seqstart, r.seqcache,
            CASE WHEN r.seqcycle THEN ' CYCLE' ELSE '' END
        ) || E'\n';
        v_sequences := v_sequences || format(
            'GRANT USAGE, SELECT ON SEQUENCE public.%I TO authenticated, anon, service_role;',
            r.seq_name
        ) || E'\n';
    END LOOP;

    -- ═══ FUNCTIONS ═══
    -- Export all user-defined functions in public schema
    -- Use DROP + CREATE to handle return type changes (CREATE OR REPLACE can't change return type)
    FOR r IN
        SELECT p.oid, p.proname,
               pg_get_functiondef(p.oid) AS funcdef,
               pg_get_function_identity_arguments(p.oid) AS identity_args,
               p.prokind
        FROM pg_proc p
        JOIN pg_namespace n ON p.pronamespace = n.oid
        WHERE n.nspname = 'public'
          AND p.prokind IN ('f', 'p') -- functions and procedures
        ORDER BY p.proname
    LOOP
        -- DROP first to handle return type changes
        IF r.prokind = 'p' THEN
            v_functions := v_functions || format(
                'DROP PROCEDURE IF EXISTS public.%I(%s) CASCADE;',
                r.proname, r.identity_args
            ) || E'\n';
        ELSE
            v_functions := v_functions || format(
                'DROP FUNCTION IF EXISTS public.%I(%s) CASCADE;',
                r.proname, r.identity_args
            ) || E'\n';
        END IF;
        v_functions := v_functions || r.funcdef || ';' || E'\n\n';
        -- Add grants for each function
        v_grants := v_grants || format(
            'GRANT EXECUTE ON FUNCTION public.%I TO authenticated, anon, service_role;',
            r.proname
        ) || E'\n';
    END LOOP;

    -- ═══ CUSTOM TYPES (enums and composites) ═══
    FOR r IN
        SELECT t.typname,
               CASE t.typtype
                   WHEN 'e' THEN
                       'CREATE TYPE IF NOT EXISTS public.' || quote_ident(t.typname) || ' AS ENUM (' ||
                       string_agg(quote_literal(e.enumlabel), ', ' ORDER BY e.enumsortorder) || ')'
                   WHEN 'c' THEN
                       'DO $typchk$ BEGIN CREATE TYPE public.' || quote_ident(t.typname) || ' AS (' ||
                       string_agg(quote_ident(a.attname) || ' ' || pg_catalog.format_type(a.atttypid, a.atttypmod), ', ' ORDER BY a.attnum) ||
                       '); EXCEPTION WHEN duplicate_object THEN NULL; END $typchk$'
               END AS typedef
        FROM pg_type t
        JOIN pg_namespace n ON t.typnamespace = n.oid
        LEFT JOIN pg_enum e ON t.typtype = 'e' AND e.enumtypid = t.oid
        LEFT JOIN pg_attribute a ON t.typtype = 'c' AND a.attrelid = t.typrelid AND a.attnum > 0
        WHERE n.nspname = 'public'
          AND t.typtype IN ('e', 'c')
          AND t.typname NOT LIKE 'pg_%'
          AND t.typname NOT LIKE '_%' -- skip internal composite types for tables
        GROUP BY t.typname, t.typtype
        ORDER BY t.typtype DESC, t.typname -- enums first, then composites
    LOOP
        IF r.typedef IS NOT NULL THEN
            v_types := v_types || r.typedef || ';' || E'\n';
        END IF;
    END LOOP;

    -- ═══ TABLES (CREATE TABLE IF NOT EXISTS) ═══
    -- Export all public tables with columns, defaults, NOT NULL, and primary keys
    FOR r IN
        SELECT c.relname AS table_name,
               c.oid AS table_oid,
               c.relrowsecurity AS rls_enabled
        FROM pg_class c
        JOIN pg_namespace n ON c.relnamespace = n.oid
        WHERE n.nspname = 'public'
          AND c.relkind = 'r' -- regular tables only
        ORDER BY c.relname
    LOOP
        DECLARE
            v_cols text := '';
            v_pk text := '';
            v_constraints text := '';
            col record;
            con record;
            idx record;
        BEGIN
            -- Columns
            FOR col IN
                SELECT a.attname,
                       pg_catalog.format_type(a.atttypid, a.atttypmod) AS col_type,
                       a.attnotnull AS not_null,
                       pg_get_expr(d.adbin, d.adrelid) AS default_val,
                       a.attidentity
                FROM pg_attribute a
                LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                WHERE a.attrelid = r.table_oid
                  AND a.attnum > 0
                  AND NOT a.attisdropped
                ORDER BY a.attnum
            LOOP
                IF v_cols != '' THEN v_cols := v_cols || ',' || E'\n'; END IF;
                v_cols := v_cols || '    ' || quote_ident(col.attname) || ' ' || col.col_type;
                IF col.attidentity = 'a' THEN
                    v_cols := v_cols || ' GENERATED ALWAYS AS IDENTITY';
                ELSIF col.attidentity = 'd' THEN
                    v_cols := v_cols || ' GENERATED BY DEFAULT AS IDENTITY';
                ELSIF col.default_val IS NOT NULL THEN
                    v_cols := v_cols || ' DEFAULT ' || col.default_val;
                END IF;
                IF col.not_null THEN
                    v_cols := v_cols || ' NOT NULL';
                END IF;
            END LOOP;

            -- Primary key and unique constraints
            FOR con IN
                SELECT pg_get_constraintdef(c2.oid) AS condef,
                       c2.conname,
                       c2.contype
                FROM pg_constraint c2
                WHERE c2.conrelid = r.table_oid
                  AND c2.contype IN ('p', 'u', 'f', 'c') -- PK, unique, FK, check
                ORDER BY c2.contype, c2.conname
            LOOP
                v_constraints := v_constraints || ',' || E'\n' || '    CONSTRAINT ' || quote_ident(con.conname) || ' ' || con.condef;
            END LOOP;

            v_tables := v_tables || 'CREATE TABLE IF NOT EXISTS public.' || quote_ident(r.table_name) || ' (' || E'\n';
            v_tables := v_tables || v_cols || v_constraints || E'\n);\n';

            -- Enable RLS if enabled on source
            IF r.rls_enabled THEN
                v_tables := v_tables || 'ALTER TABLE public.' || quote_ident(r.table_name) || ' ENABLE ROW LEVEL SECURITY;' || E'\n';
            END IF;

            -- Grant table permissions
            v_tables := v_tables || 'GRANT ALL ON public.' || quote_ident(r.table_name) || ' TO authenticated, anon, service_role;' || E'\n\n';

            -- ALTER TABLE ADD COLUMN IF NOT EXISTS for each column (handles missing columns on existing tables)
            FOR col IN
                SELECT a.attname,
                       pg_catalog.format_type(a.atttypid, a.atttypmod) AS col_type,
                       pg_get_expr(d.adbin, d.adrelid) AS default_val,
                       a.attidentity
                FROM pg_attribute a
                LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                WHERE a.attrelid = r.table_oid
                  AND a.attnum > 0
                  AND NOT a.attisdropped
                ORDER BY a.attnum
            LOOP
                -- Skip identity columns in ADD COLUMN (they need special handling)
                IF col.attidentity IN ('a', 'd') THEN
                    CONTINUE;
                END IF;
                v_columns := v_columns || 'ALTER TABLE public.' || quote_ident(r.table_name) || ' ADD COLUMN IF NOT EXISTS ' || quote_ident(col.attname) || ' ' || col.col_type;
                IF col.default_val IS NOT NULL THEN
                    v_columns := v_columns || ' DEFAULT ' || col.default_val;
                END IF;
                v_columns := v_columns || ';' || E'\n';
            END LOOP;

            -- Indexes (non-primary, non-unique-constraint)
            FOR idx IN
                SELECT pg_get_indexdef(i.indexrelid) AS indexdef
                FROM pg_index i
                JOIN pg_class ic ON i.indexrelid = ic.oid
                WHERE i.indrelid = r.table_oid
                  AND NOT i.indisprimary
                  AND NOT EXISTS (
                      SELECT 1 FROM pg_constraint WHERE conindid = i.indexrelid
                  )
            LOOP
                -- Add IF NOT EXISTS to CREATE INDEX / CREATE UNIQUE INDEX statements
                v_indexes := v_indexes || replace(replace(idx.indexdef, 'CREATE UNIQUE INDEX ', 'CREATE UNIQUE INDEX IF NOT EXISTS '), 'CREATE INDEX ', 'CREATE INDEX IF NOT EXISTS ') || ';' || E'\n';
            END LOOP;
        END;
    END LOOP;

    -- ═══ TRIGGERS ═══
    FOR r IN
        SELECT tg.tgname AS trigger_name,
               c.relname AS table_name,
               pg_get_triggerdef(tg.oid) AS triggerdef
        FROM pg_trigger tg
        JOIN pg_class c ON tg.tgrelid = c.oid
        JOIN pg_namespace n ON c.relnamespace = n.oid
        WHERE n.nspname = 'public'
          AND NOT tg.tgisinternal
        ORDER BY c.relname, tg.tgname
    LOOP
        -- DROP + CREATE to handle changes
        v_triggers := v_triggers || format(
            'DROP TRIGGER IF EXISTS %I ON public.%I;',
            r.trigger_name, r.table_name
        ) || E'\n';
        v_triggers := v_triggers || r.triggerdef || ';' || E'\n\n';
    END LOOP;

    -- ═══ RLS POLICIES ═══
    FOR r IN
        SELECT schemaname, tablename, policyname,
               permissive, roles, cmd, qual, with_check
        FROM pg_policies
        WHERE schemaname = 'public'
        ORDER BY tablename, policyname
    LOOP
        v_policies := v_policies || format(
            'DROP POLICY IF EXISTS %I ON public.%I;',
            r.policyname, r.tablename
        ) || E'\n';
        v_policies := v_policies || format(
            'CREATE POLICY %I ON public.%I AS %s FOR %s TO %s',
            r.policyname, r.tablename,
            r.permissive,
            r.cmd,
            array_to_string(r.roles, ', ')
        );
        IF r.qual IS NOT NULL THEN
            v_policies := v_policies || ' USING (' || r.qual || ')';
        END IF;
        IF r.with_check IS NOT NULL THEN
            v_policies := v_policies || ' WITH CHECK (' || r.with_check || ')';
        END IF;
        v_policies := v_policies || ';' || E'\n\n';
    END LOOP;

    RETURN jsonb_build_object(
        'sequences', v_sequences,
        'tables', v_tables,
        'columns', v_columns,
        'indexes', v_indexes,
        'types', v_types,
        'functions', v_functions,
        'triggers', v_triggers,
        'policies', v_policies,
        'grants', v_grants,
        'exported_at', now()::text,
        'table_count', (SELECT count(*) FROM pg_class c JOIN pg_namespace n ON c.relnamespace = n.oid WHERE n.nspname = 'public' AND c.relkind = 'r'),
        'function_count', (SELECT count(*) FROM pg_proc WHERE pronamespace = 'public'::regnamespace),
        'trigger_count', (SELECT count(*) FROM pg_trigger tg JOIN pg_class c ON tg.tgrelid = c.oid JOIN pg_namespace n ON c.relnamespace = n.oid WHERE n.nspname = 'public' AND NOT tg.tgisinternal),
        'type_count', (SELECT count(*) FROM pg_type WHERE typnamespace = 'public'::regnamespace AND typtype IN ('e','c') AND typname NOT LIKE 'pg_%' AND typname NOT LIKE '_%'),
        'policy_count', (SELECT count(*) FROM pg_policies WHERE schemaname = 'public'),
        'sequence_count', (SELECT count(*) FROM pg_class c JOIN pg_namespace n ON c.relnamespace = n.oid WHERE n.nspname = 'public' AND c.relkind = 'S')
    );
END;
$_$;



--
-- Name: FUNCTION export_schema_ddl(); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.export_schema_ddl() IS 'Exports all public schema DDL (functions, triggers, types, policies) as SQL text for branch sync';


--
-- Name: export_table_for_sync(text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.export_table_for_sync(p_table_name text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_result jsonb;
    v_allowed_tables text[] := ARRAY[
        'branches', 'users', 'user_sessions', 'user_device_sessions',
        'button_permissions', 'sidebar_buttons', 'button_main_sections', 'button_sub_sections',
        'interface_permissions', 'user_favorite_buttons',
        'erp_synced_products', 'product_categories', 'products', 'product_units',
        'offers', 'offer_products', 'offer_names', 'offer_bundles', 'offer_cart_tiers',
        'bogo_offer_rules', 'flyer_offers', 'flyer_offer_products',
        'customers', 'privilege_cards_master', 'privilege_cards_branch',
        'desktop_themes', 'user_theme_assignments',
        'erp_connections', 'erp_sync_logs',
        'coupon_campaigns', 'coupon_products', 'coupon_eligible_customers',
        'delivery_fee_tiers', 'delivery_service_settings',
        'social_links', 'ai_chat_guide',
        'nationalities', 'vendors',
        'expense_parent_categories', 'expense_sub_categories',
        'notification_attachments', 'notifications', 'notification_recipients',
        'push_subscriptions'
    ];
BEGIN
    -- Security: Only allow whitelisted tables
    IF NOT (p_table_name = ANY(v_allowed_tables)) THEN
        RAISE EXCEPTION 'Table % is not allowed for sync', p_table_name;
    END IF;

    EXECUTE format('SELECT COALESCE(jsonb_agg(row_to_json(t)::jsonb), ''[]''::jsonb) FROM %I t', p_table_name)
    INTO v_result;

    RETURN v_result;
END;
$$;



--
-- Name: format_file_size(bigint); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.format_file_size(size_bytes bigint) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    size_kb numeric := size_bytes / 1024.0;
    size_mb numeric := size_kb / 1024.0;
    size_gb numeric := size_mb / 1024.0;
BEGIN
    IF size_gb >= 1 THEN
        RETURN round(size_gb, 2) || ' GB';
    ELSIF size_mb >= 1 THEN
        RETURN round(size_mb, 2) || ' MB';
    ELSIF size_kb >= 1 THEN
        RETURN round(size_kb, 2) || ' KB';
    ELSE
        RETURN size_bytes || ' Bytes';
    END IF;
END;
$$;



--
-- Name: generate_branch_id(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.generate_branch_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    prefix VARCHAR(2);
    next_num INTEGER;
BEGIN
    -- Always generate branch_id if not provided or empty
    IF NEW.branch_id IS NULL OR NEW.branch_id = '' THEN
        -- Determine prefix based on branch type
        prefix := CASE 
            WHEN NEW.branch_type = 'head_branch' THEN 'HB'
            ELSE 'BR'
        END;
        
        -- Get next number for this branch type by finding the highest existing number
        SELECT COALESCE(MAX(
            CASE 
                WHEN branch_id ~ ('^' || prefix || '[0-9]+$') 
                THEN CAST(SUBSTRING(branch_id FROM LENGTH(prefix) + 1) AS INTEGER)
                ELSE 0
            END
        ), 0) + 1
        INTO next_num
        FROM branches 
        WHERE branch_id LIKE prefix || '%';
        
        -- Generate new branch_id with zero-padded number
        NEW.branch_id := prefix || LPAD(next_num::TEXT, 3, '0');
    END IF;
    
    RETURN NEW;
END;
$_$;



--
-- Name: generate_campaign_code(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.generate_campaign_code() RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
  new_code VARCHAR(8);
  code_exists BOOLEAN;
BEGIN
  LOOP
    -- Generate 8 character alphanumeric code
    new_code := upper(substring(md5(random()::text || clock_timestamp()::text) from 1 for 8));
    
    -- Check if code already exists
    SELECT EXISTS(SELECT 1 FROM coupon_campaigns WHERE campaign_code = new_code)
    INTO code_exists;
    
    EXIT WHEN NOT code_exists;
  END LOOP;
  
  RETURN new_code;
END;
$$;



--
-- Name: generate_clearance_certificate_tasks(uuid, text, text, text, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.generate_clearance_certificate_tasks(receiving_record_id_param uuid, clearance_certificate_url_param text, created_by_user_id text, created_by_name text DEFAULT NULL::text, created_by_role text DEFAULT NULL::text) RETURNS TABLE(task_count integer, notification_count integer, task_ids uuid[], assignment_ids uuid[])
    LANGUAGE plpgsql
    AS $$
DECLARE
    receiving_record RECORD;
    vendor_record RECORD;
    task_id UUID;
    assignment_id UUID;
    notification_id UUID;
    deadline_datetime TIMESTAMPTZ;
    task_description TEXT;
    user_id UUID;
    total_tasks INTEGER := 0;
    total_notifications INTEGER := 0;
    created_task_ids UUID[] := '{}';
    created_assignment_ids UUID[] := '{}';
BEGIN
    deadline_datetime := now() + INTERVAL '24 hours';
    
    -- Get receiving record details
    SELECT * INTO receiving_record 
    FROM receiving_records 
    WHERE id = receiving_record_id_param;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Receiving record not found: %', receiving_record_id_param;
    END IF;
    
    -- Get vendor details for description
    SELECT vendor_name INTO vendor_record 
    FROM vendors 
    WHERE erp_vendor_id = receiving_record.vendor_id;
    
    task_description := format('Vendor: %s, Bill #: %s, Bill Amount: %s, Bill Date: %s, Received by: %s',
        COALESCE(vendor_record.vendor_name, 'Unknown Vendor'),
        COALESCE(receiving_record.bill_number, 'N/A'),
        COALESCE(receiving_record.bill_amount::TEXT, 'N/A'),
        receiving_record.bill_date::TEXT,
        COALESCE(created_by_name, 'Unknown User')
    );
    
    -- 1. Branch Manager Task
    IF receiving_record.branch_manager_user_id IS NOT NULL THEN
        task_id := create_task(
            'New delivery arrived—start placing.',
            task_description,
            created_by_user_id,
            COALESCE(created_by_name, ''),
            COALESCE(created_by_role, ''),
            'high',
            deadline_datetime::DATE,
            deadline_datetime::TIME,
            true,   -- require_task_finished
            false,  -- require_photo_upload  
            false,  -- require_erp_reference (NO ERP!)
            false,  -- can_escalate
            true    -- can_reassign
        );
        
        assignment_id := assign_task_simple(
            task_id,
            receiving_record.branch_manager_user_id,
            created_by_user_id,
            COALESCE(created_by_name, ''),
            deadline_datetime,
            'high',
            'Clearance certificate attached'
        );
        
        notification_id := create_notification_simple(
            'New Delivery Task Assigned',
            format('You have been assigned a new delivery task: %s', task_description),
            created_by_user_id,
            COALESCE(created_by_name, ''),
            receiving_record.branch_manager_user_id,
            task_id,
            assignment_id
        );
        
        total_tasks := total_tasks + 1;
        total_notifications := total_notifications + 1;
        created_task_ids := created_task_ids || task_id;
        created_assignment_ids := created_assignment_ids || assignment_id;
        
        RAISE NOTICE 'Branch Manager task created: %', task_id;
    END IF;
    
    -- 2. Purchase Manager Task
    IF receiving_record.purchasing_manager_user_id IS NOT NULL THEN
        task_id := create_task(
            'New delivery arrived—price check.',
            task_description,
            created_by_user_id,
            COALESCE(created_by_name, ''),
            COALESCE(created_by_role, ''),
            'medium',
            deadline_datetime::DATE,
            deadline_datetime::TIME,
            true,   -- require_task_finished
            false,  -- require_photo_upload  
            false,  -- require_erp_reference (NO ERP!)
            false,  -- can_escalate
            false   -- can_reassign
        );
        
        assignment_id := assign_task_simple(
            task_id,
            receiving_record.purchasing_manager_user_id,
            created_by_user_id,
            COALESCE(created_by_name, ''),
            deadline_datetime,
            'medium',
            'Clearance certificate attached'
        );
        
        notification_id := create_notification_simple(
            'Price Check Task Assigned',
            format('You have been assigned a price check task: %s', task_description),
            created_by_user_id,
            COALESCE(created_by_name, ''),
            receiving_record.purchasing_manager_user_id,
            task_id,
            assignment_id
        );
        
        total_tasks := total_tasks + 1;
        total_notifications := total_notifications + 1;
        created_task_ids := created_task_ids || task_id;
        created_assignment_ids := created_assignment_ids || assignment_id;
        
        RAISE NOTICE 'Purchase Manager task created: %', task_id;
    END IF;
    
    -- 3. Inventory Manager Task (NO ERP!)
    IF receiving_record.inventory_manager_user_id IS NOT NULL THEN
        task_id := create_task(
            'New delivery arrived—enter into the purchase ERP, upload the original bill, and update the ERP purchase invoice number.',
            task_description,
            created_by_user_id,
            COALESCE(created_by_name, ''),
            COALESCE(created_by_role, ''),
            'high',
            deadline_datetime::DATE,
            deadline_datetime::TIME,
            true,   -- require_task_finished
            false,  -- require_photo_upload  
            false,  -- require_erp_reference (NO ERP!)
            false,  -- can_escalate
            false   -- can_reassign
        );
        
        assignment_id := assign_task_simple(
            task_id,
            receiving_record.inventory_manager_user_id,
            created_by_user_id,
            COALESCE(created_by_name, ''),
            deadline_datetime,
            'high',
            'Clearance certificate attached. NO ERP reference required.'
        );
        
        notification_id := create_notification_simple(
            'ERP Entry Task Assigned (No ERP Required)',
            format('You have been assigned an ERP entry task: %s', task_description),
            created_by_user_id,
            COALESCE(created_by_name, ''),
            receiving_record.inventory_manager_user_id,
            task_id,
            assignment_id
        );
        
        total_tasks := total_tasks + 1;
        total_notifications := total_notifications + 1;
        created_task_ids := created_task_ids || task_id;
        created_assignment_ids := created_assignment_ids || assignment_id;
        
        RAISE NOTICE 'Inventory Manager task created: %', task_id;
    END IF;
    
    -- 4. Night Supervisors Tasks
    IF receiving_record.night_supervisor_user_ids IS NOT NULL AND array_length(receiving_record.night_supervisor_user_ids, 1) > 0 THEN
        FOREACH user_id IN ARRAY receiving_record.night_supervisor_user_ids
        LOOP
            task_id := create_task(
                'New delivery arrived—confirm product is placed.',
                task_description,
                created_by_user_id,
                COALESCE(created_by_name, ''),
                COALESCE(created_by_role, ''),
                'medium',
                deadline_datetime::DATE,
                deadline_datetime::TIME,
                true,   -- require_task_finished
                false,  -- require_photo_upload  
                false,  -- require_erp_reference (NO ERP!)
                false,  -- can_escalate
                true    -- can_reassign
            );
            
            assignment_id := assign_task_simple(
                task_id,
                user_id,
                created_by_user_id,
                COALESCE(created_by_name, ''),
                deadline_datetime,
                'medium',
                'Clearance certificate attached'
            );
            
            notification_id := create_notification_simple(
                'Product Placement Task Assigned',
                format('You have been assigned a product placement task: %s', task_description),
                created_by_user_id,
                COALESCE(created_by_name, ''),
                user_id,
                task_id,
                assignment_id
            );
            
            total_tasks := total_tasks + 1;
            total_notifications := total_notifications + 1;
            created_task_ids := created_task_ids || task_id;
            created_assignment_ids := created_assignment_ids || assignment_id;
        END LOOP;
        
        RAISE NOTICE 'Night Supervisor tasks created: %', array_length(receiving_record.night_supervisor_user_ids, 1);
    END IF;
    
    -- 5. Warehouse Handlers Tasks
    IF receiving_record.warehouse_handler_user_ids IS NOT NULL AND array_length(receiving_record.warehouse_handler_user_ids, 1) > 0 THEN
        FOREACH user_id IN ARRAY receiving_record.warehouse_handler_user_ids
        LOOP
            task_id := create_task(
                'New delivery arrived—confirm product is moved to display.',
                task_description,
                created_by_user_id,
                COALESCE(created_by_name, ''),
                COALESCE(created_by_role, ''),
                'medium',
                deadline_datetime::DATE,
                deadline_datetime::TIME,
                true,   -- require_task_finished
                false,  -- require_photo_upload  
                false,  -- require_erp_reference (NO ERP!)
                false,  -- can_escalate
                false   -- can_reassign
            );
            
            assignment_id := assign_task_simple(
                task_id,
                user_id,
                created_by_user_id,
                COALESCE(created_by_name, ''),
                deadline_datetime,
                'medium',
                'Clearance certificate attached'
            );
            
            notification_id := create_notification_simple(
                'Display Movement Task Assigned',
                format('You have been assigned a display movement task: %s', task_description),
                created_by_user_id,
                COALESCE(created_by_name, ''),
                user_id,
                task_id,
                assignment_id
            );
            
            total_tasks := total_tasks + 1;
            total_notifications := total_notifications + 1;
            created_task_ids := created_task_ids || task_id;
            created_assignment_ids := created_assignment_ids || assignment_id;
        END LOOP;
        
        RAISE NOTICE 'Warehouse Handler tasks created: %', array_length(receiving_record.warehouse_handler_user_ids, 1);
    END IF;
    
    -- 6. Shelf Stockers Tasks
    IF receiving_record.shelf_stocker_user_ids IS NOT NULL AND array_length(receiving_record.shelf_stocker_user_ids, 1) > 0 THEN
        FOREACH user_id IN ARRAY receiving_record.shelf_stocker_user_ids
        LOOP
            task_id := create_task(
                'New delivery arrived—confirm product is placed.',
                task_description,
                created_by_user_id,
                COALESCE(created_by_name, ''),
                COALESCE(created_by_role, ''),
                'low',
                deadline_datetime::DATE,
                deadline_datetime::TIME,
                true,   -- require_task_finished
                false,  -- require_photo_upload  
                false,  -- require_erp_reference (NO ERP!)
                false,  -- can_escalate
                false   -- can_reassign
            );
            
            assignment_id := assign_task_simple(
                task_id,
                user_id,
                created_by_user_id,
                COALESCE(created_by_name, ''),
                deadline_datetime,
                'low',
                'Confirm product placement on shelves'
            );
            
            notification_id := create_notification_simple(
                'Shelf Stocking Task Assigned',
                format('You have been assigned a shelf stocking task: %s', task_description),
                created_by_user_id,
                COALESCE(created_by_name, ''),
                user_id,
                task_id,
                assignment_id
            );
            
            total_tasks := total_tasks + 1;
            total_notifications := total_notifications + 1;
            created_task_ids := created_task_ids || task_id;
            created_assignment_ids := created_assignment_ids || assignment_id;
        END LOOP;
        
        RAISE NOTICE 'Shelf Stocker tasks created: %', array_length(receiving_record.shelf_stocker_user_ids, 1);
    END IF;
    
    -- 7. Accountant Task (NO ERP!)
    IF receiving_record.accountant_user_id IS NOT NULL THEN
        task_id := create_task(
            'New delivery arrived—confirm the original has been received and filed, and verify the ERP purchase invoice number with the original entry.',
            task_description,
            created_by_user_id,
            COALESCE(created_by_name, ''),
            COALESCE(created_by_role, ''),
            'medium',
            deadline_datetime::DATE,
            deadline_datetime::TIME,
            true,   -- require_task_finished
            false,  -- require_photo_upload  
            false,  -- require_erp_reference (NO ERP!)
            false,  -- can_escalate
            false   -- can_reassign
        );
        
        assignment_id := assign_task_simple(
            task_id,
            receiving_record.accountant_user_id,
            created_by_user_id,
            COALESCE(created_by_name, ''),
            deadline_datetime,
            'medium',
            'NO ERP reference required'
        );
        
        notification_id := create_notification_simple(
            'Accounting Filing Task Assigned',
            format('You have been assigned an accounting filing task: %s', task_description),
            created_by_user_id,
            COALESCE(created_by_name, ''),
            receiving_record.accountant_user_id,
            task_id,
            assignment_id
        );
        
        total_tasks := total_tasks + 1;
        total_notifications := total_notifications + 1;
        created_task_ids := created_task_ids || task_id;
        created_assignment_ids := created_assignment_ids || assignment_id;
        
        RAISE NOTICE 'Accountant task created: %', task_id;
    END IF;
    
    RAISE NOTICE 'Total tasks created: %, Total notifications sent: %', total_tasks, total_notifications;
    
    RETURN QUERY SELECT total_tasks, total_notifications, created_task_ids, created_assignment_ids;
    
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Error in generate_clearance_certificate_tasks: %', SQLERRM;
    RAISE;
END;
$$;



--
-- Name: generate_insurance_company_id(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.generate_insurance_company_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  max_id INTEGER;
  new_id VARCHAR(15);
BEGIN
  -- Extract the numeric part from the last ID and increment it
  SELECT COALESCE(MAX(CAST(SUBSTRING(id, 4) AS INTEGER)), 0) + 1
  INTO max_id
  FROM hr_insurance_companies
  WHERE id LIKE 'INC%';
  
  -- Format as INC001, INC002, etc.
  new_id := 'INC' || LPAD(max_id::TEXT, 3, '0');
  NEW.id := new_id;
  
  RETURN NEW;
END;
$$;



--
-- Name: generate_new_customer_access_code(uuid, uuid, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.generate_new_customer_access_code(p_customer_id uuid, p_admin_user_id uuid, p_notes text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'extensions'
    AS $$
DECLARE
    v_new_access_code text;
    v_hashed_new_code text;
    v_customer_name text;
    v_whatsapp_number text;
    v_old_hashed_code text;
    v_admin_name text;
    v_current_time timestamp with time zone := now();
    result json;
BEGIN
    SELECT username INTO v_admin_name
    FROM public.users WHERE id = p_admin_user_id AND status = 'active';
    
    IF v_admin_name IS NULL THEN
        RETURN json_build_object('success', false, 'error', 'Invalid admin user');
    END IF;
    
    SELECT c.access_code, c.whatsapp_number, c.name
    INTO v_old_hashed_code, v_whatsapp_number, v_customer_name
    FROM public.customers c WHERE c.id = p_customer_id;
    
    IF v_customer_name IS NULL THEN
        RETURN json_build_object('success', false, 'error', 'Customer not found');
    END IF;
    
    v_new_access_code := generate_unique_customer_access_code();
    v_hashed_new_code := encode(digest(v_new_access_code::bytea, 'sha256'), 'hex');
    
    IF v_new_access_code IS NULL THEN
        RETURN json_build_object('success', false, 'error', 'Failed to generate unique access code');
    END IF;
    
    UPDATE public.customers
    SET access_code = v_hashed_new_code,
        access_code_generated_at = v_current_time,
        updated_at = v_current_time
    WHERE id = p_customer_id;

    INSERT INTO public.customer_access_code_history (
        customer_id, old_access_code, new_access_code,
        generated_by, reason, notes
    ) VALUES (
        p_customer_id, v_old_hashed_code, v_hashed_new_code,
        p_admin_user_id, 'admin_regeneration', COALESCE(p_notes, 'Regenerated by admin')
    );
    
    INSERT INTO public.notifications (title, message, type, priority, metadata, deleted_at)
    VALUES (
        'Customer Access Code Regenerated',
        'Access code regenerated for customer: ' || v_customer_name || ' by admin: ' || v_admin_name,
        'customer_access_code_change', 'medium',
        json_build_object('customer_id', p_customer_id, 'customer_name', v_customer_name,
            'generated_by', v_admin_name, 'generated_at', v_current_time, 'notes', p_notes),
        NULL
    );
    
    INSERT INTO public.notifications (title, message, type, priority, metadata, deleted_at)
    VALUES (
        'New Access Code Generated',
        'Your access code has been updated by an administrator.',
        'customer_notification', 'high',
        json_build_object('customer_id', p_customer_id, 'generated_by', v_admin_name,
            'generated_at', v_current_time, 'notes', p_notes),
        NULL
    );
    
    INSERT INTO public.user_activity_logs (user_id, activity_type, description, metadata, created_at)
    VALUES (
        p_admin_user_id, 'customer_access_code_regenerated',
        'Generated new access code for customer: ' || v_customer_name,
        json_build_object('customer_id', p_customer_id, 'customer_name', v_customer_name, 'notes', p_notes),
        v_current_time
    );
    
    result := json_build_object(
        'success', true,
        'message', 'New access code generated successfully',
        'customer_id', p_customer_id,
        'customer_name', v_customer_name,
        'whatsapp_number', v_whatsapp_number,
        'new_access_code', v_new_access_code,
        'generated_by', v_admin_name,
        'generated_at', v_current_time
    );
    
    RETURN result;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object('success', false, 'error', 'Failed to generate new access code: ' || SQLERRM);
END;
$$;



--
-- Name: generate_order_number(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.generate_order_number() RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_order_number VARCHAR(50);
    counter INTEGER;
BEGIN
    -- Format: ORD-YYYYMMDD-XXXX
    SELECT COUNT(*) + 1 INTO counter
    FROM orders
    WHERE DATE(created_at) = CURRENT_DATE;
    
    new_order_number := 'ORD-' || TO_CHAR(CURRENT_DATE, 'YYYYMMDD') || '-' || LPAD(counter::TEXT, 4, '0');
    
    RETURN new_order_number;
END;
$$;



--
-- Name: FUNCTION generate_order_number(); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.generate_order_number() IS 'Generates unique order number in format ORD-YYYYMMDD-XXXX';


--
-- Name: generate_recurring_occurrences(integer, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.generate_recurring_occurrences(p_parent_id integer, p_source_table text) RETURNS TABLE(occurrence_count integer, message text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    rec RECORD;
    occurrence_date DATE;
    start_date DATE;
    end_date DATE;
    current_date_iter DATE;
    occurrences_created INTEGER := 0;
    co_user_id_value UUID;
    co_user_name_value TEXT;
BEGIN
    -- Fetch the parent recurring schedule
    IF p_source_table = 'expense_scheduler' THEN
        SELECT * INTO rec
        FROM expense_scheduler
        WHERE id = p_parent_id
        AND schedule_type = 'recurring';
    ELSIF p_source_table = 'non_approved_payment_scheduler' THEN
        SELECT * INTO rec
        FROM non_approved_payment_scheduler
        WHERE id = p_parent_id
        AND schedule_type = 'recurring';
    ELSE
        RAISE EXCEPTION 'Invalid source_table: %', p_source_table;
    END IF;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Recurring schedule not found with ID: % in table: %', p_parent_id, p_source_table;
    END IF;
    
    -- Get creator's info to use as CO user for single_bill occurrences
    -- If parent has co_user, use that; otherwise use creator
    IF rec.co_user_id IS NOT NULL THEN
        co_user_id_value := rec.co_user_id;
        co_user_name_value := rec.co_user_name;
    ELSE
        -- Use creator's ID and username from public.users table
        co_user_id_value := rec.created_by;
        SELECT username INTO co_user_name_value
        FROM public.users
        WHERE id = rec.created_by;
        
        -- If still null, use a default
        IF co_user_name_value IS NULL THEN
            co_user_name_value := 'System User';
        END IF;
    END IF;

    -- Generate occurrences based on recurring type
    CASE rec.recurring_type
        WHEN 'daily' THEN
            -- Generate daily occurrences
            start_date := CURRENT_DATE;
            end_date := (rec.recurring_metadata->>'until_date')::DATE;
            
            current_date_iter := start_date;
            WHILE current_date_iter <= end_date LOOP
                -- Create occurrence for this date
                IF p_source_table = 'non_approved_payment_scheduler' THEN
                    INSERT INTO non_approved_payment_scheduler (
                        schedule_type,
                        branch_id,
                        branch_name,
                        expense_category_id,
                        expense_category_name_en,
                        expense_category_name_ar,
                        co_user_id,
                        co_user_name,
                        payment_method,
                        amount,
                        description,
                        bill_type,
                        due_date,
                        approver_id,
                        approver_name,
                        approval_status,
                        created_by,
                        recurring_metadata
                    ) VALUES (
                        'single_bill',
                        rec.branch_id,
                        rec.branch_name,
                        rec.expense_category_id,
                        rec.expense_category_name_en,
                        rec.expense_category_name_ar,
                        co_user_id_value,
                        co_user_name_value,
                        rec.payment_method,
                        rec.amount,
                        COALESCE(rec.description, '') || FORMAT(' (Recurring: %s)', current_date_iter::TEXT),
                        rec.bill_type,
                        current_date_iter,
                        rec.approver_id,
                        rec.approver_name,
                        'pending',
                        rec.created_by,
                        jsonb_build_object(
                            'parent_schedule_id', rec.id,
                            'occurrence_date', current_date_iter,
                            'recurring_type', rec.recurring_type
                        )
                    );
                ELSE
                    INSERT INTO expense_scheduler (
                        schedule_type,
                        branch_id,
                        branch_name,
                        expense_category_id,
                        expense_category_name_en,
                        expense_category_name_ar,
                        requisition_id,
                        requisition_number,
                        co_user_id,
                        co_user_name,
                        payment_method,
                        amount,
                        description,
                        bill_type,
                        due_date,
                        status,
                        is_paid,
                        created_by,
                        recurring_metadata
                    ) VALUES (
                        'single_bill',
                        rec.branch_id,
                        rec.branch_name,
                        rec.expense_category_id,
                        rec.expense_category_name_en,
                        rec.expense_category_name_ar,
                        rec.requisition_id,
                        rec.requisition_number,
                        co_user_id_value,
                        co_user_name_value,
                        rec.payment_method,
                        rec.amount,
                        COALESCE(rec.description, '') || FORMAT(' (Recurring: %s)', current_date_iter::TEXT),
                        rec.bill_type,
                        current_date_iter,
                        'pending',
                        FALSE,
                        rec.created_by,
                        jsonb_build_object(
                            'parent_schedule_id', rec.id,
                            'occurrence_date', current_date_iter,
                            'recurring_type', rec.recurring_type
                        )
                    );
                END IF;
                
                occurrences_created := occurrences_created + 1;
                current_date_iter := current_date_iter + INTERVAL '1 day';
            END LOOP;
            
        WHEN 'weekly' THEN
            -- Generate weekly occurrences
            DECLARE
                target_weekday INTEGER;
            BEGIN
                target_weekday := (rec.recurring_metadata->>'weekday')::INTEGER;
                start_date := CURRENT_DATE;
                end_date := (rec.recurring_metadata->>'until_date')::DATE;
                
                current_date_iter := start_date;
                WHILE current_date_iter <= end_date LOOP
                    IF EXTRACT(DOW FROM current_date_iter) = target_weekday THEN
                        -- Create occurrence
                        IF p_source_table = 'non_approved_payment_scheduler' THEN
                            INSERT INTO non_approved_payment_scheduler (
                                schedule_type, branch_id, branch_name, expense_category_id,
                                expense_category_name_en, expense_category_name_ar,
                                co_user_id, co_user_name, payment_method, amount,
                                description, bill_type, due_date, approver_id,
                                approver_name, approval_status, created_by, recurring_metadata
                            ) VALUES (
                                'single_bill', rec.branch_id, rec.branch_name, rec.expense_category_id,
                                rec.expense_category_name_en, rec.expense_category_name_ar,
                                co_user_id_value, co_user_name_value, rec.payment_method, rec.amount,
                                COALESCE(rec.description, '') || FORMAT(' (Recurring: %s)', current_date_iter::TEXT),
                                rec.bill_type, current_date_iter, rec.approver_id,
                                rec.approver_name, 'pending', rec.created_by,
                                jsonb_build_object('parent_schedule_id', rec.id, 'occurrence_date', current_date_iter, 'recurring_type', rec.recurring_type)
                            );
                        ELSE
                            INSERT INTO expense_scheduler (
                                schedule_type, branch_id, branch_name, expense_category_id,
                                expense_category_name_en, expense_category_name_ar,
                                requisition_id, requisition_number, co_user_id, co_user_name,
                                payment_method, amount, description, bill_type, due_date,
                                status, is_paid, created_by, recurring_metadata
                            ) VALUES (
                                'single_bill', rec.branch_id, rec.branch_name, rec.expense_category_id,
                                rec.expense_category_name_en, rec.expense_category_name_ar,
                                rec.requisition_id, rec.requisition_number, co_user_id_value, co_user_name_value,
                                rec.payment_method, rec.amount,
                                COALESCE(rec.description, '') || FORMAT(' (Recurring: %s)', current_date_iter::TEXT),
                                rec.bill_type, current_date_iter, 'pending', FALSE, rec.created_by,
                                jsonb_build_object('parent_schedule_id', rec.id, 'occurrence_date', current_date_iter, 'recurring_type', rec.recurring_type)
                            );
                        END IF;
                        occurrences_created := occurrences_created + 1;
                    END IF;
                    current_date_iter := current_date_iter + INTERVAL '1 day';
                END LOOP;
            END;
            
        WHEN 'monthly_date' THEN
            -- Generate monthly occurrences by date position
            DECLARE
                month_position TEXT;
                target_date DATE;
                current_month DATE;
                end_month DATE;
            BEGIN
                month_position := rec.recurring_metadata->>'month_position';
                current_month := DATE_TRUNC('month', CURRENT_DATE);
                end_month := TO_DATE(rec.recurring_metadata->>'until_month' || '-01', 'YYYY-MM-DD');
                
                WHILE current_month <= end_month LOOP
                    -- Calculate target date based on position
                    IF month_position = 'start' THEN
                        target_date := current_month;
                    ELSIF month_position = 'middle' THEN
                        target_date := current_month + INTERVAL '15 days';
                    ELSIF month_position = 'end' THEN
                        target_date := (current_month + INTERVAL '1 month' - INTERVAL '1 day')::DATE;
                    END IF;
                    
                    IF target_date >= CURRENT_DATE THEN
                        -- Create occurrence
                        IF p_source_table = 'non_approved_payment_scheduler' THEN
                            INSERT INTO non_approved_payment_scheduler (
                                schedule_type, branch_id, branch_name, expense_category_id,
                                expense_category_name_en, expense_category_name_ar,
                                co_user_id, co_user_name, payment_method, amount,
                                description, bill_type, due_date, approver_id,
                                approver_name, approval_status, created_by, recurring_metadata
                            ) VALUES (
                                'single_bill', rec.branch_id, rec.branch_name, rec.expense_category_id,
                                rec.expense_category_name_en, rec.expense_category_name_ar,
                                co_user_id_value, co_user_name_value, rec.payment_method, rec.amount,
                                COALESCE(rec.description, '') || FORMAT(' (Recurring: %s)', target_date::TEXT),
                                rec.bill_type, target_date, rec.approver_id,
                                rec.approver_name, 'pending', rec.created_by,
                                jsonb_build_object('parent_schedule_id', rec.id, 'occurrence_date', target_date, 'recurring_type', rec.recurring_type)
                            );
                        ELSE
                            INSERT INTO expense_scheduler (
                                schedule_type, branch_id, branch_name, expense_category_id,
                                expense_category_name_en, expense_category_name_ar,
                                requisition_id, requisition_number, co_user_id, co_user_name,
                                payment_method, amount, description, bill_type, due_date,
                                status, is_paid, created_by, recurring_metadata
                            ) VALUES (
                                'single_bill', rec.branch_id, rec.branch_name, rec.expense_category_id,
                                rec.expense_category_name_en, rec.expense_category_name_ar,
                                rec.requisition_id, rec.requisition_number, co_user_id_value, co_user_name_value,
                                rec.payment_method, rec.amount,
                                COALESCE(rec.description, '') || FORMAT(' (Recurring: %s)', target_date::TEXT),
                                rec.bill_type, target_date, 'pending', FALSE, rec.created_by,
                                jsonb_build_object('parent_schedule_id', rec.id, 'occurrence_date', target_date, 'recurring_type', rec.recurring_type)
                            );
                        END IF;
                        occurrences_created := occurrences_created + 1;
                    END IF;
                    
                    current_month := current_month + INTERVAL '1 month';
                END LOOP;
            END;
            
        WHEN 'monthly_day' THEN
            -- Generate monthly occurrences by specific day
            DECLARE
                day_of_month INTEGER;
                current_month DATE;
                end_month DATE;
                target_date DATE;
            BEGIN
                day_of_month := (rec.recurring_metadata->>'day_of_month')::INTEGER;
                current_month := DATE_TRUNC('month', CURRENT_DATE);
                end_month := TO_DATE(rec.recurring_metadata->>'until_month' || '-01', 'YYYY-MM-DD');
                
                WHILE current_month <= end_month LOOP
                    target_date := current_month + (day_of_month - 1) * INTERVAL '1 day';
                    
                    IF target_date >= CURRENT_DATE AND EXTRACT(DAY FROM target_date) = day_of_month THEN
                        -- Create occurrence
                        IF p_source_table = 'non_approved_payment_scheduler' THEN
                            INSERT INTO non_approved_payment_scheduler (
                                schedule_type, branch_id, branch_name, expense_category_id,
                                expense_category_name_en, expense_category_name_ar,
                                co_user_id, co_user_name, payment_method, amount,
                                description, bill_type, due_date, approver_id,
                                approver_name, approval_status, created_by, recurring_metadata
                            ) VALUES (
                                'single_bill', rec.branch_id, rec.branch_name, rec.expense_category_id,
                                rec.expense_category_name_en, rec.expense_category_name_ar,
                                co_user_id_value, co_user_name_value, rec.payment_method, rec.amount,
                                COALESCE(rec.description, '') || FORMAT(' (Recurring: %s)', target_date::TEXT),
                                rec.bill_type, target_date, rec.approver_id,
                                rec.approver_name, 'pending', rec.created_by,
                                jsonb_build_object('parent_schedule_id', rec.id, 'occurrence_date', target_date, 'recurring_type', rec.recurring_type)
                            );
                        ELSE
                            INSERT INTO expense_scheduler (
                                schedule_type, branch_id, branch_name, expense_category_id,
                                expense_category_name_en, expense_category_name_ar,
                                requisition_id, requisition_number, co_user_id, co_user_name,
                                payment_method, amount, description, bill_type, due_date,
                                status, is_paid, created_by, recurring_metadata
                            ) VALUES (
                                'single_bill', rec.branch_id, rec.branch_name, rec.expense_category_id,
                                rec.expense_category_name_en, rec.expense_category_name_ar,
                                rec.requisition_id, rec.requisition_number, co_user_id_value, co_user_name_value,
                                rec.payment_method, rec.amount,
                                COALESCE(rec.description, '') || FORMAT(' (Recurring: %s)', target_date::TEXT),
                                rec.bill_type, target_date, 'pending', FALSE, rec.created_by,
                                jsonb_build_object('parent_schedule_id', rec.id, 'occurrence_date', target_date, 'recurring_type', rec.recurring_type)
                            );
                        END IF;
                        occurrences_created := occurrences_created + 1;
                    END IF;
                    
                    current_month := current_month + INTERVAL '1 month';
                END LOOP;
            END;
            
        WHEN 'custom' THEN
            -- Generate custom date occurrences
            DECLARE
                custom_dates_json JSONB;
                custom_date TEXT;
            BEGIN
                custom_dates_json := rec.recurring_metadata->'custom_dates';
                
                IF custom_dates_json IS NOT NULL THEN
                    FOR custom_date IN SELECT jsonb_array_elements_text(custom_dates_json)
                    LOOP
                        IF custom_date::DATE >= CURRENT_DATE THEN
                            -- Create occurrence
                            IF p_source_table = 'non_approved_payment_scheduler' THEN
                                INSERT INTO non_approved_payment_scheduler (
                                    schedule_type, branch_id, branch_name, expense_category_id,
                                    expense_category_name_en, expense_category_name_ar,
                                    co_user_id, co_user_name, payment_method, amount,
                                    description, bill_type, due_date, approver_id,
                                    approver_name, approval_status, created_by, recurring_metadata
                                ) VALUES (
                                    'single_bill', rec.branch_id, rec.branch_name, rec.expense_category_id,
                                    rec.expense_category_name_en, rec.expense_category_name_ar,
                                    co_user_id_value, co_user_name_value, rec.payment_method, rec.amount,
                                    COALESCE(rec.description, '') || FORMAT(' (Recurring: %s)', custom_date::DATE::TEXT),
                                    rec.bill_type, custom_date::DATE, rec.approver_id,
                                    rec.approver_name, 'pending', rec.created_by,
                                    jsonb_build_object('parent_schedule_id', rec.id, 'occurrence_date', custom_date::DATE, 'recurring_type', rec.recurring_type)
                                );
                            ELSE
                                INSERT INTO expense_scheduler (
                                    schedule_type, branch_id, branch_name, expense_category_id,
                                    expense_category_name_en, expense_category_name_ar,
                                    requisition_id, requisition_number, co_user_id, co_user_name,
                                    payment_method, amount, description, bill_type, due_date,
                                    status, is_paid, created_by, recurring_metadata
                                ) VALUES (
                                    'single_bill', rec.branch_id, rec.branch_name, rec.expense_category_id,
                                    rec.expense_category_name_en, rec.expense_category_name_ar,
                                    rec.requisition_id, rec.requisition_number, co_user_id_value, co_user_name_value,
                                    rec.payment_method, rec.amount,
                                    COALESCE(rec.description, '') || FORMAT(' (Recurring: %s)', custom_date::DATE::TEXT),
                                    rec.bill_type, custom_date::DATE, 'pending', FALSE, rec.created_by,
                                    jsonb_build_object('parent_schedule_id', rec.id, 'occurrence_date', custom_date::DATE, 'recurring_type', rec.recurring_type)
                                );
                            END IF;
                            occurrences_created := occurrences_created + 1;
                        END IF;
                    END LOOP;
                END IF;
            END;
            
        ELSE
            RAISE EXCEPTION 'Unsupported recurring_type: %', rec.recurring_type;
    END CASE;

    -- Delete the parent recurring schedule after creating all occurrences
    -- The occurrences are now independent and linked via recurring_metadata
    IF p_source_table = 'expense_scheduler' THEN
        DELETE FROM expense_scheduler WHERE id = p_parent_id;
    ELSIF p_source_table = 'non_approved_payment_scheduler' THEN
        DELETE FROM non_approved_payment_scheduler WHERE id = p_parent_id;
    END IF;

    occurrence_count := occurrences_created;
    message := FORMAT('Successfully created %s occurrences for recurring schedule ID %s (parent deleted)', occurrences_created, p_parent_id);
    RETURN NEXT;
END;
$$;



--
-- Name: FUNCTION generate_recurring_occurrences(p_parent_id integer, p_source_table text); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.generate_recurring_occurrences(p_parent_id integer, p_source_table text) IS 'Generates all future occurrences immediately when a recurring schedule is created. This allows users to see, modify, or cancel individual occurrences.';


--
-- Name: generate_salt(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.generate_salt() RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN gen_salt('bf', 8);
END;
$$;



--
-- Name: generate_unique_customer_access_code(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.generate_unique_customer_access_code() RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_access_code text;
    code_exists boolean;
    attempts integer := 0;
    max_attempts integer := 100;
BEGIN
    LOOP
        v_access_code := LPAD(FLOOR(random() * 1000000)::text, 6, '0');
        SELECT EXISTS(
            SELECT 1 FROM public.customers c
            WHERE c.access_code = encode(extensions.digest(v_access_code::bytea, 'sha256'), 'hex')
        ) INTO code_exists;
        IF NOT code_exists THEN
            RETURN v_access_code;
        END IF;
        attempts := attempts + 1;
        IF attempts >= max_attempts THEN
            RAISE EXCEPTION 'Unable to generate unique access code after % attempts', max_attempts;
        END IF;
    END LOOP;
END;
$$;



--
-- Name: generate_unique_quick_access_code(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.generate_unique_quick_access_code() RETURNS character varying
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_code VARCHAR(6);
BEGIN
  LOOP
    v_code := LPAD(FLOOR(RANDOM() * 1000000)::TEXT, 6, '0');
    EXIT WHEN NOT EXISTS (
      SELECT 1 FROM users
      WHERE extensions.crypt(v_code, quick_access_code) = quick_access_code
    );
  END LOOP;
  RETURN v_code;
END;
$$;



--
-- Name: generate_warning_reference(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.generate_warning_reference() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.warning_reference IS NULL OR NEW.warning_reference = '' THEN
        NEW.warning_reference = 'WRN-' || TO_CHAR(NEW.created_at, 'YYYYMMDD') || '-' || LPAD(nextval('warning_ref_seq')::text, 4, '0');
    END IF;
    RETURN NEW;
END;
$$;



--
-- Name: get_active_break(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_active_break(p_user_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_break RECORD;
  v_reason RECORD;
BEGIN
  SELECT br.*, br.reason_id as rid
  INTO v_break
  FROM break_register br
  WHERE br.user_id = p_user_id AND br.status = 'open'
  LIMIT 1;

  IF v_break IS NULL THEN
    RETURN jsonb_build_object('active', false);
  END IF;

  SELECT name_en, name_ar INTO v_reason
  FROM break_reasons WHERE id = v_break.rid;

  RETURN jsonb_build_object(
    'active', true,
    'break_id', v_break.id,
    'start_time', v_break.start_time,
    'reason_en', v_reason.name_en,
    'reason_ar', v_reason.name_ar,
    'reason_note', v_break.reason_note
  );
END;
$$;



--
-- Name: get_active_customer_media(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_active_customer_media() RETURNS TABLE(id uuid, media_type character varying, slot_number integer, title_en character varying, title_ar character varying, file_url text, duration integer, display_order integer)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        cam.id,
        cam.media_type,
        cam.slot_number,
        cam.title_en,
        cam.title_ar,
        cam.file_url,
        cam.duration,
        cam.display_order
    FROM customer_app_media cam
    WHERE cam.is_active = true
      AND (
          cam.is_infinite = true 
          OR cam.expiry_date > NOW()
      )
    ORDER BY cam.display_order ASC, cam.created_at DESC;
END;
$$;



--
-- Name: FUNCTION get_active_customer_media(); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.get_active_customer_media() IS 'Returns all active non-expired media for customer home page display';


--
-- Name: get_active_employees_by_branch(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_active_employees_by_branch(branch_uuid uuid) RETURNS TABLE(id uuid, employee_id character varying, first_name character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.id,
        e.employee_id,
        e.first_name
    FROM employees e
    WHERE e.branch_id = branch_uuid 
    AND e.status = 'active'
    ORDER BY e.first_name;
END;
$$;



--
-- Name: get_active_flyer_templates(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_active_flyer_templates() RETURNS TABLE(id uuid, name character varying, description text, first_page_image_url text, sub_page_image_urls text[], first_page_configuration jsonb, sub_page_configurations jsonb, metadata jsonb, is_default boolean, category character varying, tags text[], usage_count integer, last_used_at timestamp with time zone, created_at timestamp with time zone)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    t.id,
    t.name,
    t.description,
    t.first_page_image_url,
    t.sub_page_image_urls,
    t.first_page_configuration,
    t.sub_page_configurations,
    t.metadata,
    t.is_default,
    t.category,
    t.tags,
    t.usage_count,
    t.last_used_at,
    t.created_at
  FROM flyer_templates t
  WHERE t.is_active = true 
    AND t.deleted_at IS NULL
  ORDER BY 
    t.is_default DESC,
    t.usage_count DESC,
    t.created_at DESC;
END;
$$;



--
-- Name: get_active_offers_for_customer(uuid, integer, character varying); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_active_offers_for_customer(p_customer_id uuid, p_branch_id integer DEFAULT NULL::integer, p_service_type character varying DEFAULT 'both'::character varying) RETURNS TABLE(offer_id integer, offer_type character varying, name_ar character varying, name_en character varying, discount_type character varying, discount_value numeric, start_date timestamp with time zone, end_date timestamp with time zone, service_type character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        o.id,
        o.type,
        o.name_ar,
        o.name_en,
        o.discount_type,
        o.discount_value,
        o.start_date,
        o.end_date,
        o.service_type
    FROM offers o
    WHERE o.is_active = true
        AND NOW() BETWEEN o.start_date AND o.end_date
        AND (o.branch_id IS NULL OR o.branch_id = p_branch_id)
        AND (o.service_type = 'both' OR o.service_type = p_service_type)
        AND (
            -- General offers (not customer-specific)
            o.type != 'customer'
            OR
            -- Customer-specific offers assigned to this customer
            EXISTS (
                SELECT 1 FROM customer_offers co
                WHERE co.offer_id = o.id
                    AND co.customer_id = p_customer_id
                    AND co.is_used = false
            )
        )
        AND (
            -- Check max total uses not exceeded
            o.max_total_uses IS NULL OR o.current_total_uses < o.max_total_uses
        )
    ORDER BY o.priority DESC, o.created_at DESC;
END;
$$;



--
-- Name: get_all_branches_delivery_settings(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_all_branches_delivery_settings() RETURNS TABLE(branch_id bigint, branch_name_en text, branch_name_ar text, minimum_order_amount numeric, delivery_service_enabled boolean, delivery_is_24_hours boolean, delivery_start_time time without time zone, delivery_end_time time without time zone, pickup_service_enabled boolean, pickup_is_24_hours boolean, pickup_start_time time without time zone, pickup_end_time time without time zone, delivery_message_ar text, delivery_message_en text, location_url text, latitude double precision, longitude double precision)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        b.id,
        b.name_en::text,
        b.name_ar::text,
        COALESCE(b.minimum_order_amount, 15.00)::numeric,
        COALESCE(b.delivery_service_enabled, true)::boolean,
        COALESCE(b.delivery_is_24_hours, true)::boolean,
        b.delivery_start_time,
        b.delivery_end_time,
        COALESCE(b.pickup_service_enabled, true)::boolean,
        COALESCE(b.pickup_is_24_hours, true)::boolean,
        b.pickup_start_time,
        b.pickup_end_time,
        COALESCE(b.delivery_message_ar, 'التوصيل متاح على مدار الساعة')::text,
        COALESCE(b.delivery_message_en, 'Delivery available 24/7')::text,
        b.location_url,
        b.latitude,
        b.longitude
    FROM public.branches b
    ORDER BY b.name_en;
END;
$$;



--
-- Name: get_all_breaks(date, date, integer, character varying); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_all_breaks(p_date_from date DEFAULT NULL::date, p_date_to date DEFAULT NULL::date, p_branch_id integer DEFAULT NULL::integer, p_status character varying DEFAULT NULL::character varying) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_result JSONB;
BEGIN
  SELECT COALESCE(jsonb_agg(row_to_json(t)::jsonb ORDER BY t.start_time DESC), '[]'::jsonb)
  INTO v_result
  FROM (
    SELECT
      br.id,
      br.employee_id,
      br.employee_name_en,
      br.employee_name_ar,
      br.branch_id,
      b.name_en as branch_name_en,
      b.name_ar as branch_name_ar,
      r.name_en as reason_en,
      r.name_ar as reason_ar,
      br.reason_note,
      br.start_time,
      br.end_time,
      br.duration_seconds,
      br.status
    FROM break_register br
    JOIN break_reasons r ON r.id = br.reason_id
    LEFT JOIN branches b ON b.id = br.branch_id
    WHERE (p_date_from IS NULL OR br.start_time::DATE >= p_date_from)
      AND (p_date_to IS NULL OR br.start_time::DATE <= p_date_to)
      AND (p_branch_id IS NULL OR br.branch_id = p_branch_id)
      AND (p_status IS NULL OR br.status = p_status)
    ORDER BY br.start_time DESC
    LIMIT 500
  ) t;

  RETURN jsonb_build_object('breaks', v_result);
END;
$$;



--
-- Name: get_all_delivery_tiers(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_all_delivery_tiers() RETURNS TABLE(id uuid, min_order_amount numeric, max_order_amount numeric, delivery_fee numeric, tier_order integer, is_active boolean, description_en text, description_ar text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        t.id,
        t.min_order_amount,
        t.max_order_amount,
        t.delivery_fee,
        t.tier_order,
        t.is_active,
        t.description_en,
        t.description_ar
    FROM public.delivery_fee_tiers t
    WHERE t.is_active = true
    ORDER BY t.tier_order ASC;
END;
$$;



--
-- Name: FUNCTION get_all_delivery_tiers(); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.get_all_delivery_tiers() IS 'Get all active delivery fee tiers ordered for display';


--
-- Name: get_all_expiry_products(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_all_expiry_products() RETURNS TABLE(branch_id integer, barcode character varying, product_name_en character varying, product_name_ar character varying, expiry_date date, days_left integer, managed_by jsonb)
    LANGUAGE sql STABLE
    AS $$
  SELECT
    (entry->>'branch_id')::integer AS branch_id,
    p.barcode,
    p.product_name_en,
    p.product_name_ar,
    (entry->>'expiry_date')::date AS expiry_date,
    ((entry->>'expiry_date')::date - CURRENT_DATE) AS days_left,
    p.managed_by
  FROM erp_synced_products p,
    jsonb_array_elements(p.expiry_dates) AS entry
  WHERE jsonb_array_length(p.expiry_dates) > 0
    AND (p.expiry_hidden IS NOT TRUE)
    AND (entry->>'expiry_date') IS NOT NULL
    AND (entry->>'branch_id') IS NOT NULL
  ORDER BY ((entry->>'expiry_date')::date - CURRENT_DATE) ASC, p.barcode;
$$;



--
-- Name: get_all_expiry_products(integer, integer, text, text, integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_all_expiry_products(p_page integer DEFAULT 1, p_page_size integer DEFAULT 1000, p_search_barcode text DEFAULT NULL::text, p_search_name text DEFAULT NULL::text, p_branch_id integer DEFAULT NULL::integer) RETURNS TABLE(branch_id integer, barcode character varying, product_name_en character varying, product_name_ar character varying, expiry_date date, days_left integer, managed_by jsonb, total_count bigint)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
  v_offset integer;
  v_limit integer;
BEGIN
  v_offset := CASE WHEN (p_search_barcode IS NOT NULL OR p_search_name IS NOT NULL) THEN 0 ELSE (p_page - 1) * p_page_size END;
  v_limit := CASE WHEN (p_search_barcode IS NOT NULL OR p_search_name IS NOT NULL) THEN NULL ELSE p_page_size END;

  RETURN QUERY
  SELECT
    (entry->>'branch_id')::integer AS branch_id,
    p.barcode,
    p.product_name_en,
    p.product_name_ar,
    (entry->>'expiry_date')::date AS expiry_date,
    ((entry->>'expiry_date')::date - CURRENT_DATE)::integer AS days_left,
    p.managed_by,
    count(*) OVER() AS total_count
  FROM erp_synced_products p,
    jsonb_array_elements(p.expiry_dates) AS entry
  WHERE p.expiry_hidden IS NOT TRUE
    AND jsonb_array_length(p.expiry_dates) > 0
    AND (entry->>'expiry_date') IS NOT NULL
    AND (entry->>'branch_id') IS NOT NULL
    AND (p_branch_id IS NULL OR (entry->>'branch_id')::integer = p_branch_id)
    AND (p_search_barcode IS NULL OR p.barcode ILIKE '%' || p_search_barcode || '%')
    AND (p_search_name IS NULL OR p.product_name_en ILIKE '%' || p_search_name || '%' OR p.product_name_ar ILIKE '%' || p_search_name || '%')
  ORDER BY ((entry->>'expiry_date')::date - CURRENT_DATE) ASC, p.barcode
  LIMIT v_limit
  OFFSET v_offset;
END;
$$;



--
-- Name: get_all_products_master(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_all_products_master() RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_result jsonb;
BEGIN
  SELECT COALESCE(jsonb_agg(
    jsonb_build_object(
      'id', p.id,
      'barcode', p.barcode,
      'product_name_en', p.product_name_en,
      'product_name_ar', p.product_name_ar,
      'image_url', p.image_url,
      'unit_name', COALESCE(u.name_en, ''),
      'unit_name_ar', COALESCE(u.name_ar, ''),
      'parent_category', COALESCE(c.name_en, ''),
      'parent_category_ar', COALESCE(c.name_ar, '')
    )
    ORDER BY (CASE WHEN p.image_url IS NOT NULL AND p.image_url <> '' THEN 0 ELSE 1 END), p.product_name_en
  ), '[]'::jsonb) INTO v_result
  FROM products p
  LEFT JOIN product_units u ON p.unit_id = u.id
  LEFT JOIN product_categories c ON p.category_id = c.id;
  
  RETURN v_result;
END;
$$;



--
-- Name: get_all_receiving_tasks(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_all_receiving_tasks() RETURNS TABLE(id uuid, receiving_record_id uuid, template_id uuid, role_type character varying, title text, description text, priority character varying, task_status character varying, task_completed boolean, due_date timestamp with time zone, assigned_user_id uuid, completed_at timestamp with time zone, completed_by_user_id uuid, clearance_certificate_url text, created_at timestamp with time zone, bill_number character varying, bill_amount numeric, vendor_name text, branch_name text, assigned_user_name text, completed_by_user_name text, is_overdue boolean, days_until_due integer)
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
    -- Receiving record details
    rr.bill_number,
    rr.bill_amount,
    v.vendor_name,
    b.name_en as branch_name,
    -- User details
    u1.username as assigned_user_name,
    u2.username as completed_by_user_name,
    -- Calculated fields
    (rt.due_date < NOW() AND rt.task_status != 'completed') as is_overdue,
    EXTRACT(DAY FROM (rt.due_date - NOW()))::INTEGER as days_until_due
  FROM receiving_tasks rt
  LEFT JOIN receiving_records rr ON rr.id = rt.receiving_record_id
  LEFT JOIN vendors v ON v.erp_vendor_id = rr.vendor_id AND v.branch_id = rr.branch_id
  LEFT JOIN branches b ON b.id = rr.branch_id
  LEFT JOIN users u1 ON u1.id = rt.assigned_user_id
  LEFT JOIN users u2 ON u2.id = rt.completed_by_user_id
  ORDER BY rt.created_at DESC, rt.priority DESC;
END;
$$;



--
-- Name: get_all_users(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_all_users() RETURNS TABLE(id uuid, username character varying, email character varying, role_type character varying, status character varying, employee_id uuid, created_at timestamp with time zone, updated_at timestamp with time zone)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        u.id,
        u.username,
        u.email,
        -- Use admin flags instead of role_type column
        CASE 
            WHEN u.is_master_admin THEN 'Master Admin'::VARCHAR
            WHEN u.is_admin THEN 'Admin'::VARCHAR
            ELSE 'User'::VARCHAR
        END as role_type,
        'active'::VARCHAR as status,
        u.employee_id,
        u.created_at,
        u.updated_at
    FROM users u
    WHERE u.deleted_at IS NULL
    ORDER BY u.created_at DESC;
END;
$$;



--
-- Name: get_analytics_log_tables(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_analytics_log_tables() RETURNS TABLE(table_name text, total_size text, raw_size bigint, row_estimate bigint)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    r.tablename AS table_name,
    r.total_size,
    r.raw_size,
    r.row_estimate
  FROM dblink(
    'dbname=_supabase user=supabase_admin',
    'SELECT
      t.tablename::text,
      pg_size_pretty(pg_total_relation_size(quote_ident(t.schemaname) || ''.'' || quote_ident(t.tablename)))::text AS total_size,
      pg_total_relation_size(quote_ident(t.schemaname) || ''.'' || quote_ident(t.tablename)) AS raw_size,
      COALESCE(c.reltuples, 0)::bigint AS row_estimate
    FROM pg_tables t
    LEFT JOIN pg_class c ON c.relname = t.tablename AND c.relnamespace = (SELECT oid FROM pg_namespace WHERE nspname = t.schemaname)
    WHERE t.schemaname = ''_analytics'' AND t.tablename LIKE ''log_events_%''
    ORDER BY pg_total_relation_size(quote_ident(t.schemaname) || ''.'' || quote_ident(t.tablename)) DESC'
  ) AS r(tablename text, total_size text, raw_size bigint, row_estimate bigint);
END;
$$;



--
-- Name: get_app_icons(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_app_icons() RETURNS TABLE(id uuid, name text, icon_key text, category text, storage_path text, mime_type text, file_size bigint, description text, is_active boolean, created_at timestamp with time zone, updated_at timestamp with time zone)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    SELECT id, name, icon_key, category, storage_path, mime_type, file_size, description, is_active, created_at, updated_at
    FROM public.app_icons
    ORDER BY category, name;
$$;



--
-- Name: get_approval_center_data(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_approval_center_data(p_user_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_permissions JSONB;
  v_can_approve_vendor_payments BOOLEAN := FALSE;
  v_can_approve_leave_requests BOOLEAN := FALSE;
  v_can_approve_purchase_vouchers BOOLEAN := FALSE;
  v_visibility_type VARCHAR;
  v_vendor_payment_amount_limit NUMERIC := 0;
  v_two_days_date DATE;
  v_result JSONB;
  v_requisitions JSONB;
  v_payment_schedules JSONB;
  v_vendor_payments JSONB;
  v_purchase_vouchers JSONB;
  v_my_requisitions JSONB;
  v_my_schedules JSONB;
  v_my_vouchers JSONB;
  v_day_off_requests JSONB;
  v_my_day_off_requests JSONB;
  v_user_names JSONB;
  v_employee_names JSONB;
  v_current_user_employee JSONB;
BEGIN
  -- 1) Get approval permissions
  SELECT jsonb_build_object(
    'id', ap.id,
    'user_id', ap.user_id,
    'can_approve_requisitions', ap.can_approve_requisitions,
    'requisition_amount_limit', ap.requisition_amount_limit,
    'can_approve_single_bill', ap.can_approve_single_bill,
    'single_bill_amount_limit', ap.single_bill_amount_limit,
    'can_approve_multiple_bill', ap.can_approve_multiple_bill,
    'multiple_bill_amount_limit', ap.multiple_bill_amount_limit,
    'can_approve_recurring_bill', ap.can_approve_recurring_bill,
    'recurring_bill_amount_limit', ap.recurring_bill_amount_limit,
    'can_approve_vendor_payments', ap.can_approve_vendor_payments,
    'vendor_payment_amount_limit', ap.vendor_payment_amount_limit,
    'can_approve_leave_requests', ap.can_approve_leave_requests,
    'can_approve_purchase_vouchers', ap.can_approve_purchase_vouchers,
    'can_add_missing_punches', ap.can_add_missing_punches,
    'is_active', ap.is_active
  ) INTO v_permissions
  FROM approval_permissions ap
  WHERE ap.user_id = p_user_id AND ap.is_active = TRUE
  LIMIT 1;

  -- Extract permission flags
  IF v_permissions IS NOT NULL THEN
    v_can_approve_vendor_payments := COALESCE((v_permissions->>'can_approve_vendor_payments')::BOOLEAN, FALSE);
    v_can_approve_leave_requests := COALESCE((v_permissions->>'can_approve_leave_requests')::BOOLEAN, FALSE);
    v_can_approve_purchase_vouchers := COALESCE((v_permissions->>'can_approve_purchase_vouchers')::BOOLEAN, FALSE);
    v_vendor_payment_amount_limit := COALESCE((v_permissions->>'vendor_payment_amount_limit')::NUMERIC, 0);
  END IF;

  -- Calculate two days from now for due date filtering
  v_two_days_date := CURRENT_DATE + INTERVAL '2 days';

  -- Fetch current user employee name
  SELECT jsonb_build_object('name_en', e.name_en, 'name_ar', e.name_ar)
  INTO v_current_user_employee
  FROM hr_employee_master e
  WHERE e.user_id = p_user_id
  LIMIT 1;

  -- 2) Pending requisitions where user is approver
  SELECT COALESCE(jsonb_agg(row_to_json(r)::JSONB ORDER BY r.created_at DESC), '[]'::JSONB)
  INTO v_requisitions
  FROM (
    SELECT * FROM expense_requisitions
    WHERE approver_id = p_user_id AND status = 'pending'
    ORDER BY created_at DESC
    LIMIT 200
  ) r;

  -- 3) Pending payment schedules where user is approver (single_bill + multiple_bill)
  SELECT COALESCE(jsonb_agg(row_to_json(s)::JSONB ORDER BY s.created_at DESC), '[]'::JSONB)
  INTO v_payment_schedules
  FROM (
    SELECT naps.*,
      jsonb_build_object('id', u.id, 'username', u.username,
        'hr_employee_master', CASE WHEN e.name_en IS NOT NULL THEN jsonb_build_object('name_en', e.name_en, 'name_ar', e.name_ar) ELSE NULL END
      ) AS creator
    FROM non_approved_payment_scheduler naps
    LEFT JOIN users u ON u.id = naps.created_by
    LEFT JOIN hr_employee_master e ON e.user_id = naps.created_by
    WHERE naps.approval_status = 'pending'
      AND naps.approver_id = p_user_id
      AND naps.schedule_type IN ('single_bill', 'multiple_bill')
    ORDER BY naps.created_at DESC
    LIMIT 200
  ) s;

  -- 4) Vendor payments requiring approval (conditional on permission)
  IF v_can_approve_vendor_payments THEN
    SELECT COALESCE(jsonb_agg(row_to_json(vp)::JSONB ORDER BY vp.approval_requested_at DESC), '[]'::JSONB)
    INTO v_vendor_payments
    FROM (
      SELECT vps.*,
        jsonb_build_object('id', u.id, 'username', u.username,
          'hr_employee_master', CASE WHEN e.name_en IS NOT NULL THEN jsonb_build_object('name_en', e.name_en, 'name_ar', e.name_ar) ELSE NULL END
        ) AS requester
      FROM vendor_payment_schedule vps
      LEFT JOIN users u ON u.id = vps.approval_requested_by
      LEFT JOIN hr_employee_master e ON e.user_id = vps.approval_requested_by
      WHERE vps.approval_status = 'sent_for_approval'
        AND vps.assigned_approver_id = p_user_id
      ORDER BY vps.approval_requested_at DESC
      LIMIT 200
    ) vp;
  ELSE
    v_vendor_payments := '[]'::JSONB;
  END IF;

  -- 4b) Purchase vouchers requiring approval (conditional on permission)
  IF v_can_approve_purchase_vouchers THEN
    SELECT COALESCE(jsonb_agg(row_to_json(pv)::JSONB ORDER BY pv.issued_date DESC), '[]'::JSONB)
    INTO v_purchase_vouchers
    FROM (
      SELECT pvi.*,
        jsonb_build_object('id', u.id, 'username', u.username,
          'hr_employee_master', CASE WHEN e.name_en IS NOT NULL THEN jsonb_build_object('name_en', e.name_en, 'name_ar', e.name_ar) ELSE NULL END
        ) AS issued_by_user,
        jsonb_build_object('id', b1.id, 'name_en', b1.name_en) AS stock_location_branch,
        jsonb_build_object('id', b2.id, 'name_en', b2.name_en) AS pending_location_branch,
        jsonb_build_object('id', u2.id, 'username', u2.username,
          'hr_employee_master', CASE WHEN e2.name_en IS NOT NULL THEN jsonb_build_object('name_en', e2.name_en, 'name_ar', e2.name_ar) ELSE NULL END
        ) AS pending_person_user
      FROM purchase_voucher_items pvi
      LEFT JOIN users u ON u.id = pvi.issued_by
      LEFT JOIN hr_employee_master e ON e.user_id = pvi.issued_by
      LEFT JOIN branches b1 ON b1.id = pvi.stock_location
      LEFT JOIN branches b2 ON b2.id = pvi.pending_stock_location
      LEFT JOIN users u2 ON u2.id = pvi.pending_stock_person
      LEFT JOIN hr_employee_master e2 ON e2.user_id = pvi.pending_stock_person
      WHERE pvi.approval_status = 'pending'
        AND pvi.approver_id = p_user_id
      ORDER BY pvi.issued_date DESC
      LIMIT 200
    ) pv;
  ELSE
    v_purchase_vouchers := '[]'::JSONB;
  END IF;

  -- 5) My created requisitions (pending)
  SELECT COALESCE(jsonb_agg(row_to_json(mr)::JSONB ORDER BY mr.created_at DESC), '[]'::JSONB)
  INTO v_my_requisitions
  FROM (
    SELECT * FROM expense_requisitions
    WHERE created_by = p_user_id AND status = 'pending'
    ORDER BY created_at DESC
    LIMIT 200
  ) mr;

  -- 6) My created payment schedules (pending)
  SELECT COALESCE(jsonb_agg(row_to_json(ms)::JSONB ORDER BY ms.created_at DESC), '[]'::JSONB)
  INTO v_my_schedules
  FROM (
    SELECT naps.*,
      jsonb_build_object('id', u.id, 'username', u.username,
        'hr_employee_master', CASE WHEN e.name_en IS NOT NULL THEN jsonb_build_object('name_en', e.name_en, 'name_ar', e.name_ar) ELSE NULL END
      ) AS approver
    FROM non_approved_payment_scheduler naps
    LEFT JOIN users u ON u.id = naps.approver_id
    LEFT JOIN hr_employee_master e ON e.user_id = naps.approver_id
    WHERE naps.created_by = p_user_id
      AND naps.approval_status = 'pending'
      AND naps.schedule_type IN ('single_bill', 'multiple_bill')
    ORDER BY naps.created_at DESC
    LIMIT 200
  ) ms;

  -- 6b) My created purchase vouchers (pending)
  SELECT COALESCE(jsonb_agg(row_to_json(mv)::JSONB ORDER BY mv.issued_date DESC), '[]'::JSONB)
  INTO v_my_vouchers
  FROM (
    SELECT pvi.*,
      jsonb_build_object('id', u.id, 'username', u.username,
        'hr_employee_master', CASE WHEN e.name_en IS NOT NULL THEN jsonb_build_object('name_en', e.name_en, 'name_ar', e.name_ar) ELSE NULL END
      ) AS approver_user
    FROM purchase_voucher_items pvi
    LEFT JOIN users u ON u.id = pvi.approver_id
    LEFT JOIN hr_employee_master e ON e.user_id = pvi.approver_id
    WHERE pvi.issued_by = p_user_id
      AND pvi.approval_status = 'pending'
    ORDER BY pvi.issued_date DESC
    LIMIT 200
  ) mv;

  -- 7) Day off requests requiring approval (conditional on permission)
  -- NOW FILTERS BY APPROVER VISIBILITY SCOPE
  IF v_can_approve_leave_requests THEN
    -- Get visibility configuration for this approver
    SELECT visibility_type INTO v_visibility_type
    FROM public.approver_visibility_config
    WHERE user_id = p_user_id AND is_active = true;
    
    -- Default to global if no visibility configuration found
    IF v_visibility_type IS NULL THEN
      v_visibility_type := 'global';
    END IF;
    
    -- Fetch day off requests based on visibility type
    IF v_visibility_type = 'global' THEN
      -- Global visibility: Show all pending day off requests
      SELECT COALESCE(jsonb_agg(row_to_json(dor)::JSONB ORDER BY dor.approval_requested_at DESC), '[]'::JSONB)
      INTO v_day_off_requests
      FROM (
        SELECT d.*,
          jsonb_build_object('id', u.id, 'username', u.username,
            'hr_employee_master', CASE WHEN e2.name_en IS NOT NULL THEN jsonb_build_object('name_en', e2.name_en, 'name_ar', e2.name_ar) ELSE NULL END
          ) AS requester,
          jsonb_build_object('id', e.id, 'name_en', e.name_en, 'name_ar', e.name_ar) AS employee,
          jsonb_build_object('id', dr.id, 'reason_en', dr.reason_en, 'reason_ar', dr.reason_ar) AS reason
        FROM day_off d
        LEFT JOIN users u ON u.id = d.approval_requested_by
        LEFT JOIN hr_employee_master e ON e.id = d.employee_id
        LEFT JOIN hr_employee_master e2 ON e2.user_id = d.approval_requested_by
        LEFT JOIN day_off_reasons dr ON dr.id = d.day_off_reason_id
        WHERE d.approval_status = 'pending'
        ORDER BY d.approval_requested_at DESC
        LIMIT 200
      ) dor;
    ELSE
      -- Branch-specific or multiple-branches: Filter by assigned branches
      SELECT COALESCE(jsonb_agg(row_to_json(dor)::JSONB ORDER BY dor.approval_requested_at DESC), '[]'::JSONB)
      INTO v_day_off_requests
      FROM (
        SELECT d.*,
          jsonb_build_object('id', u.id, 'username', u.username,
            'hr_employee_master', CASE WHEN e2.name_en IS NOT NULL THEN jsonb_build_object('name_en', e2.name_en, 'name_ar', e2.name_ar) ELSE NULL END
          ) AS requester,
          jsonb_build_object('id', e.id, 'name_en', e.name_en, 'name_ar', e.name_ar) AS employee,
          jsonb_build_object('id', dr.id, 'reason_en', dr.reason_en, 'reason_ar', dr.reason_ar) AS reason
        FROM day_off d
        LEFT JOIN users u ON u.id = d.approval_requested_by
        LEFT JOIN hr_employee_master e ON e.id = d.employee_id
        LEFT JOIN hr_employee_master e2 ON e2.user_id = d.approval_requested_by
        LEFT JOIN day_off_reasons dr ON dr.id = d.day_off_reason_id
        WHERE d.approval_status = 'pending'
          AND e.current_branch_id IN (
            SELECT branch_id FROM public.approver_branch_access
            WHERE user_id = p_user_id AND is_active = true
          )
        ORDER BY d.approval_requested_at DESC
        LIMIT 200
      ) dor;
    END IF;
  ELSE
    v_day_off_requests := '[]'::JSONB;
  END IF;

  -- 8) My day off requests (all statuses)
  SELECT COALESCE(jsonb_agg(row_to_json(mdo)::JSONB ORDER BY mdo.approval_requested_at DESC), '[]'::JSONB)
  INTO v_my_day_off_requests
  FROM (
    SELECT d.*,
      jsonb_build_object('id', dr.id, 'reason_en', dr.reason_en, 'reason_ar', dr.reason_ar) AS reason
    FROM day_off d
    LEFT JOIN day_off_reasons dr ON dr.id = d.day_off_reason_id
    WHERE d.approval_requested_by = p_user_id
    ORDER BY d.approval_requested_at DESC
    LIMIT 200
  ) mdo;

  -- 9) Collect unique user IDs from requisitions for username lookup
  SELECT COALESCE(jsonb_object_agg(u.id::TEXT, jsonb_build_object('id', u.id, 'username', u.username,
    'hr_employee_master', CASE WHEN e.name_en IS NOT NULL THEN jsonb_build_object('name_en', e.name_en, 'name_ar', e.name_ar) ELSE NULL END
  )), '{}'::JSONB)
  INTO v_user_names
  FROM users u
  LEFT JOIN hr_employee_master e ON e.user_id = u.id
  WHERE u.id IN (
    SELECT DISTINCT er.created_by FROM expense_requisitions er
    WHERE er.created_by IS NOT NULL
      AND (
        (er.approver_id = p_user_id AND er.status = 'pending')
        OR (er.created_by = p_user_id AND er.status = 'pending')
      )
  );

  -- 10) Collect employee names for vendor payment & day-off requesters
  SELECT COALESCE(jsonb_object_agg(e.user_id::TEXT, jsonb_build_object('user_id', e.user_id, 'name_en', e.name_en, 'name_ar', e.name_ar)), '{}'::JSONB)
  INTO v_employee_names
  FROM hr_employee_master e
  WHERE e.user_id IN (
    SELECT vps.approval_requested_by FROM vendor_payment_schedule vps
    WHERE vps.approval_status = 'sent_for_approval' AND vps.assigned_approver_id = p_user_id
    UNION
    SELECT d.approval_requested_by FROM day_off d
    WHERE d.approval_status = 'pending'
  );

  -- Build final result
  v_result := jsonb_build_object(
    'permissions', COALESCE(v_permissions, 'null'::JSONB),
    'requisitions', v_requisitions,
    'payment_schedules', v_payment_schedules,
    'vendor_payments', v_vendor_payments,
    'purchase_vouchers', v_purchase_vouchers,
    'my_requisitions', v_my_requisitions,
    'my_schedules', v_my_schedules,
    'my_vouchers', v_my_vouchers,
    'day_off_requests', v_day_off_requests,
    'my_day_off_requests', v_my_day_off_requests,
    'user_names', v_user_names,
    'employee_names', v_employee_names,
    'current_user_employee', COALESCE(v_current_user_employee, 'null'::JSONB),
    'two_days_date', v_two_days_date
  );

  RETURN v_result;
END;
$$;



--
-- Name: get_assignments_with_deadlines(uuid, integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_assignments_with_deadlines(user_id uuid DEFAULT NULL::uuid, days_ahead integer DEFAULT 7) RETURNS TABLE(id uuid, task_id uuid, task_title character varying, assigned_to uuid, assignee_name character varying, due_date date, priority character varying, status character varying, days_until_due integer)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ta.id,
        t.id as task_id,
        t.title as task_title,
        ta.assigned_to,
        u.username as assignee_name,
        t.due_date,
        ta.priority,
        ta.status,
        (t.due_date - CURRENT_DATE)::INTEGER as days_until_due
    FROM task_assignments ta
    JOIN tasks t ON ta.task_id = t.id
    LEFT JOIN users u ON ta.assigned_to = u.id
    WHERE (user_id IS NULL OR ta.assigned_to = user_id)
      AND t.due_date IS NOT NULL
      AND t.due_date <= CURRENT_DATE + INTERVAL '1 day' * days_ahead
      AND ta.status != 'completed'
      AND t.deleted_at IS NULL
    ORDER BY t.due_date ASC;
END;
$$;



--
-- Name: get_assignments_with_deadlines(text, uuid, boolean, integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_assignments_with_deadlines(p_user_id text DEFAULT NULL::text, p_branch_id uuid DEFAULT NULL::uuid, p_include_overdue boolean DEFAULT true, p_days_ahead integer DEFAULT 7) RETURNS TABLE(assignment_id uuid, task_id uuid, task_title text, task_description text, task_priority text, assignment_status text, assigned_to_user_id text, assigned_to_branch_id uuid, deadline_datetime timestamp with time zone, schedule_date date, schedule_time time without time zone, is_overdue boolean, hours_until_deadline numeric, is_reassignable boolean, notes text, require_task_finished boolean, require_photo_upload boolean, require_erp_reference boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ta.id as assignment_id,
        t.id as task_id,
        t.title as task_title,
        t.description as task_description,
        COALESCE(ta.priority_override, t.priority) as task_priority,
        ta.status as assignment_status,
        ta.assigned_to_user_id,
        ta.assigned_to_branch_id,
        ta.deadline_datetime,
        ta.schedule_date,
        ta.schedule_time,
        CASE 
            WHEN ta.deadline_datetime IS NOT NULL AND ta.deadline_datetime < now() 
                AND ta.status NOT IN ('completed', 'cancelled') 
            THEN true 
            ELSE false 
        END as is_overdue,
        CASE 
            WHEN ta.deadline_datetime IS NOT NULL 
            THEN EXTRACT(EPOCH FROM (ta.deadline_datetime - now()))/3600 
            ELSE NULL 
        END as hours_until_deadline,
        ta.is_reassignable,
        ta.notes,
        ta.require_task_finished,
        ta.require_photo_upload,
        ta.require_erp_reference
    FROM public.task_assignments ta
    JOIN public.tasks t ON ta.task_id = t.id
    WHERE 
        (p_user_id IS NULL OR ta.assigned_to_user_id = p_user_id) AND
        (p_branch_id IS NULL OR ta.assigned_to_branch_id = p_branch_id) AND
        ta.status NOT IN ('cancelled', 'reassigned') AND
        (
            p_include_overdue = true OR 
            ta.deadline_datetime IS NULL OR 
            ta.deadline_datetime >= now()
        ) AND
        (
            ta.deadline_datetime IS NULL OR 
            ta.deadline_datetime <= now() + (p_days_ahead || ' days')::interval
        )
    ORDER BY 
        CASE WHEN ta.deadline_datetime IS NOT NULL AND ta.deadline_datetime < now() THEN 1 ELSE 2 END,
        ta.deadline_datetime ASC NULLS LAST,
        ta.assigned_at DESC;
END;
$$;



--
-- Name: FUNCTION get_assignments_with_deadlines(p_user_id text, p_branch_id uuid, p_include_overdue boolean, p_days_ahead integer); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.get_assignments_with_deadlines(p_user_id text, p_branch_id uuid, p_include_overdue boolean, p_days_ahead integer) IS 'Retrieves assignments with deadline information and overdue status';


--
-- Name: get_branch_delivery_settings(bigint); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_branch_delivery_settings(p_branch_id bigint) RETURNS TABLE(branch_id bigint, branch_name_en text, branch_name_ar text, minimum_order_amount numeric, delivery_service_enabled boolean, delivery_is_24_hours boolean, delivery_start_time time without time zone, delivery_end_time time without time zone, pickup_service_enabled boolean, pickup_is_24_hours boolean, pickup_start_time time without time zone, pickup_end_time time without time zone, delivery_message_ar text, delivery_message_en text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        b.id,
        b.name_en::text,
        b.name_ar::text,
        COALESCE(b.minimum_order_amount, 15.00)::numeric,
        COALESCE(b.delivery_service_enabled, true)::boolean,
        COALESCE(b.delivery_is_24_hours, true)::boolean,
        b.delivery_start_time,
        b.delivery_end_time,
        COALESCE(b.pickup_service_enabled, true)::boolean,
        COALESCE(b.pickup_is_24_hours, true)::boolean,
        b.pickup_start_time,
        b.pickup_end_time,
        COALESCE(b.delivery_message_ar, 'التوصيل متاح على مدار الساعة')::text,
        COALESCE(b.delivery_message_en, 'Delivery available 24/7')::text
    FROM public.branches b
    WHERE b.id = p_branch_id
    LIMIT 1;
END;
$$;



--
-- Name: FUNCTION get_branch_delivery_settings(p_branch_id bigint); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.get_branch_delivery_settings(p_branch_id bigint) IS 'Get delivery settings for a specific branch with separate timings for delivery and pickup';


--
-- Name: get_branch_performance_dashboard(integer, date); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_branch_performance_dashboard(p_days_back integer DEFAULT 30, p_specific_date date DEFAULT NULL::date) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_from timestamp;
  v_to timestamp;
  v_branch_stats json;
  v_task_type_stats json;
  v_daily_stats json;
  v_top_employees json;
  v_assigned_by_stats json;
  v_checklist_stats json;
  v_totals json;
BEGIN
  IF p_specific_date IS NOT NULL THEN
    v_from := p_specific_date::timestamp;
    v_to := (p_specific_date + 1)::timestamp;
  ELSE
    v_from := NOW() - (p_days_back || ' days')::interval;
    v_to := NOW();
  END IF;

  -- 1. Overall totals
  SELECT json_build_object(
    'total_tasks', COALESCE(SUM(total), 0),
    'completed_tasks', COALESCE(SUM(completed), 0),
    'pending_tasks', COALESCE(SUM(pending), 0),
    'overdue_tasks', COALESCE(SUM(overdue), 0),
    'avg_completion_hours', ROUND(COALESCE(AVG(NULLIF(avg_hrs, 0)), 0)::numeric, 1),
    'total_checklists', COALESCE((SELECT COUNT(*) FROM hr_checklist_operations WHERE created_at >= v_from AND created_at < v_to), 0),
    'avg_checklist_score', COALESCE((SELECT ROUND(AVG(total_points::numeric / NULLIF(max_points, 0) * 100), 1) FROM hr_checklist_operations WHERE created_at >= v_from AND created_at < v_to), 0)
  ) INTO v_totals
  FROM (
    SELECT
      COUNT(*) as total,
      COUNT(*) FILTER (WHERE ta.status = 'completed') as completed,
      COUNT(*) FILTER (WHERE ta.status NOT IN ('completed','cancelled')) as pending,
      COUNT(*) FILTER (WHERE ta.status NOT IN ('completed','cancelled') AND ta.deadline_date < CURRENT_DATE) as overdue,
      EXTRACT(EPOCH FROM AVG(ta.completed_at - ta.assigned_at) FILTER (WHERE ta.status = 'completed')) / 3600 as avg_hrs
    FROM task_assignments ta
    WHERE ta.assigned_at >= v_from AND ta.assigned_at < v_to

    UNION ALL

    SELECT
      COUNT(*) as total,
      COUNT(*) FILTER (WHERE qta.status = 'completed') as completed,
      COUNT(*) FILTER (WHERE qta.status NOT IN ('completed','cancelled')) as pending,
      COUNT(*) FILTER (WHERE qta.status NOT IN ('completed','cancelled') AND qt.deadline_datetime < NOW()) as overdue,
      EXTRACT(EPOCH FROM AVG(qta.completed_at - qta.created_at) FILTER (WHERE qta.status = 'completed')) / 3600 as avg_hrs
    FROM quick_task_assignments qta
    JOIN quick_tasks qt ON qt.id = qta.quick_task_id
    WHERE qta.created_at >= v_from AND qta.created_at < v_to

    UNION ALL

    SELECT
      COUNT(*) as total,
      COUNT(*) FILTER (WHERE rt.task_status = 'completed') as completed,
      COUNT(*) FILTER (WHERE rt.task_status NOT IN ('completed','cancelled')) as pending,
      COUNT(*) FILTER (WHERE rt.task_status NOT IN ('completed','cancelled') AND rt.due_date < NOW()) as overdue,
      EXTRACT(EPOCH FROM AVG(rt.completed_at - rt.created_at) FILTER (WHERE rt.task_status = 'completed')) / 3600 as avg_hrs
    FROM receiving_tasks rt
    WHERE rt.created_at >= v_from AND rt.created_at < v_to
  ) sub;

  -- 2. Per-branch stats (tasks + checklists)
  SELECT COALESCE(json_agg(row_to_json(bs) ORDER BY bs.total_tasks DESC), '[]'::json)
  INTO v_branch_stats
  FROM (
    SELECT
      b.id as branch_id,
      b.name_en as branch_name_en,
      b.name_ar as branch_name_ar,
      b.location_en as branch_location_en,
      b.location_ar as branch_location_ar,
      COALESCE(r.total, 0) + COALESCE(q.total, 0) + COALESCE(rv.total, 0) as total_tasks,
      COALESCE(r.completed, 0) + COALESCE(q.completed, 0) + COALESCE(rv.completed, 0) as completed,
      COALESCE(r.pending, 0) + COALESCE(q.pending, 0) + COALESCE(rv.pending, 0) as pending,
      COALESCE(r.overdue, 0) + COALESCE(q.overdue, 0) + COALESCE(rv.overdue, 0) as overdue,
      COALESCE(r.regular_count, 0) as regular_count,
      COALESCE(q.quick_count, 0) as quick_count,
      COALESCE(rv.receiving_count, 0) as receiving_count,
      COALESCE(cl.checklist_count, 0) as checklist_count,
      COALESCE(cl.avg_checklist_score, 0) as avg_checklist_score,
      CASE WHEN (COALESCE(r.total, 0) + COALESCE(q.total, 0) + COALESCE(rv.total, 0)) > 0
        THEN ROUND(((COALESCE(r.completed, 0) + COALESCE(q.completed, 0) + COALESCE(rv.completed, 0))::numeric /
              (COALESCE(r.total, 0) + COALESCE(q.total, 0) + COALESCE(rv.total, 0))::numeric) * 100, 1)
        ELSE 0
      END as completion_rate
    FROM branches b
    LEFT JOIN (
      SELECT e.current_branch_id as branch_id, COUNT(*) as total, COUNT(*) as regular_count,
             COUNT(*) FILTER (WHERE ta.status = 'completed') as completed,
             COUNT(*) FILTER (WHERE ta.status NOT IN ('completed','cancelled')) as pending,
             COUNT(*) FILTER (WHERE ta.status NOT IN ('completed','cancelled') AND ta.deadline_date < CURRENT_DATE) as overdue
      FROM task_assignments ta JOIN hr_employee_master e ON e.user_id = ta.assigned_to_user_id
      WHERE ta.assigned_at >= v_from AND ta.assigned_at < v_to GROUP BY e.current_branch_id
    ) r ON r.branch_id = b.id
    LEFT JOIN (
      SELECT e.current_branch_id as branch_id, COUNT(*) as total, COUNT(*) as quick_count,
             COUNT(*) FILTER (WHERE qta.status = 'completed') as completed,
             COUNT(*) FILTER (WHERE qta.status NOT IN ('completed','cancelled')) as pending,
             COUNT(*) FILTER (WHERE qta.status NOT IN ('completed','cancelled') AND qt.deadline_datetime < NOW()) as overdue
      FROM quick_task_assignments qta JOIN quick_tasks qt ON qt.id = qta.quick_task_id
      JOIN hr_employee_master e ON e.user_id = qta.assigned_to_user_id
      WHERE qta.created_at >= v_from AND qta.created_at < v_to GROUP BY e.current_branch_id
    ) q ON q.branch_id = b.id
    LEFT JOIN (
      SELECT e.current_branch_id as branch_id, COUNT(*) as total, COUNT(*) as receiving_count,
             COUNT(*) FILTER (WHERE rt.task_status = 'completed') as completed,
             COUNT(*) FILTER (WHERE rt.task_status NOT IN ('completed','cancelled')) as pending,
             COUNT(*) FILTER (WHERE rt.task_status NOT IN ('completed','cancelled') AND rt.due_date < NOW()) as overdue
      FROM receiving_tasks rt JOIN hr_employee_master e ON e.user_id = rt.assigned_user_id
      WHERE rt.created_at >= v_from AND rt.created_at < v_to GROUP BY e.current_branch_id
    ) rv ON rv.branch_id = b.id
    LEFT JOIN (
      SELECT co.branch_id, COUNT(*) as checklist_count,
             ROUND(AVG(co.total_points::numeric / NULLIF(co.max_points, 0) * 100), 1) as avg_checklist_score
      FROM hr_checklist_operations co
      WHERE co.created_at >= v_from AND co.created_at < v_to GROUP BY co.branch_id
    ) cl ON cl.branch_id = b.id
    WHERE COALESCE(r.total, 0) + COALESCE(q.total, 0) + COALESCE(rv.total, 0) + COALESCE(cl.checklist_count, 0) > 0
  ) bs;

  -- 3. Task type distribution
  SELECT json_build_object(
    'regular', COALESCE((SELECT COUNT(*) FROM task_assignments WHERE assigned_at >= v_from AND assigned_at < v_to), 0),
    'quick', COALESCE((SELECT COUNT(*) FROM quick_task_assignments WHERE created_at >= v_from AND created_at < v_to), 0),
    'receiving', COALESCE((SELECT COUNT(*) FROM receiving_tasks WHERE created_at >= v_from AND created_at < v_to), 0),
    'checklist', COALESCE((SELECT COUNT(*) FROM hr_checklist_operations WHERE created_at >= v_from AND created_at < v_to), 0)
  ) INTO v_task_type_stats;

  -- 4. Daily completion trend
  SELECT COALESCE(json_agg(row_to_json(ds) ORDER BY ds.day), '[]'::json)
  INTO v_daily_stats
  FROM (
    SELECT
      d.day::date as day,
      COALESCE(r.cnt, 0) + COALESCE(q.cnt, 0) + COALESCE(rv.cnt, 0) as completed,
      COALESCE(rc.cnt, 0) + COALESCE(qc.cnt, 0) + COALESCE(rvc.cnt, 0) as created
    FROM generate_series(v_from::date, LEAST(v_to::date, CURRENT_DATE), '1 day') d(day)
    LEFT JOIN (
      SELECT completed_at::date as day, COUNT(*) as cnt
      FROM task_assignments WHERE status = 'completed' AND completed_at >= v_from AND completed_at < v_to
      GROUP BY completed_at::date
    ) r ON r.day = d.day
    LEFT JOIN (
      SELECT completed_at::date as day, COUNT(*) as cnt
      FROM quick_task_assignments WHERE status = 'completed' AND completed_at >= v_from AND completed_at < v_to
      GROUP BY completed_at::date
    ) q ON q.day = d.day
    LEFT JOIN (
      SELECT completed_at::date as day, COUNT(*) as cnt
      FROM receiving_tasks WHERE task_status = 'completed' AND completed_at >= v_from AND completed_at < v_to
      GROUP BY completed_at::date
    ) rv ON rv.day = d.day
    LEFT JOIN (
      SELECT assigned_at::date as day, COUNT(*) as cnt
      FROM task_assignments WHERE assigned_at >= v_from AND assigned_at < v_to
      GROUP BY assigned_at::date
    ) rc ON rc.day = d.day
    LEFT JOIN (
      SELECT created_at::date as day, COUNT(*) as cnt
      FROM quick_task_assignments WHERE created_at >= v_from AND created_at < v_to
      GROUP BY created_at::date
    ) qc ON qc.day = d.day
    LEFT JOIN (
      SELECT created_at::date as day, COUNT(*) as cnt
      FROM receiving_tasks WHERE created_at >= v_from AND created_at < v_to
      GROUP BY created_at::date
    ) rvc ON rvc.day = d.day
  ) ds;

  -- 5. Top performing employees (by completion count, with checklist data)
  SELECT COALESCE(json_agg(row_to_json(te) ORDER BY te.completed DESC), '[]'::json)
  INTO v_top_employees
  FROM (
    SELECT
      emp.user_id,
      emp.name_en,
      emp.name_ar,
      emp.branch_name_en,
      emp.branch_name_ar,
      emp.completed,
      emp.total,
      emp.rate,
      COALESCE(cl.checklist_count, 0) as checklist_count,
      COALESCE(cl.avg_score, 0) as avg_checklist_score
    FROM (
      SELECT
        e.user_id,
        e.name_en,
        e.name_ar,
        b.name_en as branch_name_en,
        b.name_ar as branch_name_ar,
        SUM(sub.completed) as completed,
        SUM(sub.total) as total,
        CASE WHEN SUM(sub.total) > 0
          THEN ROUND((SUM(sub.completed)::numeric / SUM(sub.total)::numeric) * 100, 1)
          ELSE 0
        END as rate
      FROM (
        SELECT assigned_to_user_id as user_id, COUNT(*) as total,
               COUNT(*) FILTER (WHERE status = 'completed') as completed
        FROM task_assignments WHERE assigned_at >= v_from AND assigned_at < v_to GROUP BY assigned_to_user_id
        UNION ALL
        SELECT assigned_to_user_id as user_id, COUNT(*) as total,
               COUNT(*) FILTER (WHERE status = 'completed') as completed
        FROM quick_task_assignments WHERE created_at >= v_from AND created_at < v_to GROUP BY assigned_to_user_id
        UNION ALL
        SELECT assigned_user_id as user_id, COUNT(*) as total,
               COUNT(*) FILTER (WHERE task_status = 'completed') as completed
        FROM receiving_tasks WHERE created_at >= v_from AND created_at < v_to GROUP BY assigned_user_id
      ) sub
      JOIN hr_employee_master e ON e.user_id = sub.user_id
      JOIN branches b ON b.id = e.current_branch_id
      GROUP BY e.user_id, e.name_en, e.name_ar, b.name_en, b.name_ar
      HAVING SUM(sub.total) > 0
    ) emp
    LEFT JOIN (
      SELECT co.user_id, COUNT(*) as checklist_count,
             ROUND(AVG(co.total_points::numeric / NULLIF(co.max_points, 0) * 100), 1) as avg_score
      FROM hr_checklist_operations co
      WHERE co.created_at >= v_from AND co.created_at < v_to
      GROUP BY co.user_id
    ) cl ON cl.user_id = emp.user_id
    ORDER BY emp.completed DESC
  ) te;

  -- 5b. Checklist stats per employee (separate - has score, not status)
  SELECT COALESCE(json_agg(row_to_json(cs) ORDER BY cs.checklist_count DESC), '[]'::json)
  INTO v_checklist_stats
  FROM (
    SELECT
      e.user_id,
      e.name_en,
      e.name_ar,
      b.name_en as branch_name_en,
      b.name_ar as branch_name_ar,
      COUNT(*) as checklist_count,
      ROUND(AVG(co.total_points::numeric / NULLIF(co.max_points, 0) * 100), 1) as avg_score,
      SUM(co.total_points) as total_points,
      SUM(co.max_points) as max_points
    FROM hr_checklist_operations co
    JOIN hr_employee_master e ON e.user_id = co.user_id
    JOIN branches b ON b.id = e.current_branch_id
    WHERE co.created_at >= v_from AND co.created_at < v_to
    GROUP BY e.user_id, e.name_en, e.name_ar, b.name_en, b.name_ar
    ORDER BY COUNT(*) DESC
  ) cs;

  -- 6. Assigned-by stats (who assigned tasks and their outcome)
  SELECT COALESCE(json_agg(row_to_json(ab) ORDER BY ab.total_assigned DESC), '[]'::json)
  INTO v_assigned_by_stats
  FROM (
    SELECT
      e.user_id,
      e.name_en,
      e.name_ar,
      b.name_en as branch_name_en,
      b.name_ar as branch_name_ar,
      SUM(sub.total_assigned) as total_assigned,
      SUM(sub.completed) as completed,
      SUM(sub.pending) as pending,
      SUM(sub.overdue) as overdue,
      CASE WHEN SUM(sub.total_assigned) > 0
        THEN ROUND((SUM(sub.completed)::numeric / SUM(sub.total_assigned)::numeric) * 100, 1)
        ELSE 0
      END as completion_rate
    FROM (
      -- Regular task assignments: assigned_by
      SELECT assigned_by as user_id,
             COUNT(*) as total_assigned,
             COUNT(*) FILTER (WHERE status = 'completed') as completed,
             COUNT(*) FILTER (WHERE status NOT IN ('completed','cancelled')) as pending,
             COUNT(*) FILTER (WHERE status NOT IN ('completed','cancelled') AND deadline_date < CURRENT_DATE) as overdue
      FROM task_assignments
      WHERE assigned_at >= v_from AND assigned_at < v_to AND assigned_by IS NOT NULL
      GROUP BY assigned_by

      UNION ALL

      -- Quick tasks: assigned_by is on the parent quick_tasks table
      SELECT qt.assigned_by as user_id,
             COUNT(*) as total_assigned,
             COUNT(*) FILTER (WHERE qta.status = 'completed') as completed,
             COUNT(*) FILTER (WHERE qta.status NOT IN ('completed','cancelled')) as pending,
             COUNT(*) FILTER (WHERE qta.status NOT IN ('completed','cancelled') AND qt.deadline_datetime < NOW()) as overdue
      FROM quick_task_assignments qta
      JOIN quick_tasks qt ON qt.id = qta.quick_task_id
      WHERE qta.created_at >= v_from AND qta.created_at < v_to AND qt.assigned_by IS NOT NULL
      GROUP BY qt.assigned_by

      UNION ALL

      -- Receiving tasks: created by the user who submitted the receiving record
      SELECT rr.user_id as user_id,
             COUNT(*) as total_assigned,
             COUNT(*) FILTER (WHERE rt.task_status = 'completed') as completed,
             COUNT(*) FILTER (WHERE rt.task_status NOT IN ('completed','cancelled')) as pending,
             COUNT(*) FILTER (WHERE rt.task_status NOT IN ('completed','cancelled') AND rt.due_date < NOW()) as overdue
      FROM receiving_tasks rt
      JOIN receiving_records rr ON rr.id = rt.receiving_record_id
      WHERE rt.created_at >= v_from AND rt.created_at < v_to AND rr.user_id IS NOT NULL
      GROUP BY rr.user_id
    ) sub
    JOIN hr_employee_master e ON e.user_id = sub.user_id
    JOIN branches b ON b.id = e.current_branch_id
    GROUP BY e.user_id, e.name_en, e.name_ar, b.name_en, b.name_ar
    HAVING SUM(sub.total_assigned) > 0
    ORDER BY SUM(sub.total_assigned) DESC
  ) ab;

  RETURN json_build_object(
    'totals', v_totals,
    'branch_stats', v_branch_stats,
    'task_type_stats', v_task_type_stats,
    'daily_stats', v_daily_stats,
    'top_employees', v_top_employees,
    'assigned_by_stats', v_assigned_by_stats,
    'checklist_stats', v_checklist_stats
  );
END;
$$;



--
-- Name: get_branch_promissory_notes_summary(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_branch_promissory_notes_summary(branch_uuid uuid) RETURNS TABLE(total_notes integer, total_active_amount numeric, total_collected_amount numeric, active_notes_count integer, collected_notes_count integer, cancelled_notes_count integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::INTEGER as total_notes,
        COALESCE(SUM(CASE WHEN status = 'active' THEN amount ELSE 0 END), 0) as total_active_amount,
        COALESCE(SUM(CASE WHEN status = 'collected' THEN amount ELSE 0 END), 0) as total_collected_amount,
        COUNT(CASE WHEN status = 'active' THEN 1 END)::INTEGER as active_notes_count,
        COUNT(CASE WHEN status = 'collected' THEN 1 END)::INTEGER as collected_notes_count,
        COUNT(CASE WHEN status = 'cancelled' THEN 1 END)::INTEGER as cancelled_notes_count
    FROM promissory_notes 
    WHERE branch_id = branch_uuid;
END;
$$;



--
-- Name: get_branch_service_availability(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_branch_service_availability(branch_id uuid) RETURNS TABLE(delivery_enabled boolean, pickup_enabled boolean, branch_name_en text, branch_name_ar text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        b.delivery_service_enabled,
        b.pickup_service_enabled,
        b.name_en,
        b.name_ar
    FROM public.branches b
    WHERE b.id = branch_id
    LIMIT 1;
END;
$$;



--
-- Name: FUNCTION get_branch_service_availability(branch_id uuid); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.get_branch_service_availability(branch_id uuid) IS 'Check delivery and pickup service availability for a specific branch';


--
-- Name: get_branch_sync_configs(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_branch_sync_configs() RETURNS TABLE(id bigint, branch_id bigint, branch_name_en text, branch_name_ar text, local_supabase_url text, local_supabase_key text, tunnel_url text, ssh_user text, is_active boolean, last_sync_at timestamp with time zone, last_sync_status text, last_sync_details jsonb, sync_tables text[])
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT
    c.id, c.branch_id,
    b.name_en as branch_name_en,
    b.name_ar as branch_name_ar,
    c.local_supabase_url, c.local_supabase_key,
    c.tunnel_url, COALESCE(c.ssh_user, 'u') as ssh_user,
    c.is_active,
    c.last_sync_at, c.last_sync_status, c.last_sync_details,
    c.sync_tables
  FROM branch_sync_config c
  JOIN branches b ON b.id = c.branch_id
  WHERE c.is_active = true
  ORDER BY b.name_en;
$$;



--
-- Name: get_branch_visits_summary(uuid, date, date); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_branch_visits_summary(branch_uuid uuid, start_date date DEFAULT CURRENT_DATE, end_date date DEFAULT (CURRENT_DATE + '30 days'::interval)) RETURNS TABLE(total_visits integer, scheduled_visits integer, confirmed_visits integer, completed_visits integer, high_priority_visits integer, visits_requiring_followup integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::INTEGER as total_visits,
        COUNT(CASE WHEN status = 'scheduled' THEN 1 END)::INTEGER as scheduled_visits,
        COUNT(CASE WHEN status = 'confirmed' THEN 1 END)::INTEGER as confirmed_visits,
        COUNT(CASE WHEN status = 'completed' THEN 1 END)::INTEGER as completed_visits,
        COUNT(CASE WHEN priority IN ('high', 'urgent') THEN 1 END)::INTEGER as high_priority_visits,
        COUNT(CASE WHEN follow_up_required = true THEN 1 END)::INTEGER as visits_requiring_followup
    FROM vendor_visits 
    WHERE branch_id = branch_uuid 
    AND visit_date BETWEEN start_date AND end_date;
END;
$$;



--
-- Name: get_break_security_code(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_break_security_code() RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_seed text;
    v_epoch bigint;
    v_code text;
    v_ttl integer;
BEGIN
    SELECT seed INTO v_seed FROM break_security_seed WHERE id = 1;
    
    IF v_seed IS NULL THEN
        RETURN jsonb_build_object('error', 'No security seed configured');
    END IF;
    
    -- Current 10-second epoch
    v_epoch := floor(extract(epoch from now()) / 10)::bigint;
    
    -- Generate code: md5 of seed + epoch, take first 12 chars
    v_code := substring(md5(v_seed || v_epoch::text) from 1 for 12);
    
    -- Time remaining in this window (seconds)
    v_ttl := 10 - (extract(epoch from now())::integer % 10);
    
    RETURN jsonb_build_object(
        'code', v_code,
        'ttl', v_ttl,
        'epoch', v_epoch
    );
END;
$$;



--
-- Name: get_break_summary_all_employees(date, date, integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_break_summary_all_employees(p_date_from date DEFAULT NULL::date, p_date_to date DEFAULT NULL::date, p_branch_id integer DEFAULT NULL::integer) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_date_from DATE;
    v_date_to DATE;
    v_result JSONB;
BEGIN
    -- Default to last 7 days if not specified
    v_date_to := COALESCE(p_date_to, (NOW() AT TIME ZONE 'Asia/Riyadh')::DATE);
    v_date_from := COALESCE(p_date_from, v_date_to - INTERVAL '6 days');

    -- Build summary: all active employees LEFT JOINed with break data
    SELECT COALESCE(jsonb_agg(emp_row ORDER BY emp_row->>'employee_name_en'), '[]'::JSONB)
    INTO v_result
    FROM (
        SELECT jsonb_build_object(
            'employee_id', e.id,
            'employee_name_en', e.name_en,
            'employee_name_ar', e.name_ar,
            'branch_id', e.current_branch_id,
            'days', COALESCE(
                (SELECT jsonb_agg(day_data ORDER BY day_data->>'date')
                 FROM (
                    SELECT jsonb_build_object(
                        'date', d.dt::DATE::TEXT,
                        'total_seconds', COALESCE(SUM(br.duration_seconds), 0),
                        'break_count', COUNT(br.id)
                    ) AS day_data
                    FROM generate_series(v_date_from, v_date_to, '1 day'::INTERVAL) AS d(dt)
                    LEFT JOIN break_register br
                        ON br.user_id = e.user_id
                        AND br.status = 'closed'
                        AND (br.start_time AT TIME ZONE 'Asia/Riyadh')::DATE = d.dt::DATE
                    GROUP BY d.dt
                 ) sub
                ),
                '[]'::JSONB
            ),
            'grand_total_seconds', COALESCE(
                (SELECT SUM(br2.duration_seconds)
                 FROM break_register br2
                 WHERE br2.user_id = e.user_id
                   AND br2.status = 'closed'
                   AND (br2.start_time AT TIME ZONE 'Asia/Riyadh')::DATE BETWEEN v_date_from AND v_date_to
                ), 0
            )
        ) AS emp_row
        FROM hr_employee_master e
        WHERE e.user_id IS NOT NULL
          AND COALESCE(e.employment_status, '') NOT IN ('Remote Job', 'Vacation', 'Resigned', 'Terminated', 'Run Away')
          AND (p_branch_id IS NULL OR e.current_branch_id = p_branch_id)
    ) final;

    RETURN jsonb_build_object(
        'success', true,
        'date_from', v_date_from::TEXT,
        'date_to', v_date_to::TEXT,
        'employees', v_result
    );

EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$;



--
-- Name: get_broadcast_recipients(uuid, integer, integer, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_broadcast_recipients(p_broadcast_id uuid, p_limit integer DEFAULT 100, p_offset integer DEFAULT 0, p_status_filter text DEFAULT NULL::text) RETURNS TABLE(id uuid, phone_number character varying, customer_name text, status character varying, sent_at timestamp with time zone, error_details text)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    SELECT r.id, r.phone_number, r.customer_name, r.status, r.sent_at, r.error_details
    FROM wa_broadcast_recipients r
    WHERE r.broadcast_id = p_broadcast_id
      AND (p_status_filter IS NULL OR r.status = p_status_filter)
    ORDER BY r.sent_at DESC NULLS LAST
    LIMIT p_limit
    OFFSET p_offset;
$$;



--
-- Name: get_broadcast_summary(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_broadcast_summary(p_broadcast_id uuid) RETURNS TABLE(total_count bigint, pending_count bigint, sent_count bigint, delivered_count bigint, read_count bigint, failed_count bigint)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    SELECT 
        COUNT(*)::bigint AS total_count,
        COUNT(*) FILTER (WHERE status = 'pending')::bigint AS pending_count,
        COUNT(*) FILTER (WHERE status = 'sent')::bigint AS sent_count,
        COUNT(*) FILTER (WHERE status = 'delivered')::bigint AS delivered_count,
        COUNT(*) FILTER (WHERE status = 'read')::bigint AS read_count,
        COUNT(*) FILTER (WHERE status = 'failed')::bigint AS failed_count
    FROM wa_broadcast_recipients
    WHERE broadcast_id = p_broadcast_id;
$$;



--
-- Name: get_bt_assigned_ims(uuid[]); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_bt_assigned_ims(p_request_ids uuid[]) RETURNS TABLE(product_request_id uuid, assigned_to_user_id uuid)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT
        qt.product_request_id,
        qta.assigned_to_user_id
    FROM quick_tasks qt
    INNER JOIN quick_task_assignments qta ON qta.quick_task_id = qt.id
    WHERE qt.product_request_type = 'BT'
    AND qt.product_request_id = ANY(p_request_ids);
END;
$$;



--
-- Name: get_bt_requests_with_details(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_bt_requests_with_details() RETURNS TABLE(id uuid, requester_user_id uuid, from_branch_id integer, to_branch_id integer, target_user_id uuid, status character varying, items jsonb, document_url text, created_at timestamp with time zone, updated_at timestamp with time zone, requester_name_en text, requester_name_ar text, target_name_en text, target_name_ar text, from_branch_name_en text, from_branch_name_ar text, from_branch_location_en text, from_branch_location_ar text, to_branch_name_en text, to_branch_name_ar text, to_branch_location_en text, to_branch_location_ar text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        r.id,
        r.requester_user_id,
        r.from_branch_id,
        r.to_branch_id,
        r.target_user_id,
        r.status,
        r.items,
        r.document_url,
        r.created_at,
        r.updated_at,
        COALESCE(req.name_en, req.user_id::TEXT)::TEXT AS requester_name_en,
        COALESCE(req.name_ar, req.name_en, req.user_id::TEXT)::TEXT AS requester_name_ar,
        COALESCE(tgt.name_en, tgt.user_id::TEXT)::TEXT AS target_name_en,
        COALESCE(tgt.name_ar, tgt.name_en, tgt.user_id::TEXT)::TEXT AS target_name_ar,
        COALESCE(fb.name_en, '')::TEXT AS from_branch_name_en,
        COALESCE(fb.name_ar, fb.name_en, '')::TEXT AS from_branch_name_ar,
        COALESCE(fb.location_en, '')::TEXT AS from_branch_location_en,
        COALESCE(fb.location_ar, fb.location_en, '')::TEXT AS from_branch_location_ar,
        COALESCE(tb.name_en, '')::TEXT AS to_branch_name_en,
        COALESCE(tb.name_ar, tb.name_en, '')::TEXT AS to_branch_name_ar,
        COALESCE(tb.location_en, '')::TEXT AS to_branch_location_en,
        COALESCE(tb.location_ar, tb.location_en, '')::TEXT AS to_branch_location_ar
    FROM product_request_bt r
    LEFT JOIN hr_employee_master req ON req.user_id = r.requester_user_id
    LEFT JOIN hr_employee_master tgt ON tgt.user_id = r.target_user_id
    LEFT JOIN branches fb ON fb.id = r.from_branch_id
    LEFT JOIN branches tb ON tb.id = r.to_branch_id
    ORDER BY r.created_at DESC;
END;
$$;



--
-- Name: get_bucket_files(text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_bucket_files(p_bucket_id text) RETURNS TABLE(file_name text, full_path text, file_size bigint, created_at timestamp with time zone, mime_type text)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT
    o.name::text AS file_name,
    o.name::text AS full_path,
    COALESCE((o.metadata->>'size')::bigint, 0) AS file_size,
    o.created_at,
    COALESCE(o.metadata->>'mimetype', o.metadata->>'mimeType', '') AS mime_type
  FROM storage.objects o
  WHERE o.bucket_id = p_bucket_id
  ORDER BY o.name;
$$;



--
-- Name: get_campaign_statistics(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_campaign_statistics(p_campaign_id uuid) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_stats JSONB;
  v_products JSONB;
  v_max_claims INTEGER;
BEGIN
  -- Get campaign max claims
  SELECT COALESCE(max_claims_per_customer, 1)
  INTO v_max_claims
  FROM coupon_campaigns
  WHERE id = p_campaign_id;
  
  -- Get overall campaign stats
  SELECT jsonb_build_object(
    'max_claims_per_customer', v_max_claims,
    'total_eligible_customers', (
      SELECT COUNT(*) 
      FROM coupon_eligible_customers 
      WHERE campaign_id = p_campaign_id
    ),
    'total_claims', (
      SELECT COUNT(*) 
      FROM coupon_claims 
      WHERE campaign_id = p_campaign_id
    ),
    'unique_customers_claimed', (
      SELECT COUNT(DISTINCT customer_mobile)
      FROM coupon_claims
      WHERE campaign_id = p_campaign_id
    ),
    'remaining_potential_claims', (
      SELECT COUNT(*) * v_max_claims
      FROM coupon_eligible_customers ec
      WHERE ec.campaign_id = p_campaign_id
    ) - (
      SELECT COUNT(*)
      FROM coupon_claims
      WHERE campaign_id = p_campaign_id
    ),
    'total_stock_limit', (
      SELECT COALESCE(SUM(stock_limit), 0)
      FROM coupon_products
      WHERE campaign_id = p_campaign_id
        AND deleted_at IS NULL
    ),
    'total_stock_remaining', (
      SELECT COALESCE(SUM(stock_remaining), 0)
      FROM coupon_products
      WHERE campaign_id = p_campaign_id
        AND deleted_at IS NULL
    )
  ) INTO v_stats;
  
  -- Get per-product stats
  SELECT jsonb_agg(
    jsonb_build_object(
      'product_id', p.id,
      'product_name_en', p.product_name_en,
      'product_name_ar', p.product_name_ar,
      'stock_limit', p.stock_limit,
      'stock_remaining', p.stock_remaining,
      'claims_count', (
        SELECT COUNT(*) 
        FROM coupon_claims 
        WHERE product_id = p.id
      )
    )
  )
  INTO v_products
  FROM coupon_products p
  WHERE p.campaign_id = p_campaign_id
    AND p.deleted_at IS NULL;
  
  -- Combine and return
  RETURN v_stats || jsonb_build_object('products', COALESCE(v_products, '[]'::jsonb));
END;
$$;



--
-- Name: get_cart_tier_discount(integer, numeric); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_cart_tier_discount(p_offer_id integer, p_cart_amount numeric) RETURNS TABLE(tier_number integer, discount_type character varying, discount_value numeric, min_amount numeric, max_amount numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        t.tier_number,
        t.discount_type,
        t.discount_value,
        t.min_amount,
        t.max_amount
    FROM offer_cart_tiers t
    WHERE t.offer_id = p_offer_id
      AND p_cart_amount >= t.min_amount
      AND (t.max_amount IS NULL OR p_cart_amount <= t.max_amount)
    ORDER BY t.tier_number DESC
    LIMIT 1;
END;
$$;



--
-- Name: get_close_purchase_voucher_data(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_close_purchase_voucher_data() RETURNS jsonb
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT jsonb_build_object(
    'vouchers', COALESCE((
      SELECT jsonb_agg(
        jsonb_build_object(
          'id', pvi.id,
          'purchase_voucher_id', pvi.purchase_voucher_id,
          'serial_number', pvi.serial_number,
          'value', pvi.value,
          'status', pvi.status,
          'issue_type', pvi.issue_type,
          'stock_location', pvi.stock_location,
          'stock_location_name', COALESCE(b.name_en || ' - ' || b.location_en, '-'),
          'issued_by', pvi.issued_by,
          'issued_by_name', COALESCE(eby.name_en, uby.username, '-'),
          'issued_to', pvi.issued_to,
          'issued_to_name', COALESCE(eto.name_en, uto.username, '-'),
          'issued_date', pvi.issued_date,
          'issue_remarks', pvi.issue_remarks,
          'approval_status', pvi.approval_status
        )
        ORDER BY pvi.issued_date DESC
      )
      FROM purchase_voucher_items pvi
      LEFT JOIN branches b ON b.id = pvi.stock_location
      LEFT JOIN users uby ON uby.id = pvi.issued_by
      LEFT JOIN hr_employee_master eby ON eby.id = uby.employee_id::text
      LEFT JOIN users uto ON uto.id = pvi.issued_to
      LEFT JOIN hr_employee_master eto ON eto.id = uto.employee_id::text
      WHERE pvi.status = 'issued' OR pvi.approval_status = 'pending'
    ), '[]'::jsonb),
    'branches', COALESCE((
      SELECT jsonb_agg(jsonb_build_object('id', id, 'name_en', name_en, 'location_en', location_en))
      FROM branches
    ), '[]'::jsonb),
    'expense_categories', COALESCE((
      SELECT jsonb_agg(jsonb_build_object('id', id, 'name_en', name_en, 'name_ar', name_ar, 'parent_category_id', parent_category_id))
      FROM expense_sub_categories WHERE is_active = true
    ), '[]'::jsonb)
  );
$$;



--
-- Name: get_closed_boxes(text, timestamp with time zone, timestamp with time zone, integer, integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_closed_boxes(p_branch_id text DEFAULT 'all'::text, p_date_from timestamp with time zone DEFAULT NULL::timestamp with time zone, p_date_to timestamp with time zone DEFAULT NULL::timestamp with time zone, p_limit integer DEFAULT 50, p_offset integer DEFAULT 0) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_total_count bigint;
  v_boxes jsonb;
BEGIN
  -- Get total count for the filtered set
  SELECT COUNT(*)
  INTO v_total_count
  FROM box_operations bo
  WHERE bo.status = 'completed'
    AND (p_branch_id = 'all' OR bo.branch_id = p_branch_id::int)
    AND (p_date_from IS NULL OR bo.updated_at >= p_date_from)
    AND (p_date_to IS NULL OR bo.updated_at <= p_date_to);

  -- Get boxes with their transfer status included
  SELECT COALESCE(jsonb_agg(row_data ORDER BY (row_data->>'updated_at') DESC), '[]'::jsonb)
  INTO v_boxes
  FROM (
    SELECT jsonb_build_object(
      'id', bo.id,
      'box_number', bo.box_number,
      'branch_id', bo.branch_id,
      'user_id', bo.user_id,
      'status', bo.status,
      'notes', bo.notes,
      'complete_details', bo.complete_details,
      'completed_by_name', bo.completed_by_name,
      'completed_by_user_id', bo.completed_by_user_id,
      'total_before', bo.total_before,
      'total_after', bo.total_after,
      'created_at', bo.created_at,
      'updated_at', bo.updated_at,
      'transfer_status', pdt.status::text,
      'transfer_key', CASE WHEN pdt.box_number IS NOT NULL 
        THEN pdt.box_number::text || '-' || pdt.branch_id::text || '-' || pdt.date_closed_box::text
        ELSE NULL END
    ) as row_data
    FROM box_operations bo
    LEFT JOIN pos_deduction_transfers pdt 
      ON pdt.box_operation_id = bo.id
    WHERE bo.status = 'completed'
      AND (p_branch_id = 'all' OR bo.branch_id = p_branch_id::int)
      AND (p_date_from IS NULL OR bo.updated_at >= p_date_from)
      AND (p_date_to IS NULL OR bo.updated_at <= p_date_to)
    ORDER BY bo.updated_at DESC
    LIMIT p_limit
    OFFSET p_offset
  ) sub;

  RETURN jsonb_build_object(
    'boxes', v_boxes,
    'total_count', v_total_count
  );
END;
$$;



--
-- Name: get_completed_receiving_tasks(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_completed_receiving_tasks() RETURNS TABLE(id uuid, receiving_record_id uuid, template_id uuid, role_type character varying, title text, description text, priority character varying, task_status character varying, task_completed boolean, due_date timestamp with time zone, assigned_user_id uuid, completed_at timestamp with time zone, completed_by_user_id uuid, clearance_certificate_url text, created_at timestamp with time zone, bill_number character varying, bill_amount numeric, vendor_name text, branch_name text, assigned_user_name text, completed_by_user_name text)
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
    u2.username as completed_by_user_name
  FROM receiving_tasks rt
  LEFT JOIN receiving_records rr ON rr.id = rt.receiving_record_id
  LEFT JOIN vendors v ON v.erp_vendor_id = rr.vendor_id AND v.branch_id = rr.branch_id
  LEFT JOIN branches b ON b.id = rr.branch_id
  LEFT JOIN users u1 ON u1.id = rt.assigned_user_id
  LEFT JOIN users u2 ON u2.id = rt.completed_by_user_id
  WHERE rt.task_completed = true OR rt.task_status = 'completed'
  ORDER BY rt.completed_at DESC;
END;
$$;



--
-- Name: get_completed_tasks(integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_completed_tasks(p_limit integer DEFAULT 500) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_result json;
BEGIN
  SELECT json_build_object(
    'tasks', COALESCE(tasks_arr, '[]'::json),
    'total_count', COALESCE(json_array_length(tasks_arr), 0)
  ) INTO v_result
  FROM (
    SELECT json_agg(row_to_json(t)) as tasks_arr
    FROM (
      SELECT * FROM (
      -- Task Assignments (completed)
      SELECT
        ta.id,
        'regular' as task_type,
        COALESCE(tk.title, 'Task Assignment #' || LEFT(ta.id::text, 8)) as task_title,
        COALESCE(tk.description, '') as task_description,
        ta.status,
        COALESCE(ta.priority_override, tk.priority, 'medium') as priority,
        COALESCE(b.name_en, 'No Branch') as branch_name,
        COALESCE(b.name_ar, b.name_en, 'No Branch') as branch_name_ar,
        ta.assigned_to_branch_id as branch_id,
        COALESCE(u_to.username, 'Unassigned') as assigned_to_name,
        COALESCE(e_to.name_en, u_to.username, 'Unassigned') as assigned_to_name_en,
        COALESCE(e_to.name_ar, e_to.name_en, u_to.username, 'Unassigned') as assigned_to_name_ar,
        ta.assigned_to_user_id,
        COALESCE(u_by.username, 'System') as assigned_by_name,
        ta.assigned_at as assigned_date,
        COALESCE(ta.deadline_datetime::text, ta.deadline_date::text) as deadline,
        ta.completed_at as completed_date,
        ta.notes,
        ROUND(EXTRACT(EPOCH FROM (ta.completed_at - ta.assigned_at)) / 3600, 1) as completion_hours,
        tc.completion_photo_url as completion_photo_url,
        tc.completion_notes as completion_notes_detail,
        tc.completed_by_name as completed_by_name,
        tc.erp_reference_number as erp_reference
      FROM task_assignments ta
      LEFT JOIN tasks tk ON tk.id = ta.task_id
      LEFT JOIN branches b ON b.id = ta.assigned_to_branch_id
      LEFT JOIN users u_to ON u_to.id = ta.assigned_to_user_id
      LEFT JOIN users u_by ON u_by.id = ta.assigned_by
      LEFT JOIN hr_employee_master e_to ON e_to.user_id = ta.assigned_to_user_id
      LEFT JOIN LATERAL (
        SELECT tc2.completion_photo_url, tc2.completion_notes, tc2.completed_by_name, tc2.erp_reference_number
        FROM task_completions tc2
        WHERE tc2.assignment_id = ta.id
        ORDER BY tc2.completed_at DESC
        LIMIT 1
      ) tc ON true
      WHERE ta.status = 'completed'

      UNION ALL

      -- Quick Task Assignments (completed)
      SELECT
        qta.id,
        'quick' as task_type,
        COALESCE(qt.title, 'Quick Task #' || LEFT(qta.id::text, 8)) as task_title,
        COALESCE(qt.description, '') as task_description,
        qta.status::text,
        COALESCE(qt.priority::text, 'medium') as priority,
        COALESCE(b.name_en, 'No Branch') as branch_name,
        COALESCE(b.name_ar, b.name_en, 'No Branch') as branch_name_ar,
        qt.assigned_to_branch_id as branch_id,
        COALESCE(u_to.username, 'Unassigned') as assigned_to_name,
        COALESCE(e_to.name_en, u_to.username, 'Unassigned') as assigned_to_name_en,
        COALESCE(e_to.name_ar, e_to.name_en, u_to.username, 'Unassigned') as assigned_to_name_ar,
        qta.assigned_to_user_id,
        COALESCE(u_by.username, 'System') as assigned_by_name,
        qta.created_at as assigned_date,
        qt.deadline_datetime::text as deadline,
        qta.completed_at as completed_date,
        NULL as notes,
        ROUND(EXTRACT(EPOCH FROM (qta.completed_at - qta.created_at)) / 3600, 1) as completion_hours,
        qtc.photo_path as completion_photo_url,
        qtc.completion_notes as completion_notes_detail,
        NULL as completed_by_name,
        qtc.erp_reference as erp_reference
      FROM quick_task_assignments qta
      JOIN quick_tasks qt ON qt.id = qta.quick_task_id
      LEFT JOIN branches b ON b.id = qt.assigned_to_branch_id
      LEFT JOIN users u_to ON u_to.id = qta.assigned_to_user_id
      LEFT JOIN users u_by ON u_by.id = qt.assigned_by
      LEFT JOIN hr_employee_master e_to ON e_to.user_id = qta.assigned_to_user_id
      LEFT JOIN LATERAL (
        SELECT qtc2.photo_path, qtc2.completion_notes, qtc2.erp_reference
        FROM quick_task_completions qtc2
        WHERE qtc2.assignment_id = qta.id
        ORDER BY qtc2.created_at DESC
        LIMIT 1
      ) qtc ON true
      WHERE qta.status = 'completed'

      UNION ALL

      -- Receiving Tasks (completed)
      SELECT
        rt.id,
        'receiving' as task_type,
        COALESCE(rt.title, 'Receiving Task #' || LEFT(rt.id::text, 8)) as task_title,
        COALESCE(rt.description, '') as task_description,
        rt.task_status::text as status,
        COALESCE(rt.priority::text, 'medium') as priority,
        COALESCE(b.name_en, 'No Branch') as branch_name,
        COALESCE(b.name_ar, b.name_en, 'No Branch') as branch_name_ar,
        rr.branch_id as branch_id,
        COALESCE(u_to.username, 'Unassigned') as assigned_to_name,
        COALESCE(e_to.name_en, u_to.username, 'Unassigned') as assigned_to_name_en,
        COALESCE(e_to.name_ar, e_to.name_en, u_to.username, 'Unassigned') as assigned_to_name_ar,
        rt.assigned_user_id as assigned_to_user_id,
        COALESCE(u_by.username, 'System') as assigned_by_name,
        rt.created_at as assigned_date,
        rt.due_date::text as deadline,
        rt.completed_at as completed_date,
        rt.completion_notes as notes,
        ROUND(EXTRACT(EPOCH FROM (rt.completed_at - rt.created_at)) / 3600, 1) as completion_hours,
        rt.completion_photo_url as completion_photo_url,
        rt.completion_notes as completion_notes_detail,
        NULL as completed_by_name,
        NULL as erp_reference
      FROM receiving_tasks rt
      LEFT JOIN receiving_records rr ON rr.id = rt.receiving_record_id
      LEFT JOIN branches b ON b.id = rr.branch_id
      LEFT JOIN users u_to ON u_to.id = rt.assigned_user_id
      LEFT JOIN users u_by ON u_by.id = rr.user_id
      LEFT JOIN hr_employee_master e_to ON e_to.user_id = rt.assigned_user_id
      WHERE rt.task_status = 'completed'
      ) all_tasks
      ORDER BY completed_date DESC
      LIMIT p_limit
    ) t
  ) sub;

  RETURN v_result;
END;
$$;



--
-- Name: get_contact_broadcast_stats(text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_contact_broadcast_stats(phone_number text) RETURNS TABLE(sent integer, delivered integer, read integer, failed integer, total integer)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $_$
  SELECT
    COALESCE(COUNT(*) FILTER (WHERE status = 'sent'), 0) as sent,
    COALESCE(COUNT(*) FILTER (WHERE status = 'delivered'), 0) as delivered,
    COALESCE(COUNT(*) FILTER (WHERE status = 'read'), 0) as read,
    COALESCE(COUNT(*) FILTER (WHERE status = 'failed'), 0) as failed,
    COUNT(*) as total
  FROM wa_broadcast_recipients
  WHERE phone_number = $1;
$_$;



--
-- Name: get_current_user_id(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_current_user_id() RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN current_setting('app.current_user_id', true)::UUID;
EXCEPTION
  WHEN OTHERS THEN
    RETURN NULL;
END;
$$;



--
-- Name: get_customer_products_with_offers(text, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_customer_products_with_offers(p_branch_id text DEFAULT NULL::text, p_service_type text DEFAULT 'both'::text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_result json;
  v_now timestamptz := NOW();
BEGIN
  WITH
  -- Step 1: Get active offers filtered by branch and service type
  active_offers AS (
    SELECT *
    FROM offers o
    WHERE o.is_active = true
      AND o.type IN ('product', 'bogo', 'bundle')
      AND o.start_date <= v_now
      AND o.end_date >= v_now
      AND (o.branch_id IS NULL OR o.branch_id::text = p_branch_id)
      AND (o.service_type IS NULL OR o.service_type = 'both' OR o.service_type = p_service_type)
  ),

  -- Step 2: Get offer products with enriched product + offer data
  enriched_offer_products AS (
    SELECT
      p.id,
      p.barcode,
      p.product_name_en AS "nameEn",
      p.product_name_ar AS "nameAr",
      p.category_id AS category,
      COALESCE(pc.name_en, 'Uncategorized') AS "categoryNameEn",
      COALESCE(pc.name_ar, 'غير مصنف') AS "categoryNameAr",
      p.image_url AS image,
      p.current_stock AS stock,
      p.minimum_qty_alert AS "lowStockThreshold",
      COALESCE(pu.name_en, 'Unit') AS "unitEn",
      COALESCE(pu.name_ar, 'وحدة') AS "unitAr",
      COALESCE(p.unit_qty, 1) AS "unitQty",
      p.sale_price::float AS "originalPrice",
      -- Calculate offer price
      CASE
        WHEN op.offer_percentage IS NOT NULL AND op.offer_percentage > 0 THEN
          (p.sale_price - (p.sale_price * op.offer_percentage / 100))::float
        WHEN op.offer_price IS NOT NULL AND op.offer_price > 0 THEN
          op.offer_price::float
        ELSE NULL
      END AS "offerPrice",
      -- Calculate savings
      CASE
        WHEN op.offer_percentage IS NOT NULL AND op.offer_percentage > 0 THEN
          (p.sale_price * op.offer_percentage / 100)::float
        WHEN op.offer_price IS NOT NULL AND op.offer_price > 0 THEN
          (p.sale_price - op.offer_price)::float
        ELSE 0
      END AS savings,
      -- Calculate discount percentage
      CASE
        WHEN op.offer_percentage IS NOT NULL AND op.offer_percentage > 0 THEN
          op.offer_percentage::float
        WHEN op.offer_price IS NOT NULL AND op.offer_price > 0 THEN
          ROUND(((p.sale_price - op.offer_price) / NULLIF(p.sale_price, 0) * 100))::float
        ELSE 0
      END AS "discountPercentage",
      true AS "hasOffer",
      CASE
        WHEN op.offer_percentage IS NOT NULL AND op.offer_percentage > 0 THEN 'percentage'
        ELSE 'special_price'
      END AS "offerType",
      ao.id AS "offerId",
      ao.name_en AS "offerNameEn",
      ao.name_ar AS "offerNameAr",
      op.offer_qty AS "offerQty",
      op.max_uses AS "maxUses",
      ao.end_date AS "offerEndDate",
      CASE
        WHEN EXTRACT(EPOCH FROM (ao.end_date - v_now)) / 3600 BETWEEN 0 AND 24 THEN true
        ELSE false
      END AS "isExpiringSoon"
    FROM offer_products op
    JOIN active_offers ao ON ao.id = op.offer_id
    JOIN products p ON p.id = op.product_id
    LEFT JOIN product_categories pc ON pc.id = p.category_id
    LEFT JOIN product_units pu ON pu.id = p.unit_id
    WHERE p.is_active = true
      AND p.is_customer_product = true
      AND (
        (op.offer_percentage IS NOT NULL AND op.offer_percentage > 0)
        OR (op.offer_price IS NOT NULL AND op.offer_price > 0)
      )
  ),

  -- Step 3: Get all active customer products (non-offer)
  all_products AS (
    SELECT
      p.id,
      p.barcode,
      p.product_name_en AS "nameEn",
      p.product_name_ar AS "nameAr",
      p.category_id AS category,
      COALESCE(pc.name_en, 'Uncategorized') AS "categoryNameEn",
      COALESCE(pc.name_ar, 'غير مصنف') AS "categoryNameAr",
      p.image_url AS image,
      p.current_stock AS stock,
      p.minimum_qty_alert AS "lowStockThreshold",
      COALESCE(pu.name_en, 'Unit') AS "unitEn",
      COALESCE(pu.name_ar, 'وحدة') AS "unitAr",
      COALESCE(p.unit_qty, 1) AS "unitQty",
      p.sale_price::float AS "originalPrice",
      NULL::float AS "offerPrice",
      0::float AS savings,
      0::float AS "discountPercentage",
      false AS "hasOffer",
      NULL::text AS "offerType",
      NULL::int AS "offerId",
      NULL::text AS "offerNameEn",
      NULL::text AS "offerNameAr",
      NULL::int AS "offerQty",
      NULL::int AS "maxUses",
      NULL::timestamptz AS "offerEndDate",
      false AS "isExpiringSoon"
    FROM products p
    LEFT JOIN product_categories pc ON pc.id = p.category_id
    LEFT JOIN product_units pu ON pu.id = p.unit_id
    WHERE p.is_active = true
      AND p.is_customer_product = true
      AND p.id NOT IN (SELECT id FROM enriched_offer_products)
  ),

  -- Combine offer products + regular products
  combined_products AS (
    SELECT * FROM enriched_offer_products
    UNION ALL
    SELECT * FROM all_products
  ),

  -- Step 4: Build BOGO offer cards
  bogo_cards AS (
    SELECT
      json_build_object(
        'id', 'bogo-' || bor.id,
        'type', 'bogo_offer',
        'offerId', ao.id,
        'offerNameEn', ao.name_en,
        'offerNameAr', ao.name_ar,
        'isExpiringSoon', CASE
          WHEN EXTRACT(EPOCH FROM (ao.end_date - v_now)) / 3600 BETWEEN 0 AND 24 THEN true
          ELSE false
        END,
        'offerEndDate', ao.end_date,
        'buyProduct', json_build_object(
          'id', bp.id,
          'nameEn', bp.product_name_en,
          'nameAr', bp.product_name_ar,
          'image', bp.image_url,
          'unitEn', COALESCE(bpu.name_en, 'Unit'),
          'unitAr', COALESCE(bpu.name_ar, 'وحدة'),
          'unitQty', COALESCE(bp.unit_qty, 1),
          'price', bp.sale_price::float,
          'quantity', bor.buy_quantity,
          'stock', bp.current_stock,
          'lowStockThreshold', bp.minimum_qty_alert,
          'barcode', bp.barcode,
          'category', bp.category_id,
          'categoryNameEn', COALESCE(bpc.name_en, 'Uncategorized'),
          'categoryNameAr', COALESCE(bpc.name_ar, 'غير مصنف')
        ),
        'getProduct', json_build_object(
          'id', gp.id,
          'nameEn', gp.product_name_en,
          'nameAr', gp.product_name_ar,
          'image', gp.image_url,
          'unitEn', COALESCE(gpu.name_en, 'Unit'),
          'unitAr', COALESCE(gpu.name_ar, 'وحدة'),
          'unitQty', COALESCE(gp.unit_qty, 1),
          'originalPrice', gp.sale_price::float,
          'offerPrice', CASE
            WHEN bor.discount_type = 'free' THEN 0::float
            WHEN bor.discount_type = 'percentage' AND bor.discount_value IS NOT NULL THEN
              (gp.sale_price - (gp.sale_price * bor.discount_value / 100))::float
            ELSE gp.sale_price::float
          END,
          'quantity', bor.get_quantity,
          'isFree', (bor.discount_type = 'free'),
          'discountPercentage', CASE
            WHEN bor.discount_type = 'free' THEN 100::float
            WHEN bor.discount_type = 'percentage' THEN bor.discount_value::float
            ELSE 0::float
          END,
          'stock', gp.current_stock,
          'lowStockThreshold', gp.minimum_qty_alert,
          'barcode', gp.barcode,
          'category', gp.category_id,
          'categoryNameEn', COALESCE(gpc.name_en, 'Uncategorized'),
          'categoryNameAr', COALESCE(gpc.name_ar, 'غير مصنف')
        ),
        'bundlePrice', (bp.sale_price * bor.buy_quantity +
          CASE
            WHEN bor.discount_type = 'free' THEN 0
            WHEN bor.discount_type = 'percentage' THEN (gp.sale_price - (gp.sale_price * bor.discount_value / 100)) * bor.get_quantity
            ELSE gp.sale_price * bor.get_quantity
          END)::float,
        'originalBundlePrice', (bp.sale_price * bor.buy_quantity + gp.sale_price * bor.get_quantity)::float,
        'savings', (CASE
            WHEN bor.discount_type = 'free' THEN gp.sale_price * bor.get_quantity
            WHEN bor.discount_type = 'percentage' THEN (gp.sale_price * bor.discount_value / 100) * bor.get_quantity
            ELSE 0
          END)::float
      ) AS bogo_card
    FROM bogo_offer_rules bor
    JOIN active_offers ao ON ao.id = bor.offer_id
    JOIN products bp ON bp.id = bor.buy_product_id
    JOIN products gp ON gp.id = bor.get_product_id
    LEFT JOIN product_units bpu ON bpu.id = bp.unit_id
    LEFT JOIN product_units gpu ON gpu.id = gp.unit_id
    LEFT JOIN product_categories bpc ON bpc.id = bp.category_id
    LEFT JOIN product_categories gpc ON gpc.id = gp.category_id
    WHERE bp.is_active = true
      AND gp.is_active = true
  ),

  -- Step 5: Build bundle offer cards
  bundle_data AS (
    SELECT
      ob.id AS bundle_id,
      ao.id AS offer_id,
      ao.name_en AS offer_name_en,
      ao.name_ar AS offer_name_ar,
      ao.end_date,
      ob.bundle_name_en,
      ob.bundle_name_ar,
      ob.required_products,
      ob.discount_type,
      ob.discount_value,
      CASE
        WHEN EXTRACT(EPOCH FROM (ao.end_date - v_now)) / 3600 BETWEEN 0 AND 24 THEN true
        ELSE false
      END AS is_expiring_soon
    FROM offer_bundles ob
    JOIN active_offers ao ON ao.id = ob.offer_id
  ),

  bundle_products_expanded AS (
    SELECT
      bd.bundle_id,
      bd.offer_id,
      bd.offer_name_en,
      bd.offer_name_ar,
      bd.end_date,
      bd.bundle_name_en,
      bd.bundle_name_ar,
      bd.discount_type,
      bd.discount_value,
      bd.is_expiring_soon,
      elem->>'product_id' AS req_product_id,
      COALESCE((elem->>'quantity')::int, 1) AS req_quantity,
      p.id AS product_id,
      p.product_name_en,
      p.product_name_ar,
      p.image_url,
      p.sale_price::float AS price,
      COALESCE(p.unit_qty, 1) AS unit_qty,
      p.current_stock AS stock,
      p.barcode,
      COALESCE(pu.name_en, 'Unit') AS unit_en,
      COALESCE(pu.name_ar, 'وحدة') AS unit_ar,
      p.unit_id
    FROM bundle_data bd,
    LATERAL jsonb_array_elements(bd.required_products) AS elem
    LEFT JOIN products p ON p.id = (elem->>'product_id')
    LEFT JOIN product_units pu ON pu.id = p.unit_id
    WHERE p.is_customer_product = true
  ),

  bundle_cards AS (
    SELECT
      bpe.bundle_id,
      json_build_object(
        'offerId', bpe.offer_id,
        'offerNameEn', bpe.offer_name_en,
        'offerNameAr', bpe.offer_name_ar,
        'offerType', 'bundle',
        'bundleName', bpe.bundle_name_en,
        'bundleProducts', json_agg(
          json_build_object(
            'id', bpe.product_id,
            'unitId', bpe.unit_id,
            'nameEn', bpe.product_name_en,
            'nameAr', bpe.product_name_ar,
            'image', bpe.image_url,
            'price', bpe.price,
            'quantity', bpe.req_quantity,
            'unitQty', bpe.unit_qty,
            'unitEn', bpe.unit_en,
            'unitAr', bpe.unit_ar,
            'stock', bpe.stock,
            'barcode', bpe.barcode
          )
        ),
        'originalBundlePrice', SUM(bpe.price * bpe.req_quantity),
        'bundlePrice', CASE
          WHEN bpe.discount_type = 'percentage' THEN
            SUM(bpe.price * bpe.req_quantity) * (1 - bpe.discount_value::float / 100)
          WHEN bpe.discount_type = 'amount' THEN
            bpe.discount_value::float
          ELSE
            GREATEST(0, SUM(bpe.price * bpe.req_quantity) - bpe.discount_value::float)
        END,
        'savings', CASE
          WHEN bpe.discount_type = 'percentage' THEN
            SUM(bpe.price * bpe.req_quantity) * (bpe.discount_value::float / 100)
          WHEN bpe.discount_type = 'amount' THEN
            SUM(bpe.price * bpe.req_quantity) - bpe.discount_value::float
          ELSE
            bpe.discount_value::float
        END,
        'discountType', bpe.discount_type,
        'discountValue', bpe.discount_value::float,
        'offerEndDate', bpe.end_date,
        'isExpiringSoon', bpe.is_expiring_soon
      ) AS bundle_card
    FROM bundle_products_expanded bpe
    GROUP BY bpe.bundle_id, bpe.offer_id, bpe.offer_name_en, bpe.offer_name_ar,
             bpe.bundle_name_en, bpe.bundle_name_ar, bpe.discount_type,
             bpe.discount_value, bpe.end_date, bpe.is_expiring_soon
  )

  -- Final: Build the complete result
  SELECT json_build_object(
    'products', COALESCE((SELECT json_agg(
      json_build_object(
        'id', cp.id,
        'barcode', cp.barcode,
        'nameEn', cp."nameEn",
        'nameAr', cp."nameAr",
        'category', cp.category,
        'categoryNameEn', cp."categoryNameEn",
        'categoryNameAr', cp."categoryNameAr",
        'image', cp.image,
        'stock', cp.stock,
        'lowStockThreshold', cp."lowStockThreshold",
        'unitEn', cp."unitEn",
        'unitAr', cp."unitAr",
        'unitQty', cp."unitQty",
        'originalPrice', cp."originalPrice",
        'offerPrice', cp."offerPrice",
        'savings', cp.savings,
        'discountPercentage', cp."discountPercentage",
        'hasOffer', cp."hasOffer",
        'offerType', cp."offerType",
        'offerId', cp."offerId",
        'offerNameEn', cp."offerNameEn",
        'offerNameAr', cp."offerNameAr",
        'offerQty', cp."offerQty",
        'maxUses', cp."maxUses",
        'offerEndDate', cp."offerEndDate",
        'isExpiringSoon', cp."isExpiringSoon"
      )
    ) FROM combined_products cp), '[]'::json),
    'bogoOffers', COALESCE((SELECT json_agg(bc.bogo_card) FROM bogo_cards bc), '[]'::json),
    'bundleOffers', COALESCE((SELECT json_agg(bc.bundle_card) FROM bundle_cards bc), '[]'::json),
    'offersCount', (SELECT COUNT(*) FROM active_offers)
  ) INTO v_result;

  RETURN v_result;
END;
$$;



--
-- Name: get_customer_requests_with_details(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_customer_requests_with_details() RETURNS TABLE(id uuid, requester_user_id uuid, branch_id integer, target_user_id uuid, status text, items jsonb, notes text, created_at timestamp with time zone, updated_at timestamp with time zone, requester_name_en text, requester_name_ar text, target_name_en text, target_name_ar text, branch_name_en text, branch_name_ar text, branch_location_en text, branch_location_ar text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        r.id,
        r.requester_user_id,
        r.branch_id,
        r.target_user_id,
        r.status,
        r.items,
        r.notes,
        r.created_at,
        r.updated_at,
        COALESCE(req.name_en, req.user_id::TEXT)::TEXT AS requester_name_en,
        COALESCE(req.name_ar, req.name_en, req.user_id::TEXT)::TEXT AS requester_name_ar,
        COALESCE(tgt.name_en, tgt.user_id::TEXT)::TEXT AS target_name_en,
        COALESCE(tgt.name_ar, tgt.name_en, tgt.user_id::TEXT)::TEXT AS target_name_ar,
        COALESCE(b.name_en, '')::TEXT AS branch_name_en,
        COALESCE(b.name_ar, b.name_en, '')::TEXT AS branch_name_ar,
        COALESCE(b.location_en, '')::TEXT AS branch_location_en,
        COALESCE(b.location_ar, b.location_en, '')::TEXT AS branch_location_ar
    FROM customer_product_requests r
    LEFT JOIN hr_employee_master req ON req.user_id = r.requester_user_id
    LEFT JOIN hr_employee_master tgt ON tgt.user_id = r.target_user_id
    LEFT JOIN branches b ON b.id = r.branch_id
    ORDER BY r.created_at DESC;
END;
$$;



--
-- Name: get_customers_list(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_customers_list() RETURNS TABLE(id uuid, name text, access_code text, whatsapp_number text, registration_status text, registration_notes text, approved_by uuid, approved_at timestamp with time zone, access_code_generated_at timestamp with time zone, last_login_at timestamp with time zone, created_at timestamp with time zone, updated_at timestamp with time zone, location1_name text, location1_url text, location1_lat double precision, location1_lng double precision, location2_name text, location2_url text, location2_lat double precision, location2_lng double precision, location3_name text, location3_url text, location3_lat double precision, location3_lng double precision, is_deleted boolean)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    c.id,
    c.name,
    c.access_code,
    c.whatsapp_number::text,
    c.registration_status,
    c.registration_notes,
    c.approved_by,
    c.approved_at,
    c.access_code_generated_at,
    c.last_login_at,
    c.created_at,
    c.updated_at,
    c.location1_name,
    c.location1_url,
    c.location1_lat,
    c.location1_lng,
    c.location2_name,
    c.location2_url,
    c.location2_lat,
    c.location2_lng,
    c.location3_name,
    c.location3_url,
    c.location3_lat,
    c.location3_lng,
    c.is_deleted
  FROM customers c
  ORDER BY
    CASE
      WHEN c.registration_status = 'pending' THEN 1
      WHEN c.registration_status = 'approved' THEN 2
      WHEN c.registration_status = 'rejected' THEN 3
      WHEN c.registration_status = 'suspended' THEN 4
      ELSE 5
    END,
    c.created_at DESC;
END;
$$;



--
-- Name: get_customers_list_paginated(text, text, integer, integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_customers_list_paginated(p_search text DEFAULT ''::text, p_status text DEFAULT 'all'::text, p_limit integer DEFAULT 50, p_offset integer DEFAULT 0) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  result json;
  total_count bigint;
  rows_data json;
BEGIN
  -- Get total count with filters
  SELECT count(*)
  INTO total_count
  FROM customers c
  WHERE
    (p_status = 'all' OR c.registration_status = p_status)
    AND (
      p_search = '' 
      OR c.name ILIKE '%' || p_search || '%'
      OR c.whatsapp_number ILIKE '%' || p_search || '%'
    );

  -- Get paginated rows
  SELECT json_agg(row_data)
  INTO rows_data
  FROM (
    SELECT
      c.id,
      c.name,
      c.access_code,
      c.whatsapp_number::text,
      c.registration_status,
      c.registration_notes,
      c.approved_by,
      c.approved_at,
      c.access_code_generated_at,
      c.last_login_at,
      c.created_at,
      c.updated_at,
      c.location1_name,
      c.location1_url,
      c.location1_lat,
      c.location1_lng,
      c.location2_name,
      c.location2_url,
      c.location2_lat,
      c.location2_lng,
      c.location3_name,
      c.location3_url,
      c.location3_lat,
      c.location3_lng,
      c.is_deleted
    FROM customers c
    WHERE
      (p_status = 'all' OR c.registration_status = p_status)
      AND (
        p_search = '' 
        OR c.name ILIKE '%' || p_search || '%'
        OR c.whatsapp_number ILIKE '%' || p_search || '%'
      )
    ORDER BY
      CASE
        WHEN c.registration_status = 'pending' THEN 1
        WHEN c.registration_status = 'approved' THEN 2
        WHEN c.registration_status = 'rejected' THEN 3
        WHEN c.registration_status = 'suspended' THEN 4
        ELSE 5
      END,
      c.created_at DESC
    LIMIT p_limit
    OFFSET p_offset
  ) row_data;

  -- Build result JSON
  result := json_build_object(
    'data', COALESCE(rows_data, '[]'::json),
    'total', total_count
  );

  RETURN result;
END;
$$;



--
-- Name: get_database_functions(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_database_functions() RETURNS TABLE(func_name text, func_args text, return_type text, func_language text, func_type text, is_security_definer boolean, func_definition text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $_$
DECLARE
  rec RECORD;
  ddl text;
  arg_list text;
  ret text;
BEGIN
  FOR rec IN
    SELECT
      p.oid,
      p.proname::text AS fname,
      pg_get_function_arguments(p.oid) AS fargs,
      pg_get_function_result(p.oid) AS fresult,
      l.lanname::text AS flang,
      CASE p.prokind
        WHEN 'f' THEN 'FUNCTION'
        WHEN 'p' THEN 'PROCEDURE'
        WHEN 'a' THEN 'AGGREGATE'
        WHEN 'w' THEN 'WINDOW'
        ELSE 'FUNCTION'
      END AS ftype,
      p.prosecdef AS secdef,
      p.prosrc AS fsrc,
      p.proretset,
      p.provolatile,
      p.proisstrict
    FROM pg_proc p
    JOIN pg_namespace n ON n.oid = p.pronamespace
    JOIN pg_language l ON l.oid = p.prolang
    WHERE n.nspname = 'public'
    ORDER BY p.proname
  LOOP
    -- Build CREATE OR REPLACE
    ddl := 'CREATE OR REPLACE ' || rec.ftype || ' public.' || quote_ident(rec.fname) || '(' || rec.fargs || ')' || E'\n';
    ddl := ddl || 'RETURNS ' || rec.fresult || E'\n';
    ddl := ddl || 'LANGUAGE ' || rec.flang || E'\n';

    -- Volatility
    IF rec.provolatile = 'i' THEN
      ddl := ddl || 'IMMUTABLE' || E'\n';
    ELSIF rec.provolatile = 's' THEN
      ddl := ddl || 'STABLE' || E'\n';
    END IF;

    IF rec.proisstrict THEN
      ddl := ddl || 'STRICT' || E'\n';
    END IF;

    IF rec.secdef THEN
      ddl := ddl || 'SECURITY DEFINER' || E'\n';
    END IF;

    ddl := ddl || 'AS $func$' || E'\n' || rec.fsrc || E'\n' || '$func$;';

    func_name := rec.fname;
    func_args := rec.fargs;
    return_type := rec.fresult;
    func_language := rec.flang;
    func_type := rec.ftype;
    is_security_definer := rec.secdef;
    func_definition := ddl;
    RETURN NEXT;
  END LOOP;
END;
$_$;



--
-- Name: get_database_schema(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_database_schema() RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  result jsonb;
BEGIN
  -- Get basic table and column information only
  SELECT jsonb_build_object(
    'tables', jsonb_agg(
      jsonb_build_object(
        'table_name', table_info.table_name,
        'columns', table_info.columns
      ) ORDER BY table_info.table_name
    )
  ) INTO result
  FROM (
    SELECT 
      t.table_name,
      jsonb_agg(
        jsonb_build_object(
          'column_name', c.column_name,
          'data_type', c.data_type,
          'is_nullable', c.is_nullable,
          'column_default', c.column_default
        ) ORDER BY c.ordinal_position
      ) as columns
    FROM information_schema.tables t
    LEFT JOIN information_schema.columns c 
      ON c.table_schema = t.table_schema 
      AND c.table_name = t.table_name
    WHERE t.table_schema = 'public'
      AND t.table_type = 'BASE TABLE'
    GROUP BY t.table_name
  ) as table_info;

  RETURN result;
END;
$$;



--
-- Name: get_database_triggers(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_database_triggers() RETURNS TABLE(trigger_name text, event_manipulation text, event_object_table text, action_statement text, action_timing text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        tg.trigger_name::text,
        tg.event_manipulation::text,
        tg.event_object_table::text,
        tg.action_statement::text,
        tg.action_timing::text
    FROM information_schema.triggers tg
    WHERE tg.trigger_schema = 'public'
    ORDER BY tg.event_object_table, tg.trigger_name;
END;
$$;



--
-- Name: get_day_offs_with_details(date, date); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_day_offs_with_details(p_date_from date, p_date_to date) RETURNS TABLE(id text, employee_id text, employee_id_number text, employee_name_en text, employee_name_ar text, employee_email text, employee_whatsapp text, branch_id text, branch_name_en text, branch_name_ar text, branch_location_en text, branch_location_ar text, nationality_id text, nationality_name_en text, nationality_name_ar text, sponsorship_status text, employment_status text, day_off_date date, approval_status text, reason_en text, reason_ar text, document_url text, description text, is_deductible_on_salary boolean, approval_requested_at timestamp with time zone, day_off_reason_id text, approver_name_en text, approver_name_ar text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        d.id::TEXT,
        d.employee_id::TEXT,
        COALESCE(e.id_number, '')::TEXT AS employee_id_number,
        COALESCE(e.name_en, 'N/A')::TEXT AS employee_name_en,
        COALESCE(e.name_ar, 'N/A')::TEXT AS employee_name_ar,
        COALESCE(e.email, '')::TEXT AS employee_email,
        COALESCE(e.whatsapp_number, '')::TEXT AS employee_whatsapp,
        e.current_branch_id::TEXT AS branch_id,
        COALESCE(b.name_en, 'N/A')::TEXT AS branch_name_en,
        COALESCE(b.name_ar, 'N/A')::TEXT AS branch_name_ar,
        COALESCE(b.location_en, '')::TEXT AS branch_location_en,
        COALESCE(b.location_ar, '')::TEXT AS branch_location_ar,
        e.nationality_id::TEXT,
        COALESCE(n.name_en, 'N/A')::TEXT AS nationality_name_en,
        COALESCE(n.name_ar, 'N/A')::TEXT AS nationality_name_ar,
        e.sponsorship_status::TEXT,
        e.employment_status::TEXT,
        d.day_off_date,
        COALESCE(d.approval_status, 'pending')::TEXT AS approval_status,
        COALESCE(r.reason_en, 'N/A')::TEXT AS reason_en,
        COALESCE(r.reason_ar, 'N/A')::TEXT AS reason_ar,
        d.document_url::TEXT,
        d.description::TEXT,
        COALESCE(d.is_deductible_on_salary, false) AS is_deductible_on_salary,
        d.approval_requested_at,
        d.day_off_reason_id::TEXT,
        COALESCE(a.name_en, '')::TEXT AS approver_name_en,
        COALESCE(a.name_ar, '')::TEXT AS approver_name_ar
    FROM day_off d
    LEFT JOIN hr_employee_master e ON e.id = d.employee_id
    LEFT JOIN branches b ON b.id = e.current_branch_id
    LEFT JOIN nationalities n ON n.id = e.nationality_id
    LEFT JOIN day_off_reasons r ON r.id = d.day_off_reason_id
    LEFT JOIN hr_employee_master a ON a.user_id = d.approval_approved_by
    WHERE d.day_off_date >= p_date_from
      AND d.day_off_date <= p_date_to
    ORDER BY d.day_off_date DESC;
END;
$$;



--
-- Name: get_default_flyer_template(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_default_flyer_template() RETURNS TABLE(id uuid, name character varying, description text, first_page_image_url text, sub_page_image_urls text[], first_page_configuration jsonb, sub_page_configurations jsonb, metadata jsonb)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    t.id,
    t.name,
    t.description,
    t.first_page_image_url,
    t.sub_page_image_urls,
    t.first_page_configuration,
    t.sub_page_configurations,
    t.metadata
  FROM flyer_templates t
  WHERE t.is_default = true 
    AND t.is_active = true 
    AND t.deleted_at IS NULL
  LIMIT 1;
END;
$$;



--
-- Name: get_delivery_fee_for_amount(numeric); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_delivery_fee_for_amount(order_amount numeric) RETURNS numeric
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    calculated_fee numeric;
BEGIN
    -- Find the appropriate tier for the given order amount
    SELECT delivery_fee INTO calculated_fee
    FROM public.delivery_fee_tiers
    WHERE is_active = true
      AND min_order_amount <= order_amount
      AND (max_order_amount IS NULL OR max_order_amount >= order_amount)
    ORDER BY min_order_amount DESC
    LIMIT 1;
    
    -- If no tier found, return 0 (shouldn't happen with proper setup)
    RETURN COALESCE(calculated_fee, 0);
END;
$$;



--
-- Name: FUNCTION get_delivery_fee_for_amount(order_amount numeric); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.get_delivery_fee_for_amount(order_amount numeric) IS 'Calculate delivery fee based on order amount using active tier structure';


--
-- Name: get_delivery_fee_for_amount_by_branch(bigint, numeric); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_delivery_fee_for_amount_by_branch(p_branch_id bigint, p_order_amount numeric) RETURNS numeric
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_fee numeric;
BEGIN
    -- Require a branch id; without it, no fee can be determined
    IF p_branch_id IS NULL THEN
        RETURN 0;
    END IF;

    -- Attempt branch-specific tier match
    SELECT t.delivery_fee INTO v_fee
    FROM public.delivery_fee_tiers t
    WHERE t.is_active = true
      AND t.branch_id = p_branch_id
      AND t.min_order_amount <= p_order_amount
      AND (t.max_order_amount IS NULL OR t.max_order_amount >= p_order_amount)
    ORDER BY t.min_order_amount DESC
    LIMIT 1;

    RETURN COALESCE(v_fee, 0);
END;
$$;



--
-- Name: FUNCTION get_delivery_fee_for_amount_by_branch(p_branch_id bigint, p_order_amount numeric); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.get_delivery_fee_for_amount_by_branch(p_branch_id bigint, p_order_amount numeric) IS 'Calculate delivery fee for order amount using branch tiers only';


--
-- Name: get_delivery_service_settings(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_delivery_service_settings() RETURNS TABLE(minimum_order_amount numeric, is_24_hours boolean, operating_start_time time without time zone, operating_end_time time without time zone, is_active boolean, display_message_ar text, display_message_en text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        s.minimum_order_amount,
        s.is_24_hours,
        s.operating_start_time,
        s.operating_end_time,
        s.is_active,
        s.display_message_ar,
        s.display_message_en
    FROM public.delivery_service_settings s
    WHERE s.id = '00000000-0000-0000-0000-000000000001'::uuid
    LIMIT 1;
END;
$$;



--
-- Name: FUNCTION get_delivery_service_settings(); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.get_delivery_service_settings() IS 'Get global delivery service configuration settings';


--
-- Name: get_delivery_tiers_by_branch(bigint); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_delivery_tiers_by_branch(p_branch_id bigint) RETURNS TABLE(id uuid, branch_id bigint, min_order_amount numeric, max_order_amount numeric, delivery_fee numeric, tier_order integer, is_active boolean, description_en text, description_ar text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    -- Strictly branch-specific tiers; if branch_id is NULL, return empty set
    IF p_branch_id IS NULL THEN
        RETURN;
    END IF;

    RETURN QUERY
    SELECT 
        t.id,
        t.branch_id,
        t.min_order_amount,
        t.max_order_amount,
        t.delivery_fee,
        t.tier_order,
        t.is_active,
        t.description_en,
        t.description_ar
    FROM public.delivery_fee_tiers t
    WHERE t.is_active = true
      AND t.branch_id = p_branch_id
    ORDER BY t.tier_order ASC;
END;
$$;



--
-- Name: FUNCTION get_delivery_tiers_by_branch(p_branch_id bigint); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.get_delivery_tiers_by_branch(p_branch_id bigint) IS 'Get active delivery fee tiers for a specific branch only';


--
-- Name: get_dependency_completion_photos(uuid, text[]); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_dependency_completion_photos(receiving_record_id_param uuid, dependency_role_types text[]) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  result_photos JSONB := '{}'::JSONB;
  current_role_type TEXT;
  task_record RECORD;
BEGIN
  -- Loop through each dependency role type
  FOREACH current_role_type IN ARRAY dependency_role_types
  LOOP
    -- Get the completion photo for this role type
    SELECT completion_photo_url, role_type INTO task_record
    FROM receiving_tasks
    WHERE receiving_record_id = receiving_record_id_param
      AND role_type = current_role_type
      AND task_completed = true
      AND completion_photo_url IS NOT NULL
    LIMIT 1;
    
    -- If photo exists, add it to the result
    IF FOUND AND task_record.completion_photo_url IS NOT NULL THEN
      result_photos := result_photos || jsonb_build_object(
        current_role_type, task_record.completion_photo_url
      );
    END IF;
  END LOOP;
  
  -- Convert JSONB to JSON for return
  RETURN result_photos::JSON;
  
EXCEPTION WHEN OTHERS THEN
  -- Return empty object on error
  RETURN '{}'::JSON;
END;
$$;



--
-- Name: get_edge_function_logs(integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_edge_function_logs(p_limit integer DEFAULT 100) RETURNS TABLE(runid bigint, jobname text, status text, return_message text, start_time timestamp with time zone, end_time timestamp with time zone, duration_ms double precision)
    LANGUAGE sql SECURITY DEFINER
    AS $$
  SELECT 
    d.runid,
    j.jobname,
    d.status,
    d.return_message,
    d.start_time,
    d.end_time,
    EXTRACT(EPOCH FROM (d.end_time - d.start_time)) * 1000 as duration_ms
  FROM cron.job_run_details d
  JOIN cron.job j ON j.jobid = d.jobid
  ORDER BY d.start_time DESC
  LIMIT p_limit;
$$;



--
-- Name: get_edge_functions(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_edge_functions() RETURNS TABLE(func_name text, func_size text, file_count integer, last_modified timestamp with time zone, has_index boolean, func_code text)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT func_name, func_size, file_count, last_modified, has_index, func_code
  FROM public.edge_functions_cache
  ORDER BY func_name;
$$;



--
-- Name: get_employee_basic_hours(bigint); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_employee_basic_hours(p_employee_id bigint) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
    emp_basic_hours DECIMAL(4,2);
BEGIN
    SELECT basic_hours INTO emp_basic_hours
    FROM employee_basic_hours 
    WHERE employee_id = p_employee_id;
    
    -- Return employee-specific hours or default to 8.0
    RETURN COALESCE(emp_basic_hours, 8.0);
END;
$$;



--
-- Name: get_employee_basic_hours(uuid, date); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_employee_basic_hours(p_employee_id uuid, p_date date DEFAULT CURRENT_DATE) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
    basic_hours DECIMAL(4,2);
BEGIN
    SELECT ebh.basic_hours_per_day
    INTO basic_hours
    FROM employee_basic_hours ebh
    WHERE ebh.employee_id = p_employee_id
      AND ebh.is_active = true
      AND p_date >= ebh.effective_from
      AND (ebh.effective_to IS NULL OR p_date <= ebh.effective_to)
    ORDER BY ebh.effective_from DESC
    LIMIT 1;
    
    RETURN COALESCE(basic_hours, 8.0); -- Default to 8 hours if not configured
END;
$$;



--
-- Name: get_employee_document_category_stats(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_employee_document_category_stats(emp_id uuid) RETURNS TABLE(category public.document_category_enum, count bigint, total_days integer, latest_date timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        d.document_category::document_category_enum,
        COUNT(*)::BIGINT,
        SUM(COALESCE(d.category_days, 0))::INTEGER,
        MAX(d.upload_date)
    FROM hr_employee_documents d
    WHERE d.employee_id = emp_id 
      AND d.is_active = true 
      AND d.document_category IS NOT NULL
    GROUP BY d.document_category;
END;
$$;



--
-- Name: get_employee_products(text, integer, integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_employee_products(p_employee_id text, p_limit integer DEFAULT 1000, p_offset integer DEFAULT 0) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_result JSON;
BEGIN
  SELECT json_build_object(
    'products', COALESCE((
      SELECT json_agg(row_to_json(t))
      FROM (
        SELECT 
          barcode, 
          product_name_en, 
          product_name_ar, 
          parent_barcode,
          expiry_dates,
          managed_by
        FROM erp_synced_products
        WHERE managed_by @> ('[{"employee_id":"' || p_employee_id || '"}]')::jsonb
        ORDER BY product_name_en
        LIMIT p_limit
        OFFSET p_offset
      ) t
    ), '[]'::json),
    'total_count', (
      SELECT count(*)
      FROM erp_synced_products
      WHERE managed_by @> ('[{"employee_id":"' || p_employee_id || '"}]')::jsonb
    )
  ) INTO v_result;

  RETURN v_result;
END;
$$;



--
-- Name: get_employee_schedules(bigint, date, date); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_employee_schedules(p_employee_id bigint, p_start_date date, p_end_date date) RETURNS TABLE(schedule_id bigint, schedule_date date, start_time time without time zone, end_time time without time zone, hours numeric, is_overnight boolean, is_auto boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ds.id,
        ds.schedule_date,
        ds.scheduled_start_time,
        ds.scheduled_end_time,
        ds.scheduled_hours,
        ds.is_overnight,
        ds.is_auto_generated
    FROM duty_schedules ds
    WHERE ds.employee_id = p_employee_id
      AND ds.schedule_date >= p_start_date
      AND ds.schedule_date <= p_end_date
    ORDER BY ds.schedule_date;
END;
$$;



--
-- Name: get_employee_schedules(uuid, date, date); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_employee_schedules(p_employee_id uuid, p_start_date date, p_end_date date) RETURNS TABLE(schedule_id uuid, schedule_date date, start_time time without time zone, end_time time without time zone, hours numeric, is_overnight boolean, is_auto boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ds.id,
        ds.schedule_date,
        ds.scheduled_start_time,
        ds.scheduled_end_time,
        ds.scheduled_hours,
        ds.is_overnight,
        ds.is_auto_generated
    FROM duty_schedules ds
    WHERE ds.employee_id = p_employee_id
      AND ds.schedule_date >= p_start_date
      AND ds.schedule_date <= p_end_date
    ORDER BY ds.schedule_date;
END;
$$;



--
-- Name: get_expense_category_stats(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_expense_category_stats() RETURNS TABLE(total_parent_categories integer, enabled_parent_categories integer, disabled_parent_categories integer, total_sub_categories integer, enabled_sub_categories integer, disabled_sub_categories integer, vat_applicable_categories integer, vat_not_applicable_categories integer, both_vat_categories integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        (SELECT COUNT(*)::INT FROM expense_parent_categories) as total_parent_categories,
        (SELECT COUNT(*)::INT FROM expense_parent_categories WHERE is_enabled = true) as enabled_parent_categories,
        (SELECT COUNT(*)::INT FROM expense_parent_categories WHERE is_enabled = false) as disabled_parent_categories,
        COUNT(*)::INT as total_sub_categories,
        COUNT(*) FILTER (WHERE is_enabled = true)::INT as enabled_sub_categories,
        COUNT(*) FILTER (WHERE is_enabled = false)::INT as disabled_sub_categories,
        COUNT(*) FILTER (WHERE vat_applicable = true AND vat_not_applicable = false)::INT as vat_applicable_categories,
        COUNT(*) FILTER (WHERE vat_applicable = false AND vat_not_applicable = true)::INT as vat_not_applicable_categories,
        COUNT(*) FILTER (WHERE vat_applicable = true AND vat_not_applicable = true)::INT as both_vat_categories
    FROM expense_categories;
END;
$$;



--
-- Name: get_expiring_products_count(text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_expiring_products_count(p_employee_id text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_branch_id INTEGER;
  v_count INTEGER := 0;
BEGIN
  -- Get employee's current branch
  SELECT current_branch_id INTO v_branch_id
  FROM hr_employee_master
  WHERE id = p_employee_id;

  IF v_branch_id IS NULL THEN
    RETURN jsonb_build_object('count', 0);
  END IF;

  -- Count products managed by this employee where expiry for their branch is < 15 days from now
  SELECT COUNT(DISTINCT p.barcode)
  INTO v_count
  FROM erp_synced_products p,
       LATERAL jsonb_array_elements(COALESCE(p.expiry_dates, '[]'::jsonb)) AS ed
  WHERE p.managed_by @> ('[{"employee_id":"' || p_employee_id || '"}]')::jsonb
    AND (ed->>'branch_id')::INTEGER = v_branch_id
    AND (ed->>'expiry_date') IS NOT NULL
    AND (ed->>'expiry_date')::DATE >= CURRENT_DATE
    AND (ed->>'expiry_date')::DATE < (CURRENT_DATE + INTERVAL '15 days');

  RETURN jsonb_build_object('count', v_count);
END;
$$;



--
-- Name: get_file_extension(text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_file_extension(filename text) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN lower(split_part(filename, '.', array_length(string_to_array(filename, '.'), 1)));
END;
$$;



--
-- Name: get_flyer_generator_data(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_flyer_generator_data(p_offer_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  result jsonb;
BEGIN
  WITH 
  -- Step 1: Get all offer products for this offer
  offer_products AS (
    SELECT 
      fop.id,
      fop.offer_id,
      fop.product_barcode,
      fop.cost,
      fop.sales_price,
      fop.offer_price,
      fop.profit_amount,
      fop.profit_percent,
      fop.profit_after_offer,
      fop.decrease_amount,
      fop.offer_qty,
      fop.limit_qty,
      fop.free_qty,
      fop.created_at,
      fop.page_number,
      fop.page_order,
      fop.total_sales_price,
      fop.total_offer_price
    FROM flyer_offer_products fop
    WHERE fop.offer_id = p_offer_id
  ),
  -- Step 2: Get product details for all barcodes in the offer
  product_details AS (
    SELECT 
      p.barcode,
      p.product_name_en,
      p.product_name_ar,
      p.image_url,
      p.is_variation,
      p.parent_product_barcode,
      p.variation_group_name_en,
      p.variation_group_name_ar,
      p.variation_image_override,
      p.variation_order,
      pu.name_ar AS unit_name_ar,
      pu.name_en AS unit_name_en
    FROM products p
    LEFT JOIN product_units pu ON p.unit_id = pu.id
    WHERE p.barcode IN (SELECT product_barcode FROM offer_products)
  ),
  -- Step 3: Get variation images for all variations in the offer
  -- (grouped by parent_product_barcode)
  variation_images AS (
    SELECT 
      p.parent_product_barcode,
      jsonb_agg(
        jsonb_build_object(
          'barcode', p.barcode,
          'image_url', p.image_url,
          'variation_order', COALESCE(p.variation_order, 0)
        ) ORDER BY COALESCE(p.variation_order, 0)
      ) AS images
    FROM products p
    WHERE p.is_variation = true
      AND p.parent_product_barcode IS NOT NULL
      AND p.barcode IN (SELECT product_barcode FROM offer_products)
    GROUP BY p.parent_product_barcode
  ),
  -- Step 4: Build combined result for each offer product
  combined AS (
    SELECT 
      jsonb_build_object(
        'id', op.id,
        'offer_id', op.offer_id,
        'product_barcode', op.product_barcode,
        'cost', op.cost,
        'sales_price', op.sales_price,
        'offer_price', op.offer_price,
        'profit_amount', op.profit_amount,
        'profit_percent', op.profit_percent,
        'profit_after_offer', op.profit_after_offer,
        'decrease_amount', op.decrease_amount,
        'offer_qty', op.offer_qty,
        'limit_qty', op.limit_qty,
        'free_qty', op.free_qty,
        'created_at', op.created_at,
        'page_number', COALESCE(op.page_number, 1),
        'page_order', COALESCE(op.page_order, 1),
        'total_sales_price', op.total_sales_price,
        'total_offer_price', op.total_offer_price,
        'product_name_en', COALESCE(pd.product_name_en, ''),
        'product_name_ar', COALESCE(pd.product_name_ar, ''),
        'unit_name', COALESCE(pd.unit_name_ar, ''),
        'image_url', COALESCE(pd.image_url, pd.variation_image_override),
        'is_variation', COALESCE(pd.is_variation, false),
        'parent_product_barcode', pd.parent_product_barcode,
        'variation_group_name_en', pd.variation_group_name_en,
        'variation_group_name_ar', pd.variation_group_name_ar,
        'variation_order', pd.variation_order,
        'variation_images', COALESCE(vi.images, '[]'::jsonb)
      ) AS product_data
    FROM offer_products op
    LEFT JOIN product_details pd ON pd.barcode = op.product_barcode
    LEFT JOIN variation_images vi ON vi.parent_product_barcode = op.product_barcode
                                  OR vi.parent_product_barcode = pd.parent_product_barcode
  )
  SELECT jsonb_build_object(
    'products', COALESCE(jsonb_agg(c.product_data), '[]'::jsonb)
  )
  INTO result
  FROM combined c;

  RETURN COALESCE(result, jsonb_build_object('products', '[]'::jsonb));
END;
$$;



--
-- Name: get_incident_manager_data(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_incident_manager_data() RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_result JSONB;
BEGIN
    SELECT jsonb_agg(incident_row ORDER BY 
        CASE WHEN (incident_row->>'resolution_status') = 'resolved' THEN 1 ELSE 0 END ASC,
        (incident_row->>'created_at') DESC)
    INTO v_result
    FROM (
        SELECT jsonb_build_object(
            'id', i.id,
            'incident_type_id', i.incident_type_id,
            'employee_id', i.employee_id,
            'branch_id', i.branch_id,
            'violation_id', i.violation_id,
            'what_happened', i.what_happened,
            'witness_details', i.witness_details,
            'report_type', i.report_type,
            'reports_to_user_ids', i.reports_to_user_ids,
            'resolution_status', i.resolution_status::TEXT,
            'resolution_report', i.resolution_report,
            'user_statuses', i.user_statuses,
            'attachments', i.attachments,
            'investigation_report', i.investigation_report,
            'created_at', i.created_at,
            'created_by', i.created_by,
            -- Joined incident type
            'incident_types', CASE WHEN it.id IS NOT NULL THEN jsonb_build_object(
                'id', it.id,
                'incident_type_en', it.incident_type_en,
                'incident_type_ar', it.incident_type_ar
            ) ELSE NULL END,
            -- Joined warning violation
            'warning_violation', CASE WHEN wv.id IS NOT NULL THEN jsonb_build_object(
                'id', wv.id,
                'name_en', wv.name_en,
                'name_ar', wv.name_ar
            ) ELSE NULL END,
            -- Employee name (from hr_employee_master by employee_id = id)
            'employee_name_en', emp.name_en,
            'employee_name_ar', emp.name_ar,
            -- Branch info
            'branch_name_en', b.name_en,
            'branch_name_ar', b.name_ar,
            'branch_location_en', b.location_en,
            'branch_location_ar', b.location_ar,
            -- Reporter name (from hr_employee_master by user_id = created_by)
            'reporter_name_en', reporter.name_en,
            'reporter_name_ar', reporter.name_ar,
            -- Claimed-by user name (parse from user_statuses JSONB - find user with claimed status)
            'claimed_by_name_en', (
                SELECT e.name_en
                FROM jsonb_each(i.user_statuses) AS us(user_id_str, status_obj)
                JOIN hr_employee_master e ON e.user_id = us.user_id_str::uuid
                WHERE status_obj->>'status' IN ('claimed', 'Claimed')
                LIMIT 1
            ),
            'claimed_by_name_ar', (
                SELECT e.name_ar
                FROM jsonb_each(i.user_statuses) AS us(user_id_str, status_obj)
                JOIN hr_employee_master e ON e.user_id = us.user_id_str::uuid
                WHERE status_obj->>'status' IN ('claimed', 'Claimed')
                LIMIT 1
            ),
            -- Report-to users with names (subquery)
            'report_to_users', (
                SELECT COALESCE(jsonb_agg(jsonb_build_object(
                    'user_id', rtu.user_id,
                    'name_en', rtu.name_en,
                    'name_ar', rtu.name_ar
                )), '[]'::JSONB)
                FROM hr_employee_master rtu
                WHERE rtu.user_id = ANY(i.reports_to_user_ids)
            ),
            -- Incident actions (subquery)
            'incident_actions', (
                SELECT COALESCE(jsonb_agg(
                    jsonb_build_object(
                        'id', ia.id,
                        'action_type', ia.action_type,
                        'recourse_type', ia.recourse_type,
                        'action_report', ia.action_report,
                        'has_fine', ia.has_fine,
                        'fine_amount', ia.fine_amount,
                        'fine_threat_amount', ia.fine_threat_amount,
                        'is_paid', ia.is_paid,
                        'paid_at', ia.paid_at,
                        'paid_by', ia.paid_by,
                        'employee_id', ia.employee_id,
                        'incident_id', ia.incident_id,
                        'incident_type_id', ia.incident_type_id,
                        'created_by', ia.created_by,
                        'created_at', ia.created_at,
                        'updated_at', ia.updated_at
                    ) ORDER BY ia.created_at DESC
                ), '[]'::JSONB)
                FROM incident_actions ia
                WHERE ia.incident_id = i.id
            )
        ) AS incident_row
        FROM incidents i
        LEFT JOIN incident_types it ON it.id = i.incident_type_id
        LEFT JOIN warning_violation wv ON wv.id = i.violation_id
        LEFT JOIN hr_employee_master emp ON emp.id = i.employee_id
        LEFT JOIN branches b ON b.id = i.branch_id
        LEFT JOIN hr_employee_master reporter ON reporter.user_id = i.created_by
    ) sub;

    RETURN COALESCE(v_result, '[]'::JSONB);
END;
$$;



--
-- Name: get_incomplete_receiving_tasks(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

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
-- Name: get_incomplete_receiving_tasks_breakdown(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_incomplete_receiving_tasks_breakdown() RETURNS TABLE(total_receiving_tasks integer, incomplete_receiving_tasks integer, missing_task_completions integer, incomplete_task_completions integer, tasks_not_completed integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    WITH stats AS (
        SELECT 
            COUNT(*) as total_tasks,
            COUNT(CASE WHEN rt.task_completed = false OR t.status != 'completed' THEN 1 END) as incomplete_tasks,
            COUNT(CASE WHEN tc.id IS NULL THEN 1 END) as missing_completions,
            COUNT(CASE WHEN tc.id IS NOT NULL AND tc.task_finished_completed = false THEN 1 END) as incomplete_completions,
            COUNT(CASE WHEN t.status != 'completed' THEN 1 END) as tasks_not_completed
        FROM receiving_tasks rt
        LEFT JOIN tasks t ON rt.task_id = t.id
        LEFT JOIN task_completions tc ON rt.task_id = tc.task_id AND rt.assignment_id = tc.assignment_id
    )
    SELECT 
        s.total_tasks::INTEGER,
        s.incomplete_tasks::INTEGER,
        s.missing_completions::INTEGER,
        s.incomplete_completions::INTEGER,
        s.tasks_not_completed::INTEGER
    FROM stats s;
END;
$$;



--
-- Name: get_incomplete_tasks(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_incomplete_tasks() RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_result json;
BEGIN
  SELECT json_build_object(
    'tasks', COALESCE(tasks_arr, '[]'::json),
    'total_count', COALESCE(json_array_length(tasks_arr), 0)
  ) INTO v_result
  FROM (
    SELECT json_agg(row_to_json(t) ORDER BY t.assigned_date DESC) as tasks_arr
    FROM (
      -- Task Assignments (incomplete)
      SELECT
        ta.id,
        'regular' as task_type,
        COALESCE(tk.title, 'Task Assignment #' || LEFT(ta.id::text, 8)) as task_title,
        COALESCE(tk.description, '') as task_description,
        ta.status,
        COALESCE(ta.priority_override, tk.priority, 'medium') as priority,
        COALESCE(b.name_en, 'No Branch') as branch_name,
        COALESCE(b.name_ar, b.name_en, 'No Branch') as branch_name_ar,
        ta.assigned_to_branch_id as branch_id,
        COALESCE(u_to.username, 'Unassigned') as assigned_to_name,
        COALESCE(e_to.name_en, u_to.username, 'Unassigned') as assigned_to_name_en,
        COALESCE(e_to.name_ar, e_to.name_en, u_to.username, 'Unassigned') as assigned_to_name_ar,
        ta.assigned_to_user_id,
        COALESCE(u_by.username, 'System') as assigned_by_name,
        ta.assigned_at as assigned_date,
        COALESCE(ta.deadline_datetime::text, ta.deadline_date::text) as deadline,
        ta.notes
      FROM task_assignments ta
      LEFT JOIN tasks tk ON tk.id = ta.task_id
      LEFT JOIN branches b ON b.id = ta.assigned_to_branch_id
      LEFT JOIN users u_to ON u_to.id = ta.assigned_to_user_id
      LEFT JOIN users u_by ON u_by.id = ta.assigned_by
      LEFT JOIN hr_employee_master e_to ON e_to.user_id = ta.assigned_to_user_id
      WHERE ta.status NOT IN ('completed', 'cancelled')

      UNION ALL

      -- Quick Task Assignments (incomplete)
      SELECT
        qta.id,
        'quick' as task_type,
        COALESCE(qt.title, 'Quick Task #' || LEFT(qta.id::text, 8)) as task_title,
        COALESCE(qt.description, '') as task_description,
        qta.status,
        COALESCE(qt.priority, 'medium') as priority,
        COALESCE(b.name_en, 'No Branch') as branch_name,
        COALESCE(b.name_ar, b.name_en, 'No Branch') as branch_name_ar,
        qt.assigned_to_branch_id as branch_id,
        COALESCE(u_to.username, 'Unassigned') as assigned_to_name,
        COALESCE(e_to.name_en, u_to.username, 'Unassigned') as assigned_to_name_en,
        COALESCE(e_to.name_ar, e_to.name_en, u_to.username, 'Unassigned') as assigned_to_name_ar,
        qta.assigned_to_user_id,
        COALESCE(u_by.username, 'System') as assigned_by_name,
        qta.created_at as assigned_date,
        qt.deadline_datetime::text as deadline,
        NULL as notes
      FROM quick_task_assignments qta
      JOIN quick_tasks qt ON qt.id = qta.quick_task_id
      LEFT JOIN branches b ON b.id = qt.assigned_to_branch_id
      LEFT JOIN users u_to ON u_to.id = qta.assigned_to_user_id
      LEFT JOIN users u_by ON u_by.id = qt.assigned_by
      LEFT JOIN hr_employee_master e_to ON e_to.user_id = qta.assigned_to_user_id
      WHERE qta.status NOT IN ('completed', 'cancelled')

      UNION ALL

      -- Receiving Tasks (incomplete)
      SELECT
        rt.id,
        'receiving' as task_type,
        COALESCE(rt.title, 'Receiving Task #' || LEFT(rt.id::text, 8)) as task_title,
        COALESCE(rt.description, '') as task_description,
        rt.task_status as status,
        COALESCE(rt.priority, 'medium') as priority,
        COALESCE(b.name_en, 'No Branch') as branch_name,
        COALESCE(b.name_ar, b.name_en, 'No Branch') as branch_name_ar,
        rr.branch_id as branch_id,
        COALESCE(u_to.username, 'Unassigned') as assigned_to_name,
        COALESCE(e_to.name_en, u_to.username, 'Unassigned') as assigned_to_name_en,
        COALESCE(e_to.name_ar, e_to.name_en, u_to.username, 'Unassigned') as assigned_to_name_ar,
        rt.assigned_user_id as assigned_to_user_id,
        COALESCE(u_by.username, 'System') as assigned_by_name,
        rt.created_at as assigned_date,
        rt.due_date::text as deadline,
        rt.completion_notes as notes
      FROM receiving_tasks rt
      LEFT JOIN receiving_records rr ON rr.id = rt.receiving_record_id
      LEFT JOIN branches b ON b.id = rr.branch_id
      LEFT JOIN users u_to ON u_to.id = rt.assigned_user_id
      LEFT JOIN users u_by ON u_by.id = rr.user_id
      LEFT JOIN hr_employee_master e_to ON e_to.user_id = rt.assigned_user_id
      WHERE rt.task_status NOT IN ('completed', 'cancelled')
    ) t
  ) sub;

  RETURN v_result;
END;
$$;



--
-- Name: get_issue_pv_vouchers(text, bigint); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_issue_pv_vouchers(p_pv_id text DEFAULT NULL::text, p_serial_number bigint DEFAULT NULL::bigint) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  result jsonb;
BEGIN
  IF p_pv_id IS NULL AND p_serial_number IS NULL THEN
    RETURN '[]'::jsonb;
  END IF;

  SELECT COALESCE(jsonb_agg(row_to_json(t)), '[]'::jsonb)
  INTO result
  FROM (
    SELECT
      pvi.id,
      pvi.purchase_voucher_id,
      pvi.serial_number,
      pvi.value,
      pvi.stock,
      pvi.status,
      pvi.issue_type,
      pvi.stock_location,
      pvi.stock_person,
      COALESCE(b.name_en || ' - ' || b.location_en, '') as stock_location_name,
      COALESCE(
        u.username || ' - ' || emp.name_en,
        u.username,
        ''
      ) as stock_person_name
    FROM purchase_voucher_items pvi
    LEFT JOIN branches b ON b.id = pvi.stock_location
    LEFT JOIN users u ON u.id = pvi.stock_person
    LEFT JOIN hr_employee_master emp ON emp.id = u.employee_id::text
    WHERE pvi.issue_type = 'not issued'
      AND (p_pv_id IS NULL OR pvi.purchase_voucher_id = p_pv_id)
      AND (p_serial_number IS NULL OR pvi.serial_number = p_serial_number)
    ORDER BY pvi.serial_number
  ) t;

  RETURN result;
END;
$$;



--
-- Name: get_latest_frontend_build(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_latest_frontend_build() RETURNS TABLE(id integer, version text, file_name text, file_size bigint, storage_path text, notes text, created_at timestamp with time zone, download_url text)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    SELECT 
        fb.id,
        fb.version,
        fb.file_name,
        fb.file_size,
        fb.storage_path,
        fb.notes,
        fb.created_at,
        '/storage/v1/object/public/frontend-builds/' || fb.storage_path as download_url
    FROM public.frontend_builds fb
    ORDER BY fb.created_at DESC
    LIMIT 1;
$$;



--
-- Name: get_lease_rent_properties_with_spaces(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_lease_rent_properties_with_spaces() RETURNS TABLE(property_id uuid, property_name_en character varying, property_name_ar character varying, property_location_en character varying, property_location_ar character varying, property_is_leased boolean, property_is_rented boolean, space_id uuid, space_number character varying)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.id AS property_id,
        p.name_en AS property_name_en,
        p.name_ar AS property_name_ar,
        p.location_en AS property_location_en,
        p.location_ar AS property_location_ar,
        p.is_leased AS property_is_leased,
        p.is_rented AS property_is_rented,
        s.id AS space_id,
        s.space_number AS space_number
    FROM lease_rent_properties p
    LEFT JOIN lease_rent_property_spaces s ON s.property_id = p.id
    ORDER BY p.name_en, s.space_number;
END;
$$;



--
-- Name: get_lease_rent_tab_data(text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_lease_rent_tab_data(p_party_type text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    parties_json JSON;
    changes_json JSON;
BEGIN
    IF p_party_type = 'lease' THEN
        SELECT COALESCE(json_agg(sub ORDER BY sub.party_name_en), '[]'::json) INTO parties_json
        FROM (
            SELECT lp.*,
                json_build_object('name_en', prop.name_en, 'name_ar', prop.name_ar) as property,
                json_build_object('space_number', sp.space_number) as space
            FROM lease_rent_lease_parties lp
            LEFT JOIN lease_rent_properties prop ON prop.id = lp.property_id
            LEFT JOIN lease_rent_property_spaces sp ON sp.id = lp.property_space_id
        ) sub;
    ELSIF p_party_type = 'rent' THEN
        SELECT COALESCE(json_agg(sub ORDER BY sub.party_name_en), '[]'::json) INTO parties_json
        FROM (
            SELECT rp.*,
                json_build_object('name_en', prop.name_en, 'name_ar', prop.name_ar) as property,
                json_build_object('space_number', sp.space_number) as space
            FROM lease_rent_rent_parties rp
            LEFT JOIN lease_rent_properties prop ON prop.id = rp.property_id
            LEFT JOIN lease_rent_property_spaces sp ON sp.id = rp.property_space_id
        ) sub;
    ELSE
        parties_json := '[]'::json;
    END IF;
    SELECT COALESCE(json_agg(c ORDER BY c.created_at DESC), '[]'::json) INTO changes_json
    FROM lease_rent_special_changes c
    WHERE c.party_type = p_party_type;
    RETURN json_build_object('parties', parties_json, 'changes', changes_json);
END;
$$;



--
-- Name: get_mobile_dashboard_data(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_mobile_dashboard_data(p_user_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_employee_id TEXT;
    v_employee_branch_id INTEGER;
    v_employee_id_mapping JSONB;
    v_all_employee_codes TEXT[];
    v_today TEXT;
    v_yesterday TEXT;
    v_today_weekday INTEGER;
    v_yesterday_weekday INTEGER;
    v_attendance_today JSONB;
    v_attendance_yesterday JSONB;
    v_shift_info JSONB;
    v_yesterday_shift_info JSONB;
    v_punches JSONB;
    v_box_pending_close INTEGER;
    v_box_completed INTEGER;
    v_box_in_use INTEGER;
    v_checklist_assignments JSONB;
    v_checklist_submissions JSONB;
    v_pending_tasks INTEGER;
    v_key TEXT;
    v_val TEXT;
    -- Break totals
    v_break_total_today INTEGER;
    v_break_total_yesterday INTEGER;
    v_shift_start TEXT;
    v_shift_end TEXT;
    v_shift_overlapping BOOLEAN;
    v_window_start TIMESTAMPTZ;
    v_window_end TIMESTAMPTZ;
BEGIN
    -- 1. Get employee record
    SELECT id, current_branch_id, employee_id_mapping
    INTO v_employee_id, v_employee_branch_id, v_employee_id_mapping
    FROM hr_employee_master
    WHERE user_id = p_user_id
    LIMIT 1;

    IF v_employee_id IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'Employee record not found');
    END IF;

    -- Extract all employee codes from mapping
    IF v_employee_id_mapping IS NOT NULL THEN
        SELECT array_agg(value::TEXT)
        INTO v_all_employee_codes
        FROM jsonb_each_text(v_employee_id_mapping);
    END IF;

    -- Clean up quotes from employee codes
    IF v_all_employee_codes IS NOT NULL THEN
        v_all_employee_codes := array(
            SELECT trim(both '"' from unnest(v_all_employee_codes))
        );
    END IF;

    -- Calculate dates (Saudi timezone)
    v_today := (NOW() AT TIME ZONE 'Asia/Riyadh')::DATE::TEXT;
    v_yesterday := ((NOW() AT TIME ZONE 'Asia/Riyadh')::DATE - INTERVAL '1 day')::DATE::TEXT;
    v_today_weekday := EXTRACT(DOW FROM (NOW() AT TIME ZONE 'Asia/Riyadh')::DATE)::INTEGER;
    v_yesterday_weekday := EXTRACT(DOW FROM ((NOW() AT TIME ZONE 'Asia/Riyadh')::DATE - INTERVAL '1 day'))::INTEGER;

    -- 2. Get attendance data (today + yesterday)
    SELECT COALESCE(
        (SELECT to_jsonb(a.*) FROM hr_analysed_attendance_data a
         WHERE a.employee_id = v_employee_id AND a.shift_date = v_today::DATE
         LIMIT 1),
        'null'::JSONB
    ) INTO v_attendance_today;

    SELECT COALESCE(
        (SELECT to_jsonb(a.*) FROM hr_analysed_attendance_data a
         WHERE a.employee_id = v_employee_id AND a.shift_date = v_yesterday::DATE
         LIMIT 1),
        'null'::JSONB
    ) INTO v_attendance_yesterday;

    -- 3. Get shift info for TODAY (priority: date-wise → weekday → regular)
    SELECT COALESCE(
        (SELECT jsonb_build_object(
            'shift_start_time', s.shift_start_time,
            'shift_end_time', s.shift_end_time,
            'is_shift_overlapping_next_day', s.is_shift_overlapping_next_day,
            'source', 'special_shift_date_wise'
        )
        FROM special_shift_date_wise s
        WHERE s.employee_id = v_employee_id AND s.shift_date = v_today::DATE
        LIMIT 1),

        (SELECT jsonb_build_object(
            'shift_start_time', s.shift_start_time,
            'shift_end_time', s.shift_end_time,
            'is_shift_overlapping_next_day', s.is_shift_overlapping_next_day,
            'source', 'special_shift_weekday'
        )
        FROM special_shift_weekday s
        WHERE s.employee_id = v_employee_id AND s.weekday = v_today_weekday
        LIMIT 1),

        (SELECT jsonb_build_object(
            'shift_start_time', s.shift_start_time,
            'shift_end_time', s.shift_end_time,
            'is_shift_overlapping_next_day', s.is_shift_overlapping_next_day,
            'source', 'regular_shift'
        )
        FROM regular_shift s
        WHERE s.id = v_employee_id
        LIMIT 1),

        'null'::JSONB
    ) INTO v_shift_info;

    -- 3b. Get shift info for YESTERDAY (needed for break totals)
    SELECT COALESCE(
        (SELECT jsonb_build_object(
            'shift_start_time', s.shift_start_time,
            'shift_end_time', s.shift_end_time,
            'is_shift_overlapping_next_day', s.is_shift_overlapping_next_day
        )
        FROM special_shift_date_wise s
        WHERE s.employee_id = v_employee_id AND s.shift_date = v_yesterday::DATE
        LIMIT 1),

        (SELECT jsonb_build_object(
            'shift_start_time', s.shift_start_time,
            'shift_end_time', s.shift_end_time,
            'is_shift_overlapping_next_day', s.is_shift_overlapping_next_day
        )
        FROM special_shift_weekday s
        WHERE s.employee_id = v_employee_id AND s.weekday = v_yesterday_weekday
        LIMIT 1),

        (SELECT jsonb_build_object(
            'shift_start_time', s.shift_start_time,
            'shift_end_time', s.shift_end_time,
            'is_shift_overlapping_next_day', s.is_shift_overlapping_next_day
        )
        FROM regular_shift s
        WHERE s.id = v_employee_id
        LIMIT 1),

        'null'::JSONB
    ) INTO v_yesterday_shift_info;

    -- 4. Get last 2 fingerprint punches
    IF v_all_employee_codes IS NOT NULL AND array_length(v_all_employee_codes, 1) > 0 THEN
        SELECT COALESCE(jsonb_agg(p), '[]'::JSONB)
        INTO v_punches
        FROM (
            SELECT employee_id, date, time, status
            FROM hr_fingerprint_transactions
            WHERE employee_id = ANY(v_all_employee_codes)
            ORDER BY date DESC, time DESC
            LIMIT 2
        ) p;
    ELSE
        v_punches := '[]'::JSONB;
    END IF;

    -- 5. Get box operation counts
    SELECT COUNT(*) INTO v_box_pending_close
    FROM box_operations
    WHERE user_id = p_user_id AND status = 'pending_close';

    SELECT COUNT(*) INTO v_box_completed
    FROM box_operations
    WHERE user_id = p_user_id AND status = 'completed';

    SELECT COUNT(*) INTO v_box_in_use
    FROM box_operations
    WHERE user_id = p_user_id AND status = 'in_use';

    -- 6. Count pending tasks across all task types (exclude completed and cancelled only)
    SELECT
        (SELECT COUNT(*) FROM task_assignments WHERE assigned_to_user_id = p_user_id AND status NOT IN ('completed', 'cancelled')) +
        (SELECT COUNT(*) FROM quick_task_assignments WHERE assigned_to_user_id = p_user_id AND status NOT IN ('completed', 'cancelled')) +
        (SELECT COUNT(*) FROM receiving_tasks WHERE assigned_user_id = p_user_id AND task_status NOT IN ('completed', 'cancelled'))
    INTO v_pending_tasks;

    -- 7. Get checklist assignments (active, not deleted)
    SELECT COALESCE(jsonb_agg(jsonb_build_object(
        'id', ca.id,
        'frequency_type', ca.frequency_type,
        'day_of_week', ca.day_of_week,
        'checklist_id', ca.checklist_id
    )), '[]'::JSONB)
    INTO v_checklist_assignments
    FROM employee_checklist_assignments ca
    WHERE ca.assigned_to_user_id = p_user_id::TEXT
      AND ca.deleted_at IS NULL
      AND ca.is_active = true;

    -- 8. Get today's checklist submissions
    SELECT COALESCE(jsonb_agg(jsonb_build_object(
        'checklist_id', co.checklist_id
    )), '[]'::JSONB)
    INTO v_checklist_submissions
    FROM hr_checklist_operations co
    WHERE co.employee_id = v_employee_id::VARCHAR
      AND co.operation_date = v_today::DATE;

    -- 9. Calculate TODAY's break total (shift-aware)
    v_break_total_today := 0;
    IF v_shift_info IS NOT NULL AND v_shift_info != 'null'::JSONB THEN
        v_shift_start := v_shift_info->>'shift_start_time';
        v_shift_end := v_shift_info->>'shift_end_time';
        v_shift_overlapping := COALESCE((v_shift_info->>'is_shift_overlapping_next_day')::BOOLEAN, false);

        IF v_shift_overlapping THEN
            -- Overlapping shift: e.g. 20:00 today → 08:00 tomorrow
            v_window_start := (v_today::DATE + v_shift_start::TIME) AT TIME ZONE 'Asia/Riyadh';
            v_window_end := ((v_today::DATE + INTERVAL '1 day') + v_shift_end::TIME) AT TIME ZONE 'Asia/Riyadh';
        ELSE
            -- Normal shift: e.g. 08:00 today → 17:00 today
            v_window_start := (v_today::DATE + v_shift_start::TIME) AT TIME ZONE 'Asia/Riyadh';
            v_window_end := (v_today::DATE + v_shift_end::TIME) AT TIME ZONE 'Asia/Riyadh';
        END IF;

        SELECT COALESCE(SUM(duration_seconds), 0) INTO v_break_total_today
        FROM break_register
        WHERE user_id = p_user_id
          AND status = 'closed'
          AND start_time >= v_window_start
          AND start_time < v_window_end;
    ELSE
        -- No shift info: fallback to calendar day (Saudi timezone)
        SELECT COALESCE(SUM(duration_seconds), 0) INTO v_break_total_today
        FROM break_register
        WHERE user_id = p_user_id
          AND status = 'closed'
          AND start_time >= (v_today::DATE AT TIME ZONE 'Asia/Riyadh')
          AND start_time < ((v_today::DATE + INTERVAL '1 day') AT TIME ZONE 'Asia/Riyadh');
    END IF;

    -- 10. Calculate YESTERDAY's break total (shift-aware, using yesterday's shift)
    v_break_total_yesterday := 0;
    IF v_yesterday_shift_info IS NOT NULL AND v_yesterday_shift_info != 'null'::JSONB THEN
        v_shift_start := v_yesterday_shift_info->>'shift_start_time';
        v_shift_end := v_yesterday_shift_info->>'shift_end_time';
        v_shift_overlapping := COALESCE((v_yesterday_shift_info->>'is_shift_overlapping_next_day')::BOOLEAN, false);

        IF v_shift_overlapping THEN
            -- Overlapping shift: e.g. 20:00 yesterday → 08:00 today
            v_window_start := (v_yesterday::DATE + v_shift_start::TIME) AT TIME ZONE 'Asia/Riyadh';
            v_window_end := (v_today::DATE + v_shift_end::TIME) AT TIME ZONE 'Asia/Riyadh';
        ELSE
            -- Normal shift: e.g. 08:00 yesterday → 17:00 yesterday
            v_window_start := (v_yesterday::DATE + v_shift_start::TIME) AT TIME ZONE 'Asia/Riyadh';
            v_window_end := (v_yesterday::DATE + v_shift_end::TIME) AT TIME ZONE 'Asia/Riyadh';
        END IF;

        SELECT COALESCE(SUM(duration_seconds), 0) INTO v_break_total_yesterday
        FROM break_register
        WHERE user_id = p_user_id
          AND status = 'closed'
          AND start_time >= v_window_start
          AND start_time < v_window_end;
    ELSE
        -- No shift info: fallback to calendar day (Saudi timezone)
        SELECT COALESCE(SUM(duration_seconds), 0) INTO v_break_total_yesterday
        FROM break_register
        WHERE user_id = p_user_id
          AND status = 'closed'
          AND start_time >= (v_yesterday::DATE AT TIME ZONE 'Asia/Riyadh')
          AND start_time < (v_today::DATE AT TIME ZONE 'Asia/Riyadh');
    END IF;

    -- Return everything
    RETURN jsonb_build_object(
        'success', true,
        'employee', jsonb_build_object(
            'id', v_employee_id,
            'branch_id', v_employee_branch_id,
            'employee_codes', to_jsonb(v_all_employee_codes)
        ),
        'attendance', jsonb_build_object(
            'today', v_attendance_today,
            'yesterday', v_attendance_yesterday
        ),
        'shift_info', v_shift_info,
        'punches', v_punches,
        'pending_tasks', v_pending_tasks,
        'box_counts', jsonb_build_object(
            'pending_close', v_box_pending_close,
            'completed', v_box_completed,
            'in_use', v_box_in_use
        ),
        'checklists', jsonb_build_object(
            'assignments', v_checklist_assignments,
            'submissions_today', v_checklist_submissions
        ),
        'break_totals', jsonb_build_object(
            'today_seconds', v_break_total_today,
            'yesterday_seconds', v_break_total_yesterday
        )
    );

EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$;



--
-- Name: get_my_assignments(uuid, integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_my_assignments(p_user_id uuid, p_limit integer DEFAULT 500) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_result json;
BEGIN
  SELECT json_build_object(
    'tasks', COALESCE(tasks_arr, '[]'::json),
    'total_count', COALESCE(json_array_length(tasks_arr), 0)
  ) INTO v_result
  FROM (
    SELECT json_agg(row_to_json(t)) as tasks_arr
    FROM (
      SELECT * FROM (
      -- Regular Task Assignments (assigned by this user)
      SELECT
        ta.id,
        'regular' as task_type,
        COALESCE(tk.title, 'Task #' || LEFT(ta.id::text, 8)) as task_title,
        COALESCE(tk.description, '') as task_description,
        ta.status,
        COALESCE(ta.priority_override, tk.priority, 'medium') as priority,
        COALESCE(b.name_en, 'No Branch') as branch_name,
        COALESCE(b.name_ar, b.name_en, 'No Branch') as branch_name_ar,
        ta.assigned_to_branch_id as branch_id,
        COALESCE(u_to.username, 'Unassigned') as assigned_to_name,
        COALESCE(e_to.name_en, u_to.username, 'Unassigned') as assigned_to_name_en,
        COALESCE(e_to.name_ar, e_to.name_en, u_to.username, 'Unassigned') as assigned_to_name_ar,
        ta.assigned_to_user_id,
        COALESCE(u_by.username, 'System') as assigned_by_name,
        ta.assigned_by as assigned_by_id,
        ta.assigned_at as assigned_date,
        COALESCE(ta.deadline_datetime::text, ta.deadline_date::text) as deadline,
        ta.completed_at as completed_date,
        ta.notes,
        CASE WHEN ta.status = 'completed' AND ta.completed_at IS NOT NULL AND ta.assigned_at IS NOT NULL
          THEN ROUND(EXTRACT(EPOCH FROM (ta.completed_at - ta.assigned_at)) / 3600, 1)
          ELSE NULL
        END as completion_hours,
        NULL as price_tag,
        NULL as issue_type
      FROM task_assignments ta
      LEFT JOIN tasks tk ON tk.id = ta.task_id
      LEFT JOIN branches b ON b.id = ta.assigned_to_branch_id
      LEFT JOIN users u_to ON u_to.id = ta.assigned_to_user_id
      LEFT JOIN users u_by ON u_by.id = ta.assigned_by
      LEFT JOIN hr_employee_master e_to ON e_to.user_id = ta.assigned_to_user_id
      WHERE ta.assigned_by = p_user_id

      UNION ALL

      -- Quick Task Assignments (assigned by this user)
      SELECT
        qta.id,
        'quick' as task_type,
        COALESCE(qt.title, 'Quick Task #' || LEFT(qta.id::text, 8)) as task_title,
        COALESCE(qt.description, '') as task_description,
        qta.status::text,
        COALESCE(qt.priority::text, 'medium') as priority,
        COALESCE(b.name_en, 'No Branch') as branch_name,
        COALESCE(b.name_ar, b.name_en, 'No Branch') as branch_name_ar,
        qt.assigned_to_branch_id as branch_id,
        COALESCE(u_to.username, 'Unassigned') as assigned_to_name,
        COALESCE(e_to.name_en, u_to.username, 'Unassigned') as assigned_to_name_en,
        COALESCE(e_to.name_ar, e_to.name_en, u_to.username, 'Unassigned') as assigned_to_name_ar,
        qta.assigned_to_user_id,
        COALESCE(u_by.username, 'System') as assigned_by_name,
        qt.assigned_by as assigned_by_id,
        qta.created_at as assigned_date,
        qt.deadline_datetime::text as deadline,
        qta.completed_at as completed_date,
        NULL as notes,
        CASE WHEN qta.status = 'completed' AND qta.completed_at IS NOT NULL
          THEN ROUND(EXTRACT(EPOCH FROM (qta.completed_at - qta.created_at)) / 3600, 1)
          ELSE NULL
        END as completion_hours,
        qt.price_tag,
        qt.issue_type
      FROM quick_task_assignments qta
      JOIN quick_tasks qt ON qt.id = qta.quick_task_id
      LEFT JOIN branches b ON b.id = qt.assigned_to_branch_id
      LEFT JOIN users u_to ON u_to.id = qta.assigned_to_user_id
      LEFT JOIN users u_by ON u_by.id = qt.assigned_by
      LEFT JOIN hr_employee_master e_to ON e_to.user_id = qta.assigned_to_user_id
      WHERE qt.assigned_by = p_user_id
      ) all_tasks
      ORDER BY assigned_date DESC
      LIMIT p_limit
    ) t
  ) sub;

  RETURN v_result;
END;
$$;



--
-- Name: get_my_tasks(uuid, boolean, integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_my_tasks(p_user_id uuid, p_include_completed boolean DEFAULT false, p_limit integer DEFAULT 500) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_result json;
BEGIN
  SELECT json_build_object(
    'tasks', COALESCE(tasks_arr, '[]'::json),
    'total_count', COALESCE(json_array_length(tasks_arr), 0)
  ) INTO v_result
  FROM (
    SELECT json_agg(row_to_json(t)) as tasks_arr
    FROM (
      SELECT * FROM (
      -- Regular Task Assignments (assigned TO this user)
      SELECT
        ta.task_id as id,
        'regular' as task_type,
        COALESCE(tk.title, 'Task #' || LEFT(ta.id::text, 8)) as title,
        COALESCE(tk.description, '') as description,
        COALESCE(ta.priority_override, tk.priority, 'medium') as priority,
        COALESCE(tk.status, 'pending') as status,
        ta.status as assignment_status,
        ta.id as assignment_id,
        ta.assigned_at,
        COALESCE(ta.deadline_datetime::text, ta.deadline_date::text) as deadline_datetime,
        ta.assigned_by,
        COALESCE(u_by.username, 'Unknown') as assigned_by_name,
        ta.assigned_to_user_id,
        COALESCE(b.name_en, 'No Branch') as branch_name,
        COALESCE(b.name_ar, b.name_en, 'No Branch') as branch_name_ar,
        COALESCE(e_to.name_en, u_to.username, 'You') as assigned_to_name_en,
        COALESCE(e_to.name_ar, e_to.name_en, u_to.username, 'أنت') as assigned_to_name_ar,
        tk.created_at,
        -- Completion requirements
        false as require_task_finished,
        false as require_photo_upload,
        false as require_erp_reference,
        -- Quick task extras
        NULL::text as issue_type,
        NULL::text as incident_id,
        NULL::uuid as product_request_id,
        NULL::text as product_request_type,
        NULL::text as price_tag,
        -- Receiving extras
        NULL::text as role_type,
        NULL::uuid as receiving_record_id,
        NULL::text as clearance_certificate_url,
        ta.completed_at
      FROM task_assignments ta
      LEFT JOIN tasks tk ON tk.id = ta.task_id
      LEFT JOIN branches b ON b.id = ta.assigned_to_branch_id
      LEFT JOIN users u_by ON u_by.id = ta.assigned_by
      LEFT JOIN users u_to ON u_to.id = ta.assigned_to_user_id
      LEFT JOIN hr_employee_master e_to ON e_to.user_id = ta.assigned_to_user_id
      WHERE ta.assigned_to_user_id = p_user_id
        AND (p_include_completed OR ta.status NOT IN ('completed', 'cancelled'))

      UNION ALL

      -- Quick Task Assignments (assigned TO this user)
      SELECT
        qt.id as id,
        'quick_task' as task_type,
        COALESCE(qt.title, 'Quick Task #' || LEFT(qta.id::text, 8)) as title,
        COALESCE(qt.description, '') as description,
        COALESCE(qt.priority::text, 'medium') as priority,
        COALESCE(qt.status, 'pending') as status,
        qta.status::text as assignment_status,
        qta.id as assignment_id,
        qta.created_at as assigned_at,
        qt.deadline_datetime::text as deadline_datetime,
        qt.assigned_by,
        COALESCE(u_by.username, 'Unknown') as assigned_by_name,
        qta.assigned_to_user_id,
        COALESCE(b.name_en, 'No Branch') as branch_name,
        COALESCE(b.name_ar, b.name_en, 'No Branch') as branch_name_ar,
        COALESCE(e_to.name_en, u_to.username, 'You') as assigned_to_name_en,
        COALESCE(e_to.name_ar, e_to.name_en, u_to.username, 'أنت') as assigned_to_name_ar,
        qt.created_at,
        false as require_task_finished,
        false as require_photo_upload,
        false as require_erp_reference,
        qt.issue_type,
        qt.incident_id,
        qt.product_request_id,
        qt.product_request_type,
        qt.price_tag,
        NULL::text as role_type,
        NULL::uuid as receiving_record_id,
        NULL::text as clearance_certificate_url,
        qta.completed_at
      FROM quick_task_assignments qta
      JOIN quick_tasks qt ON qt.id = qta.quick_task_id
      LEFT JOIN branches b ON b.id = qt.assigned_to_branch_id
      LEFT JOIN users u_by ON u_by.id = qt.assigned_by
      LEFT JOIN users u_to ON u_to.id = qta.assigned_to_user_id
      LEFT JOIN hr_employee_master e_to ON e_to.user_id = qta.assigned_to_user_id
      WHERE qta.assigned_to_user_id = p_user_id
        AND (p_include_completed OR qta.status NOT IN ('completed', 'cancelled'))

      UNION ALL

      -- Receiving Tasks (assigned TO this user)
      SELECT
        rt.id as id,
        'receiving' as task_type,
        COALESCE(rt.title, 'Receiving Task #' || LEFT(rt.id::text, 8)) as title,
        COALESCE(rt.description, '') as description,
        COALESCE(rt.priority::text, 'medium') as priority,
        rt.task_status::text as status,
        rt.task_status::text as assignment_status,
        rt.id as assignment_id,
        rt.created_at as assigned_at,
        rt.due_date::text as deadline_datetime,
        rr.user_id as assigned_by,
        COALESCE(u_by.username, 'System (Receiving)') as assigned_by_name,
        rt.assigned_user_id as assigned_to_user_id,
        COALESCE(b.name_en, 'No Branch') as branch_name,
        COALESCE(b.name_ar, b.name_en, 'No Branch') as branch_name_ar,
        COALESCE(e_to.name_en, u_to.username, 'You') as assigned_to_name_en,
        COALESCE(e_to.name_ar, e_to.name_en, u_to.username, 'أنت') as assigned_to_name_ar,
        rt.created_at,
        true as require_task_finished,
        COALESCE(rt.requires_original_bill_upload, false) as require_photo_upload,
        COALESCE(rt.requires_erp_reference, false) as require_erp_reference,
        NULL::text as issue_type,
        NULL::text as incident_id,
        NULL::uuid as product_request_id,
        NULL::text as product_request_type,
        NULL::text as price_tag,
        rt.role_type,
        rt.receiving_record_id,
        rt.clearance_certificate_url,
        rt.completed_at
      FROM receiving_tasks rt
      LEFT JOIN receiving_records rr ON rr.id = rt.receiving_record_id
      LEFT JOIN branches b ON b.id = rr.branch_id
      LEFT JOIN users u_by ON u_by.id = rr.user_id
      LEFT JOIN users u_to ON u_to.id = rt.assigned_user_id
      LEFT JOIN hr_employee_master e_to ON e_to.user_id = rt.assigned_user_id
      WHERE rt.assigned_user_id = p_user_id
        AND (p_include_completed OR rt.task_status NOT IN ('completed', 'cancelled'))
      ) all_tasks
      ORDER BY
        CASE WHEN assignment_status IN ('completed', 'cancelled') THEN 1 ELSE 0 END,
        assigned_at DESC
      LIMIT p_limit
    ) t
  ) sub;

  RETURN v_result;
END;
$$;



--
-- Name: get_next_delivery_tier(numeric); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_next_delivery_tier(current_amount numeric) RETURNS TABLE(next_tier_min_amount numeric, next_tier_delivery_fee numeric, amount_needed numeric, potential_savings numeric, description_en text, description_ar text)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    current_fee numeric;
BEGIN
    -- Get current delivery fee
    current_fee := public.get_delivery_fee_for_amount(current_amount);
    
    -- Find next better tier
    RETURN QUERY
    SELECT 
        t.min_order_amount,
        t.delivery_fee,
        (t.min_order_amount - current_amount) as amount_needed,
        (current_fee - t.delivery_fee) as potential_savings,
        t.description_en,
        t.description_ar
    FROM public.delivery_fee_tiers t
    WHERE t.is_active = true
      AND t.min_order_amount > current_amount
      AND t.delivery_fee < current_fee
    ORDER BY t.min_order_amount ASC
    LIMIT 1;
END;
$$;



--
-- Name: FUNCTION get_next_delivery_tier(current_amount numeric); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.get_next_delivery_tier(current_amount numeric) IS 'Get the next tier that would reduce delivery fee with amount needed to reach it';


--
-- Name: get_next_delivery_tier_by_branch(bigint, numeric); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_next_delivery_tier_by_branch(p_branch_id bigint, p_current_amount numeric) RETURNS TABLE(next_tier_min_amount numeric, next_tier_delivery_fee numeric, amount_needed numeric, potential_savings numeric, description_en text, description_ar text)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_current_fee numeric;
BEGIN
    -- Require branch id
    IF p_branch_id IS NULL THEN
        RETURN; -- empty set
    END IF;

    v_current_fee := public.get_delivery_fee_for_amount_by_branch(p_branch_id, p_current_amount);

    RETURN QUERY
    SELECT 
        t.min_order_amount,
        t.delivery_fee,
        (t.min_order_amount - p_current_amount) AS amount_needed,
        (v_current_fee - t.delivery_fee) AS potential_savings,
        t.description_en,
        t.description_ar
    FROM public.delivery_fee_tiers t
    WHERE t.is_active = true
      AND t.branch_id = p_branch_id
      AND t.min_order_amount > p_current_amount
      AND t.delivery_fee < v_current_fee
    ORDER BY t.min_order_amount ASC
    LIMIT 1;
END;
$$;



--
-- Name: FUNCTION get_next_delivery_tier_by_branch(p_branch_id bigint, p_current_amount numeric); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.get_next_delivery_tier_by_branch(p_branch_id bigint, p_current_amount numeric) IS 'Get next tier for branch reducing delivery fee with savings info';


--
-- Name: get_next_product_serial(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_next_product_serial() RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
    next_number INTEGER;
    next_serial TEXT;
BEGIN
    -- Get the highest serial number
    SELECT COALESCE(
        MAX(CAST(SUBSTRING(product_serial FROM 3) AS INTEGER)),
        0
    ) + 1 INTO next_number
    FROM products
    WHERE product_serial ~ '^UR[0-9]+$';
    
    -- Format as UR0001, UR0002, etc.
    next_serial := 'UR' || LPAD(next_number::TEXT, 4, '0');
    
    RETURN next_serial;
END;
$_$;



--
-- Name: get_offer_products_data(integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_offer_products_data(p_exclude_offer_id integer DEFAULT 0) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_result json;
BEGIN
  SELECT json_build_object(
    'products', (
      SELECT COALESCE(json_agg(
        json_build_object(
          'id', p.id,
          'name_ar', p.product_name_ar,
          'name_en', p.product_name_en,
          'barcode', p.barcode,
          'product_serial', COALESCE(p.barcode, ''),
          'price', COALESCE(p.sale_price, 0),
          'cost', COALESCE(p.cost, 0),
          'unit_name_en', COALESCE(u.name_en, ''),
          'unit_name_ar', COALESCE(u.name_ar, ''),
          'unit_qty', COALESCE(p.unit_qty, 1),
          'image_url', p.image_url,
          'stock', COALESCE(p.current_stock, 0),
          'minim_qty', 1
        ) ORDER BY p.barcode
      ), '[]'::json)
      FROM products p
      LEFT JOIN product_units u ON u.id = p.unit_id
      WHERE p.is_active = true
        AND p.is_customer_product = true
    ),
    'products_in_other_offers', (
      SELECT COALESCE(json_agg(DISTINCT pid), '[]'::json)
      FROM (
        -- Products in offer_products (percentage, fixed price offers)
        SELECT op.product_id AS pid
        FROM offer_products op
        JOIN offers o ON o.id = op.offer_id
        WHERE o.is_active = true
          AND o.end_date >= NOW()
          AND o.id != p_exclude_offer_id

        UNION

        -- Products in BOGO offers (buy product)
        SELECT bor.buy_product_id AS pid
        FROM bogo_offer_rules bor
        JOIN offers o ON o.id = bor.offer_id
        WHERE o.is_active = true
          AND o.end_date >= NOW()
          AND o.id != p_exclude_offer_id

        UNION

        -- Products in BOGO offers (get product)
        SELECT bor.get_product_id AS pid
        FROM bogo_offer_rules bor
        JOIN offers o ON o.id = bor.offer_id
        WHERE o.is_active = true
          AND o.end_date >= NOW()
          AND o.id != p_exclude_offer_id

        UNION

        -- Products in bundle offers (from JSONB required_products array)
        SELECT (elem->>'product_id')::text AS pid
        FROM offer_bundles ob
        JOIN offers o ON o.id = ob.offer_id,
        LATERAL jsonb_array_elements(ob.required_products) AS elem
        WHERE o.is_active = true
          AND o.end_date >= NOW()
          AND o.id != p_exclude_offer_id
      ) sub
      WHERE pid IS NOT NULL
    )
  ) INTO v_result;

  RETURN v_result;
END;
$$;



--
-- Name: get_offer_variation_summary(integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_offer_variation_summary(p_offer_id integer) RETURNS TABLE(variation_group_id uuid, parent_barcode text, group_name_en text, group_name_ar text, selected_count integer, total_count integer, has_price_mismatch boolean)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN QUERY
  WITH variation_groups AS (
    SELECT DISTINCT 
      op.variation_group_id,
      op.variation_parent_barcode
    FROM offer_products op
    WHERE op.offer_id = p_offer_id
      AND op.is_part_of_variation_group = true
      AND op.variation_group_id IS NOT NULL
  ),
  selected_variations AS (
    SELECT 
      op.variation_group_id,
      COUNT(DISTINCT op.product_id) as selected_count,
      COUNT(DISTINCT op.offer_price) as price_count,
      COUNT(DISTINCT op.offer_percentage) as percentage_count
    FROM offer_products op
    WHERE op.offer_id = p_offer_id
      AND op.variation_group_id IS NOT NULL
    GROUP BY op.variation_group_id
  ),
  total_variations AS (
    SELECT 
      vg.variation_group_id,
      COUNT(DISTINCT p.id) as total_count
    FROM variation_groups vg
    JOIN products p ON p.parent_product_barcode = vg.variation_parent_barcode
      OR p.barcode = vg.variation_parent_barcode
    WHERE p.is_variation = true
    GROUP BY vg.variation_group_id
  )
  SELECT 
    vg.variation_group_id,
    vg.variation_parent_barcode as parent_barcode,
    p.variation_group_name_en as group_name_en,
    p.variation_group_name_ar as group_name_ar,
    sv.selected_count::INTEGER,
    tv.total_count::INTEGER,
    CASE 
      WHEN sv.price_count > 1 OR sv.percentage_count > 1 THEN true
      ELSE false
    END as has_price_mismatch
  FROM variation_groups vg
  JOIN products p ON p.barcode = vg.variation_parent_barcode
  LEFT JOIN selected_variations sv ON sv.variation_group_id = vg.variation_group_id
  LEFT JOIN total_variations tv ON tv.variation_group_id = vg.variation_group_id
  ORDER BY p.variation_group_name_en;
END;
$$;



--
-- Name: get_ongoing_quick_assignment_count(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

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
-- Name: get_or_create_app_function(text, text, text, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_or_create_app_function(p_function_code text, p_function_name text DEFAULT NULL::text, p_description text DEFAULT NULL::text, p_category text DEFAULT 'Application'::text) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    function_id UUID;
BEGIN
    -- Try to get existing function
    SELECT id INTO function_id 
    FROM app_functions 
    WHERE function_code = p_function_code;
    
    -- If not found, create it
    IF function_id IS NULL THEN
        function_id := register_app_function(
            COALESCE(p_function_name, initcap(replace(p_function_code, '_', ' '))),
            p_function_code,
            p_description,
            p_category
        );
    END IF;
    
    RETURN function_id;
END;
$$;



--
-- Name: get_overdue_tasks_without_reminders(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_overdue_tasks_without_reminders() RETURNS TABLE(assignment_id uuid, task_id uuid, task_title text, assigned_to_user_id uuid, user_name character varying, deadline timestamp with time zone, hours_overdue numeric)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    ta.id as assignment_id,
    t.id as task_id,
    t.title as task_title,
    ta.assigned_to_user_id,
    u.username as user_name,
    COALESCE(ta.deadline_datetime, ta.deadline_date, t.due_datetime) as deadline,
    EXTRACT(EPOCH FROM (NOW() - COALESCE(ta.deadline_datetime, ta.deadline_date, t.due_datetime))) / 3600 as hours_overdue
  FROM task_assignments ta
  JOIN tasks t ON t.id = ta.task_id
  JOIN users u ON u.id = ta.assigned_to_user_id
  LEFT JOIN task_completions tc ON tc.assignment_id = ta.id
  WHERE tc.id IS NULL  -- Not completed
    AND COALESCE(ta.deadline_datetime, ta.deadline_date, t.due_datetime) IS NOT NULL  -- Has deadline
    AND COALESCE(ta.deadline_datetime, ta.deadline_date, t.due_datetime) < NOW()  -- Overdue
    AND NOT EXISTS (  -- No reminder sent yet
      SELECT 1 FROM task_reminder_logs trl 
      WHERE trl.task_assignment_id = ta.id
    )
  ORDER BY hours_overdue DESC;
END;
$$;



--
-- Name: FUNCTION get_overdue_tasks_without_reminders(); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.get_overdue_tasks_without_reminders() IS 'Returns overdue tasks that havent received reminders yet - used by Edge Function';


--
-- Name: get_paid_expense_payments(date, date); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

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
-- Name: get_paid_vendor_payments(date, date); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

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
-- Name: get_party_payment_data(text, uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_party_payment_data(p_party_type text, p_party_id uuid) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN json_build_object(
        'changes', (
            SELECT COALESCE(json_agg(sub), '[]'::json)
            FROM (
                SELECT * FROM lease_rent_special_changes
                WHERE party_type = p_party_type AND party_id = p_party_id
                ORDER BY effective_from ASC
            ) sub
        ),
        'entries', (
            SELECT COALESCE(json_agg(sub), '[]'::json)
            FROM (
                SELECT * FROM lease_rent_payment_entries
                WHERE party_type = p_party_type AND party_id = p_party_id
                ORDER BY created_at ASC
            ) sub
        )
    );
END;
$$;



--
-- Name: get_po_requests_with_details(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_po_requests_with_details() RETURNS TABLE(id uuid, requester_user_id uuid, from_branch_id integer, target_user_id uuid, status character varying, items jsonb, document_url text, created_at timestamp with time zone, updated_at timestamp with time zone, requester_name_en text, requester_name_ar text, target_name_en text, target_name_ar text, branch_name_en text, branch_name_ar text, branch_location_en text, branch_location_ar text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        r.id,
        r.requester_user_id,
        r.from_branch_id,
        r.target_user_id,
        r.status,
        r.items,
        r.document_url,
        r.created_at,
        r.updated_at,
        COALESCE(req.name_en, req.user_id::TEXT)::TEXT AS requester_name_en,
        COALESCE(req.name_ar, req.name_en, req.user_id::TEXT)::TEXT AS requester_name_ar,
        COALESCE(tgt.name_en, tgt.user_id::TEXT)::TEXT AS target_name_en,
        COALESCE(tgt.name_ar, tgt.name_en, tgt.user_id::TEXT)::TEXT AS target_name_ar,
        COALESCE(b.name_en, '')::TEXT AS branch_name_en,
        COALESCE(b.name_ar, b.name_en, '')::TEXT AS branch_name_ar,
        COALESCE(b.location_en, '')::TEXT AS branch_location_en,
        COALESCE(b.location_ar, b.location_en, '')::TEXT AS branch_location_ar
    FROM product_request_po r
    LEFT JOIN hr_employee_master req ON req.user_id = r.requester_user_id
    LEFT JOIN hr_employee_master tgt ON tgt.user_id = r.target_user_id
    LEFT JOIN branches b ON b.id = r.from_branch_id
    ORDER BY r.created_at DESC;
END;
$$;



--
-- Name: get_pos_report(timestamp with time zone, timestamp with time zone); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_pos_report(p_date_from timestamp with time zone DEFAULT NULL::timestamp with time zone, p_date_to timestamp with time zone DEFAULT NULL::timestamp with time zone) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_result jsonb;
BEGIN
  SELECT COALESCE(jsonb_agg(row_data ORDER BY (row_data->>'created_at') DESC), '[]'::jsonb)
  INTO v_result
  FROM (
    SELECT jsonb_build_object(
      'id', bo.id,
      'box_number', bo.box_number,
      'branch_id', bo.branch_id,
      'user_id', bo.user_id,
      'total_difference', COALESCE(
        (bo.complete_details->>'total_difference')::numeric,
        bo.total_difference,
        0
      ),
      'created_at', bo.created_at,
      'branch_name_en', COALESCE(b.name_en, b.name_ar, 'N/A'),
      'branch_name_ar', COALESCE(b.name_ar, b.name_en, 'N/A'),
      'branch_location_en', COALESCE(b.location_en, b.location_ar, 'N/A'),
      'branch_location_ar', COALESCE(b.location_ar, b.location_en, 'N/A'),
      'cashier_name_en', COALESCE(e.name_en, 'N/A'),
      'cashier_name_ar', COALESCE(e.name_ar, 'N/A'),
      'transfer_status', COALESCE(
        (SELECT pdt.status::text FROM pos_deduction_transfers pdt WHERE pdt.box_operation_id = bo.id ORDER BY pdt.created_at DESC LIMIT 1),
        'Not Transferred'
      )
    ) as row_data
    FROM box_operations bo
    LEFT JOIN branches b ON b.id = bo.branch_id
    LEFT JOIN hr_employee_master e ON e.user_id = bo.user_id
    WHERE bo.status = 'completed'
      AND (p_date_from IS NULL OR bo.created_at >= p_date_from)
      AND (p_date_to IS NULL OR bo.created_at <= p_date_to)
    ORDER BY bo.created_at DESC
  ) sub;

  RETURN v_result;
END;
$$;



--
-- Name: get_product_master_init_data(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_product_master_init_data() RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_total_products int;
  v_with_images int;
  v_without_images int;
  v_units jsonb;
  v_categories jsonb;
BEGIN
  -- Get total products count
  SELECT count(*) INTO v_total_products FROM products;
  
  -- Get products with images count
  SELECT count(*) INTO v_with_images 
  FROM products 
  WHERE image_url IS NOT NULL AND image_url <> '';
  
  -- Get products without images count
  v_without_images := v_total_products - v_with_images;
  
  -- Get all units
  SELECT COALESCE(jsonb_agg(
    jsonb_build_object('id', id, 'name_en', name_en, 'name_ar', name_ar)
    ORDER BY name_en
  ), '[]'::jsonb) INTO v_units
  FROM product_units;
  
  -- Get all categories
  SELECT COALESCE(jsonb_agg(
    jsonb_build_object('id', id, 'name_en', name_en, 'name_ar', name_ar)
    ORDER BY name_en
  ), '[]'::jsonb) INTO v_categories
  FROM product_categories;
  
  RETURN jsonb_build_object(
    'total_products', v_total_products,
    'products_with_images', v_with_images,
    'products_without_images', v_without_images,
    'units', v_units,
    'categories', v_categories
  );
END;
$$;



--
-- Name: get_product_offers(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_product_offers(p_product_id uuid) RETURNS TABLE(offer_id integer, offer_name_en text, offer_name_ar text, offer_type text, discount_type text, offer_qty integer, offer_percentage numeric, offer_price numeric, original_price numeric, savings numeric, end_date timestamp with time zone, service_type text, branch_id integer)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    o.id AS offer_id,
    o.name_en AS offer_name_en,
    o.name_ar AS offer_name_ar,
    o.type AS offer_type,
    o.discount_type,
    op.offer_qty,
    op.offer_percentage,
    op.offer_price,
    p.sale_price AS original_price,
    CASE 
      WHEN op.offer_percentage IS NOT NULL THEN 
        (p.sale_price * op.offer_qty) - ((p.sale_price * op.offer_qty) * (1 - op.offer_percentage / 100))
      WHEN op.offer_price IS NOT NULL THEN 
        (p.sale_price * op.offer_qty) - op.offer_price
      ELSE 0
    END AS savings,
    o.end_date,
    o.service_type,
    o.branch_id
  FROM offers o
  INNER JOIN offer_products op ON o.id = op.offer_id
  INNER JOIN products p ON op.product_id = p.id
  WHERE op.product_id = p_product_id
    AND o.is_active = true
    AND o.type = 'product'
    AND o.start_date <= NOW()
    AND o.end_date >= NOW()
  ORDER BY savings DESC;
END;
$$;



--
-- Name: FUNCTION get_product_offers(p_product_id uuid); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.get_product_offers(p_product_id uuid) IS 'Get all active product offers for a specific product, ordered by best savings';


--
-- Name: get_product_variations(text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_product_variations(p_barcode text) RETURNS TABLE(id character varying, barcode text, product_name_en text, product_name_ar text, unit_name text, image_url text, variation_order integer, is_parent boolean, parent_barcode text, group_name_en text, group_name_ar text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN QUERY
  WITH target_product AS (
    SELECT 
      COALESCE(p.parent_product_barcode, p.barcode) as parent_ref
    FROM products p
    WHERE p.barcode = p_barcode
  )
  SELECT 
    p.id,
    p.barcode,
    p.product_name_en,
    p.product_name_ar,
    pu.name_en as unit_name,
    p.image_url,
    p.variation_order,
    (p.barcode = (SELECT parent_ref FROM target_product)) as is_parent,
    p.parent_product_barcode as parent_barcode,
    p.variation_group_name_en as group_name_en,
    p.variation_group_name_ar as group_name_ar
  FROM products p
  LEFT JOIN product_units pu ON p.unit_id = pu.id
  WHERE p.is_variation = true
    AND (p.parent_product_barcode = (SELECT parent_ref FROM target_product)
         OR p.barcode = (SELECT parent_ref FROM target_product))
  ORDER BY p.variation_order ASC, p.product_name_en ASC;
END;
$$;



--
-- Name: get_products_dashboard_data(integer, integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_products_dashboard_data(p_limit integer DEFAULT 500, p_offset integer DEFAULT 0) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  result jsonb;
BEGIN
  SELECT jsonb_build_object(
    'products', COALESCE((
      SELECT jsonb_agg(row_data ORDER BY rn)
      FROM (
        SELECT 
          jsonb_build_object(
            'id', p.id,
            'barcode', p.barcode,
            'product_name_en', COALESCE(p.product_name_en, ''),
            'product_name_ar', COALESCE(p.product_name_ar, ''),
            'category_id', p.category_id,
            'category_name_en', pc.name_en,
            'category_name_ar', pc.name_ar,
            'unit_id', p.unit_id,
            'unit_name_en', pu.name_en,
            'unit_name_ar', pu.name_ar
          ) AS row_data,
          ROW_NUMBER() OVER (ORDER BY p.product_name_en) AS rn
        FROM products p
        LEFT JOIN product_categories pc ON p.category_id = pc.id
        LEFT JOIN product_units pu ON p.unit_id = pu.id
        ORDER BY p.product_name_en
        LIMIT p_limit
        OFFSET p_offset
      ) sub
    ), '[]'::jsonb),
    'categories', COALESCE((
      SELECT jsonb_agg(
        jsonb_build_object(
          'id', pc.id,
          'name_en', pc.name_en,
          'name_ar', pc.name_ar
        ) ORDER BY pc.name_en
      )
      FROM product_categories pc
    ), '[]'::jsonb),
    'units', COALESCE((
      SELECT jsonb_agg(
        jsonb_build_object(
          'id', pu.id,
          'name_en', pu.name_en,
          'name_ar', pu.name_ar
        ) ORDER BY pu.name_en
      )
      FROM product_units pu
    ), '[]'::jsonb),
    'total_count', (SELECT COUNT(*)::int FROM products)
  )
  INTO result;

  RETURN result;
END;
$$;



--
-- Name: get_products_in_active_offers(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_products_in_active_offers() RETURNS TABLE(product_id uuid, offer_id integer, offer_name_en text, offer_name_ar text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    op.product_id,
    o.id AS offer_id,
    o.name_en AS offer_name_en,
    o.name_ar AS offer_name_ar
  FROM offer_products op
  INNER JOIN offers o ON op.offer_id = o.id
  WHERE o.is_active = true
    AND o.type = 'product'
    AND o.start_date <= NOW()
    AND o.end_date >= NOW();
END;
$$;



--
-- Name: FUNCTION get_products_in_active_offers(); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.get_products_in_active_offers() IS 'Get all products in active product offers for admin filtering';


--
-- Name: get_purchase_voucher_manager_data(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_purchase_voucher_manager_data() RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  result jsonb;
  not_issued_stats jsonb;
  issued_stats jsonb;
  closed_stats jsonb;
  book_summary_data jsonb;
  branches_data jsonb;
  users_data jsonb;
  employees_data jsonb;
BEGIN

  -- 1. Not Issued Stats: group by stock_location, value
  SELECT COALESCE(jsonb_agg(row_to_json(t)::jsonb), '[]'::jsonb)
  INTO not_issued_stats
  FROM (
    SELECT 
      COALESCE(stock_location::text, 'unassigned') as stock_location,
      value,
      count(*) as voucher_count,
      count(DISTINCT purchase_voucher_id) as book_count
    FROM purchase_voucher_items
    WHERE issue_type = 'not issued'
    GROUP BY COALESCE(stock_location::text, 'unassigned'), value
  ) t;

  -- 2. Issued Stats: group by stock_location, value, issue_type (excluding 'not issued')
  SELECT COALESCE(jsonb_agg(row_to_json(t)::jsonb), '[]'::jsonb)
  INTO issued_stats
  FROM (
    SELECT 
      COALESCE(stock_location::text, 'unassigned') as stock_location,
      value,
      COALESCE(issue_type, 'unknown') as issue_type,
      count(*) as voucher_count,
      count(DISTINCT purchase_voucher_id) as book_count
    FROM purchase_voucher_items
    WHERE issue_type != 'not issued'
    GROUP BY COALESCE(stock_location::text, 'unassigned'), value, COALESCE(issue_type, 'unknown')
  ) t;

  -- 3. Closed Stats: group by stock_location, value, issue_type (status = 'closed')
  SELECT COALESCE(jsonb_agg(row_to_json(t)::jsonb), '[]'::jsonb)
  INTO closed_stats
  FROM (
    SELECT 
      COALESCE(stock_location::text, 'unassigned') as stock_location,
      value,
      COALESCE(issue_type, 'unknown') as issue_type,
      count(*) as voucher_count,
      count(DISTINCT purchase_voucher_id) as book_count
    FROM purchase_voucher_items
    WHERE status = 'closed'
    GROUP BY COALESCE(stock_location::text, 'unassigned'), value, COALESCE(issue_type, 'unknown')
  ) t;

  -- 4. Book Summary: join purchase_vouchers with aggregated purchase_voucher_items
  SELECT COALESCE(jsonb_agg(row_to_json(t)::jsonb ORDER BY t.has_unassigned DESC, t.voucher_id ASC), '[]'::jsonb)
  INTO book_summary_data
  FROM (
    SELECT 
      pv.id as voucher_id,
      pv.book_number,
      pv.serial_start || ' - ' || pv.serial_end as serial_range,
      COALESCE(agg.total_count, 0) as total_count,
      COALESCE(agg.total_value, 0) as total_value,
      COALESCE(agg.stock_count, 0) as stock_count,
      COALESCE(agg.stocked_count, 0) as stocked_count,
      COALESCE(agg.issued_count, 0) as issued_count,
      COALESCE(agg.closed_count, 0) as closed_count,
      COALESCE(agg.stock_locations, '[]'::jsonb) as stock_locations,
      COALESCE(agg.stock_persons, '[]'::jsonb) as stock_persons,
      CASE WHEN COALESCE(agg.stock_locations, '[]'::jsonb) = '[]'::jsonb 
           OR COALESCE(agg.stock_persons, '[]'::jsonb) = '[]'::jsonb 
           THEN 1 ELSE 0 END as has_unassigned
    FROM purchase_vouchers pv
    LEFT JOIN (
      SELECT 
        purchase_voucher_id,
        count(*) as total_count,
        COALESCE(sum(value), 0) as total_value,
        count(*) FILTER (WHERE stock > 0) as stock_count,
        count(*) FILTER (WHERE status = 'stocked') as stocked_count,
        count(*) FILTER (WHERE status = 'issued') as issued_count,
        count(*) FILTER (WHERE status = 'closed') as closed_count,
        COALESCE(jsonb_agg(DISTINCT stock_location) FILTER (WHERE stock_location IS NOT NULL AND stock_location::text != ''), '[]'::jsonb) as stock_locations,
        COALESCE(jsonb_agg(DISTINCT stock_person) FILTER (WHERE stock_person IS NOT NULL AND stock_person::text != ''), '[]'::jsonb) as stock_persons
      FROM purchase_voucher_items
      GROUP BY purchase_voucher_id
    ) agg ON agg.purchase_voucher_id = pv.id
  ) t;

  -- 5. Branches lookup
  SELECT COALESCE(jsonb_agg(row_to_json(t)::jsonb), '[]'::jsonb)
  INTO branches_data
  FROM (
    SELECT id, name_en, location_en FROM branches ORDER BY name_en
  ) t;

  -- 6. Users lookup
  SELECT COALESCE(jsonb_agg(row_to_json(t)::jsonb), '[]'::jsonb)
  INTO users_data
  FROM (
    SELECT id, username, employee_id FROM users
  ) t;

  -- 7. Employees lookup
  SELECT COALESCE(jsonb_agg(row_to_json(t)::jsonb), '[]'::jsonb)
  INTO employees_data
  FROM (
    SELECT id, name FROM hr_employees
  ) t;

  -- Build final result
  result := jsonb_build_object(
    'not_issued_stats', not_issued_stats,
    'issued_stats', issued_stats,
    'closed_stats', closed_stats,
    'book_summary', book_summary_data,
    'branches', branches_data,
    'users', users_data,
    'employees', employees_data
  );

  RETURN result;
END;
$$;



--
-- Name: get_pv_stock_manager_data(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_pv_stock_manager_data() RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  result jsonb;
BEGIN
  SELECT jsonb_build_object(
    'book_summary', COALESCE((
      SELECT jsonb_agg(to_jsonb(bs.*) ORDER BY bs.has_unassigned DESC, bs.voucher_id ASC)
      FROM (
        SELECT 
          pv.id AS voucher_id,
          pv.book_number,
          pv.serial_start || ' - ' || pv.serial_end AS serial_range,
          COUNT(pvi.id)::int AS total_count,
          COALESCE(SUM(pvi.value), 0)::numeric AS total_value,
          COUNT(CASE WHEN pvi.stock > 0 THEN 1 END)::int AS stock_count,
          COUNT(CASE WHEN pvi.status = 'stocked' THEN 1 END)::int AS stocked_count,
          COUNT(CASE WHEN pvi.status = 'issued' THEN 1 END)::int AS issued_count,
          COUNT(CASE WHEN pvi.status = 'closed' THEN 1 END)::int AS closed_count,
          COALESCE(
            (SELECT jsonb_agg(DISTINCT sl) FROM unnest(array_agg(DISTINCT pvi.stock_location)) sl WHERE sl IS NOT NULL),
            '[]'::jsonb
          ) AS stock_locations,
          COALESCE(
            (SELECT jsonb_agg(DISTINCT sp) FROM unnest(array_agg(DISTINCT pvi.stock_person)) sp WHERE sp IS NOT NULL),
            '[]'::jsonb
          ) AS stock_persons,
          CASE WHEN bool_or(pvi.stock_location IS NULL OR pvi.stock_person IS NULL) THEN 1 ELSE 0 END AS has_unassigned
        FROM purchase_vouchers pv
        LEFT JOIN purchase_voucher_items pvi ON pvi.purchase_voucher_id = pv.id
        GROUP BY pv.id, pv.book_number, pv.serial_start, pv.serial_end
      ) bs
    ), '[]'::jsonb),
    'branches', COALESCE((
      SELECT jsonb_agg(jsonb_build_object('id', b.id, 'name_en', b.name_en, 'location_en', b.location_en))
      FROM branches b
    ), '[]'::jsonb),
    'users', COALESCE((
      SELECT jsonb_agg(jsonb_build_object('id', u.id, 'username', u.username, 'employee_id', u.employee_id))
      FROM users u
    ), '[]'::jsonb),
    'employees', COALESCE((
      SELECT jsonb_agg(jsonb_build_object('id', e.id, 'name', e.name))
      FROM hr_employees e
    ), '[]'::jsonb)
  ) INTO result;

  RETURN result;
END;
$$;



--
-- Name: get_pv_stock_voucher_items(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_pv_stock_voucher_items() RETURNS jsonb
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT jsonb_build_object(
    'items', COALESCE((
      SELECT jsonb_agg(
        jsonb_build_object(
          'id', pvi.id,
          'purchase_voucher_id', pvi.purchase_voucher_id,
          'serial_number', pvi.serial_number,
          'value', pvi.value,
          'stock', pvi.stock,
          'status', pvi.status,
          'issue_type', pvi.issue_type,
          'stock_location', pvi.stock_location,
          'stock_person', pvi.stock_person,
          'stock_location_name', COALESCE(b.name_en, '-'),
          'stock_person_name', COALESCE(e.name_en, u.username, '-')
        )
        ORDER BY pvi.purchase_voucher_id, pvi.serial_number
      )
      FROM purchase_voucher_items pvi
      LEFT JOIN branches b ON b.id = pvi.stock_location
      LEFT JOIN users u ON u.id = pvi.stock_person
      LEFT JOIN hr_employee_master e ON e.id = u.employee_id::text
    ), '[]'::jsonb)
  );
$$;



--
-- Name: get_pv_stock_voucher_items(integer, integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_pv_stock_voucher_items(p_offset integer DEFAULT 0, p_limit integer DEFAULT 2000) RETURNS jsonb
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT jsonb_build_object(
    'total_count', (SELECT count(*) FROM purchase_voucher_items),
    'items', COALESCE((
      SELECT jsonb_agg(row_data)
      FROM (
        SELECT jsonb_build_object(
          'id', pvi.id,
          'purchase_voucher_id', pvi.purchase_voucher_id,
          'serial_number', pvi.serial_number,
          'value', pvi.value,
          'stock', pvi.stock,
          'status', pvi.status,
          'issue_type', pvi.issue_type,
          'stock_location', pvi.stock_location,
          'stock_person', pvi.stock_person,
          'stock_location_name', COALESCE(b.name_en, '-'),
          'stock_person_name', COALESCE(e.name_en, u.username, '-')
        ) as row_data
        FROM purchase_voucher_items pvi
        LEFT JOIN branches b ON b.id = pvi.stock_location
        LEFT JOIN users u ON u.id = pvi.stock_person
        LEFT JOIN hr_employee_master e ON e.id = u.employee_id::text
        ORDER BY pvi.purchase_voucher_id, pvi.serial_number
        LIMIT p_limit OFFSET p_offset
      ) sub
    ), '[]'::jsonb)
  );
$$;



--
-- Name: get_quick_access_stats(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_quick_access_stats() RETURNS TABLE(total_codes bigint, active_codes bigint, unused_codes bigint)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::BIGINT as total_codes,
        COUNT(CASE WHEN status = 'active' THEN 1 END)::BIGINT as active_codes,
        COUNT(CASE WHEN quick_access_code IS NOT NULL AND last_login_at IS NULL THEN 1 END)::BIGINT as unused_codes
    FROM users
    WHERE deleted_at IS NULL;
END;
$$;



--
-- Name: get_quick_expiry_report(integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_quick_expiry_report(days_threshold integer DEFAULT 15) RETURNS TABLE(branch_id integer, barcode character varying, product_name_en character varying, product_name_ar character varying, expiry_date date, days_left integer)
    LANGUAGE sql STABLE
    AS $$
  SELECT
    (entry->>'branch_id')::integer AS branch_id,
    p.barcode,
    p.product_name_en,
    p.product_name_ar,
    (entry->>'expiry_date')::date AS expiry_date,
    ((entry->>'expiry_date')::date - CURRENT_DATE) AS days_left
  FROM erp_synced_products p,
    jsonb_array_elements(p.expiry_dates) AS entry
  WHERE jsonb_array_length(p.expiry_dates) > 0
    AND (p.expiry_hidden IS NOT TRUE)
    AND (entry->>'expiry_date') IS NOT NULL
    AND (entry->>'branch_id') IS NOT NULL
    AND ((entry->>'expiry_date')::date - CURRENT_DATE) <= days_threshold
  ORDER BY p.barcode, ((entry->>'expiry_date')::date - CURRENT_DATE) ASC;
$$;



--
-- Name: get_quick_task_completion_stats(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_quick_task_completion_stats() RETURNS TABLE(total_completions bigint, submitted_count bigint, verified_count bigint, rejected_count bigint, pending_review_count bigint, completions_with_photos bigint, completions_with_erp bigint, avg_verification_time interval)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*) as total_completions,
        COUNT(*) FILTER (WHERE completion_status = 'submitted') as submitted_count,
        COUNT(*) FILTER (WHERE completion_status = 'verified') as verified_count,
        COUNT(*) FILTER (WHERE completion_status = 'rejected') as rejected_count,
        COUNT(*) FILTER (WHERE completion_status = 'pending_review') as pending_review_count,
        COUNT(*) FILTER (WHERE photo_path IS NOT NULL) as completions_with_photos,
        COUNT(*) FILTER (WHERE erp_reference IS NOT NULL) as completions_with_erp,
        AVG(verified_at - created_at) FILTER (WHERE verified_at IS NOT NULL) as avg_verification_time
    FROM quick_task_completions;
END;
$$;



--
-- Name: get_receiving_records_with_details(integer, integer, text, text, text, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_receiving_records_with_details(p_limit integer DEFAULT 500, p_offset integer DEFAULT 0, p_branch_id text DEFAULT NULL::text, p_vendor_search text DEFAULT NULL::text, p_pr_excel_filter text DEFAULT NULL::text, p_erp_ref_filter text DEFAULT NULL::text) RETURNS TABLE(id text, bill_number text, vendor_id text, branch_id text, bill_date date, bill_amount numeric, created_at timestamp with time zone, user_id text, original_bill_url text, erp_purchase_invoice_reference text, certificate_url text, due_date date, pr_excel_file_url text, final_bill_amount numeric, payment_method text, credit_period integer, bank_name text, iban text, branch_name_en text, branch_location_en text, vendor_name text, vat_number text, username text, user_display_name text, is_scheduled boolean, is_paid boolean, pr_excel_verified boolean, pr_excel_verified_by text, pr_excel_verified_date timestamp with time zone, total_count bigint)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_total BIGINT;
BEGIN
    -- Get total count with same filters (for pagination info)
    SELECT COUNT(*) INTO v_total
    FROM receiving_records r
    LEFT JOIN branches b ON b.id = r.branch_id
    LEFT JOIN vendors v ON v.erp_vendor_id = r.vendor_id AND v.branch_id = r.branch_id
    LEFT JOIN LATERAL (
        SELECT vps.pr_excel_verified
        FROM vendor_payment_schedule vps
        WHERE vps.receiving_record_id = r.id
        LIMIT 1
    ) ps_count ON true
    WHERE (p_branch_id IS NULL OR r.branch_id::TEXT = p_branch_id)
      AND (p_vendor_search IS NULL OR p_vendor_search = '' OR LOWER(v.vendor_name) LIKE '%' || LOWER(p_vendor_search) || '%')
      AND (p_pr_excel_filter IS NULL OR p_pr_excel_filter = '' 
           OR (p_pr_excel_filter = 'verified' AND COALESCE(ps_count.pr_excel_verified, false) = true)
           OR (p_pr_excel_filter = 'unverified' AND COALESCE(ps_count.pr_excel_verified, false) = false))
      AND (p_erp_ref_filter IS NULL OR p_erp_ref_filter = ''
           OR (p_erp_ref_filter = 'entered' AND r.erp_purchase_invoice_reference IS NOT NULL AND TRIM(r.erp_purchase_invoice_reference::TEXT) <> '')
           OR (p_erp_ref_filter = 'not_entered' AND (r.erp_purchase_invoice_reference IS NULL OR TRIM(r.erp_purchase_invoice_reference::TEXT) = '')));

    RETURN QUERY
    SELECT
        r.id::TEXT,
        r.bill_number::TEXT,
        r.vendor_id::TEXT,
        r.branch_id::TEXT,
        r.bill_date,
        r.bill_amount,
        r.created_at,
        r.user_id::TEXT,
        r.original_bill_url::TEXT,
        r.erp_purchase_invoice_reference::TEXT,
        r.certificate_url::TEXT,
        r.due_date,
        r.pr_excel_file_url::TEXT,
        r.final_bill_amount,
        r.payment_method::TEXT,
        r.credit_period,
        r.bank_name::TEXT,
        r.iban::TEXT,
        -- Branch
        COALESCE(b.name_en, 'N/A')::TEXT AS branch_name_en,
        COALESCE(b.location_en, '')::TEXT AS branch_location_en,
        -- Vendor (match by erp_vendor_id AND branch_id)
        COALESCE(v.vendor_name, 'N/A')::TEXT AS vendor_name,
        v.vat_number::TEXT,
        -- User
        COALESCE(u.username, '')::TEXT AS username,
        COALESCE(he.name, u.username, '')::TEXT AS user_display_name,
        -- Payment schedule
        (ps.receiving_record_id IS NOT NULL) AS is_scheduled,
        COALESCE(ps.is_paid, false) AS is_paid,
        COALESCE(ps.pr_excel_verified, false) AS pr_excel_verified,
        ps.pr_excel_verified_by::TEXT,
        ps.pr_excel_verified_date,
        -- Total count
        v_total AS total_count
    FROM receiving_records r
    LEFT JOIN branches b ON b.id = r.branch_id
    LEFT JOIN vendors v ON v.erp_vendor_id = r.vendor_id AND v.branch_id = r.branch_id
    LEFT JOIN users u ON u.id = r.user_id
    LEFT JOIN hr_employees he ON he.id = u.id
    LEFT JOIN LATERAL (
        SELECT 
            vps.receiving_record_id,
            vps.is_paid,
            vps.pr_excel_verified,
            vps.pr_excel_verified_by,
            vps.pr_excel_verified_date
        FROM vendor_payment_schedule vps
        WHERE vps.receiving_record_id = r.id
        LIMIT 1
    ) ps ON true
    WHERE (p_branch_id IS NULL OR r.branch_id::TEXT = p_branch_id)
      AND (p_vendor_search IS NULL OR p_vendor_search = '' OR LOWER(v.vendor_name) LIKE '%' || LOWER(p_vendor_search) || '%')
      AND (p_pr_excel_filter IS NULL OR p_pr_excel_filter = ''
           OR (p_pr_excel_filter = 'verified' AND COALESCE(ps.pr_excel_verified, false) = true)
           OR (p_pr_excel_filter = 'unverified' AND COALESCE(ps.pr_excel_verified, false) = false))
      AND (p_erp_ref_filter IS NULL OR p_erp_ref_filter = ''
           OR (p_erp_ref_filter = 'entered' AND r.erp_purchase_invoice_reference IS NOT NULL AND TRIM(r.erp_purchase_invoice_reference::TEXT) <> '')
           OR (p_erp_ref_filter = 'not_entered' AND (r.erp_purchase_invoice_reference IS NULL OR TRIM(r.erp_purchase_invoice_reference::TEXT) = '')))
    ORDER BY r.created_at DESC
    LIMIT p_limit
    OFFSET p_offset;
END;
$$;



--
-- Name: get_receiving_task_statistics(integer, date, date); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_receiving_task_statistics(branch_id_param integer DEFAULT NULL::integer, date_from date DEFAULT NULL::date, date_to date DEFAULT NULL::date) RETURNS TABLE(total_tasks bigint, pending_tasks bigint, in_progress_tasks bigint, completed_tasks bigint, overdue_tasks bigint, high_priority_tasks bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*) as total_tasks,
        COUNT(*) FILTER (WHERE t.status = 'pending') as pending_tasks,
        COUNT(*) FILTER (WHERE t.status = 'in_progress') as in_progress_tasks,
        COUNT(*) FILTER (WHERE t.status = 'completed') as completed_tasks,
        COUNT(*) FILTER (WHERE t.status != 'completed' AND t.due_datetime < NOW()) as overdue_tasks,
        COUNT(*) FILTER (WHERE t.priority = 'high') as high_priority_tasks
    FROM tasks t
    LEFT JOIN receiving_records rr ON rr.id::text = SUBSTRING(t.description FROM 'receiving record ([0-9a-f-]+)')
    WHERE t.description LIKE '%receiving record%'
    AND (branch_id_param IS NULL OR rr.branch_id = branch_id_param)
    AND (date_from IS NULL OR DATE(t.created_at) >= date_from)
    AND (date_to IS NULL OR DATE(t.created_at) <= date_to);
END;
$$;



--
-- Name: get_receiving_task_statistics(integer, timestamp with time zone, timestamp with time zone); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_receiving_task_statistics(branch_id_param integer DEFAULT NULL::integer, date_from timestamp with time zone DEFAULT NULL::timestamp with time zone, date_to timestamp with time zone DEFAULT NULL::timestamp with time zone) RETURNS TABLE(total_tasks bigint, completed_tasks bigint, pending_tasks bigint, overdue_tasks bigint, tasks_by_role jsonb, completion_rate numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*) as total_tasks,
        COUNT(*) FILTER (WHERE task_completed = true) as completed_tasks,
        COUNT(*) FILTER (WHERE task_completed = false) as pending_tasks,
        COUNT(*) FILTER (WHERE is_overdue = true AND task_completed = false) as overdue_tasks,
        jsonb_object_agg(
            role_type, 
            jsonb_build_object(
                'total', role_count,
                'completed', role_completed
            )
        ) as tasks_by_role,
        CASE 
            WHEN COUNT(*) > 0 THEN 
                ROUND((COUNT(*) FILTER (WHERE task_completed = true) * 100.0) / COUNT(*), 2)
            ELSE 0
        END as completion_rate
    FROM (
        SELECT 
            rtd.role_type,
            rtd.task_completed,
            rtd.is_overdue,
            COUNT(*) OVER (PARTITION BY rtd.role_type) as role_count,
            COUNT(*) FILTER (WHERE rtd.task_completed = true) OVER (PARTITION BY rtd.role_type) as role_completed
        FROM receiving_tasks_detailed rtd
        WHERE (branch_id_param IS NULL OR rtd.branch_id = branch_id_param)
          AND (date_from IS NULL OR rtd.created_at >= date_from)
          AND (date_to IS NULL OR rtd.created_at <= date_to)
    ) stats
    GROUP BY ();
END;
$$;



--
-- Name: get_receiving_tasks_for_user(uuid, integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_receiving_tasks_for_user(p_user_id uuid, p_completed_days integer DEFAULT 7) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_my_tasks json;
  v_team_tasks json;
  v_is_branch_manager boolean := false;
  v_employee_names json;
  v_cutoff timestamp;
BEGIN
  -- Calculate cutoff for completed tasks
  v_cutoff := NOW() - (p_completed_days || ' days')::interval;

  -- 1. Get user's own tasks: all pending + completed from last N days
  SELECT json_agg(t ORDER BY t.created_at DESC)
  INTO v_my_tasks
  FROM (
    SELECT id, title, description, priority, role_type, task_status, due_date,
           created_at, assigned_user_id, receiving_record_id, clearance_certificate_url,
           requires_original_bill_upload, requires_erp_reference
    FROM receiving_tasks
    WHERE assigned_user_id = p_user_id
      AND (task_status != 'completed' OR created_at >= v_cutoff)
  ) t;

  -- Default to empty array
  IF v_my_tasks IS NULL THEN
    v_my_tasks := '[]'::json;
  END IF;

  -- 2. Check if user is branch manager
  SELECT EXISTS (
    SELECT 1 FROM receiving_tasks
    WHERE assigned_user_id = p_user_id AND role_type = 'branch_manager'
    LIMIT 1
  ) INTO v_is_branch_manager;

  -- 3. If branch manager, load team tasks (shelf_stocker + night_supervisor)
  -- All pending tasks (no time limit) + completed from last N days
  IF v_is_branch_manager THEN
    SELECT json_agg(t ORDER BY t.created_at DESC)
    INTO v_team_tasks
    FROM (
      SELECT rt.id, rt.title, rt.description, rt.priority, rt.role_type, rt.task_status,
             rt.due_date, rt.created_at, rt.assigned_user_id, rt.receiving_record_id,
             rt.clearance_certificate_url, rt.completion_photo_url, rt.completed_at
      FROM receiving_tasks rt
      WHERE rt.receiving_record_id IN (
        SELECT DISTINCT receiving_record_id
        FROM receiving_tasks
        WHERE assigned_user_id = p_user_id
      )
      AND rt.role_type IN ('shelf_stocker', 'night_supervisor')
      AND (rt.task_status != 'completed' OR rt.created_at >= v_cutoff)
    ) t;

    IF v_team_tasks IS NULL THEN
      v_team_tasks := '[]'::json;
    END IF;

    -- 4. Resolve employee names for team task users
    SELECT json_agg(json_build_object('user_id', e.user_id, 'name_en', COALESCE(e.name_en, e.name_ar, 'Unknown'), 'name_ar', COALESCE(e.name_ar, e.name_en, 'غير معروف')))
    INTO v_employee_names
    FROM hr_employee_master e
    WHERE e.user_id IN (
      SELECT DISTINCT rt.assigned_user_id
      FROM receiving_tasks rt
      WHERE rt.receiving_record_id IN (
        SELECT DISTINCT receiving_record_id
        FROM receiving_tasks
        WHERE assigned_user_id = p_user_id
      )
      AND rt.role_type IN ('shelf_stocker', 'night_supervisor')
      AND rt.assigned_user_id IS NOT NULL
    );

    IF v_employee_names IS NULL THEN
      v_employee_names := '[]'::json;
    END IF;
  ELSE
    v_team_tasks := '[]'::json;
    v_employee_names := '[]'::json;
  END IF;

  RETURN json_build_object(
    'my_tasks', v_my_tasks,
    'team_tasks', v_team_tasks,
    'is_branch_manager', v_is_branch_manager,
    'employee_names', v_employee_names
  );
END;
$$;



--
-- Name: get_reminder_statistics(uuid, integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_reminder_statistics(p_user_id uuid DEFAULT NULL::uuid, p_days integer DEFAULT 30) RETURNS TABLE(total_reminders bigint, reminders_today bigint, reminders_this_week bigint, reminders_this_month bigint, avg_hours_overdue numeric, most_overdue_task text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN QUERY
  WITH stats AS (
    SELECT
      COUNT(*) as total,
      COUNT(*) FILTER (WHERE DATE(reminder_sent_at) = CURRENT_DATE) as today,
      COUNT(*) FILTER (WHERE reminder_sent_at >= CURRENT_DATE - INTERVAL '7 days') as week,
      COUNT(*) FILTER (WHERE reminder_sent_at >= CURRENT_DATE - INTERVAL '30 days') as month,
      AVG(hours_overdue) as avg_overdue
    FROM task_reminder_logs
    WHERE (p_user_id IS NULL OR assigned_to_user_id = p_user_id)
      AND reminder_sent_at >= CURRENT_DATE - (p_days || ' days')::INTERVAL
  ),
  most_overdue AS (
    SELECT task_title
    FROM task_reminder_logs
    WHERE (p_user_id IS NULL OR assigned_to_user_id = p_user_id)
    ORDER BY hours_overdue DESC NULLS LAST
    LIMIT 1
  )
  SELECT 
    COALESCE(s.total, 0),
    COALESCE(s.today, 0),
    COALESCE(s.week, 0),
    COALESCE(s.month, 0),
    ROUND(COALESCE(s.avg_overdue, 0), 1),
    COALESCE(m.task_title, 'N/A')
  FROM stats s
  CROSS JOIN most_overdue m;
END;
$$;



--
-- Name: FUNCTION get_reminder_statistics(p_user_id uuid, p_days integer); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.get_reminder_statistics(p_user_id uuid, p_days integer) IS 'Returns statistics about sent reminders for a user or all users';


--
-- Name: get_report_data(text, uuid[]); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_report_data(p_party_type text, p_party_ids uuid[]) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN json_build_object(
        'entries', (
            SELECT COALESCE(json_agg(sub), '[]'::json)
            FROM (
                SELECT * FROM lease_rent_payment_entries
                WHERE party_type = p_party_type AND party_id = ANY(p_party_ids)
                ORDER BY created_at ASC
            ) sub
        ),
        'changes', (
            SELECT COALESCE(json_agg(sub), '[]'::json)
            FROM (
                SELECT * FROM lease_rent_special_changes
                WHERE party_type = p_party_type AND party_id = ANY(p_party_ids)
                ORDER BY created_at DESC
            ) sub
        )
    );
END;
$$;



--
-- Name: get_report_party_paid_totals(text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_report_party_paid_totals(p_party_type text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN (
        SELECT COALESCE(json_object_agg(party_id, total_paid), '{}'::json)
        FROM (
            SELECT party_id, SUM(amount)::numeric as total_paid
            FROM lease_rent_payment_entries
            WHERE party_type = p_party_type
            GROUP BY party_id
        ) sub
    );
END;
$$;



--
-- Name: get_server_disk_usage(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_server_disk_usage() RETURNS TABLE(filesystem text, total_size text, used_size text, available_size text, use_percent integer, mount_point text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $_$
BEGIN
  CREATE TEMP TABLE IF NOT EXISTS _disk_raw (line text) ON COMMIT DROP;
  TRUNCATE _disk_raw;

  COPY _disk_raw (line) FROM PROGRAM
    'df -h / | tail -n 1 | awk ''{print $1"|"$2"|"$3"|"$4"|"$5"|"$6}''';

  RETURN QUERY
  SELECT
    split_part(line, '|', 1),
    split_part(line, '|', 2),
    split_part(line, '|', 3),
    split_part(line, '|', 4),
    REPLACE(split_part(line, '|', 5), '%', '')::int,
    split_part(line, '|', 6)
  FROM _disk_raw
  LIMIT 1;
END;
$_$;



--
-- Name: get_stock_requests_with_details(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_stock_requests_with_details() RETURNS TABLE(id uuid, requester_user_id uuid, branch_id integer, target_user_id uuid, status character varying, items jsonb, document_url text, created_at timestamp with time zone, updated_at timestamp with time zone, requester_name_en text, requester_name_ar text, target_name_en text, target_name_ar text, branch_name_en text, branch_name_ar text, branch_location_en text, branch_location_ar text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        r.id,
        r.requester_user_id,
        r.branch_id,
        r.target_user_id,
        r.status,
        r.items,
        r.document_url,
        r.created_at,
        r.updated_at,
        -- Requester name
        COALESCE(req.name_en, req.user_id::TEXT)::TEXT AS requester_name_en,
        COALESCE(req.name_ar, req.name_en, req.user_id::TEXT)::TEXT AS requester_name_ar,
        -- Target name
        COALESCE(tgt.name_en, tgt.user_id::TEXT)::TEXT AS target_name_en,
        COALESCE(tgt.name_ar, tgt.name_en, tgt.user_id::TEXT)::TEXT AS target_name_ar,
        -- Branch info
        COALESCE(b.name_en, '')::TEXT AS branch_name_en,
        COALESCE(b.name_ar, b.name_en, '')::TEXT AS branch_name_ar,
        COALESCE(b.location_en, '')::TEXT AS branch_location_en,
        COALESCE(b.location_ar, b.location_en, '')::TEXT AS branch_location_ar
    FROM product_request_st r
    LEFT JOIN hr_employee_master req ON req.user_id = r.requester_user_id
    LEFT JOIN hr_employee_master tgt ON tgt.user_id = r.target_user_id
    LEFT JOIN branches b ON b.id = r.branch_id
    ORDER BY r.created_at DESC;
END;
$$;



--
-- Name: get_storage_buckets_info(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_storage_buckets_info() RETURNS TABLE(bucket_id text, bucket_name text, is_public boolean, created_at timestamp with time zone, updated_at timestamp with time zone, file_size_limit bigint, allowed_mime_types text[], file_count bigint, total_size bigint)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public', 'storage'
    AS $$
  SELECT 
    b.id::text AS bucket_id,
    b.name::text AS bucket_name,
    b.public AS is_public,
    b.created_at,
    b.updated_at,
    b.file_size_limit,
    b.allowed_mime_types,
    COALESCE(stats.file_count, 0) AS file_count,
    COALESCE(stats.total_size, 0) AS total_size
  FROM storage.buckets b
  LEFT JOIN (
    SELECT 
      bucket_id,
      COUNT(*) AS file_count,
      SUM(COALESCE((metadata->>'size')::bigint, 0)) AS total_size
    FROM storage.objects
    GROUP BY bucket_id
  ) stats ON stats.bucket_id = b.id
  ORDER BY total_size DESC NULLS LAST;
$$;



--
-- Name: get_storage_stats(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_storage_stats() RETURNS TABLE(bucket_id text, bucket_name text, file_count bigint, total_size bigint)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    SELECT 
        b.id::text AS bucket_id,
        b.name::text AS bucket_name,
        COALESCE(COUNT(o.id), 0) AS file_count,
        COALESCE(SUM((o.metadata->>'size')::bigint), 0) AS total_size
    FROM storage.buckets b
    LEFT JOIN storage.objects o ON o.bucket_id = b.id
    GROUP BY b.id, b.name
    ORDER BY total_size DESC;
$$;



--
-- Name: get_system_expiry_dates(text[], integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_system_expiry_dates(barcode_list text[], branch_id_param integer) RETURNS TABLE(barcode text, expiry_date_formatted text)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT 
    esp.barcode,
    COALESCE(
      (SELECT TO_CHAR((e->>'expiry_date')::date, 'DD-MM-YYYY')
       FROM jsonb_array_elements(esp.expiry_dates) as e
       WHERE (e->>'branch_id')::integer = branch_id_param
       LIMIT 1),
      'â€”'
    ) as expiry_date_formatted
  FROM erp_synced_products esp
  WHERE esp.barcode = ANY(barcode_list)
  ORDER BY esp.barcode;
$$;



--
-- Name: get_table_schemas(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_table_schemas() RETURNS TABLE(table_name text, column_count bigint, row_estimate bigint, table_size text, total_size text, schema_ddl text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  rec RECORD;
  col RECORD;
  con RECORD;
  idx RECORD;
  trg RECORD;
  pol RECORD;
  ddl text;
  col_line text;
  first_col boolean;
  tbl_oid oid;
  rls_enabled boolean;
BEGIN
  FOR rec IN
    SELECT
      t.tablename::text AS tname,
      (SELECT count(*) FROM information_schema.columns c WHERE c.table_schema = 'public' AND c.table_name = t.tablename) AS col_cnt,
      COALESCE(s.n_live_tup, 0) AS row_est,
      pg_size_pretty(pg_table_size(('public.' || quote_ident(t.tablename))::regclass)) AS tbl_size,
      pg_size_pretty(pg_total_relation_size(('public.' || quote_ident(t.tablename))::regclass)) AS tot_size
    FROM pg_tables t
    LEFT JOIN pg_stat_user_tables s ON s.schemaname = 'public' AND s.relname = t.tablename
    WHERE t.schemaname = 'public'
    ORDER BY pg_total_relation_size(('public.' || quote_ident(t.tablename))::regclass) DESC
  LOOP
    -- Get table OID
    tbl_oid := ('public.' || quote_ident(rec.tname))::regclass::oid;

    -- ==================== COLUMNS ====================
    ddl := 'CREATE TABLE public.' || quote_ident(rec.tname) || ' (' || E'\n';
    first_col := true;

    FOR col IN
      SELECT
        c.column_name,
        c.data_type,
        c.character_maximum_length,
        c.column_default,
        c.is_nullable,
        c.udt_name
      FROM information_schema.columns c
      WHERE c.table_schema = 'public' AND c.table_name = rec.tname
      ORDER BY c.ordinal_position
    LOOP
      IF NOT first_col THEN
        ddl := ddl || ',' || E'\n';
      END IF;
      first_col := false;

      col_line := '  ' || quote_ident(col.column_name) || ' ';

      IF col.data_type = 'USER-DEFINED' THEN
        col_line := col_line || col.udt_name;
      ELSIF col.data_type = 'character varying' THEN
        IF col.character_maximum_length IS NOT NULL THEN
          col_line := col_line || 'varchar(' || col.character_maximum_length || ')';
        ELSE
          col_line := col_line || 'varchar';
        END IF;
      ELSIF col.data_type = 'ARRAY' THEN
        col_line := col_line || col.udt_name;
      ELSE
        col_line := col_line || col.data_type;
      END IF;

      IF col.is_nullable = 'NO' THEN
        col_line := col_line || ' NOT NULL';
      END IF;

      IF col.column_default IS NOT NULL THEN
        col_line := col_line || ' DEFAULT ' || col.column_default;
      END IF;

      ddl := ddl || col_line;
    END LOOP;

    -- ==================== TABLE CONSTRAINTS (PK, UNIQUE, FK, CHECK) ====================
    FOR con IN
      SELECT
        pg_get_constraintdef(c2.oid, true) AS condef,
        c2.conname,
        c2.contype
      FROM pg_constraint c2
      WHERE c2.conrelid = tbl_oid
      ORDER BY
        CASE c2.contype WHEN 'p' THEN 1 WHEN 'u' THEN 2 WHEN 'f' THEN 3 WHEN 'c' THEN 4 ELSE 5 END,
        c2.conname
    LOOP
      ddl := ddl || ',' || E'\n' || '  CONSTRAINT ' || quote_ident(con.conname) || ' ' || con.condef;
    END LOOP;

    ddl := ddl || E'\n);';

    -- ==================== INDEXES (non-constraint) ====================
    FOR idx IN
      SELECT pg_get_indexdef(i.indexrelid) || ';' AS idxdef
      FROM pg_index i
      JOIN pg_class ic ON ic.oid = i.indexrelid
      WHERE i.indrelid = tbl_oid
        AND NOT i.indisprimary
        AND NOT i.indisunique
      ORDER BY ic.relname
    LOOP
      ddl := ddl || E'\n' || idx.idxdef;
    END LOOP;

    -- Also include unique indexes that are NOT backing a constraint
    FOR idx IN
      SELECT pg_get_indexdef(i.indexrelid) || ';' AS idxdef
      FROM pg_index i
      JOIN pg_class ic ON ic.oid = i.indexrelid
      WHERE i.indrelid = tbl_oid
        AND i.indisunique
        AND NOT i.indisprimary
        AND NOT EXISTS (
          SELECT 1 FROM pg_constraint pgc
          WHERE pgc.conindid = i.indexrelid
        )
      ORDER BY ic.relname
    LOOP
      ddl := ddl || E'\n' || idx.idxdef;
    END LOOP;

    -- ==================== TRIGGERS ====================
    FOR trg IN
      SELECT pg_get_triggerdef(t2.oid, true) || ';' AS trgdef
      FROM pg_trigger t2
      WHERE t2.tgrelid = tbl_oid
        AND NOT t2.tgisinternal
      ORDER BY t2.tgname
    LOOP
      ddl := ddl || E'\n\n' || trg.trgdef;
    END LOOP;

    -- ==================== RLS POLICIES ====================
    SELECT c3.relrowsecurity INTO rls_enabled
    FROM pg_class c3
    WHERE c3.oid = tbl_oid;

    IF rls_enabled THEN
      ddl := ddl || E'\n\n' || 'ALTER TABLE public.' || quote_ident(rec.tname) || ' ENABLE ROW LEVEL SECURITY;';

      FOR pol IN
        SELECT
          p.polname,
          CASE p.polcmd
            WHEN 'r' THEN 'SELECT'
            WHEN 'a' THEN 'INSERT'
            WHEN 'w' THEN 'UPDATE'
            WHEN 'd' THEN 'DELETE'
            WHEN '*' THEN 'ALL'
          END AS cmd,
          CASE p.polpermissive WHEN true THEN 'PERMISSIVE' ELSE 'RESTRICTIVE' END AS permissive,
          pg_get_expr(p.polqual, p.polrelid, true) AS using_expr,
          pg_get_expr(p.polwithcheck, p.polrelid, true) AS check_expr,
          ARRAY(
            SELECT rolname FROM pg_roles WHERE oid = ANY(p.polroles)
          ) AS roles
        FROM pg_policy p
        WHERE p.polrelid = tbl_oid
        ORDER BY p.polname
      LOOP
        ddl := ddl || E'\n' || 'CREATE POLICY ' || quote_ident(pol.polname)
          || ' ON public.' || quote_ident(rec.tname);

        IF pol.permissive = 'RESTRICTIVE' THEN
          ddl := ddl || ' AS RESTRICTIVE';
        END IF;

        ddl := ddl || ' FOR ' || pol.cmd;

        IF array_length(pol.roles, 1) IS NOT NULL AND pol.roles != ARRAY['public']::name[] THEN
          ddl := ddl || ' TO ' || array_to_string(pol.roles, ', ');
        END IF;

        IF pol.using_expr IS NOT NULL THEN
          ddl := ddl || E'\n  USING (' || pol.using_expr || ')';
        END IF;

        IF pol.check_expr IS NOT NULL THEN
          ddl := ddl || E'\n  WITH CHECK (' || pol.check_expr || ')';
        END IF;

        ddl := ddl || ';';
      END LOOP;
    END IF;

    table_name := rec.tname;
    column_count := rec.col_cnt;
    row_estimate := rec.row_est;
    table_size := rec.tbl_size;
    total_size := rec.tot_size;
    schema_ddl := ddl;
    RETURN NEXT;
  END LOOP;
END;
$$;



--
-- Name: get_task_dashboard(text, uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_task_dashboard(user_id_param text DEFAULT NULL::text, branch_id_param uuid DEFAULT NULL::uuid) RETURNS TABLE(total_tasks bigint, my_tasks bigint, completed_today bigint, overdue_count bigint, high_priority_count bigint, recent_completions json)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        (SELECT COUNT(*) FROM tasks WHERE deleted_at IS NULL) as total_tasks,
        (
            SELECT COUNT(DISTINCT ta.task_id) 
            FROM task_assignments ta 
            JOIN tasks t ON ta.task_id = t.id
            WHERE (ta.assigned_to_user_id = user_id_param OR ta.assignment_type = 'all' 
                   OR (ta.assignment_type = 'branch' AND ta.assigned_to_branch_id = branch_id_param))
            AND t.deleted_at IS NULL
        ) as my_tasks,
        (
            SELECT COUNT(*) 
            FROM task_completions tc 
            JOIN tasks t ON tc.task_id = t.id
            WHERE tc.completed_by = user_id_param 
            AND tc.completed_at::date = CURRENT_DATE
            AND t.deleted_at IS NULL
        ) as completed_today,
        (SELECT COUNT(*) FROM tasks WHERE due_date < CURRENT_DATE AND status IN ('active', 'draft', 'paused') AND deleted_at IS NULL) as overdue_count,
        (SELECT COUNT(*) FROM tasks WHERE priority = 'high' AND status IN ('active', 'draft', 'paused') AND deleted_at IS NULL) as high_priority_count,
        (
            SELECT json_agg(json_build_object(
                'task_id', tc.task_id,
                'task_title', t.title,
                'completed_at', tc.completed_at,
                'completed_by_name', tc.completed_by_name
            ))
            FROM task_completions tc
            JOIN tasks t ON tc.task_id = t.id
            WHERE tc.completed_at >= CURRENT_DATE - INTERVAL '7 days'
            AND t.deleted_at IS NULL
            ORDER BY tc.completed_at DESC
            LIMIT 10
        ) as recent_completions;
END;
$$;



--
-- Name: get_task_master_stats(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_task_master_stats(p_user_id uuid) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_result json;
  v_total_tasks bigint;
  v_completed_tasks bigint;
  v_incomplete_tasks bigint;
  v_my_assigned_tasks bigint;
  v_my_completed_tasks bigint;
  v_my_assignments bigint;
BEGIN
  -- Total tasks (all assignment types)
  SELECT
    (SELECT COUNT(*) FROM task_assignments) +
    (SELECT COUNT(*) FROM quick_task_assignments) +
    (SELECT COUNT(*) FROM receiving_tasks)
  INTO v_total_tasks;

  -- Completed tasks
  SELECT
    (SELECT COUNT(*) FROM task_completions) +
    (SELECT COUNT(*) FROM quick_task_completions) +
    (SELECT COUNT(*) FROM receiving_tasks WHERE task_status = 'completed')
  INTO v_completed_tasks;

  -- Incomplete tasks
  SELECT
    (SELECT COUNT(*) FROM task_assignments WHERE status NOT IN ('completed', 'closed')) +
    (SELECT COUNT(*) FROM quick_task_assignments WHERE status NOT IN ('completed', 'closed')) +
    (SELECT COUNT(*) FROM receiving_tasks WHERE task_status != 'completed' AND task_completed = false)
  INTO v_incomplete_tasks;

  -- My assigned tasks (active only)
  SELECT
    (SELECT COUNT(*) FROM task_assignments WHERE assigned_to_user_id = p_user_id AND status IN ('assigned', 'in_progress', 'pending')) +
    (SELECT COUNT(*) FROM quick_task_assignments WHERE assigned_to_user_id = p_user_id AND status IN ('assigned', 'in_progress', 'pending')) +
    (SELECT COUNT(*) FROM receiving_tasks WHERE assigned_user_id = p_user_id AND task_status IN ('pending', 'in_progress'))
  INTO v_my_assigned_tasks;

  -- My completed tasks
  SELECT
    (SELECT COUNT(*) FROM task_completions WHERE completed_by = p_user_id::text) +
    (SELECT COUNT(*) FROM quick_task_completions WHERE completed_by_user_id = p_user_id) +
    (SELECT COUNT(*) FROM receiving_tasks WHERE completed_by_user_id = p_user_id AND task_status = 'completed')
  INTO v_my_completed_tasks;

  -- My assignments (tasks I assigned to others)
  SELECT
    (SELECT COUNT(*) FROM task_assignments WHERE assigned_by = p_user_id) +
    (SELECT COUNT(*) FROM quick_tasks WHERE assigned_by = p_user_id)
  INTO v_my_assignments;

  v_result := json_build_object(
    'total_tasks', v_total_tasks,
    'completed_tasks', v_completed_tasks,
    'incomplete_tasks', v_incomplete_tasks,
    'my_assigned_tasks', v_my_assigned_tasks,
    'my_completed_tasks', v_my_completed_tasks,
    'my_assignments', v_my_assignments
  );

  RETURN v_result;
END;
$$;



--
-- Name: get_task_statistics(text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_task_statistics(user_id_param text DEFAULT NULL::text) RETURNS TABLE(total_tasks bigint, active_tasks bigint, completed_tasks bigint, draft_tasks bigint, paused_tasks bigint, cancelled_tasks bigint, my_assigned_tasks bigint, my_completed_tasks bigint, overdue_tasks bigint, due_today bigint, high_priority_tasks bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*) FILTER (WHERE t.deleted_at IS NULL) as total_tasks,
        COUNT(*) FILTER (WHERE t.status = 'active' AND t.deleted_at IS NULL) as active_tasks,
        COUNT(*) FILTER (WHERE t.status = 'completed' AND t.deleted_at IS NULL) as completed_tasks,
        COUNT(*) FILTER (WHERE t.status = 'draft' AND t.deleted_at IS NULL) as draft_tasks,
        COUNT(*) FILTER (WHERE t.status = 'paused' AND t.deleted_at IS NULL) as paused_tasks,
        COUNT(*) FILTER (WHERE t.status = 'cancelled' AND t.deleted_at IS NULL) as cancelled_tasks,
        COUNT(DISTINCT ta.task_id) FILTER (WHERE (ta.assigned_to_user_id = user_id_param OR ta.assignment_type = 'all') AND t.deleted_at IS NULL) as my_assigned_tasks,
        COUNT(DISTINCT tc.task_id) FILTER (WHERE tc.completed_by = user_id_param AND t.deleted_at IS NULL) as my_completed_tasks,
        COUNT(*) FILTER (WHERE t.due_date < CURRENT_DATE AND t.status IN ('active', 'draft', 'paused') AND t.deleted_at IS NULL) as overdue_tasks,
        COUNT(*) FILTER (WHERE t.due_date = CURRENT_DATE AND t.status IN ('active', 'draft', 'paused') AND t.deleted_at IS NULL) as due_today,
        COUNT(*) FILTER (WHERE t.priority = 'high' AND t.status IN ('active', 'draft', 'paused') AND t.deleted_at IS NULL) as high_priority_tasks
    FROM public.tasks t
    LEFT JOIN public.task_assignments ta ON t.id = ta.task_id
    LEFT JOIN public.task_completions tc ON t.id = tc.task_id AND tc.completed_by = user_id_param;
END;
$$;



--
-- Name: get_task_statistics(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_task_statistics(user_id uuid DEFAULT NULL::uuid) RETURNS TABLE(total_tasks bigint, pending_tasks bigint, in_progress_tasks bigint, completed_tasks bigint, overdue_tasks bigint)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::BIGINT as total_tasks,
        COUNT(CASE WHEN t.status = 'pending' THEN 1 END)::BIGINT as pending_tasks,
        COUNT(CASE WHEN t.status = 'in_progress' THEN 1 END)::BIGINT as in_progress_tasks,
        COUNT(CASE WHEN t.status = 'completed' THEN 1 END)::BIGINT as completed_tasks,
        COUNT(CASE WHEN t.status = 'overdue' THEN 1 END)::BIGINT as overdue_tasks
    FROM tasks t
    LEFT JOIN task_assignments ta ON t.id = ta.task_id
    WHERE (user_id IS NULL OR ta.assigned_to = user_id OR t.created_by = user_id)
      AND t.deleted_at IS NULL;
END;
$$;



--
-- Name: get_tasks_for_receiving_record(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

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
-- Name: get_todays_scheduled_visits(date); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_todays_scheduled_visits(target_date date DEFAULT CURRENT_DATE) RETURNS TABLE(id uuid, vendor_name text, branch_name text, visit_type text, pattern_info text, notes text, branch_id uuid, vendor_id uuid, weekday_name text, fresh_type text, day_number integer, skip_days integer, start_date date, next_visit_date date)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        vv.id,
        v.name::TEXT as vendor_name,
        b.name::TEXT as branch_name,
        vv.visit_type::TEXT,
        CASE 
            WHEN vv.visit_type = 'weekly' THEN ('Weekly on ' || COALESCE(vv.weekday_name, ''))::TEXT
            WHEN vv.visit_type = 'daily' THEN ('Daily (' || COALESCE(vv.fresh_type, '') || ')')::TEXT
            WHEN vv.visit_type = 'monthly' THEN ('Monthly on day ' || COALESCE(vv.day_number::TEXT, ''))::TEXT
            WHEN vv.visit_type = 'skip_days' THEN ('Every ' || COALESCE(vv.skip_days::TEXT, '') || ' days')::TEXT
            ELSE vv.visit_type::TEXT
        END as pattern_info,
        COALESCE(vv.notes, '')::TEXT,
        vv.branch_id,
        vv.vendor_id,
        COALESCE(vv.weekday_name, '')::TEXT,
        COALESCE(vv.fresh_type, '')::TEXT,
        vv.day_number,
        vv.skip_days,
        vv.start_date,
        vv.next_visit_date
    FROM vendor_visits vv
    JOIN vendors v ON vv.vendor_id = v.id
    JOIN branches b ON vv.branch_id = b.id
    WHERE vv.next_visit_date = target_date
    AND vv.status = 'active'
    ORDER BY b.name, v.name;
END;
$$;



--
-- Name: get_todays_scheduled_visits(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_todays_scheduled_visits(branch_uuid uuid DEFAULT NULL::uuid) RETURNS TABLE(visit_id uuid, vendor_name text, vendor_company text, visit_type text, fresh_type text, notes text, branch_name text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        vv.id as visit_id,
        v.name as vendor_name,
        v.company as vendor_company,
        vv.visit_type,
        vv.fresh_type,
        vv.notes,
        b.name as branch_name
    FROM vendor_visits vv
    JOIN vendors v ON vv.vendor_id = v.id
    JOIN branches b ON vv.branch_id = b.id
    WHERE vv.next_visit_date = CURRENT_DATE
    AND vv.status = 'active'
    AND (branch_uuid IS NULL OR vv.branch_id = branch_uuid)
    ORDER BY v.company;
END;
$$;



--
-- Name: get_todays_vendor_visits(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_todays_vendor_visits(branch_uuid uuid) RETURNS TABLE(visit_id uuid, vendor_name text, vendor_company text, visit_time time without time zone, purpose text, status text, priority text, contact_person text, expected_duration_minutes integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        vv.id as visit_id,
        v.name as vendor_name,
        v.company as vendor_company,
        vv.visit_time,
        vv.purpose,
        vv.status,
        vv.priority,
        vv.contact_person,
        vv.expected_duration_minutes
    FROM vendor_visits vv
    JOIN vendors v ON vv.vendor_id = v.id
    WHERE vv.branch_id = branch_uuid 
    AND vv.visit_date = CURRENT_DATE
    AND vv.status IN ('scheduled', 'confirmed', 'in_progress')
    ORDER BY vv.visit_time ASC NULLS LAST, vv.priority DESC;
END;
$$;



--
-- Name: get_todays_visits(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_todays_visits(branch_uuid uuid DEFAULT NULL::uuid) RETURNS TABLE(id uuid, vendor_name text, branch_name text, visit_type text, next_visit_date date, pattern_config jsonb, notes text, last_visit_date date, visit_count integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        vv.id,
        v.name::TEXT as vendor_name,
        b.name::TEXT as branch_name,
        vv.visit_type::TEXT,
        vv.next_visit_date,
        COALESCE(vv.pattern_config, '{}'::jsonb) as pattern_config,
        COALESCE(vv.notes, '')::TEXT,
        vv.last_visit_date,
        COALESCE(
            (SELECT COUNT(*)::INTEGER 
             FROM visit_history vh 
             WHERE vh.visit_schedule_id = vv.id 
             AND vh.status = 'completed'), 
            0
        ) as visit_count
    FROM vendor_visits vv
    JOIN vendors v ON vv.vendor_id = v.id
    JOIN branches b ON vv.branch_id = b.id
    WHERE vv.next_visit_date = CURRENT_DATE
    AND COALESCE(vv.is_active, true) = true
    AND (branch_uuid IS NULL OR vv.branch_id = branch_uuid)
    ORDER BY v.name ASC;
END;
$$;



--
-- Name: get_upcoming_visits(uuid, integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_upcoming_visits(branch_uuid uuid DEFAULT NULL::uuid, days_ahead integer DEFAULT 7) RETURNS TABLE(visit_id uuid, vendor_name text, vendor_company text, visit_type text, next_visit_date date, days_until_visit integer, notes text, branch_name text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        vv.id as visit_id,
        v.name as vendor_name,
        v.company as vendor_company,
        vv.visit_type,
        vv.next_visit_date,
        (vv.next_visit_date - CURRENT_DATE)::INTEGER as days_until_visit,
        vv.notes,
        b.name as branch_name
    FROM vendor_visits vv
    JOIN vendors v ON vv.vendor_id = v.id
    JOIN branches b ON vv.branch_id = b.id
    WHERE vv.next_visit_date BETWEEN CURRENT_DATE AND CURRENT_DATE + days_ahead
    AND vv.status = 'active'
    AND (branch_uuid IS NULL OR vv.branch_id = branch_uuid)
    ORDER BY vv.next_visit_date, v.company;
END;
$$;



--
-- Name: get_user_assigned_tasks(text, uuid, text, integer, integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_user_assigned_tasks(user_id_param text, branch_id_param uuid DEFAULT NULL::uuid, status_filter text DEFAULT NULL::text, limit_param integer DEFAULT 50, offset_param integer DEFAULT 0) RETURNS TABLE(id uuid, title text, description text, require_task_finished boolean, require_photo_upload boolean, require_erp_reference boolean, can_escalate boolean, can_reassign boolean, created_by text, created_by_name text, status text, priority text, created_at timestamp with time zone, updated_at timestamp with time zone, due_date date, due_time time without time zone, assignment_status text, assigned_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        t.id, t.title, t.description, t.require_task_finished, t.require_photo_upload, t.require_erp_reference,
        t.can_escalate, t.can_reassign, t.created_by, t.created_by_name, t.status, t.priority,
        t.created_at, t.updated_at, t.due_date, t.due_time,
        ta.status as assignment_status, ta.assigned_at
    FROM public.tasks t
    INNER JOIN public.task_assignments ta ON t.id = ta.task_id
    WHERE t.deleted_at IS NULL
    AND (
        ta.assignment_type = 'all' 
        OR (ta.assignment_type = 'user' AND ta.assigned_to_user_id = user_id_param)
        OR (ta.assignment_type = 'branch' AND ta.assigned_to_branch_id = branch_id_param)
    )
    AND (status_filter IS NULL OR t.status = status_filter)
    ORDER BY t.created_at DESC
    LIMIT limit_param OFFSET offset_param;
END;
$$;



--
-- Name: get_user_interface_permissions(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_user_interface_permissions(p_user_id uuid) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_permissions record;
    v_user_type text;
    result json;
BEGIN
    -- Get user type
    SELECT user_type INTO v_user_type
    FROM public.users
    WHERE id = p_user_id;
    
    IF v_user_type IS NULL THEN
        RAISE EXCEPTION 'User not found';
    END IF;
    
    -- Get interface permissions
    SELECT 
        desktop_enabled,
        mobile_enabled,
        customer_enabled
    INTO v_permissions
    FROM public.interface_permissions
    WHERE user_id = p_user_id;
    
    -- If no permissions record exists, create default
    IF v_permissions IS NULL THEN
        INSERT INTO public.interface_permissions (
            user_id,
            desktop_enabled,
            mobile_enabled,
            customer_enabled,
            updated_by
        ) VALUES (
            p_user_id,
            CASE WHEN v_user_type = 'customer' THEN false ELSE true END,
            CASE WHEN v_user_type = 'customer' THEN false ELSE true END,
            CASE WHEN v_user_type = 'customer' THEN true ELSE false END,
            p_user_id
        ) RETURNING desktop_enabled, mobile_enabled, customer_enabled
        INTO v_permissions;
    END IF;
    
    -- Return permissions
    result := json_build_object(
        'success', true,
        'user_id', p_user_id,
        'user_type', v_user_type,
        'permissions', json_build_object(
            'desktop_enabled', v_permissions.desktop_enabled,
            'mobile_enabled', v_permissions.mobile_enabled,
            'customer_enabled', v_permissions.customer_enabled
        )
    );
    
    RETURN result;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'success', false,
            'error', SQLERRM
        );
END;
$$;



--
-- Name: get_user_receiving_tasks_dashboard(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_user_receiving_tasks_dashboard(user_id_param uuid) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_result JSON;
  v_pending_count INT;
  v_completed_count INT;
  v_overdue_count INT;
BEGIN
  -- Count statistics
  SELECT COUNT(*) INTO v_pending_count
  FROM receiving_tasks
  WHERE assigned_user_id = user_id_param
  AND task_completed = false
  AND task_status != 'completed';
  
  SELECT COUNT(*) INTO v_completed_count
  FROM receiving_tasks
  WHERE assigned_user_id = user_id_param
  AND (task_completed = true OR task_status = 'completed');
  
  SELECT COUNT(*) INTO v_overdue_count
  FROM receiving_tasks
  WHERE assigned_user_id = user_id_param
  AND due_date < NOW()
  AND task_completed = false
  AND task_status != 'completed';
  
  -- Build JSON result
  SELECT json_build_object(
    'user_id', user_id_param,
    'statistics', json_build_object(
      'pending_count', v_pending_count,
      'completed_count', v_completed_count,
      'overdue_count', v_overdue_count,
      'total_count', v_pending_count + v_completed_count
    ),
    'recent_tasks', (
      SELECT COALESCE(json_agg(tasks_json), '[]'::json)
      FROM (
        SELECT json_build_object(
          'id', rt.id,
          'receiving_record_id', rt.receiving_record_id,
          'role_type', rt.role_type,
          'title', rt.title,
          'description', rt.description,
          'priority', rt.priority,
          'task_status', rt.task_status,
          'task_completed', rt.task_completed,
          'due_date', rt.due_date,
          'completed_at', rt.completed_at,
          'clearance_certificate_url', rt.clearance_certificate_url,
          'created_at', rt.created_at,
          'bill_number', rr.bill_number,
          'bill_amount', rr.bill_amount,
          'vendor_name', v.vendor_name,
          'branch_name', b.name_en,
          'is_overdue', (rt.due_date < NOW() AND rt.task_status != 'completed'),
          'days_until_due', EXTRACT(DAY FROM (rt.due_date - NOW()))::INTEGER
        ) as tasks_json
        FROM receiving_tasks rt
        LEFT JOIN receiving_records rr ON rr.id = rt.receiving_record_id
        LEFT JOIN vendors v ON v.erp_vendor_id = rr.vendor_id AND v.branch_id = rr.branch_id
        LEFT JOIN branches b ON b.id = rr.branch_id
        WHERE rt.assigned_user_id = user_id_param
        ORDER BY rt.created_at DESC
        LIMIT 20
      ) tasks
    )
  ) INTO v_result;
  
  RETURN v_result;
END;
$$;



--
-- Name: get_users_with_employee_details(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_users_with_employee_details() RETURNS TABLE(id uuid, username character varying, email character varying, role_type character varying, status character varying, employee_id uuid, employee_name character varying, employee_code character varying, employee_status character varying, department_name character varying, position_title character varying, branch_name character varying, created_at timestamp with time zone, updated_at timestamp with time zone)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        u.id,
        u.username,
        ''::VARCHAR as email,
        -- Use admin flags instead of role_type column
        CASE 
            WHEN u.is_master_admin THEN 'Master Admin'::VARCHAR
            WHEN u.is_admin THEN 'Admin'::VARCHAR
            ELSE 'User'::VARCHAR
        END as role_type,
        COALESCE(u.status::VARCHAR, 'active') as status,
        u.employee_id,
        COALESCE(e.name, u.username)::VARCHAR as employee_name,
        COALESCE(e.employee_id, '')::VARCHAR as employee_code,
        COALESCE(e.status, 'active')::VARCHAR as employee_status,
        COALESCE(d.department_name_en, 'No Department')::VARCHAR as department_name,
        COALESCE(p.position_title_en, 'No Position')::VARCHAR as position_title,
        COALESCE(b.name_en, 'No Branch')::VARCHAR as branch_name,
        u.created_at,
        u.updated_at
    FROM users u
    LEFT JOIN hr_employees e ON u.employee_id = e.id
    LEFT JOIN branches b ON u.branch_id = b.id
    LEFT JOIN hr_positions p ON u.position_id = p.id
    LEFT JOIN hr_departments d ON p.department_id = d.id
    WHERE u.status = 'active'
    ORDER BY u.created_at DESC;
END;
$$;



--
-- Name: get_variation_group_info(text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_variation_group_info(p_barcode text) RETURNS TABLE(parent_barcode text, group_name_en text, group_name_ar text, total_variations integer, variation_image_override text, created_by uuid, modified_by uuid, modified_at timestamp with time zone)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN QUERY
  WITH parent_info AS (
    SELECT 
      COALESCE(p.parent_product_barcode, p.barcode) as parent_ref
    FROM products p
    WHERE p.barcode = p_barcode
  )
  SELECT 
    parent.barcode as parent_barcode,
    parent.variation_group_name_en as group_name_en,
    parent.variation_group_name_ar as group_name_ar,
    COUNT(DISTINCT variations.barcode)::INTEGER as total_variations,
    parent.variation_image_override,
    parent.created_by,
    parent.modified_by,
    parent.modified_at
  FROM products parent
  LEFT JOIN products variations 
    ON variations.parent_product_barcode = parent.barcode 
    OR variations.barcode = parent.barcode
  WHERE parent.barcode = (SELECT parent_ref FROM parent_info)
    AND parent.is_variation = true
  GROUP BY 
    parent.barcode,
    parent.variation_group_name_en,
    parent.variation_group_name_ar,
    parent.variation_image_override,
    parent.created_by,
    parent.modified_by,
    parent.modified_at;
END;
$$;



--
-- Name: get_vendor_count_by_branch(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_vendor_count_by_branch() RETURNS TABLE(branch_id bigint, branch_name text, vendor_count bigint, active_vendor_count bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        b.id as branch_id,
        b.name_en as branch_name,
        COUNT(v.erp_vendor_id) as vendor_count,
        COUNT(CASE WHEN v.status = 'Active' THEN 1 END) as active_vendor_count
    FROM branches b
    LEFT JOIN vendors v ON b.id = v.branch_id
    GROUP BY b.id, b.name_en
    ORDER BY b.name_en;
END;
$$;



--
-- Name: get_vendor_for_receiving_record(integer, bigint); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_vendor_for_receiving_record(vendor_id_param integer, branch_id_param bigint) RETURNS TABLE(erp_vendor_id integer, vendor_name text, vat_number text, salesman_name text, salesman_contact text, branch_id bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        v.erp_vendor_id,
        v.vendor_name,
        v.vat_number,
        v.salesman_name,
        v.salesman_contact,
        v.branch_id
    FROM vendors v
    WHERE v.erp_vendor_id = vendor_id_param
    AND (v.branch_id = branch_id_param OR v.branch_id IS NULL)
    LIMIT 1;
END;
$$;



--
-- Name: FUNCTION get_vendor_for_receiving_record(vendor_id_param integer, branch_id_param bigint); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.get_vendor_for_receiving_record(vendor_id_param integer, branch_id_param bigint) IS 'Gets vendor details for a receiving record, ensuring branch compatibility';


--
-- Name: get_vendor_pending_summary(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_vendor_pending_summary() RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  result jsonb;
  vps_paid numeric := 0;
  vps_unpaid numeric := 0;
  exp_paid numeric := 0;
  exp_unpaid numeric := 0;
  vendor_count integer := 0;
  vendors_arr jsonb;
  methods_arr jsonb;
BEGIN
  -- 1. Aggregate totals from vendor_payment_schedule
  SELECT
    COALESCE(SUM(CASE WHEN is_paid THEN final_bill_amount ELSE 0 END), 0),
    COALESCE(SUM(CASE WHEN NOT is_paid THEN final_bill_amount ELSE 0 END), 0)
  INTO vps_paid, vps_unpaid
  FROM vendor_payment_schedule;

  -- 2. Aggregate totals from expense_scheduler (vendor expenses only)
  SELECT
    COALESCE(SUM(CASE WHEN is_paid THEN amount ELSE 0 END), 0),
    COALESCE(SUM(CASE WHEN NOT is_paid THEN amount ELSE 0 END), 0)
  INTO exp_paid, exp_unpaid
  FROM expense_scheduler
  WHERE vendor_id IS NOT NULL;

  -- 3. Get distinct vendors from both tables
  WITH all_vendors AS (
    SELECT DISTINCT vendor_id::text AS vid, vendor_name AS vname
    FROM vendor_payment_schedule
    WHERE vendor_id IS NOT NULL AND vendor_name IS NOT NULL
    UNION
    SELECT DISTINCT vendor_id::text AS vid, vendor_name AS vname
    FROM expense_scheduler
    WHERE vendor_id IS NOT NULL AND vendor_name IS NOT NULL
  )
  SELECT
    COUNT(*),
    COALESCE(jsonb_agg(jsonb_build_object('vendor_id', vid, 'vendor_name', vname) ORDER BY vname), '[]'::jsonb)
  INTO vendor_count, vendors_arr
  FROM all_vendors;

  -- 4. Get distinct payment methods from both tables
  WITH all_methods AS (
    SELECT DISTINCT payment_method AS m
    FROM vendor_payment_schedule
    WHERE payment_method IS NOT NULL AND payment_method != ''
    UNION
    SELECT DISTINCT payment_method AS m
    FROM expense_scheduler
    WHERE payment_method IS NOT NULL AND payment_method != '' AND vendor_id IS NOT NULL
  )
  SELECT COALESCE(jsonb_agg(m ORDER BY m), '[]'::jsonb)
  INTO methods_arr
  FROM all_methods;

  -- 5. Build final result
  result := jsonb_build_object(
    'global_total_paid', vps_paid + exp_paid,
    'global_total_unpaid', vps_unpaid + exp_unpaid,
    'global_grand_total', vps_paid + exp_paid + vps_unpaid + exp_unpaid,
    'total_vendor_count', vendor_count,
    'vendors', vendors_arr,
    'payment_methods', methods_arr
  );

  RETURN result;
END;
$$;



--
-- Name: get_vendor_promissory_notes_summary(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_vendor_promissory_notes_summary(vendor_uuid uuid) RETURNS TABLE(total_notes integer, total_active_amount numeric, total_collected_amount numeric, oldest_active_date date, newest_note_date date)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::INTEGER as total_notes,
        COALESCE(SUM(CASE WHEN status = 'active' THEN amount ELSE 0 END), 0) as total_active_amount,
        COALESCE(SUM(CASE WHEN status = 'collected' THEN amount ELSE 0 END), 0) as total_collected_amount,
        MIN(CASE WHEN status = 'active' THEN signed_date END) as oldest_active_date,
        MAX(signed_date) as newest_note_date
    FROM promissory_notes 
    WHERE vendor_id = vendor_uuid;
END;
$$;



--
-- Name: get_vendor_visits_summary(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_vendor_visits_summary(vendor_uuid uuid) RETURNS TABLE(total_visits integer, completed_visits integer, scheduled_visits integer, cancelled_visits integer, last_visit_date date, next_visit_date date, avg_duration_minutes numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::INTEGER as total_visits,
        COUNT(CASE WHEN status = 'completed' THEN 1 END)::INTEGER as completed_visits,
        COUNT(CASE WHEN status IN ('scheduled', 'confirmed') THEN 1 END)::INTEGER as scheduled_visits,
        COUNT(CASE WHEN status = 'cancelled' THEN 1 END)::INTEGER as cancelled_visits,
        MAX(CASE WHEN status = 'completed' THEN visit_date END) as last_visit_date,
        MIN(CASE WHEN status IN ('scheduled', 'confirmed') AND visit_date >= CURRENT_DATE THEN visit_date END) as next_visit_date,
        AVG(CASE 
            WHEN actual_start_time IS NOT NULL AND actual_end_time IS NOT NULL 
            THEN EXTRACT(EPOCH FROM (actual_end_time - actual_start_time))/60 
            ELSE expected_duration_minutes 
        END)::NUMERIC(10,2) as avg_duration_minutes
    FROM vendor_visits 
    WHERE vendor_id = vendor_uuid;
END;
$$;



--
-- Name: get_vendors_by_branch(bigint); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_vendors_by_branch(branch_id_param bigint DEFAULT NULL::bigint) RETURNS TABLE(erp_vendor_id integer, vendor_name text, salesman_name text, vendor_contact_number text, payment_method text, status text, branch_id bigint, categories text[], delivery_modes text[], place text, vat_number text, created_at timestamp without time zone, updated_at timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF branch_id_param IS NULL THEN
        -- Return all vendors if no branch specified
        RETURN QUERY
        SELECT 
            v.erp_vendor_id,
            v.vendor_name,
            v.salesman_name,
            v.vendor_contact_number,
            v.payment_method,
            v.status,
            v.branch_id,
            v.categories,
            v.delivery_modes,
            v.place,
            v.vat_number,
            v.created_at,
            v.updated_at
        FROM vendors v
        ORDER BY v.vendor_name;
    ELSE
        -- Return vendors for specific branch
        RETURN QUERY
        SELECT 
            v.erp_vendor_id,
            v.vendor_name,
            v.salesman_name,
            v.vendor_contact_number,
            v.payment_method,
            v.status,
            v.branch_id,
            v.categories,
            v.delivery_modes,
            v.place,
            v.vat_number,
            v.created_at,
            v.updated_at
        FROM vendors v
        WHERE v.branch_id = branch_id_param
        ORDER BY v.vendor_name;
    END IF;
END;
$$;



--
-- Name: get_visit_history(date, date, uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_visit_history(start_date_param date DEFAULT (CURRENT_DATE - '30 days'::interval), end_date_param date DEFAULT CURRENT_DATE, branch_uuid uuid DEFAULT NULL::uuid) RETURNS TABLE(id uuid, vendor_name text, branch_name text, visit_type text, scheduled_date date, actual_date date, status text, outcome_notes text, completed_by text, duration_minutes integer, next_scheduled_date date, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        vh.id,
        v.name::TEXT as vendor_name,
        b.name::TEXT as branch_name,
        vv.visit_type::TEXT,
        vh.scheduled_date,
        vh.actual_date,
        vh.status::TEXT,
        COALESCE(vh.outcome_notes, '')::TEXT,
        COALESCE(vh.completed_by, '')::TEXT,
        vh.duration_minutes,
        vh.next_scheduled_date,
        vh.created_at
    FROM visit_history vh
    JOIN vendor_visits vv ON vh.visit_schedule_id = vv.id
    JOIN vendors v ON vh.vendor_id = v.id
    JOIN branches b ON vh.branch_id = b.id
    WHERE vh.scheduled_date BETWEEN start_date_param AND end_date_param
    AND (branch_uuid IS NULL OR vh.branch_id = branch_uuid)
    ORDER BY vh.scheduled_date DESC, vh.created_at DESC;
END;
$$;



--
-- Name: get_visits_by_date_range(date, date); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_visits_by_date_range(start_date date DEFAULT CURRENT_DATE, end_date date DEFAULT CURRENT_DATE) RETURNS TABLE(id uuid, vendor_name text, branch_name text, visit_type text, pattern_info text, notes text, branch_id uuid, vendor_id uuid, weekday_name text, fresh_type text, day_number integer, skip_days integer, start_date_schedule date, next_visit_date date, is_past boolean, is_today boolean, is_future boolean, days_difference integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        vv.id,
        v.name::TEXT as vendor_name,
        b.name::TEXT as branch_name,
        vv.visit_type::TEXT,
        CASE 
            WHEN vv.visit_type = 'weekly' THEN ('Weekly on ' || COALESCE(vv.weekday_name, ''))::TEXT
            WHEN vv.visit_type = 'daily' THEN ('Daily (' || COALESCE(vv.fresh_type, '') || ')')::TEXT
            WHEN vv.visit_type = 'monthly' THEN ('Monthly on day ' || COALESCE(vv.day_number::TEXT, ''))::TEXT
            WHEN vv.visit_type = 'skip_days' THEN ('Every ' || COALESCE(vv.skip_days::TEXT, '') || ' days')::TEXT
            ELSE vv.visit_type::TEXT
        END as pattern_info,
        COALESCE(vv.notes, '')::TEXT,
        vv.branch_id,
        vv.vendor_id,
        COALESCE(vv.weekday_name, '')::TEXT,
        COALESCE(vv.fresh_type, '')::TEXT,
        vv.day_number,
        vv.skip_days,
        vv.start_date as start_date_schedule,
        vv.next_visit_date,
        (vv.next_visit_date < CURRENT_DATE) as is_past,
        (vv.next_visit_date = CURRENT_DATE) as is_today,
        (vv.next_visit_date > CURRENT_DATE) as is_future,
        (vv.next_visit_date - CURRENT_DATE)::INTEGER as days_difference
    FROM vendor_visits vv
    JOIN vendors v ON vv.vendor_id = v.id
    JOIN branches b ON vv.branch_id = b.id
    WHERE vv.next_visit_date BETWEEN start_date AND end_date
    AND vv.status = 'active'
    ORDER BY vv.next_visit_date DESC, b.name, v.name;
END;
$$;



--
-- Name: get_visits_by_date_range(date, date, uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_visits_by_date_range(start_date_param date DEFAULT CURRENT_DATE, end_date_param date DEFAULT (CURRENT_DATE + '7 days'::interval), branch_uuid uuid DEFAULT NULL::uuid) RETURNS TABLE(id uuid, vendor_name text, branch_name text, visit_type text, next_visit_date date, pattern_config jsonb, notes text, is_active boolean, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        vv.id,
        v.name::TEXT as vendor_name,
        b.name::TEXT as branch_name,
        vv.visit_type::TEXT,
        vv.next_visit_date,
        COALESCE(vv.pattern_config, '{}'::jsonb) as pattern_config,
        COALESCE(vv.notes, '')::TEXT,
        COALESCE(vv.is_active, true) as is_active,
        vv.created_at
    FROM vendor_visits vv
    JOIN vendors v ON vv.vendor_id = v.id
    JOIN branches b ON vv.branch_id = b.id
    WHERE vv.next_visit_date BETWEEN start_date_param AND end_date_param
    AND COALESCE(vv.is_active, true) = true
    AND (branch_uuid IS NULL OR vv.branch_id = branch_uuid)
    ORDER BY vv.next_visit_date ASC;
END;
$$;



--
-- Name: get_wa_catalog_stats(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_wa_catalog_stats(p_account_id uuid) RETURNS TABLE(total_catalogs bigint, total_products bigint, active_products bigint, hidden_products bigint, total_orders bigint, pending_orders bigint, total_revenue numeric)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    SELECT
        (SELECT count(*) FROM wa_catalogs WHERE wa_account_id = p_account_id),
        (SELECT count(*) FROM wa_catalog_products WHERE wa_account_id = p_account_id),
        (SELECT count(*) FROM wa_catalog_products WHERE wa_account_id = p_account_id AND status = 'active' AND NOT is_hidden),
        (SELECT count(*) FROM wa_catalog_products WHERE wa_account_id = p_account_id AND is_hidden),
        (SELECT count(*) FROM wa_catalog_orders WHERE wa_account_id = p_account_id),
        (SELECT count(*) FROM wa_catalog_orders WHERE wa_account_id = p_account_id AND order_status = 'pending'),
        (SELECT COALESCE(sum(total), 0) FROM wa_catalog_orders WHERE wa_account_id = p_account_id AND order_status NOT IN ('cancelled', 'refunded'));
$$;



--
-- Name: get_wa_contacts(integer, integer, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_wa_contacts(p_limit integer DEFAULT 100, p_offset integer DEFAULT 0, p_search text DEFAULT NULL::text) RETURNS TABLE(id uuid, name text, whatsapp_number character varying, registration_status text, whatsapp_available boolean, created_at timestamp with time zone, approved_at timestamp with time zone, last_login_at timestamp with time zone, is_deleted boolean, conversation_id uuid, last_message_at timestamp with time zone, last_interaction_at timestamp with time zone, unread_count integer, is_inside_24hr boolean, handled_by text, is_bot_handling boolean, total_count bigint)
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
  SELECT
    c.id,
    c.name::text AS name,
    c.whatsapp_number,
    c.registration_status,
    c.whatsapp_available,
    c.created_at,
    c.approved_at,
    c.last_login_at,
    COALESCE(c.is_deleted, false) AS is_deleted,
    conv.id AS conversation_id,
    conv.last_message_at,
    GREATEST(conv.last_message_at, code_hist.last_code_at, c.created_at) AS last_interaction_at,
    COALESCE(conv.unread_count, 0)::int AS unread_count,
    CASE
      WHEN conv.last_message_at IS NOT NULL
        AND conv.last_message_at > (now() - interval '24 hours')
      THEN true
      ELSE false
    END AS is_inside_24hr,
    COALESCE(conv.handled_by, 'bot') AS handled_by,
    COALESCE(conv.is_bot_handling, true) AS is_bot_handling,
    COUNT(*) OVER() AS total_count
  FROM customers c
  LEFT JOIN LATERAL (
    SELECT wc.id, wc.last_message_at, wc.unread_count, wc.handled_by, wc.is_bot_handling
    FROM wa_conversations wc
    WHERE wc.customer_phone = c.whatsapp_number
      AND wc.status = 'active'
    ORDER BY wc.created_at DESC
    LIMIT 1
  ) conv ON true
  LEFT JOIN LATERAL (
    SELECT MAX(ach.created_at) AS last_code_at
    FROM customer_access_code_history ach
    WHERE ach.customer_id = c.id
  ) code_hist ON true
  WHERE c.whatsapp_number IS NOT NULL
    AND c.whatsapp_number != ''
    AND COALESCE(c.is_deleted, false) = false
    AND (
      p_search IS NULL
      OR c.name ILIKE '%' || p_search || '%'
      OR c.whatsapp_number ILIKE '%' || p_search || '%'
    )
  ORDER BY GREATEST(conv.last_message_at, code_hist.last_code_at, c.created_at) DESC NULLS LAST
  LIMIT p_limit
  OFFSET p_offset;
$$;



--
-- Name: get_wa_conversations_fast(uuid, integer, integer, text, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_wa_conversations_fast(p_account_id uuid, p_limit integer DEFAULT 50, p_offset integer DEFAULT 0, p_search text DEFAULT NULL::text, p_filter text DEFAULT 'all'::text) RETURNS TABLE(id uuid, customer_phone character varying, customer_name text, last_message_at timestamp with time zone, last_message_preview text, unread_count integer, is_bot_handling boolean, bot_type character varying, handled_by character varying, needs_human boolean, status character varying, is_inside_24hr boolean, is_sos boolean, total_count bigint)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.id,
        c.customer_phone,
        c.customer_name,
        c.last_message_at,
        c.last_message_preview,
        c.unread_count,
        c.is_bot_handling,
        c.bot_type,
        c.handled_by,
        c.needs_human,
        c.status,
        CASE
            WHEN c.last_message_at IS NOT NULL
                 AND c.last_message_at > (NOW() - INTERVAL '24 hours')
            THEN TRUE
            ELSE FALSE
        END AS is_inside_24hr,
        c.is_sos,
        COUNT(*) OVER() AS total_count
    FROM wa_conversations c
    WHERE c.wa_account_id = p_account_id
      AND c.status = 'active'
      -- Exclude priority conversations (SOS / needs_human) — they go in their own section
      AND c.is_sos IS NOT TRUE
      AND c.needs_human IS NOT TRUE
      -- Search filter
      AND (
          p_search IS NULL
          OR p_search = ''
          OR c.customer_name ILIKE '%' || p_search || '%'
          OR c.customer_phone ILIKE '%' || p_search || '%'
      )
      -- Chat filter
      AND (
          p_filter = 'all'
          OR (p_filter = 'unread' AND c.unread_count > 0)
          OR (p_filter = 'ai' AND c.is_bot_handling = TRUE AND c.bot_type = 'ai')
          OR (p_filter = 'bot' AND c.is_bot_handling = TRUE AND c.bot_type = 'auto_reply')
          OR (p_filter = 'human' AND c.is_bot_handling = FALSE)
      )
    ORDER BY c.last_message_at DESC NULLS LAST
    LIMIT p_limit
    OFFSET p_offset;
END;
$$;



--
-- Name: get_wa_priority_conversations(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_wa_priority_conversations(p_account_id uuid) RETURNS TABLE(id uuid, customer_phone character varying, customer_name text, last_message_at timestamp with time zone, last_message_preview text, unread_count integer, is_bot_handling boolean, bot_type character varying, handled_by character varying, needs_human boolean, status character varying, is_inside_24hr boolean, is_sos boolean, total_count bigint)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.id,
        c.customer_phone,
        c.customer_name,
        c.last_message_at,
        c.last_message_preview,
        c.unread_count,
        c.is_bot_handling,
        c.bot_type,
        c.handled_by,
        c.needs_human,
        c.status,
        CASE
            WHEN c.last_message_at IS NOT NULL
                 AND c.last_message_at > (NOW() - INTERVAL '24 hours')
            THEN TRUE
            ELSE FALSE
        END AS is_inside_24hr,
        c.is_sos,
        COUNT(*) OVER() AS total_count
    FROM wa_conversations c
    WHERE c.wa_account_id = p_account_id
      AND c.status = 'active'
      AND (c.is_sos = TRUE OR c.needs_human = TRUE)
    ORDER BY
        CASE WHEN c.is_sos = TRUE THEN 0 ELSE 1 END ASC,
        c.last_message_at DESC NULLS LAST;
END;
$$;



--
-- Name: handle_document_deactivation(); Type: FUNCTION; Schema: public; Owner: supabase_admin
