SELECT pg_catalog.set_config('search_path', '', false);

Type: SCHEMA;

Schema: -;

Type: COMMENT;

Schema: -;

Type: TYPE;

Schema: public;

Type: TYPE;

Schema: public;

Type: TYPE;

Schema: public;

Type: TYPE;

Schema: public;

Type: TYPE;

Schema: public;

Type: TYPE;

Schema: public;

Type: TYPE;

Schema: public;

Type: TYPE;

Schema: public;

Type: TYPE;

Schema: public;

Type: TYPE;

Schema: public;

Type: TYPE;

Schema: public;

Type: TYPE;

Schema: public;

Type: TYPE;

Schema: public;

Type: TYPE;

Schema: public;

Type: TYPE;

Schema: public;

Type: TYPE;

Schema: public;

Type: TYPE;

Schema: public;

Type: TYPE;

Schema: public;

Type: TYPE;

Schema: public;

Type: TYPE;

Schema: public;

Type: TYPE;

Schema: public;

Type: TYPE;

Schema: public;

Type: TYPE;

Schema: public;

Type: FUNCTION;

Schema: public;

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

RETURN QUERY SELECT TRUE, 'Order accepted successfully';

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

RETURN FOUND;

END;

$$;

Type: FUNCTION;

Schema: public;

BEGIN
    -- Validate that product_id exists
    IF NEW.product_id IS NULL THEN
        RAISE EXCEPTION 'product_id is required';

END IF;

END IF;

RAISE NOTICE 'Product % stock decreased by %. New stock: %', 
        NEW.product_id, NEW.quantity, (current_quantity - NEW.quantity);

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

v_approved_by UUID;

v_is_admin BOOLEAN;

v_is_master_admin BOOLEAN;

BEGIN
    -- p_approved_by is required since we use custom auth (not Supabase Auth)
    IF p_approved_by IS NULL THEN
        RAISE EXCEPTION 'User ID (p_approved_by) is required.';

END IF;

END IF;

IF NOT (v_is_admin = true OR v_is_master_admin = true) THEN
        RAISE EXCEPTION 'Access denied. Admin privileges required.';

END IF;

RETURN;

END IF;

RETURN;

END IF;

RETURN;

END IF;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

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

RETURN result;

EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'success', false,
            'error', SQLERRM
        );

END;

$$;

Type: FUNCTION;

Schema: public;

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

RETURN QUERY SELECT TRUE, 'Delivery person assigned successfully';

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

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

RETURN QUERY SELECT TRUE, 'Picker assigned successfully';

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

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

ELSIF NEW.credit_period IS NOT NULL THEN
                schedule_date := (NEW.created_at + (NEW.credit_period || ' days')::INTERVAL);

ELSE
                schedule_date := (NEW.created_at + INTERVAL '30 days');

RAISE NOTICE 'Auto-created payment schedule for receiving record: % (certificate: %)', NEW.id, NEW.certificate_url;

ELSE
            RAISE NOTICE 'Payment schedule already exists for receiving record: %', NEW.id;

END IF;

END IF;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

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

CONTINUE;

END IF;

ELSIF length(v_formatted) = 10 AND v_formatted LIKE '0%' THEN
            v_formatted := '966' || substring(v_formatted from 2);

END IF;

IF v_exists THEN
            v_skipped := v_skipped + 1;

CONTINUE;

END IF;

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

Type: FUNCTION;

Schema: public;

GET DIAGNOSTICS v_count = ROW_COUNT;

RETURN json_build_object(
        'success', true,
        'updated_count', v_count
    );

END;

$$;

Type: FUNCTION;

Schema: public;

END IF;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

ELSE
    NEW.profit_percentage := 0;

END IF;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

ELSE
        NEW.profit_percentage = 0;

END IF;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

END IF;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

END IF;

END IF;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

end_minutes INTEGER;

hours_diff NUMERIC;

BEGIN
  -- Convert times to minutes since midnight
  start_minutes := EXTRACT(HOUR FROM NEW.shift_start_time)::INTEGER * 60 + 
                   EXTRACT(MINUTE FROM NEW.shift_start_time)::INTEGER;

end_minutes := EXTRACT(HOUR FROM NEW.shift_end_time)::INTEGER * 60 + 
                 EXTRACT(MINUTE FROM NEW.shift_end_time)::INTEGER;

ELSE
    -- If shift doesn't overlap: (end_minutes - start_minutes) / 60
    hours_diff := (end_minutes - start_minutes)::NUMERIC / 60;

END IF;

NEW.working_hours := ROUND(hours_diff, 2);

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

ELSE
        -- For regular shifts: end_time - start_time
        RETURN ROUND(
            EXTRACT(EPOCH FROM (end_time - start_time)) / 3600.0, 2
        );

END IF;

END;

$$;

Type: FUNCTION;

Schema: public;

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

RETURN QUERY SELECT TRUE, 'Order cancelled successfully';

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

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

END IF;

END IF;

END IF;

EXCEPTION WHEN OTHERS THEN
  RETURN jsonb_build_object(
    'can_complete', false,
    'error', SQLERRM,
    'error_code', 'INTERNAL_ERROR',
    'message', 'Error checking accountant dependencies: ' || SQLERRM
  );

END;

$$;

Type: FUNCTION;

Schema: public;

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

schedule_id := rec.id;

notification_sent := TRUE;

message := FORMAT('Sent reminder notification for schedule ID %s (due date: %s)', rec.id, rec.due_date);

RETURN NEXT;

END IF;

END LOOP;

RETURN;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

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

notifications_sent := notified_count;

execution_date := CURRENT_DATE;

message := FORMAT('Checked %s schedules, sent %s notifications', checked_count, notified_count);

RETURN NEXT;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

result_json JSONB;

has_tasks BOOLEAN := false;

BEGIN
    RAISE NOTICE 'Checking sync status for receiving_record_id: %', receiving_record_id_param;

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

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

v_customer_usage_count INTEGER;

BEGIN
    -- Get offer details
    SELECT * INTO v_offer FROM offers WHERE id = p_offer_id;

IF NOT FOUND THEN
        RETURN false;

END IF;

END IF;

END IF;

END IF;

END IF;

IF v_customer_usage_count >= v_offer.max_uses_per_customer THEN
            RETURN false;

END IF;

END IF;

END IF;

END IF;

END IF;

RETURN true;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

notification_id UUID;

reminder_count INTEGER := 0;

BEGIN
  RAISE NOTICE 'Starting overdue task reminder check at %', NOW();

reminder_count := reminder_count + 1;

RAISE NOTICE 'Sent reminder for task "%" to user "%"', task_record.task_title, task_record.user_name;

EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'Failed to send reminder for task %: %', task_record.assignment_id, SQLERRM;

CONTINUE;

END;

END LOOP;

reminder_count := reminder_count + 1;

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

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

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

END IF;

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

Type: FUNCTION;

Schema: public;

BEGIN
    SELECT require_task_finished, require_photo_upload, require_erp_reference
    INTO task_record
    FROM tasks 
    WHERE id = task_uuid;

ELSE
        RETURN false;

END IF;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

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

END IF;

IF v_stock_remaining IS NULL OR v_stock_remaining <= 0 THEN
    RETURN jsonb_build_object(
      'success', false,
      'error_message', 'Product is out of stock'
    );

END IF;

END;

$$;

Type: FUNCTION;

Schema: public;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

cnt int := 0;

total_freed bigint := 0;

tbl_size bigint;

db_size_before bigint;

db_size_after bigint;

BEGIN
  -- Get _supabase database size before
  SELECT pg_database_size('_supabase') INTO db_size_before;

FOR tbl IN
    SELECT t.tablename FROM dblink('analytics_conn',
      'SELECT tablename::text FROM pg_tables WHERE schemaname = ''_analytics'' AND tablename LIKE ''log_events_%'''
    ) AS t(tablename text)
  LOOP
    PERFORM dblink_exec('analytics_conn', format('TRUNCATE TABLE _analytics.%I', tbl.tablename));

cnt := cnt + 1;

END LOOP;

END IF;

PERFORM dblink_disconnect('analytics_conn');

RETURN format('Cleared %s log tables, freed ~%s', cnt, pg_size_pretty(GREATEST(db_size_before - db_size_after, 0)));

END;

$$;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

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

EXCEPTION WHEN OTHERS THEN
    PERFORM set_config('session_replication_role', 'origin', true);

RAISE;

END;

$$;

Type: FUNCTION;

Schema: public;

v_receiving_record_id UUID;

v_template RECORD;

dependency_check_result JSONB;

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

IF NOT (accountant_dependency_result->>'can_complete')::BOOLEAN THEN
      RETURN jsonb_build_object(  -- Changed from json_build_object
        'success', false,
        'error', accountant_dependency_result->>'error',
        'error_code', accountant_dependency_result->>'error_code',
        'message', accountant_dependency_result->>'message'
      );

END IF;

END IF;

END IF;

END IF;

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

v_payment_schedule RECORD;

BEGIN
      -- Get receiving record details
      SELECT * INTO v_receiving_record
      FROM receiving_records
      WHERE id = v_task.receiving_record_id;

END IF;

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

Type: FUNCTION;

Schema: public;

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

END IF;

IF NOT FOUND THEN
    RETURN json_build_object(
      'success', false,
      'error', 'Receiving record not found',
      'error_code', 'RECEIVING_RECORD_NOT_FOUND'
    );

END IF;

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

RETURN v_result;

EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object(
    'success', false,
    'error', SQLERRM,
    'error_code', 'INTERNAL_ERROR'
  );

END;

$$;

Type: FUNCTION;

Schema: public;

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

END IF;

IF NOT FOUND THEN
    RETURN json_build_object(
      'success', false,
      'error', 'Receiving record not found',
      'error_code', 'RECEIVING_RECORD_NOT_FOUND'
    );

END IF;

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

RETURN v_result;

EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object(
    'success', false,
    'error', SQLERRM,
    'error_code', 'INTERNAL_ERROR'
  );

END;

$$;

Type: FUNCTION;

Schema: public;

new_next_date DATE;

BEGIN
    -- Get the visit record
    SELECT * INTO visit_record FROM vendor_visits WHERE id = visit_id;

IF NOT FOUND THEN
        RAISE EXCEPTION 'Visit schedule not found with id: %', visit_id;

END IF;

RETURN new_next_date;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

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

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

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

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

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

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

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

RETURN QUERY SELECT v_order_id, v_order_number, TRUE, 'Order created successfully';

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

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

END LOOP;

END IF;

END LOOP;

END IF;

END LOOP;

END IF;

RAISE NOTICE 'Created recipients for notification %', NEW.id;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

assigned_to_name TEXT;

BEGIN
    -- Get the name of who assigned the task (from hr_employees if available, otherwise username)
    SELECT COALESCE(he.name, u.username, 'Admin') INTO assigned_by_name
    FROM users u
    LEFT JOIN hr_employees he ON u.employee_id = he.id
    WHERE u.id = (SELECT assigned_by FROM quick_tasks WHERE id = NEW.quick_task_id);

RETURN NEW;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

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

END LOOP;

END IF;

RETURN task_id;

END;

$$;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

next_exec_time TIMESTAMP WITH TIME ZONE;

BEGIN
    -- Calculate first execution time
    next_exec_time := (p_start_date::text || ' ' || p_execute_time::text)::timestamp with time zone;

RETURN assignment_id;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

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

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

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

qr_salt := generate_salt();

END IF;

final_quick_code := p_quick_access_code;

ELSE
        final_quick_code := generate_unique_quick_access_code();

END IF;

RAISE NOTICE 'System admin user created with ID: %', admin_user_id;

RAISE NOTICE 'Username: %, Is Master Admin: %, Quick Access: %', p_username, p_is_master_admin, final_quick_code;

RETURN admin_user_id;

END;

$$;

Type: FUNCTION;

Schema: public;

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

qr_salt := generate_salt();

END IF;

final_quick_code := p_quick_access_code;

ELSE
        final_quick_code := generate_unique_quick_access_code();

END IF;

RAISE NOTICE 'System admin user created with ID: %', admin_user_id;

RAISE NOTICE 'Username: %, Role: %, Quick Access: %', p_username, p_role_type, final_quick_code;

RETURN admin_user_id;

END;

$$;

Type: FUNCTION;

Schema: public;

calculated_due_datetime TIMESTAMPTZ;

BEGIN
    -- Calculate due_datetime if due_date is provided
    IF due_date_param IS NOT NULL THEN
        calculated_due_datetime := due_date_param + COALESCE(due_time_param, '23:59:59'::TIME);

END IF;

RETURN task_id;

END;

$$;

Type: FUNCTION;

Schema: public;

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

END LOOP;

ELSE
    v_quick_access_code := p_quick_access_code;

END IF;

END IF;

IF EXISTS (SELECT 1 FROM users WHERE username = p_username) THEN
    RETURN json_build_object(
      'success', false,
      'message', 'Username already exists'
    );

END IF;

v_password_hash := extensions.crypt(p_password, v_salt);

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

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

v_barcode TEXT;

v_order INTEGER := 1;

BEGIN
  -- Validate parent product exists
  IF NOT EXISTS (SELECT 1 FROM products WHERE barcode = p_parent_barcode) THEN
    RETURN QUERY SELECT false, 'Parent product barcode does not exist', 0;

RETURN;

END IF;

END IF;

v_affected_count := v_affected_count + 1;

v_order := v_order + 1;

v_affected_count := v_affected_count + 1;

END LOOP;

END IF;

RETURN QUERY SELECT true, 'Variation group created successfully', v_affected_count;

END;

$$;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

EXCEPTION
  WHEN OTHERS THEN
    RETURN false;

END;

$$;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

role_type TEXT;

task_record RECORD;

found_count INTEGER := 0;

BEGIN
  RAISE NOTICE 'Debug: Starting function with receiving_record_id = %, roles = %', receiving_record_id_param, dependency_role_types;

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

EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'Debug: Error occurred - %', SQLERRM;

RETURN '{}'::JSON;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

IF NOT FOUND THEN
        RAISE EXCEPTION 'Insufficient stock for voucher value %', voucher_value;

END IF;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN FOUND;

END;

$$;

Type: FUNCTION;

Schema: public;

$$;

Type: FUNCTION;

Schema: public;

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

RETURN json_build_object(
        'success', true,
        'message', 'Account deleted successfully'
    );

END;

$$;

Type: FUNCTION;

Schema: public;

BEGIN
    -- Collect quick_task IDs linked to this incident
    SELECT ARRAY(SELECT id FROM quick_tasks WHERE incident_id = p_incident_id)
    INTO v_task_ids;

DELETE FROM quick_task_comments    WHERE quick_task_id = ANY(v_task_ids);

DELETE FROM quick_task_completions WHERE quick_task_id = ANY(v_task_ids);

DELETE FROM quick_task_files       WHERE quick_task_id = ANY(v_task_ids);

END IF;

END;

$$;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

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

RETURN new_template_id;

END;

$$;

Type: FUNCTION;

Schema: public;

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

RETURN jsonb_build_object('success', true, 'break_id', v_break.id, 'duration_seconds', v_duration);

END;

$$;

Type: FUNCTION;

Schema: public;

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

IF v_break_id IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'No open break found');

END IF;

RETURN jsonb_build_object('success', true, 'break_id', v_break_id, 'duration_seconds', v_duration);

END;

$$;

Type: FUNCTION;

Schema: public;

END IF;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

v_triggers text := '';

v_types text := '';

v_policies text := '';

v_grants text := '';

v_tables text := '';

v_indexes text := '';

v_sequences text := '';

v_columns text := '';

r record;

',
            r.seq_name, r.seq_type, r.seqincrement, r.seqmin, r.seqmax, r.seqstart, r.seqcache,
            CASE WHEN r.seqcycle THEN ' CYCLE' ELSE '' END
        ) || E'\n';

',
            r.seq_name
        ) || E'\n';

END LOOP;

',
                r.proname, r.identity_args
            ) || E'\n';

ELSE
            v_functions := v_functions || format(
                'DROP FUNCTION IF EXISTS public.%I(%s) CASCADE;

',
                r.proname, r.identity_args
            ) || E'\n';

END IF;

v_functions := v_functions || r.funcdef || ';

' || E'\n\n';

',
            r.proname
        ) || E'\n';

END LOOP;

EXCEPTION WHEN duplicate_object THEN NULL;

END $typchk$'
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
            v_types := v_types || r.typedef || ';

' || E'\n';

END IF;

END LOOP;

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
                IF v_cols != '' THEN v_cols := v_cols || ',' || E'\n';

END IF;

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

END LOOP;

v_tables := v_tables || v_cols || v_constraints || E'\n);

\n';

' || E'\n';

END IF;

' || E'\n\n';

END IF;

v_columns := v_columns || 'ALTER TABLE public.' || quote_ident(r.table_name) || ' ADD COLUMN IF NOT EXISTS ' || quote_ident(col.attname) || ' ' || col.col_type;

IF col.default_val IS NOT NULL THEN
                    v_columns := v_columns || ' DEFAULT ' || col.default_val;

END IF;

v_columns := v_columns || ';

' || E'\n';

END LOOP;

' || E'\n';

END LOOP;

END;

END LOOP;

',
            r.trigger_name, r.table_name
        ) || E'\n';

v_triggers := v_triggers || r.triggerdef || ';

' || E'\n\n';

END LOOP;

',
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

v_policies := v_policies || ';

' || E'\n\n';

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

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

next_num INTEGER;

BEGIN
    -- Always generate branch_id if not provided or empty
    IF NEW.branch_id IS NULL OR NEW.branch_id = '' THEN
        -- Determine prefix based on branch type
        prefix := CASE 
            WHEN NEW.branch_type = 'head_branch' THEN 'HB'
            ELSE 'BR'
        END;

END IF;

RETURN NEW;

END;

$_$;

Type: FUNCTION;

Schema: public;

code_exists BOOLEAN;

BEGIN
  LOOP
    -- Generate 8 character alphanumeric code
    new_code := upper(substring(md5(random()::text || clock_timestamp()::text) from 1 for 8));

EXIT WHEN NOT code_exists;

END LOOP;

RETURN new_code;

END;

$$;

Type: FUNCTION;

Schema: public;

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

IF NOT FOUND THEN
        RAISE EXCEPTION 'Receiving record not found: %', receiving_record_id_param;

END IF;

task_description := format('Vendor: %s, Bill #: %s, Bill Amount: %s, Bill Date: %s, Received by: %s',
        COALESCE(vendor_record.vendor_name, 'Unknown Vendor'),
        COALESCE(receiving_record.bill_number, 'N/A'),
        COALESCE(receiving_record.bill_amount::TEXT, 'N/A'),
        receiving_record.bill_date::TEXT,
        COALESCE(created_by_name, 'Unknown User')
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

Type: FUNCTION;

Schema: public;

new_id VARCHAR(15);

BEGIN
  -- Extract the numeric part from the last ID and increment it
  SELECT COALESCE(MAX(CAST(SUBSTRING(id, 4) AS INTEGER)), 0) + 1
  INTO max_id
  FROM hr_insurance_companies
  WHERE id LIKE 'INC%';

NEW.id := new_id;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

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

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

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

otherwise use creator
    IF rec.co_user_id IS NOT NULL THEN
        co_user_id_value := rec.co_user_id;

co_user_name_value := rec.co_user_name;

ELSE
        -- Use creator's ID and username from public.users table
        co_user_id_value := rec.created_by;

SELECT username INTO co_user_name_value
        FROM public.users
        WHERE id = rec.created_by;

END IF;

END IF;

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

ELSIF p_source_table = 'non_approved_payment_scheduler' THEN
        DELETE FROM non_approved_payment_scheduler WHERE id = p_parent_id;

END IF;

occurrence_count := occurrences_created;

message := FORMAT('Successfully created %s occurrences for recurring schedule ID %s (parent deleted)', occurrences_created, p_parent_id);

RETURN NEXT;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

END IF;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

$$;

Type: FUNCTION;

Schema: public;

v_limit integer;

v_limit := CASE WHEN (p_search_barcode IS NOT NULL OR p_search_name IS NOT NULL) THEN NULL ELSE p_page_size END;

END;

$$;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

$$;

Type: FUNCTION;

Schema: public;

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

v_can_approve_leave_requests := COALESCE((v_permissions->>'can_approve_leave_requests')::BOOLEAN, FALSE);

v_can_approve_purchase_vouchers := COALESCE((v_permissions->>'can_approve_purchase_vouchers')::BOOLEAN, FALSE);

v_vendor_payment_amount_limit := COALESCE((v_permissions->>'vendor_payment_amount_limit')::NUMERIC, 0);

END IF;

ELSE
    v_vendor_payments := '[]'::JSONB;

END IF;

ELSE
    v_purchase_vouchers := '[]'::JSONB;

END IF;

END IF;

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

RETURN v_result;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

v_epoch bigint;

v_code text;

v_ttl integer;

BEGIN
    SELECT seed INTO v_seed FROM break_security_seed WHERE id = 1;

IF v_seed IS NULL THEN
        RETURN jsonb_build_object('error', 'No security seed configured');

END IF;

RETURN jsonb_build_object(
        'code', v_code,
        'ttl', v_ttl,
        'epoch', v_epoch
    );

END;

$$;

Type: FUNCTION;

Schema: public;

v_date_to DATE;

v_result JSONB;

BEGIN
    -- Default to last 7 days if not specified
    v_date_to := COALESCE(p_date_to, (NOW() AT TIME ZONE 'Asia/Riyadh')::DATE);

v_date_from := COALESCE(p_date_from, v_date_to - INTERVAL '6 days');

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

Type: FUNCTION;

Schema: public;

$$;

Type: FUNCTION;

Schema: public;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

$$;

Type: FUNCTION;

Schema: public;

v_products JSONB;

v_max_claims INTEGER;

BEGIN
  -- Get campaign max claims
  SELECT COALESCE(max_claims_per_customer, 1)
  INTO v_max_claims
  FROM coupon_campaigns
  WHERE id = p_campaign_id;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

$$;

Type: FUNCTION;

Schema: public;

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

RETURN jsonb_build_object(
    'boxes', v_boxes,
    'total_count', v_total_count
  );

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

$_$;

Type: FUNCTION;

Schema: public;

EXCEPTION
  WHEN OTHERS THEN
    RETURN NULL;

END;

$$;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

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

RETURN result;

END;

$$;

Type: FUNCTION;

Schema: public;

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

ELSIF rec.provolatile = 's' THEN
      ddl := ddl || 'STABLE' || E'\n';

END IF;

IF rec.proisstrict THEN
      ddl := ddl || 'STRICT' || E'\n';

END IF;

IF rec.secdef THEN
      ddl := ddl || 'SECURITY DEFINER' || E'\n';

END IF;

ddl := ddl || 'AS $func$' || E'\n' || rec.fsrc || E'\n' || '$func$;

';

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

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

BEGIN
    -- Find the appropriate tier for the given order amount
    SELECT delivery_fee INTO calculated_fee
    FROM public.delivery_fee_tiers
    WHERE is_active = true
      AND min_order_amount <= order_amount
      AND (max_order_amount IS NULL OR max_order_amount >= order_amount)
    ORDER BY min_order_amount DESC
    LIMIT 1;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

BEGIN
    -- Require a branch id;

without it, no fee can be determined
    IF p_branch_id IS NULL THEN
        RETURN 0;

END IF;

RETURN COALESCE(v_fee, 0);

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

if branch_id is NULL, return empty set
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

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

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

END IF;

END LOOP;

EXCEPTION WHEN OTHERS THEN
  -- Return empty object on error
  RETURN '{}'::JSON;

END;

$$;

Type: FUNCTION;

Schema: public;

$$;

Type: FUNCTION;

Schema: public;

$$;

Type: FUNCTION;

Schema: public;

BEGIN
    SELECT basic_hours INTO emp_basic_hours
    FROM employee_basic_hours 
    WHERE employee_id = p_employee_id;

END;

$$;

Type: FUNCTION;

Schema: public;

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

RETURN COALESCE(basic_hours, 8.0);

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN v_result;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

v_count INTEGER := 0;

BEGIN
  -- Get employee's current branch
  SELECT current_branch_id INTO v_branch_id
  FROM hr_employee_master
  WHERE id = p_employee_id;

IF v_branch_id IS NULL THEN
    RETURN jsonb_build_object('count', 0);

END IF;

RETURN jsonb_build_object('count', v_count);

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

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

END IF;

END IF;

v_yesterday := ((NOW() AT TIME ZONE 'Asia/Riyadh')::DATE - INTERVAL '1 day')::DATE::TEXT;

v_today_weekday := EXTRACT(DOW FROM (NOW() AT TIME ZONE 'Asia/Riyadh')::DATE)::INTEGER;

v_yesterday_weekday := EXTRACT(DOW FROM ((NOW() AT TIME ZONE 'Asia/Riyadh')::DATE - INTERVAL '1 day'))::INTEGER;

SELECT COALESCE(
        (SELECT to_jsonb(a.*) FROM hr_analysed_attendance_data a
         WHERE a.employee_id = v_employee_id AND a.shift_date = v_yesterday::DATE
         LIMIT 1),
        'null'::JSONB
    ) INTO v_attendance_yesterday;

ELSE
        v_punches := '[]'::JSONB;

END IF;

SELECT COUNT(*) INTO v_box_completed
    FROM box_operations
    WHERE user_id = p_user_id AND status = 'completed';

SELECT COUNT(*) INTO v_box_in_use
    FROM box_operations
    WHERE user_id = p_user_id AND status = 'in_use';

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

EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object('success', false, 'error', SQLERRM);

END;

$$;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

BEGIN
    -- Get current delivery fee
    current_fee := public.get_delivery_fee_for_amount(current_amount);

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

BEGIN
    -- Require branch id
    IF p_branch_id IS NULL THEN
        RETURN;

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

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

next_serial TEXT;

BEGIN
    -- Get the highest serial number
    SELECT COALESCE(
        MAX(CAST(SUBSTRING(product_serial FROM 3) AS INTEGER)),
        0
    ) + 1 INTO next_number
    FROM products
    WHERE product_serial ~ '^UR[0-9]+$';

RETURN next_serial;

END;

$_$;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

$$;

Type: FUNCTION;

Schema: public;

BEGIN
    -- Try to get existing function
    SELECT id INTO function_id 
    FROM app_functions 
    WHERE function_code = p_function_code;

END IF;

RETURN function_id;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

$$;

Type: FUNCTION;

Schema: public;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

v_with_images int;

v_without_images int;

v_units jsonb;

v_categories jsonb;

BEGIN
  -- Get total products count
  SELECT count(*) INTO v_total_products FROM products;

RETURN jsonb_build_object(
    'total_products', v_total_products,
    'products_with_images', v_with_images,
    'products_without_images', v_without_images,
    'units', v_units,
    'categories', v_categories
  );

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN result;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

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

RETURN result;

END;

$$;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

$$;

Type: FUNCTION;

Schema: public;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

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

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

v_team_tasks json;

v_is_branch_manager boolean := false;

v_employee_names json;

v_cutoff timestamp;

BEGIN
  -- Calculate cutoff for completed tasks
  v_cutoff := NOW() - (p_completed_days || ' days')::interval;

END IF;

IF v_team_tasks IS NULL THEN
      v_team_tasks := '[]'::json;

END IF;

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

Type: FUNCTION;

Schema: public;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

$$;

Type: FUNCTION;

Schema: public;

$$;

Type: FUNCTION;

Schema: public;

$$;

Type: FUNCTION;

Schema: public;

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

END LOOP;

ddl := ddl || E'\n);

';

' AS idxdef
      FROM pg_index i
      JOIN pg_class ic ON ic.oid = i.indexrelid
      WHERE i.indrelid = tbl_oid
        AND NOT i.indisprimary
        AND NOT i.indisunique
      ORDER BY ic.relname
    LOOP
      ddl := ddl || E'\n' || idx.idxdef;

END LOOP;

' AS idxdef
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

' AS trgdef
      FROM pg_trigger t2
      WHERE t2.tgrelid = tbl_oid
        AND NOT t2.tgisinternal
      ORDER BY t2.tgname
    LOOP
      ddl := ddl || E'\n\n' || trg.trgdef;

END LOOP;

IF rls_enabled THEN
      ddl := ddl || E'\n\n' || 'ALTER TABLE public.' || quote_ident(rec.tname) || ' ENABLE ROW LEVEL SECURITY;

';

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

ddl := ddl || ';

';

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

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

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

END IF;

RETURN result;

EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'success', false,
            'error', SQLERRM
        );

END;

$$;

Type: FUNCTION;

Schema: public;

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

RETURN v_result;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

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

RETURN result;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

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

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

$$;

Type: FUNCTION;

Schema: public;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

NEW.health_card_expiry := NULL;

ELSIF NEW.document_type = 'resident_id' THEN
            NEW.resident_id_number := NULL;

NEW.resident_id_expiry := NULL;

ELSIF NEW.document_type = 'passport' THEN
            NEW.passport_number := NULL;

NEW.passport_expiry := NULL;

ELSIF NEW.document_type = 'driving_license' THEN
            NEW.driving_license_number := NULL;

NEW.driving_license_expiry := NULL;

ELSIF NEW.document_type = 'resume' THEN
            NEW.resume_uploaded := FALSE;

END IF;

END IF;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

v_order RECORD;

v_notification_id UUID;

v_admin_user RECORD;

v_notif_title TEXT;

v_notif_message TEXT;

v_finish_task_id UUID;

BEGIN
    -- Only proceed if status changed to 'completed'
    IF NEW.status <> 'completed' OR OLD.status = 'completed' THEN
        RETURN NEW;

END IF;

END IF;

IF v_order IS NULL THEN
        RETURN NEW;

END IF;

v_notif_message := 'Start picking completed. Please finish picking order #' || v_order.order_number || '|||تم بدء التحضير. يرجى إنهاء تحضير الطلب #' || v_order.order_number;

INSERT INTO notifications (
            title, message, type, created_by, created_by_name, created_by_role,
            priority, status, target_type, target_roles, sent_at
        ) VALUES (
            v_notif_title, v_notif_message, 'order_picking',
            NEW.assigned_to_user_id::text, 'System', 'System',
            'high', 'published', 'user_specific',
            NULL,
            NOW()
        ) RETURNING id INTO v_notification_id;

INSERT INTO notification_recipients (notification_id, user_id, role, is_read, delivery_status)
        VALUES (v_notification_id, NEW.assigned_to_user_id, 'User', FALSE, 'delivered');

IF v_order.fulfillment_method = 'pickup' THEN
            v_notif_message := 'Order #' || v_order.order_number || ' is ready for pickup. Customer: ' || v_order.customer_name || '|||الطلب #' || v_order.order_number || ' جاهز للاستلام. العميل: ' || v_order.customer_name;

ELSE
            v_notif_message := 'Order #' || v_order.order_number || ' is ready. Please assign a delivery person. Customer: ' || v_order.customer_name || '|||الطلب #' || v_order.order_number || ' جاهز. يرجى تعيين مندوب توصيل. العميل: ' || v_order.customer_name;

END IF;

INSERT INTO notifications (
            title, message, type, created_by, created_by_name, created_by_role,
            priority, status, target_type, target_roles, sent_at
        ) VALUES (
            v_notif_title, v_notif_message, 'order_ready',
            NEW.assigned_to_user_id::text, 'System', 'System',
            'high', 'published', 'role_based',
            to_jsonb(ARRAY['Admin', 'Master Admin']),
            NOW()
        ) RETURNING id INTO v_notification_id;

END LOOP;

v_notif_message := 'Order #' || v_order.order_number || ' has been delivered to ' || v_order.customer_name || '|||تم توصيل الطلب #' || v_order.order_number || ' إلى ' || v_order.customer_name;

INSERT INTO notifications (
            title, message, type, created_by, created_by_name, created_by_role,
            priority, status, target_type, target_roles, sent_at
        ) VALUES (
            v_notif_title, v_notif_message, 'order_delivered',
            NEW.assigned_to_user_id::text, 'System', 'System',
            'medium', 'published', 'role_based',
            to_jsonb(ARRAY['Admin', 'Master Admin']),
            NOW()
        ) RETURNING id INTO v_notification_id;

FOR v_admin_user IN
            SELECT id,
                   CASE WHEN is_master_admin THEN 'Master Admin'
                        WHEN is_admin THEN 'Admin'
                        ELSE 'User' END as role_type
            FROM users
            WHERE status = 'active' AND (is_admin = true OR is_master_admin = true)
        LOOP
            INSERT INTO notification_recipients (notification_id, user_id, role, is_read, delivery_status)
            VALUES (v_notification_id, v_admin_user.id, v_admin_user.role_type, FALSE, 'delivered');

END LOOP;

END IF;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

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
    IF NOT (p_table_name = ANY(v_allowed_tables)) THEN
        RAISE EXCEPTION 'Table % is not allowed for sync import', p_table_name;

END IF;

IF p_data IS NULL OR jsonb_array_length(p_data) = 0 THEN 
        RETURN 0;

END IF;

GET DIAGNOSTICS v_count = ROW_COUNT;

RETURN v_count;

EXCEPTION WHEN OTHERS THEN
    PERFORM set_config('session_replication_role', 'origin', true);

RAISE;

END;

$_$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

SELECT facebook_clicks INTO v_count FROM social_links WHERE branch_id = _branch_id;

SELECT whatsapp_clicks INTO v_count FROM social_links WHERE branch_id = _branch_id;

SELECT instagram_clicks INTO v_count FROM social_links WHERE branch_id = _branch_id;

SELECT tiktok_clicks INTO v_count FROM social_links WHERE branch_id = _branch_id;

SELECT snapchat_clicks INTO v_count FROM social_links WHERE branch_id = _branch_id;

SELECT website_clicks INTO v_count FROM social_links WHERE branch_id = _branch_id;

SELECT location_link_clicks INTO v_count FROM social_links WHERE branch_id = _branch_id;

END IF;

RETURN json_build_object('branch_id', _branch_id, 'platform', _platform, 'click_count', v_count);

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

v_error_msg text;

BEGIN
  -- Log input
  RAISE NOTICE 'insert_order_items called with % items', jsonb_array_length(p_order_items);

INSERT INTO order_items (
    order_id,
    product_id,
    product_name_ar,
    product_name_en,
    quantity,
    unit_price,
    original_price,
    discount_amount,
    final_price,
    line_total,
    has_offer,
    offer_id,
    item_type,
    is_bundle_item,
    is_bogo_free
  )
  SELECT
    (item->>'order_id')::uuid,
    item->>'product_id',
    item->>'product_name_ar',
    item->>'product_name_en',
    (item->>'quantity')::integer,
    (item->>'unit_price')::numeric,
    (item->>'original_price')::numeric,
    (item->>'discount_amount')::numeric,
    (item->>'final_price')::numeric,
    (item->>'line_total')::numeric,
    (item->>'has_offer')::boolean,
    CASE 
      WHEN item->>'offer_id' IS NULL OR item->>'offer_id' = 'null' THEN NULL::integer
      ELSE (item->>'offer_id')::integer
    END,
    item->>'item_type',
    (item->>'is_bundle_item')::boolean,
    (item->>'is_bogo_free')::boolean
  FROM jsonb_array_elements(p_order_items) AS item;

GET DIAGNOSTICS v_count = ROW_COUNT;

RAISE NOTICE 'Inserted % order items', v_count;

RETURN QUERY SELECT true, format('Order items inserted successfully (%s items)', v_count)::text;

EXCEPTION WHEN OTHERS THEN
  GET STACKED DIAGNOSTICS v_error_msg = MESSAGE_TEXT;

RAISE NOTICE 'Error in insert_order_items: %', v_error_msg;

RETURN QUERY SELECT false, v_error_msg::text;

END;

$$;

Type: FUNCTION;

Schema: public;

BEGIN
    INSERT INTO public.vendors (
        erp_vendor_code,
        name,
        vat_number,
        company,
        category,
        status
    ) VALUES (
        p_erp_vendor_code,
        p_vendor_name,
        p_vat_number,
        COALESCE(p_vendor_name, 'Unknown Company'),
        'General',
        'active'
    )
    ON CONFLICT (erp_vendor_code) 
    DO UPDATE SET
        name = EXCLUDED.name,
        vat_number = EXCLUDED.vat_number,
        company = EXCLUDED.company,
        updated_at = NOW()
    RETURNING id INTO vendor_id;

RETURN vendor_id;

END;

$$;

Type: FUNCTION;

Schema: public;

vendor_company CHARACTER VARYING(255);

BEGIN
    -- Use English name as company if provided, otherwise use the main vendor name
    vendor_company := COALESCE(p_vendor_name_english, p_vendor_name_arabic, 'Unknown Company');

RETURN vendor_id;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

BEGIN
    SELECT EXISTS(
        SELECT 1
        FROM offer_bundles ob
        INNER JOIN offers o ON ob.offer_id = o.id
        WHERE o.is_active = true
          AND o.end_date > NOW()
          AND (p_exclude_offer_id IS NULL OR o.id != p_exclude_offer_id)
          AND ob.required_products::jsonb @> jsonb_build_array(
              jsonb_build_object('product_id', p_product_id::text)
          )
    ) INTO v_found;

RETURN v_found;

END;

$$;

Type: FUNCTION;

Schema: public;

END IF;

END;

$_$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

user_is_admin BOOLEAN;

BEGIN
  SELECT is_master_admin, is_admin
  INTO user_is_master_admin, user_is_admin
  FROM users
  WHERE id = check_user_id;

RETURN COALESCE(user_is_master_admin, false) OR COALESCE(user_is_admin, false);

END;

$$;

Type: FUNCTION;

Schema: public;

BEGIN
  SELECT is_master_admin
  INTO user_is_master_admin
  FROM users
  WHERE id = check_user_id;

RETURN COALESCE(user_is_master_admin, false);

END;

$$;

Type: FUNCTION;

Schema: public;

BEGIN
    -- Find employee by employee_code and branch
    SELECT e.id INTO v_employee_id
    FROM public.employees e
    WHERE e.employee_id = p_employee_code
    AND e.branch_id = p_branch_id
    AND e.status = 'active';

RETURN v_employee_id;

END;

$$;

Type: FUNCTION;

Schema: public;

BEGIN
    -- Insert usage log
    INSERT INTO offer_usage_logs (
        offer_id, customer_id, order_id,
        discount_applied, original_amount, final_amount,
        cart_items
    ) VALUES (
        p_offer_id, p_customer_id, p_order_id,
        p_discount_applied, p_original_amount, p_final_amount,
        p_cart_items
    ) RETURNING id INTO v_log_id;

RETURN v_log_id;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN CASE 
        WHEN TG_OP = 'DELETE' THEN OLD
        ELSE NEW
    END;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN COALESCE(NEW, OLD);

END;

$$;

Type: FUNCTION;

Schema: public;

v_customer_id UUID;

v_title TEXT;

v_body TEXT;

v_url TEXT;

v_type TEXT;

v_service_role_key TEXT;

v_supabase_url TEXT;

v_request_id BIGINT;

BEGIN
    -- Only handle status_change actions
    IF NEW.action_type <> 'status_change' THEN
        RETURN NEW;

END IF;

IF v_order IS NULL OR v_order.customer_id IS NULL THEN
        RETURN NEW;

END IF;

v_customer_id := v_order.customer_id;

END IF;

v_body := 'تم قبول طلبك رقم #' || v_order.order_number || ' وجاري تجهيزه.' || chr(10) || 'Your order #' || v_order.order_number || ' has been accepted.';

v_type := 'order_accepted';

WHEN 'in_picking' THEN
            v_title := 'جاري تحضير طلبك 📦';

v_body := 'طلبك رقم #' || v_order.order_number || ' قيد التحضير الآن.' || chr(10) || 'Your order #' || v_order.order_number || ' is being prepared.';

v_type := 'order_picking';

WHEN 'ready' THEN
            IF v_order.fulfillment_method = 'pickup' THEN
                v_title := 'طلبك جاهز للاستلام 🎉';

v_body := 'طلبك رقم #' || v_order.order_number || ' جاهز! تعال واستلمه.' || chr(10) || 'Your order #' || v_order.order_number || ' is ready for pickup!';

ELSE
                v_title := 'طلبك جاهز 🎉';

v_body := 'طلبك رقم #' || v_order.order_number || ' جاهز وبانتظار التوصيل.' || chr(10) || 'Your order #' || v_order.order_number || ' is ready for delivery.';

END IF;

v_type := 'order_ready';

WHEN 'out_for_delivery' THEN
            v_title := 'طلبك في الطريق 🚗';

v_body := 'طلبك رقم #' || v_order.order_number || ' في طريقه إليك!' || chr(10) || 'Your order #' || v_order.order_number || ' is on its way!';

v_type := 'order_out_for_delivery';

WHEN 'delivered' THEN
            v_title := 'تم توصيل طلبك ✅';

v_body := 'تم توصيل طلبك رقم #' || v_order.order_number || ' بنجاح. بالعافية!' || chr(10) || 'Your order #' || v_order.order_number || ' has been delivered. Enjoy!';

v_type := 'order_delivered';

WHEN 'picked_up' THEN
            v_title := 'تم استلام طلبك ✅';

v_body := 'تم تأكيد استلام طلبك رقم #' || v_order.order_number || '. شكراً لك!' || chr(10) || 'Your order #' || v_order.order_number || ' pickup confirmed. Thank you!';

v_type := 'order_picked_up';

WHEN 'cancelled' THEN
            v_title := 'تم إلغاء طلبك ❌';

v_body := 'تم إلغاء طلبك رقم #' || v_order.order_number || '.' || chr(10) || 'Your order #' || v_order.order_number || ' has been cancelled.';

v_type := 'order_cancelled';

ELSE
            RETURN NEW;

END CASE;

v_url := '/customer-interface/track-order';

IF v_service_role_key IS NULL THEN
        BEGIN
            v_service_role_key := current_setting('supabase.service_role_key', true);

EXCEPTION WHEN OTHERS THEN
            v_service_role_key := NULL;

END;

END IF;

END IF;

RAISE LOG 'Customer push notification queued for customer % (order %), request_id: %', 
        v_customer_id, v_order.order_number, v_request_id;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN COALESCE(NEW, OLD);

END;

$$;

Type: FUNCTION;

Schema: public;

v_notifications_sent INT := 0;

v_receiving_record RECORD;

v_template RECORD;

v_task_id UUID;

v_title TEXT;

v_description TEXT;

v_due_date TIMESTAMP;

v_assigned_user_id UUID;

v_notification_id UUID;

v_user_idx INT;

v_array_len INT;

BEGIN

  -- =======================================================
  -- STEP 1: PREVENT DUPLICATE TASK CREATION
  -- =======================================================
  IF EXISTS (
    SELECT 1 FROM receiving_tasks
    WHERE receiving_record_id = receiving_record_id_param
  ) THEN
    RETURN json_build_object(
      'success', false,
      'error', 'Tasks already exist for this receiving record',
      'error_code', 'DUPLICATE_TASKS',
      'tasks_created', 0,
      'notifications_sent', 0
    );

END IF;

IF NOT FOUND THEN
    RETURN json_build_object(
      'success', false,
      'error', 'Receiving record not found',
      'error_code', 'RECORD_NOT_FOUND',
      'tasks_created', 0,
      'notifications_sent', 0
    );

END IF;

v_title := REPLACE(v_title, '{bill_number}', COALESCE(v_receiving_record.bill_number, 'N/A'));

v_title := REPLACE(v_title, '{vendor_name}', COALESCE(v_receiving_record.vendor_name, 'Unknown Vendor'));

v_title := REPLACE(v_title, '{branch_name}', COALESCE(v_receiving_record.branch_name, 'Unknown Branch'));

v_description := REPLACE(v_description, '{bill_number}', COALESCE(v_receiving_record.bill_number, 'N/A'));

v_description := REPLACE(v_description, '{vendor_name}', COALESCE(v_receiving_record.vendor_name, 'Unknown Vendor'));

v_description := REPLACE(v_description, '{branch_name}', COALESCE(v_receiving_record.branch_name, 'Unknown Branch'));

v_description := REPLACE(v_description, '{vendor_id}', COALESCE(v_receiving_record.vendor_id::TEXT, 'N/A'));

v_description := REPLACE(v_description, '{bill_amount}', COALESCE(v_receiving_record.bill_amount::TEXT, 'N/A'));

v_description := REPLACE(v_description, '{bill_date}', COALESCE(TO_CHAR(v_receiving_record.bill_date, 'YYYY-MM-DD'), 'N/A'));

v_description := REPLACE(v_description, '{received_by}', COALESCE(v_receiving_record.received_by_name, 'Unknown'));

v_description := REPLACE(v_description, '{certificate_url}', COALESCE(clearance_certificate_url_param, 'Not Available'));

BEGIN
        CASE v_template.role_type
          WHEN 'night_supervisor' THEN
            v_user_ids := v_receiving_record.night_supervisor_user_ids;

WHEN 'warehouse_handler' THEN
            v_user_ids := v_receiving_record.warehouse_handler_user_ids;

WHEN 'shelf_stocker' THEN
            v_user_ids := v_receiving_record.shelf_stocker_user_ids;

END CASE;

IF v_user_ids IS NOT NULL AND array_length(v_user_ids, 1) > 0 THEN
          FOR v_user_idx IN 1..array_length(v_user_ids, 1) LOOP
            v_assigned_user_id := v_user_ids[v_user_idx];

v_task_id := gen_random_uuid();

INSERT INTO receiving_tasks (
              id, receiving_record_id, template_id, role_type, assigned_user_id,
              title, description, priority, due_date, task_status, task_completed,
              clearance_certificate_url, created_at, updated_at
            ) VALUES (
              v_task_id, receiving_record_id_param, v_template.id, v_template.role_type,
              v_assigned_user_id, v_title, v_description, v_template.priority,
              v_due_date, 'pending', false, clearance_certificate_url_param,
              CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
            );

v_tasks_created := v_tasks_created + 1;

INSERT INTO notifications (
                id, title, message, type, priority, created_by, created_by_name,
                target_users, target_type, status, created_at, sent_at, metadata
              ) VALUES (
                v_notification_id,
                'New Receiving Task Assigned',
                E'\u26A0\uFE0F New Task Assigned: A new task has been assigned to you: ' || v_title ||
                ' Branch: ' || COALESCE(v_receiving_record.branch_name, 'Unknown') ||
                ' Vendor: ' || COALESCE(v_receiving_record.vendor_name, 'Unknown') ||
                ' (ID: ' || COALESCE(v_receiving_record.vendor_id::TEXT, 'N/A') || ')' ||
                ' Bill Amount: ' || COALESCE(v_receiving_record.bill_amount::TEXT, 'N/A') ||
                ' Bill Number: ' || COALESCE(v_receiving_record.bill_number, 'N/A') ||
                ' Received Date: ' || COALESCE(TO_CHAR(v_receiving_record.bill_date, 'YYYY-MM-DD'), 'N/A') ||
                ' Received By: ' || COALESCE(v_receiving_record.received_by_name, 'Unknown') ||
                ' Deadline: ' || TO_CHAR(v_due_date, 'YYYY-MM-DD HH24:MI') || ' (24 hours)' ||
                ' Please start the delivery placement process and manage the team accordingly.',
                'task', v_template.priority, generated_by_user_id,
                COALESCE(generated_by_name, 'System'),
                jsonb_build_array(v_assigned_user_id::text),
                'specific_users', 'published', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
                jsonb_build_object(
                  'task_id', v_task_id, 'receiving_record_id', receiving_record_id_param,
                  'role_type', v_template.role_type, 'bill_number', v_receiving_record.bill_number,
                  'vendor_name', v_receiving_record.vendor_name, 'vendor_id', v_receiving_record.vendor_id,
                  'branch_name', v_receiving_record.branch_name, 'bill_amount', v_receiving_record.bill_amount,
                  'bill_date', v_receiving_record.bill_date, 'received_by', v_receiving_record.received_by_name,
                  'due_date', v_due_date, 'clearance_certificate_url', clearance_certificate_url_param
                )
              );

INSERT INTO notification_recipients (id, notification_id, user_id, is_read, created_at)
              VALUES (gen_random_uuid(), v_notification_id, v_assigned_user_id, false, CURRENT_TIMESTAMP)
              ON CONFLICT (notification_id, user_id) DO NOTHING;

v_notifications_sent := v_notifications_sent + 1;

END IF;

END LOOP;

END IF;

END;

ELSE
      -- SINGLE-USER ROLES: branch_manager, purchase_manager, inventory_manager, accountant
      v_assigned_user_id := NULL;

CASE v_template.role_type
        WHEN 'branch_manager' THEN
          v_assigned_user_id := v_receiving_record.branch_manager_user_id;

WHEN 'purchase_manager' THEN
          v_assigned_user_id := v_receiving_record.purchasing_manager_user_id;

WHEN 'inventory_manager' THEN
          v_assigned_user_id := v_receiving_record.inventory_manager_user_id;

WHEN 'accountant' THEN
          v_assigned_user_id := v_receiving_record.accountant_user_id;

ELSE
          v_assigned_user_id := NULL;

END CASE;

v_task_id := gen_random_uuid();

INSERT INTO receiving_tasks (
        id, receiving_record_id, template_id, role_type, assigned_user_id,
        title, description, priority, due_date, task_status, task_completed,
        clearance_certificate_url, created_at, updated_at
      ) VALUES (
        v_task_id, receiving_record_id_param, v_template.id, v_template.role_type,
        v_assigned_user_id, v_title, v_description, v_template.priority,
        v_due_date, 'pending', false, clearance_certificate_url_param,
        CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
      );

v_tasks_created := v_tasks_created + 1;

IF v_assigned_user_id IS NOT NULL THEN
        v_notification_id := gen_random_uuid();

INSERT INTO notifications (
          id, title, message, type, priority, created_by, created_by_name,
          target_users, target_type, status, created_at, sent_at, metadata
        ) VALUES (
          v_notification_id,
          'New Receiving Task Assigned',
          E'\u26A0\uFE0F New Task Assigned: A new task has been assigned to you: ' || v_title ||
          ' Branch: ' || COALESCE(v_receiving_record.branch_name, 'Unknown') ||
          ' Vendor: ' || COALESCE(v_receiving_record.vendor_name, 'Unknown') ||
          ' (ID: ' || COALESCE(v_receiving_record.vendor_id::TEXT, 'N/A') || ')' ||
          ' Bill Amount: ' || COALESCE(v_receiving_record.bill_amount::TEXT, 'N/A') ||
          ' Bill Number: ' || COALESCE(v_receiving_record.bill_number, 'N/A') ||
          ' Received Date: ' || COALESCE(TO_CHAR(v_receiving_record.bill_date, 'YYYY-MM-DD'), 'N/A') ||
          ' Received By: ' || COALESCE(v_receiving_record.received_by_name, 'Unknown') ||
          ' Deadline: ' || TO_CHAR(v_due_date, 'YYYY-MM-DD HH24:MI') || ' (24 hours)' ||
          ' Please start the delivery placement process and manage the team accordingly.',
          'task', v_template.priority, generated_by_user_id,
          COALESCE(generated_by_name, 'System'),
          jsonb_build_array(v_assigned_user_id::text),
          'specific_users', 'published', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          jsonb_build_object(
            'task_id', v_task_id, 'receiving_record_id', receiving_record_id_param,
            'role_type', v_template.role_type, 'bill_number', v_receiving_record.bill_number,
            'vendor_name', v_receiving_record.vendor_name, 'vendor_id', v_receiving_record.vendor_id,
            'branch_name', v_receiving_record.branch_name, 'bill_amount', v_receiving_record.bill_amount,
            'bill_date', v_receiving_record.bill_date, 'received_by', v_receiving_record.received_by_name,
            'due_date', v_due_date, 'clearance_certificate_url', clearance_certificate_url_param
          )
        );

INSERT INTO notification_recipients (id, notification_id, user_id, is_read, created_at)
        VALUES (gen_random_uuid(), v_notification_id, v_assigned_user_id, false, CURRENT_TIMESTAMP)
        ON CONFLICT (notification_id, user_id) DO NOTHING;

v_notifications_sent := v_notifications_sent + 1;

END IF;

END IF;

END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RETURN json_build_object(
      'success', false,
      'error', SQLERRM,
      'error_code', 'INTERNAL_ERROR',
      'tasks_created', 0,
      'notifications_sent', 0
    );

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

v_admin_name text;

v_new_access_code text;

v_current_time timestamp with time zone := now();

result json;

BEGIN
    -- Validate admin user
    SELECT username INTO v_admin_name
    FROM public.users
    WHERE id = p_admin_user_id
    AND status = 'active';

IF v_admin_name IS NULL THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Invalid admin user'
        );

END IF;

END IF;

IF v_request_record.id IS NULL THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Recovery request not found or already processed'
        );

END IF;

IF p_action = 'approve' THEN
        -- Generate new access code
        v_new_access_code := generate_unique_customer_access_code();

IF v_new_access_code IS NULL THEN
            RETURN json_build_object(
                'success', false,
                'error', 'Failed to generate unique access code'
            );

END IF;

result := json_build_object(
            'success', true,
            'message', 'Customer recovery approved successfully',
            'customer_name', v_request_record.customer_name,
            'whatsapp_number', v_request_record.whatsapp_number,
            'new_access_code', v_new_access_code,
            'processed_by', v_admin_name,
            'processed_at', v_current_time
        );

result := json_build_object(
            'success', true,
            'message', 'Customer recovery request rejected',
            'customer_name', v_request_record.customer_name,
            'whatsapp_number', v_request_record.whatsapp_number,
            'processed_by', v_admin_name,
            'processed_at', v_current_time,
            'reason', p_notes
        );

END IF;

RETURN result;

EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Failed to process customer recovery: ' || SQLERRM
        );

END;

$$;

Type: FUNCTION;

Schema: public;

END IF;

NEW.updated_at := NOW();

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

subscription_record RECORD;

notification_data RECORD;

BEGIN
    -- Get notification data
    SELECT 
        title,
        body,
        type,
        created_at
    INTO notification_data
    FROM notifications 
    WHERE id = p_notification_id;

IF NOT FOUND THEN
        RETURN;

END IF;

END LOOP;

WHEN 'specific_users' THEN
            -- Queue for specific users
            IF p_target_users IS NOT NULL THEN
                FOR subscription_record IN 
                    SELECT DISTINCT ps.user_id, ps.endpoint, ps.p256dh, ps.auth
                    FROM push_subscriptions ps
                    JOIN users u ON ps.user_id = u.id
                    WHERE u.status = 'active'
                      AND ps.status = 'active'
                      AND ps.user_id = ANY(
                          SELECT jsonb_array_elements_text(p_target_users)::UUID
                      )
                LOOP
                    INSERT INTO notification_queue (
                        notification_id,
                        user_id,
                        endpoint,
                        p256dh,
                        auth,
                        payload,
                        status,
                        created_at
                    ) VALUES (
                        p_notification_id,
                        subscription_record.user_id,
                        subscription_record.endpoint,
                        subscription_record.p256dh,
                        subscription_record.auth,
                        jsonb_build_object(
                            'title', notification_data.title,
                            'body', notification_data.body,
                            'type', notification_data.type,
                            'notification_id', p_notification_id
                        ),
                        'pending',
                        NOW()
                    );

END LOOP;

END IF;

WHEN 'specific_roles' THEN
            -- Queue for users with specific roles
            IF p_target_roles IS NOT NULL THEN
                FOR subscription_record IN 
                    SELECT DISTINCT ps.user_id, ps.endpoint, ps.p256dh, ps.auth
                    FROM push_subscriptions ps
                    JOIN users u ON ps.user_id = u.id
                    JOIN user_roles ur ON u.id = ur.user_id
                    WHERE u.status = 'active'
                      AND ps.status = 'active'
                      AND ur.role_name = ANY(p_target_roles)
                LOOP
                    INSERT INTO notification_queue (
                        notification_id,
                        user_id,
                        endpoint,
                        p256dh,
                        auth,
                        payload,
                        status,
                        created_at
                    ) VALUES (
                        p_notification_id,
                        subscription_record.user_id,
                        subscription_record.endpoint,
                        subscription_record.p256dh,
                        subscription_record.auth,
                        jsonb_build_object(
                            'title', notification_data.title,
                            'body', notification_data.body,
                            'type', notification_data.type,
                            'notification_id', p_notification_id
                        ),
                        'pending',
                        NOW()
                    );

END LOOP;

END IF;

WHEN 'specific_branches' THEN
            -- Queue for users in specific branches
            IF p_target_branches IS NOT NULL THEN
                FOR subscription_record IN 
                    SELECT DISTINCT ps.user_id, ps.endpoint, ps.p256dh, ps.auth
                    FROM push_subscriptions ps
                    JOIN users u ON ps.user_id = u.id
                    JOIN hr_employees e ON u.employee_id = e.id
                    WHERE u.status = 'active'
                      AND ps.status = 'active'
                      AND e.branch_id = ANY(p_target_branches)
                LOOP
                    INSERT INTO notification_queue (
                        notification_id,
                        user_id,
                        endpoint,
                        p256dh,
                        auth,
                        payload,
                        status,
                        created_at
                    ) VALUES (
                        p_notification_id,
                        subscription_record.user_id,
                        subscription_record.endpoint,
                        subscription_record.p256dh,
                        subscription_record.auth,
                        jsonb_build_object(
                            'title', notification_data.title,
                            'body', notification_data.body,
                            'type', notification_data.type,
                            'notification_id', p_notification_id
                        ),
                        'pending',
                        NOW()
                    );

END LOOP;

END IF;

END CASE;

END;

$$;

Type: FUNCTION;

Schema: public;

notification_payload jsonb;

BEGIN
    -- Only process if this is a task assignment notification
    IF NEW.type = 'task_assignment' AND NEW.target_users IS NOT NULL THEN
        -- Extract assignment details from metadata
        notification_payload := jsonb_build_object(
            'title', NEW.title,
            'body', NEW.message,
            'icon', '/favicon.ico',
            'badge', '/favicon.ico',
            'data', jsonb_build_object(
                'notificationId', NEW.id,
                'type', NEW.type,
                'quick_task_id', (NEW.metadata->>'quick_task_id'),
                'assignment_details', (NEW.metadata->>'assignment_details'),
                'url', '/mobile/quick-task'
            )
        );

END LOOP;

END IF;

RETURN NEW;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

new_assignment_id UUID;

response JSONB;

BEGIN
    -- Get the current receiving task
    SELECT * INTO receiving_task 
    FROM receiving_tasks 
    WHERE id = receiving_task_id_param;

IF NOT FOUND THEN
        RAISE EXCEPTION 'Receiving task not found: %', receiving_task_id_param;

END IF;

END IF;

response := jsonb_build_object(
        'success', true,
        'receiving_task_id', receiving_task_id_param,
        'new_assignment_id', new_assignment_id,
        'new_assigned_user_id', new_assigned_user_id,
        'reassigned_at', now()
    );

RETURN response;

EXCEPTION
    WHEN OTHERS THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', SQLERRM
        );

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN FOUND;

END;

$$;

Type: FUNCTION;

Schema: public;

original_assignment RECORD;

BEGIN
    -- Get original assignment details
    SELECT * INTO original_assignment 
    FROM public.task_assignments 
    WHERE id = p_assignment_id;

IF NOT FOUND THEN
        RAISE EXCEPTION 'Assignment not found: %', p_assignment_id;

END IF;

IF NOT original_assignment.is_reassignable THEN
        RAISE EXCEPTION 'Assignment is not reassignable: %', p_assignment_id;

END IF;

RETURN new_assignment_id;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

total_paid DECIMAL(10,2);

fine_amount DECIMAL(10,2);

BEGIN
    -- Get the fine amount
    SELECT ew.fine_amount INTO fine_amount
    FROM employee_warnings ew
    WHERE ew.id = warning_id_param;

RETURN payment_id;

END;

$$;

Type: FUNCTION;

Schema: public;

v_sent_count int;

v_delivered_count int;

v_read_count int;

v_failed_count int;

v_pending_count int;

v_broadcast_status text;

v_old_status text;

v_broadcast_status := v_old_status;

IF v_pending_count > 0 THEN
        v_broadcast_status := 'sending';

ELSIF v_failed_count = v_total AND v_total > 0 THEN
        v_broadcast_status := 'failed';

ELSIF v_pending_count = 0 AND v_total > 0 THEN
        v_broadcast_status := 'completed';

END IF;

END;

$$;

Type: FUNCTION;

Schema: public;

INSERT INTO public.edge_functions_cache (func_name, func_size, file_count, last_modified, has_index, func_code)
  SELECT
    (f->>'func_name')::text,
    (f->>'func_size')::text,
    (f->>'file_count')::int,
    to_timestamp((f->>'last_modified')::bigint),
    (f->>'has_index')::boolean,
    (f->>'func_code')::text
  FROM jsonb_array_elements(p_functions) AS f;

END;

$$;

Type: FUNCTION;

Schema: public;

$$;

Type: FUNCTION;

Schema: public;

BEGIN
    -- Insert new roles from positions that don't exist yet
    INSERT INTO user_roles (role_name, role_code, description, is_system_role)
    SELECT 
        hp.position_title_en,
        UPPER(REPLACE(REPLACE(hp.position_title_en, ' ', '_'), '/', '_')),
        CONCAT('Access level for ', hp.position_title_en, ' position'),
        false
    FROM hr_positions hp
    WHERE hp.position_title_en IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM user_roles ur 
        WHERE ur.role_name = hp.position_title_en
    );

GET DIAGNOSTICS roles_updated = ROW_COUNT;

RETURN roles_updated;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN new_id;

ELSE
        -- Insert new function
        INSERT INTO app_functions (function_name, function_code, description, category, is_active)
        VALUES (p_function_name, p_function_code, p_description, p_category, p_enabled)
        RETURNING id INTO new_id;

RETURN new_id;

END IF;

END;

$$;

Type: FUNCTION;

Schema: public;

END IF;

RETURN subscription_id;

END;

$$;

Type: FUNCTION;

Schema: public;

BEGIN
    INSERT INTO user_roles (role_name, role_code, description, is_system_role)
    VALUES (p_role_name, p_role_code, p_description, true)
    ON CONFLICT (role_name) DO UPDATE SET
        role_code = p_role_code,
        description = p_description,
        updated_at = NOW()
    RETURNING id INTO new_role_id;

RETURN new_role_id;

END;

$$;

Type: FUNCTION;

Schema: public;

v_otp VARCHAR(6);

v_whatsapp_clean VARCHAR(20);

BEGIN
  -- Clean WhatsApp number (remove spaces, dashes)
  v_whatsapp_clean := REGEXP_REPLACE(p_whatsapp, '[\s\-]', '', 'g');

IF v_user_id IS NULL THEN
    RETURN json_build_object(
      'success', false,
      'message', 'No matching user found. Please check your email and WhatsApp number.'
    );

END IF;

END IF;

RETURN json_build_object(
    'success', true,
    'otp', v_otp,
    'whatsapp_number', v_whatsapp_clean,
    'message', 'OTP generated successfully'
  );

END;

$$;

Type: FUNCTION;

Schema: public;

v_new_access_code text;

v_hashed_new_code text;

v_system_user_id uuid := 'e1fdaee2-97f0-4fc1-872f-9d99c6bd684b';

BEGIN
    SELECT id, name, access_code, registration_status, whatsapp_number
    INTO v_customer
    FROM public.customers
    WHERE whatsapp_number = p_whatsapp_number
       OR whatsapp_number = '+' || p_whatsapp_number
       OR regexp_replace(whatsapp_number, '[^0-9]', '', 'g') = regexp_replace(p_whatsapp_number, '[^0-9]', '', 'g')
    LIMIT 1;

IF v_customer.id IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'not_found',
            'message', 'No account found with this WhatsApp number.');

END IF;

IF v_customer.registration_status != 'approved' THEN
        RETURN jsonb_build_object('success', false, 'error', 'not_approved',
            'message', 'Your account is not active. Please register again or contact support.');

END IF;

v_hashed_new_code := encode(digest(v_new_access_code::bytea, 'sha256'), 'hex');

INSERT INTO public.customer_access_code_history (
        customer_id, old_access_code, new_access_code,
        generated_by, reason, notes
    ) VALUES (
        v_customer.id, v_customer.access_code, v_hashed_new_code,
        v_system_user_id, 'customer_request', 'Customer requested code resend (new code generated)'
    );

RETURN jsonb_build_object(
        'success', true,
        'customer_id', v_customer.id,
        'access_code', v_new_access_code,
        'whatsapp_number', v_customer.whatsapp_number,
        'customer_name', v_customer.name,
        'message', 'A new access code has been sent to your WhatsApp.'
    );

END;

$$;

Type: FUNCTION;

Schema: public;

v_customer_name text;

v_current_time timestamp with time zone := now();

v_request_id uuid;

result json;

BEGIN
    -- Validate input
    IF p_whatsapp_number IS NULL OR trim(p_whatsapp_number) = '' THEN
        RETURN json_build_object(
            'success', false,
            'error', 'WhatsApp number is required'
        );

END IF;

END IF;

END IF;

EXCEPTION
        WHEN OTHERS THEN
            RETURN json_build_object(
                'success', false,
                'error', 'Failed to create recovery request: ' || SQLERRM
            );

END;

BEGIN
            SELECT array_agg(id::text) INTO v_admin_user_ids
            FROM public.users 
            WHERE (is_admin = true OR is_master_admin = true)
            AND status = 'active';

END;

EXCEPTION
        WHEN OTHERS THEN
            -- Don't fail the whole recovery if notification fails
            RAISE NOTICE 'Failed to create notification: %', SQLERRM;

END;

result := json_build_object(
        'success', true,
        'message', 'Account recovery request submitted successfully. An administrator will contact you soon for verification.',
        'request_id', v_request_id,
        'customer_name', v_customer_name,
        'whatsapp_number', p_whatsapp_number
    );

RETURN result;

EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Failed to process account recovery request: ' || SQLERRM
        );

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN 'Restart requested successfully. Services will restart within 30 seconds.';

END;

$$;

Type: FUNCTION;

Schema: public;

IF NOT FOUND THEN
        RAISE EXCEPTION 'Visit schedule not found with id: %', visit_id;

END IF;

RETURN new_date;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

v_admin_user RECORD;

BEGIN
    INSERT INTO notifications (
        title, message, type, created_by, created_by_name, created_by_role,
        priority, status, target_type, target_roles, sent_at
    ) VALUES (
        p_title, p_message, p_type,
        COALESCE(p_performed_by::text, 'system'), 'System', 'System',
        p_priority, 'published',
        CASE WHEN p_target_user_id IS NOT NULL THEN 'specific_users' ELSE 'role_based' END,
        to_jsonb(ARRAY['Admin', 'Master Admin']),
        NOW()
    ) RETURNING id INTO v_notification_id;

END IF;

END LOOP;

RETURN v_notification_id;

END;

$$;

Type: FUNCTION;

Schema: public;

PERFORM set_config('app.is_master_admin', is_master_admin::text, false);

PERFORM set_config('app.is_admin', is_admin::text, false);

END;

$$;

Type: FUNCTION;

Schema: public;

func_record RECORD;

BEGIN
    -- Get role ID
    SELECT id INTO v_role_id FROM user_roles WHERE role_code = p_role_code;

IF v_role_id IS NULL THEN
        RAISE NOTICE 'Role % not found', p_role_code;

RETURN 0;

END IF;

END LOOP;

RETURN permissions_set;

END;

$$;

Type: FUNCTION;

Schema: public;

IF NOT FOUND THEN
        RAISE EXCEPTION 'Visit schedule not found with id: %', visit_id;

END IF;

END;

$$;

Type: FUNCTION;

Schema: public;

BEGIN
  -- Check if it's the default template
  SELECT is_default INTO is_default_template
  FROM flyer_templates
  WHERE id = template_id;

END IF;

RETURN FOUND;

END;

$$;

Type: FUNCTION;

Schema: public;

v_existing UUID;

v_break_id UUID;

BEGIN
  -- Check for already-open break
  SELECT id INTO v_existing
  FROM break_register
  WHERE user_id = p_user_id AND status = 'open'
  LIMIT 1;

IF v_existing IS NOT NULL THEN
    RETURN jsonb_build_object('success', false, 'error', 'You already have an open break', 'break_id', v_existing);

END IF;

IF v_emp IS NULL THEN
    RETURN jsonb_build_object('success', false, 'error', 'Employee record not found');

END IF;

RETURN jsonb_build_object('success', true, 'break_id', v_break_id);

END;

$$;

Type: FUNCTION;

Schema: public;

v_completion_id uuid;

v_existing_completion_id uuid;

v_require_photo boolean;

v_require_erp boolean;

v_assignment_record RECORD;

BEGIN
    -- Get the assignment details including requirements
    SELECT 
        qta.quick_task_id,
        qta.require_photo_upload,
        qta.require_erp_reference,
        qta.status
    INTO v_assignment_record
    FROM quick_task_assignments qta
    WHERE qta.id = p_assignment_id;

END IF;

END IF;

v_quick_task_id := v_assignment_record.quick_task_id;

v_require_photo := v_assignment_record.require_photo_upload;

v_require_erp := v_assignment_record.require_erp_reference;

END IF;

END IF;

IF v_existing_completion_id IS NOT NULL THEN
        -- Update existing completion
        UPDATE quick_task_completions
        SET
            completion_notes = COALESCE(p_completion_notes, completion_notes),
            photo_path = COALESCE(array_to_string(p_photos, ','), photo_path),
            erp_reference = COALESCE(p_erp_reference, erp_reference),
            updated_at = now()
        WHERE id = v_existing_completion_id;

v_completion_id := v_existing_completion_id;

ELSE
        -- Create new completion record
        INSERT INTO quick_task_completions (
            quick_task_id,
            assignment_id,
            completed_by_user_id,
            completion_notes,
            photo_path,
            erp_reference,
            completion_status
        ) VALUES (
            v_quick_task_id,
            p_assignment_id,
            p_user_id,
            p_completion_notes,
            array_to_string(p_photos, ','),
            p_erp_reference,
            'submitted'
        )
        RETURNING id INTO v_completion_id;

END IF;

RETURN v_completion_id;

END;

$$;

Type: FUNCTION;

Schema: public;

total_synced INTEGER := 0;

sync_details TEXT := '';

total_synced := total_synced + 1;

sync_details := sync_details || format('Synced receiving_record %s with ERP %s;

', 
                                              sync_record.receiving_record_id, 
                                              TRIM(sync_record.erp_reference_number));

END LOOP;

RETURN QUERY SELECT total_synced, sync_details;

END;

$$;

Type: FUNCTION;

Schema: public;

total_synced INTEGER := 0;

sync_details JSONB := '[]'::JSONB;

record_detail JSONB;

total_synced := total_synced + 1;

sync_details := sync_details || record_detail;

END LOOP;

RETURN jsonb_build_object(
        'success', true,
        'total_synced', total_synced,
        'details', sync_details,
        'message', format('%s receiving records synced successfully', total_synced)
    );

EXCEPTION
    WHEN OTHERS THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', SQLERRM,
            'error_code', SQLSTATE
        );

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

function_record JSONB;

result_count INTEGER := 0;

result_text TEXT := '';

BEGIN
    -- Loop through each component in the metadata
    FOR component IN SELECT jsonb_array_elements(component_metadata->'components')
    LOOP
        -- Loop through functions in each component
        FOR function_record IN SELECT jsonb_array_elements(component->'functions')
        LOOP
            -- Register each function
            PERFORM register_app_function(
                function_record->>'name',
                function_record->>'code',
                function_record->>'description',
                COALESCE(function_record->>'category', component->>'category', 'Application')
            );

result_count := result_count + 1;

END LOOP;

END LOOP;

result_text := format('Synchronized %s app functions from component metadata', result_count);

RETURN result_text;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN FOUND;

END;

$$;

Type: FUNCTION;

Schema: public;

updated_count INTEGER := 0;

result_json JSONB;

BEGIN
    RAISE NOTICE 'Starting ERP sync for receiving_record_id: %', receiving_record_id_param;

GET DIAGNOSTICS updated_count = ROW_COUNT;

result_json := jsonb_build_object(
                'success', true,
                'synced', true,
                'updated_count', updated_count,
                'erp_reference', TRIM(sync_record.erp_reference_number),
                'previous_erp', sync_record.current_erp,
                'completed_by', sync_record.completed_by,
                'completed_at', sync_record.completed_at,
                'message', format('ERP reference %s synced from task completion', TRIM(sync_record.erp_reference_number))
            );

ELSE
            result_json := jsonb_build_object(
                'success', true,
                'synced', false,
                'updated_count', 0,
                'erp_reference', sync_record.current_erp,
                'message', 'ERP reference already synced - no update needed'
            );

END IF;

ELSE
        RAISE NOTICE 'No task completion found, checking for existing ERP reference';

IF FOUND AND sync_record.current_erp IS NOT NULL AND TRIM(sync_record.current_erp) != '' THEN
            result_json := jsonb_build_object(
                'success', true,
                'synced', false,
                'updated_count', 0,
                'erp_reference', sync_record.current_erp,
                'message', format('ERP reference %s already exists (legacy record)', sync_record.current_erp)
            );

ELSE
            result_json := jsonb_build_object(
                'success', true,
                'synced', false,
                'updated_count', 0,
                'message', 'No ERP reference available - inventory manager task not completed'
            );

END IF;

END IF;

RETURN result_json;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'ERROR in sync function: %', SQLERRM;

RETURN jsonb_build_object(
            'success', false,
            'error', SQLERRM,
            'error_code', SQLSTATE
        );

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

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

END IF;

END IF;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END IF;

IF NEW.is_active = false AND OLD.is_active = true THEN
        NEW.deactivated_at = NOW();

END IF;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN OLD;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

RETURN OLD;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

v_notification_id UUID;

v_admin_user RECORD;

v_title TEXT;

v_message TEXT;

v_fulfillment_label_en TEXT;

v_fulfillment_label_ar TEXT;

v_push_body TEXT;

v_service_role_key TEXT;

v_supabase_url TEXT;

v_request_id BIGINT;

v_user_ids JSONB;

BEGIN
    -- Get customer name
    SELECT name INTO v_customer_name
    FROM customers
    WHERE id = NEW.customer_id;

v_fulfillment_label_ar := '??????';

ELSE
        v_fulfillment_label_en := 'Delivery';

v_fulfillment_label_ar := '?????';

END IF;

v_message := 'Order #' || NEW.order_number || ' from ' || COALESCE(v_customer_name, NEW.customer_name) || ' - Total: ' || NEW.total_amount || ' SAR - ' || v_fulfillment_label_en || '|||??? #' || NEW.order_number || ' ?? ' || COALESCE(v_customer_name, NEW.customer_name) || ' - ??????: ' || NEW.total_amount || ' ?.? - ' || v_fulfillment_label_ar;

END LOOP;

RETURN NEW;

END IF;

v_push_body := '??? ???? ?? ' || COALESCE(v_customer_name, NEW.customer_name) || ' - ' || NEW.total_amount || ' ?.? - ' || v_fulfillment_label_ar
        || chr(10) || 'New order from ' || COALESCE(v_customer_name, NEW.customer_name) || ' - ' || NEW.total_amount || ' SAR - ' || v_fulfillment_label_en;

SELECT decrypted_secret INTO v_service_role_key
    FROM vault.decrypted_secrets
    WHERE name = 'service_role_key'
    LIMIT 1;

IF v_service_role_key IS NULL THEN
        BEGIN
            v_service_role_key := current_setting('supabase.service_role_key', true);

EXCEPTION WHEN OTHERS THEN
            v_service_role_key := NULL;

END;

END IF;

END IF;

RAISE LOG 'Staff push for new order % sent to % branch receivers, request_id: %', 
        NEW.order_number, jsonb_array_length(v_user_ids), v_request_id;

RETURN NEW;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

END IF;

RETURN NEW;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

BEGIN
    -- Only process if ERP reference is provided and completed
    IF NEW.erp_reference_completed = true 
       AND NEW.erp_reference_number IS NOT NULL 
       AND TRIM(NEW.erp_reference_number) != '' THEN
        
        -- Check if this is a regular task completion (not receiving task)
        -- Regular tasks (like payment tasks) don't need this trigger
        -- This trigger only handles receiving_tasks (inventory manager tasks)
        
        -- Since receiving_tasks is a separate system with its own completion logic,
        -- and regular tasks/task_assignments are separate,
        -- we don't need to do anything here for regular task completions.
        
        -- The receiving tasks have their own completion system via:
        -- complete_receiving_task() function which is called directly
        
        RAISE NOTICE 'ℹ️  Task completion with ERP reference: Task ID %, ERP: %', 
                     NEW.task_id, 
                     TRIM(NEW.erp_reference_number);

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN COALESCE(NEW, OLD);

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

END IF;

ELSIF NEW.check_in_time IS NOT NULL THEN
        NEW.status = 'present';

ELSE
        NEW.status = 'absent';

END IF;

NEW.updated_at = NOW();

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

ELSE
        NEW.deadline_datetime = NULL;

END IF;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

BEGIN
      -- Determine the base amount to deduct from
      base_amount := COALESCE(NEW.original_final_amount, NEW.bill_amount);

END;

END IF;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

NEW.health_card_expiry := NEW.expiry_date;

ELSIF NEW.document_type = 'resident_id' THEN
        NEW.resident_id_number := NEW.document_number;

NEW.resident_id_expiry := NEW.expiry_date;

ELSIF NEW.document_type = 'passport' THEN
        NEW.passport_number := NEW.document_number;

NEW.passport_expiry := NEW.expiry_date;

ELSIF NEW.document_type = 'driving_license' THEN
        NEW.driving_license_number := NEW.document_number;

NEW.driving_license_expiry := NEW.expiry_date;

ELSIF NEW.document_type = 'resume' THEN
        NEW.resume_uploaded := TRUE;

END IF;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

new_next_date DATE;

BEGIN
    -- Get the visit record
    SELECT * INTO visit_record FROM vendor_visits WHERE id = visit_id;

IF NOT FOUND THEN
        RAISE EXCEPTION 'Visit schedule not found with id: %', visit_id;

END IF;

RETURN new_next_date;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

RETURN OLD;

END IF;

RETURN NULL;

END;

$$;

Type: FUNCTION;

Schema: public;

RAISE NOTICE 'Updated delivery status for notification % user %', NEW.notification_id, NEW.user_id;

RAISE NOTICE 'Marked delivery as failed for notification % user %', NEW.notification_id, NEW.user_id;

END IF;

RETURN NEW;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

END IF;

RETURN COALESCE(NEW, OLD);

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

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

RETURN QUERY SELECT TRUE, 'Order status updated successfully';

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

END IF;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

END IF;

END IF;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

END IF;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

can_complete BOOLEAN := true;

BEGIN
    -- Get receiving task details
    SELECT * INTO receiving_task 
    FROM receiving_tasks 
    WHERE id = receiving_task_id_param;

IF NOT FOUND THEN
        RAISE EXCEPTION 'Receiving task not found: %', receiving_task_id_param;

END IF;

END IF;

END IF;

RETURN true;

END IF;

RETURN false;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

END IF;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

END IF;

RETURN COALESCE(NEW, OLD);

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

v_status_label TEXT;

v_status_label_ar TEXT;

v_notif_type TEXT;

v_message TEXT;

v_title TEXT;

v_tasks_completed INTEGER := 0;

v_task_record RECORD;

IF v_requester_user_id IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'Request not found');

END IF;

v_tasks_completed := v_tasks_completed + 1;

END LOOP;

v_status_label_ar := 'مقبول ✅';

v_notif_type := 'success';

v_message := 'Your Stock Request has been approved.' || E'\n---\n' || 'طلب المخزون الخاص بك تم قبوله.';

ELSE
        v_status_label := 'Rejected ❌';

v_status_label_ar := 'مرفوض ❌';

v_notif_type := 'error';

v_message := 'Your Stock Request has been rejected.' || E'\n---\n' || 'طلب المخزون الخاص بك تم رفضه.';

END IF;

v_title := 'ST Request ' || v_status_label || ' | طلب ST ' || v_status_label_ar;

RETURN jsonb_build_object(
        'success', true,
        'status', p_new_status,
        'tasks_completed', v_tasks_completed,
        'notification_sent', true
    );

EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object('success', false, 'error', SQLERRM);

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

END IF;

END IF;

END IF;

END IF;

END IF;

END IF;

END IF;

END IF;

END IF;

END IF;

END IF;

END IF;

RETURN json_build_object(
    'success', true,
    'message', 'User updated successfully'
  );

EXCEPTION
  WHEN OTHERS THEN
    RETURN json_build_object(
      'success', false,
      'message', SQLERRM
    );

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

total_deductions NUMERIC;

calculated_final_amount NUMERIC;

BEGIN
  -- Get the bill_amount (this is always our base for calculation)
  SELECT bill_amount
  INTO current_bill_amount
  FROM vendor_payment_schedule
  WHERE id = payment_id;

END IF;

END IF;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

BEGIN
    INSERT INTO public.app_icons (icon_key, name, category, storage_path, mime_type, file_size, description, created_by)
    VALUES (p_icon_key, p_name, p_category, p_storage_path, p_mime_type, p_file_size, p_description, auth.uid())
    ON CONFLICT (icon_key) DO UPDATE SET
        name = EXCLUDED.name,
        category = EXCLUDED.category,
        storage_path = EXCLUDED.storage_path,
        mime_type = EXCLUDED.mime_type,
        file_size = EXCLUDED.file_size,
        description = EXCLUDED.description,
        updated_at = now()
    RETURNING id INTO v_id;

RETURN v_id;

END;

$$;

Type: FUNCTION;

Schema: public;

BEGIN
    INSERT INTO branch_sync_config (branch_id, local_supabase_url, local_supabase_key, tunnel_url, is_active)
    VALUES (p_branch_id, p_local_supabase_url, p_local_supabase_key, p_tunnel_url, true)
    ON CONFLICT (branch_id) DO UPDATE SET
        local_supabase_url = EXCLUDED.local_supabase_url,
        local_supabase_key = EXCLUDED.local_supabase_key,
        tunnel_url = COALESCE(EXCLUDED.tunnel_url, branch_sync_config.tunnel_url),
        updated_at = now()
    RETURNING id INTO v_id;

RETURN v_id;

END;

$$;

Type: FUNCTION;

Schema: public;

BEGIN
  INSERT INTO branch_sync_config (branch_id, local_supabase_url, local_supabase_key, tunnel_url, ssh_user)
  VALUES (p_branch_id, p_local_supabase_url, p_local_supabase_key, p_tunnel_url, COALESCE(p_ssh_user, 'u'))
  ON CONFLICT (branch_id) DO UPDATE SET
    local_supabase_url = EXCLUDED.local_supabase_url,
    local_supabase_key = EXCLUDED.local_supabase_key,
    tunnel_url = COALESCE(EXCLUDED.tunnel_url, branch_sync_config.tunnel_url),
    ssh_user = COALESCE(EXCLUDED.ssh_user, branch_sync_config.ssh_user, 'u'),
    updated_at = now()
  RETURNING id INTO v_id;

RETURN v_id;

END;

$$;

Type: FUNCTION;

Schema: public;

v_updated int := 0;

v_product jsonb;

v_existing_expiry jsonb;

v_new_expiry jsonb;

v_merged_expiry jsonb;

v_branch_id bigint;

BEGIN
  FOR v_product IN SELECT * FROM jsonb_array_elements(p_products)
  LOOP
    v_new_expiry := COALESCE(v_product->'expiry_dates', '[]'::jsonb);

IF v_existing_expiry IS NOT NULL THEN
      -- Record exists - merge expiry dates
      -- Remove entries for the same branch_id(s) we're inserting, then append new ones
      v_merged_expiry := COALESCE(v_existing_expiry, '[]'::jsonb);

FOR v_branch_id IN SELECT (elem->>'branch_id')::bigint FROM jsonb_array_elements(v_new_expiry) AS elem
      LOOP
        -- Remove existing entry for this branch_id
        SELECT COALESCE(jsonb_agg(elem), '[]'::jsonb)
        INTO v_merged_expiry
        FROM jsonb_array_elements(v_merged_expiry) AS elem
        WHERE (elem->>'branch_id')::bigint != v_branch_id;

END LOOP;

v_updated := v_updated + 1;

ELSE
      -- New record - insert
      INSERT INTO erp_synced_products (
        barcode, auto_barcode, parent_barcode, 
        product_name_en, product_name_ar,
        unit_name, unit_qty, is_base_unit, expiry_dates
      ) VALUES (
        v_product->>'barcode',
        v_product->>'auto_barcode',
        v_product->>'parent_barcode',
        v_product->>'product_name_en',
        v_product->>'product_name_ar',
        v_product->>'unit_name',
        COALESCE((v_product->>'unit_qty')::numeric, 1),
        COALESCE((v_product->>'is_base_unit')::boolean, false),
        v_new_expiry
      );

v_inserted := v_inserted + 1;

END IF;

END LOOP;

RETURN jsonb_build_object(
    'inserted', v_inserted,
    'updated', v_updated
  );

END;

$$;

Type: FUNCTION;

Schema: public;

Type: FUNCTION;

Schema: public;

v_epoch bigint;

v_current_code text;

v_previous_code text;

BEGIN
    SELECT seed INTO v_seed FROM break_security_seed WHERE id = 1;

IF v_seed IS NULL THEN
        RETURN false;

END IF;

v_epoch := floor(extract(epoch from now()) / 10)::bigint;

RETURN (p_code = v_current_code OR p_code = v_previous_code);

END;

$$;

Type: FUNCTION;

Schema: public;

BEGIN
    -- Get the offer type
    SELECT type INTO v_offer_type FROM offers WHERE id = NEW.offer_id;

IF v_offer_type IS NULL THEN
        RAISE EXCEPTION 'Offer with id % does not exist', NEW.offer_id;

END IF;

IF v_offer_type != 'bundle' THEN
        RAISE EXCEPTION 'Offer with id % must be of type "bundle" but is "%"', NEW.offer_id, v_offer_type;

END IF;

RETURN NEW;

END;

$$;

Type: FUNCTION;

Schema: public;

v_campaign_name VARCHAR;

v_is_active BOOLEAN;

v_validity_start TIMESTAMP WITH TIME ZONE;

v_validity_end TIMESTAMP WITH TIME ZONE;

v_max_claims_per_customer INTEGER;

v_is_eligible BOOLEAN;

v_current_claim_count INTEGER;

BEGIN
  -- Get campaign details
  SELECT 
    id, 
    campaign_name, 
    is_active,
    validity_start_date,
    validity_end_date,
    COALESCE(max_claims_per_customer, 1)
  INTO 
    v_campaign_id,
    v_campaign_name,
    v_is_active,
    v_validity_start,
    v_validity_end,
    v_max_claims_per_customer
  FROM coupon_campaigns
  WHERE campaign_code = p_campaign_code
    AND deleted_at IS NULL;

END IF;

END IF;

END IF;

IF NOT v_is_eligible THEN
    RETURN jsonb_build_object(
      'eligible', false,
      'error_message', 'Customer is not eligible for this campaign'
    );

END IF;

END IF;

END;

$$;

Type: FUNCTION;

Schema: public;

required_keys TEXT[] := ARRAY['id', 'number', 'x', 'y', 'width', 'height', 'fields'];

BEGIN
  -- Check if config is an array
  IF jsonb_typeof(config) != 'array' THEN
    RAISE EXCEPTION 'Configuration must be a JSON array';

END IF;

END IF;

END IF;

END IF;

END LOOP;

RETURN true;

END;

$$;

Type: FUNCTION;

Schema: public;

method TEXT;

methods TEXT[];

BEGIN
    IF payment_methods IS NULL OR LENGTH(TRIM(payment_methods)) = 0 THEN
        RETURN TRUE;

END IF;

END IF;

END LOOP;

RETURN TRUE;

END;

$$;

Type: FUNCTION;

Schema: public;

v_is_active BOOLEAN;

v_start_date TIMESTAMPTZ;

v_end_date TIMESTAMPTZ;

BEGIN
  SELECT 
    op.offer_qty,
    o.is_active,
    o.start_date,
    o.end_date
  INTO 
    v_offer_qty,
    v_is_active,
    v_start_date,
    v_end_date
  FROM offer_products op
  INNER JOIN offers o ON op.offer_id = o.id
  WHERE op.offer_id = p_offer_id 
    AND op.product_id = p_product_id;

IF NOT FOUND THEN
    RETURN FALSE;

END IF;

IF NOT v_is_active THEN
    RETURN FALSE;

END IF;

IF NOW() < v_start_date OR NOW() > v_end_date THEN
    RETURN FALSE;

END IF;

IF p_quantity < v_offer_qty THEN
    RETURN FALSE;

END IF;

RETURN TRUE;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

receiving_record RECORD;

validation_result JSONB;

missing_requirements TEXT[] := '{}';

BEGIN
    -- Get receiving task
    SELECT * INTO receiving_task 
    FROM receiving_tasks 
    WHERE id = receiving_task_id_param AND assigned_user_id = user_id_param;

IF NOT FOUND THEN
        RETURN jsonb_build_object(
            'valid', false,
            'error', 'Task not found or user not authorized'
        );

END IF;

END IF;

END IF;

END IF;

validation_result := jsonb_build_object(
        'valid', array_length(missing_requirements, 1) IS NULL,
        'missing_requirements', missing_requirements,
        'task_id', receiving_task.task_id,
        'role_type', receiving_task.role_type,
        'requirements', jsonb_build_object(
            'erp_reference_required', receiving_task.requires_erp_reference,
            'erp_reference_provided', receiving_task.erp_reference_number IS NOT NULL,
            'original_bill_upload_required', receiving_task.requires_original_bill_upload,
            'original_bill_uploaded', receiving_task.original_bill_uploaded OR receiving_record.original_bill_url IS NOT NULL,
            'task_finished_mark_required', receiving_task.requires_task_finished_mark
        )
    );

RETURN validation_result;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END IF;

RETURN NEW;

END;

$$;

Type: COMMENT;

Schema: public;

Type: FUNCTION;

Schema: public;

v_otp_record RECORD;

v_whatsapp_clean VARCHAR(20);

v_hashed_code VARCHAR(255);

v_existing_count INT;

BEGIN
  v_whatsapp_clean := REGEXP_REPLACE(p_whatsapp, '[\s\-]', '', 'g');

IF v_user_id IS NULL THEN
    RETURN json_build_object('success', false, 'message', 'User not found.');

END IF;

IF v_otp_record IS NULL THEN
    RETURN json_build_object('success', false, 'message', 'No valid OTP found. Please request a new one.');

END IF;

RETURN json_build_object('success', false, 'message', 'Too many failed attempts. Please request a new OTP.');

END IF;

RETURN json_build_object('success', false, 'message', 'Invalid OTP code.');

END IF;

IF v_existing_count > 0 THEN
    RETURN json_build_object('success', false, 'message', 'This access code is already in use. Please choose a different one.');

END IF;

RETURN json_build_object('success', true, 'message', 'Access code changed successfully.');

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

END;

$$;

Type: FUNCTION;

Schema: public;

BEGIN
  -- Validate input format
  IF p_code IS NULL OR LENGTH(p_code) != 6 OR p_code !~ '^[0-9]{6}$' THEN
    RETURN json_build_object('success', false, 'error', 'Invalid access code format');

END IF;

IF NOT FOUND THEN
    RETURN json_build_object('success', false, 'error', 'Invalid access code');

END IF;

RETURN json_build_object(
    'success', true,
    'user', json_build_object(
      'id', v_user.id,
      'username', v_user.username,
      'user_type', v_user.user_type,
      'status', v_user.status,
      'is_master_admin', v_user.is_master_admin,
      'is_admin', v_user.is_admin,
      'employee_id', v_user.employee_id,
      'branch_id', v_user.branch_id,
      'position_id', v_user.position_id,
      'avatar', v_user.avatar
    )
  );

END;

$_$;

Type: FUNCTION;

Schema: public;

BEGIN
    IF is_approved THEN
        new_status := 'verified';

ELSE
        new_status := 'rejected';

END IF;

RETURN FOUND;

END;

$$;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

ALTER TABLE ONLY public.break_register REPLICA IDENTITY FULL;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

ALTER TABLE ONLY public.delivery_service_settings REPLICA IDENTITY FULL;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: MATERIALIZED VIEW;

Schema: public;

--

CREATE MATERIALIZED VIEW public.mv_expiry_products AS
 SELECT ((entry.value ->> 'branch_id'::text))::integer AS branch_id,
    p.barcode,
    p.product_name_en,
    p.product_name_ar,
    ((entry.value ->> 'expiry_date'::text))::date AS expiry_date,
    (((entry.value ->> 'expiry_date'::text))::date - CURRENT_DATE) AS days_left,
    p.managed_by,
    p.expiry_hidden
   FROM public.erp_synced_products p,
    LATERAL jsonb_array_elements(p.expiry_dates) entry(value)
  WHERE ((jsonb_array_length(p.expiry_dates) > 0) AND ((entry.value ->> 'expiry_date'::text) IS NOT NULL) AND ((entry.value ->> 'branch_id'::text) IS NOT NULL))
  WITH NO DATA;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

ALTER TABLE ONLY public.order_audit_logs REPLICA IDENTITY FULL;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

ALTER TABLE ONLY public.order_items REPLICA IDENTITY FULL;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

ALTER TABLE ONLY public.orders REPLICA IDENTITY FULL;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: VIEW;

Schema: public;

--

CREATE VIEW IF NOT EXISTS public.quick_task_completion_details AS
 SELECT qtc.id,
    qtc.quick_task_id,
    qt.title AS task_title,
    qt.description AS task_description,
    qtc.assignment_id,
    qtc.completed_by_user_id,
    u1.username AS completed_by_username,
    u1.username AS completed_by_name,
    qtc.completion_notes,
    qtc.photo_path,
    qtc.erp_reference,
    qtc.completion_status,
    qtc.verified_by_user_id,
    u2.username AS verified_by_username,
    u2.username AS verified_by_name,
    qtc.verified_at,
    qtc.verification_notes,
    qtc.created_at,
    qtc.updated_at,
    qta.require_photo_upload,
    qta.require_erp_reference,
    qta.require_task_finished
   FROM ((((public.quick_task_completions qtc
     JOIN public.quick_tasks qt ON ((qtc.quick_task_id = qt.id)))
     JOIN public.quick_task_assignments qta ON ((qtc.assignment_id = qta.id)))
     JOIN public.users u1 ON ((qtc.completed_by_user_id = u1.id)))
     LEFT JOIN public.users u2 ON ((qtc.verified_by_user_id = u2.id)))
  ORDER BY qtc.created_at DESC;

Type: TABLE;

Schema: public;

Type: VIEW;

Schema: public;

--

CREATE VIEW IF NOT EXISTS public.quick_task_files_with_details AS
 SELECT qtf.id,
    qtf.quick_task_id,
    qtf.file_name,
    qtf.file_type,
    qtf.file_size,
    qtf.mime_type,
    qtf.storage_path,
    qtf.storage_bucket,
    qtf.uploaded_by,
    qtf.uploaded_at,
    qt.title AS task_title,
    qt.status AS task_status,
    u.username AS uploaded_by_username,
    he.name AS uploaded_by_name
   FROM (((public.quick_task_files qtf
     LEFT JOIN public.quick_tasks qt ON ((qtf.quick_task_id = qt.id)))
     LEFT JOIN public.users u ON ((qtf.uploaded_by = u.id)))
     LEFT JOIN public.hr_employees he ON ((u.employee_id = he.id)));

Type: TABLE;

Schema: public;

Type: VIEW;

Schema: public;

--

CREATE VIEW IF NOT EXISTS public.quick_tasks_with_details AS
 SELECT qt.id,
    qt.title,
    qt.description,
    qt.price_tag,
    qt.issue_type,
    qt.priority,
    qt.assigned_by,
    qt.assigned_to_branch_id,
    qt.created_at,
    qt.deadline_datetime,
    qt.completed_at,
    qt.status,
    qt.created_from,
    qt.updated_at,
    u_assigned_by.username AS assigned_by_username,
    he_assigned_by.name AS assigned_by_name,
    b.name_en AS branch_name,
    b.name_ar AS branch_name_ar,
    count(qta.id) AS total_assignments,
    count(
        CASE
            WHEN ((qta.status)::text = 'completed'::text) THEN 1
            ELSE NULL::integer
        END) AS completed_assignments,
    count(
        CASE
            WHEN ((qta.status)::text = 'overdue'::text) THEN 1
            ELSE NULL::integer
        END) AS overdue_assignments
   FROM ((((public.quick_tasks qt
     LEFT JOIN public.users u_assigned_by ON ((qt.assigned_by = u_assigned_by.id)))
     LEFT JOIN public.hr_employees he_assigned_by ON ((u_assigned_by.employee_id = he_assigned_by.id)))
     LEFT JOIN public.branches b ON ((qt.assigned_to_branch_id = b.id)))
     LEFT JOIN public.quick_task_assignments qta ON ((qt.id = qta.quick_task_id)))
  GROUP BY qt.id, qt.title, qt.description, qt.price_tag, qt.issue_type, qt.priority, qt.assigned_by, qt.assigned_to_branch_id, qt.created_at, qt.deadline_datetime, qt.completed_at, qt.status, qt.created_from, qt.updated_at, u_assigned_by.username, he_assigned_by.name, b.name_en, b.name_ar;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: VIEW;

Schema: public;

--

CREATE VIEW IF NOT EXISTS public.receiving_records_pr_excel_status AS
 SELECT rr.id,
    rr.bill_number,
    rr.vendor_id,
    v.vendor_name,
    rr.pr_excel_file_url,
        CASE
            WHEN (rr.pr_excel_file_url IS NOT NULL) THEN 'Uploaded'::text
            ELSE 'Not Uploaded'::text
        END AS pr_excel_status,
    rr.updated_at
   FROM (public.receiving_records rr
     LEFT JOIN public.vendors v ON ((v.erp_vendor_id = rr.vendor_id)))
  ORDER BY rr.updated_at DESC;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

$$);

Alternatively, use external cron service (GitHub Actions, Vercel Cron, etc.) to call:
POST https://your-project.supabase.co/rest/v1/rpc/check_and_notify_recurring_schedules_with_logging
';

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: VIEW;

Schema: public;

--

CREATE VIEW IF NOT EXISTS public.task_attachments AS
 SELECT task_images.id,
    task_images.task_id,
    task_images.file_name,
    task_images.file_url AS file_path,
    task_images.file_size,
    task_images.file_type,
    COALESCE(task_images.attachment_type, task_images.image_type, 'task_creation'::text) AS attachment_type,
    task_images.uploaded_by,
    task_images.uploaded_by_name,
    task_images.created_at
   FROM public.task_images;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: VIEW;

Schema: public;

--

CREATE VIEW IF NOT EXISTS public.task_completion_summary AS
 SELECT tc.id AS completion_id,
    tc.task_id,
    t.title AS task_title,
    t.priority AS task_priority,
    tc.assignment_id,
    tc.completed_by,
    tc.completed_by_name,
    tc.completed_by_branch_id,
    b.name_en AS branch_name,
    tc.task_finished_completed,
    tc.photo_uploaded_completed,
    tc.completion_photo_url,
    tc.erp_reference_completed,
    tc.erp_reference_number,
    tc.completion_notes,
    tc.verified_by,
    tc.verified_at,
    tc.verification_notes,
    tc.completed_at,
    round((((((
        CASE
            WHEN tc.task_finished_completed THEN 1
            ELSE 0
        END +
        CASE
            WHEN tc.photo_uploaded_completed THEN 1
            ELSE 0
        END) +
        CASE
            WHEN tc.erp_reference_completed THEN 1
            ELSE 0
        END))::numeric * 100.0) / (3)::numeric), 2) AS completion_percentage,
    ((tc.task_finished_completed = true) AND (tc.photo_uploaded_completed = true) AND (tc.erp_reference_completed = true)) AS is_fully_completed
   FROM ((public.task_completions tc
     JOIN public.tasks t ON ((tc.task_id = t.id)))
     LEFT JOIN public.branches b ON (((tc.completed_by_branch_id)::text = (b.id)::text)))
  ORDER BY tc.completed_at DESC;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: VIEW;

Schema: public;

--

CREATE VIEW IF NOT EXISTS public.user_management_view AS
 SELECT u.id,
    u.username,
    u.status,
    u.is_master_admin,
    u.is_admin,
    u.branch_id,
    u.employee_id,
    u.position_id,
    u.created_at,
    u.updated_at,
    u.failed_login_attempts,
    u.is_first_login,
    u.last_login_at,
    e.name AS employee_name,
    b.name_en AS branch_name,
    p.position_title_en,
    p.position_title_ar
   FROM (((public.users u
     LEFT JOIN public.hr_employees e ON ((u.employee_id = e.id)))
     LEFT JOIN public.branches b ON ((u.branch_id = b.id)))
     LEFT JOIN public.hr_positions p ON ((u.position_id = p.id)));

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: VIEW;

Schema: public;

--

CREATE VIEW IF NOT EXISTS public.user_permissions_view AS
 SELECT bp.user_id,
    u.username,
    sb.button_code AS function_code,
    sb.button_name_en AS function_name,
    bp.is_enabled AS can_view,
    bp.is_enabled AS can_add,
    bp.is_enabled AS can_edit,
    bp.is_enabled AS can_delete,
    bp.is_enabled AS can_export
   FROM ((public.button_permissions bp
     JOIN public.users u ON ((bp.user_id = u.id)))
     JOIN public.sidebar_buttons sb ON ((bp.button_id = sb.id)))
  WHERE (bp.is_enabled = true);

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: SEQUENCE OWNED BY;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

ALTER TABLE ONLY public.wa_broadcast_recipients REPLICA IDENTITY FULL;

Type: TABLE;

Schema: public;

ALTER TABLE ONLY public.wa_broadcasts REPLICA IDENTITY FULL;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: SEQUENCE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: TABLE;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: DEFAULT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: CONSTRAINT;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

--

CREATE UNIQUE INDEX idx_mv_expiry_unique ON public.mv_expiry_products USING btree (barcode, branch_id, expiry_date);

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

--

CREATE UNIQUE INDEX idx_payments_party_period ON public.lease_rent_payments USING btree (party_type, party_id, period_num);

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

--

CREATE UNIQUE INDEX idx_users_quick_access ON public.users USING btree (quick_access_code);

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

Type: INDEX;

Schema: public;

--

CREATE UNIQUE INDEX uq_products_barcode ON public.products USING btree (barcode);

Type: INDEX;

Schema: public;

--

CREATE UNIQUE INDEX ux_delivery_tiers_scope_order ON public.delivery_fee_tiers USING btree (COALESCE(branch_id, ('-1'::integer)::bigint), tier_order);

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: TRIGGER;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: COMMENT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: FK CONSTRAINT;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY "Admins can manage all fine payments" ON public.employee_fine_payments USING ((EXISTS ( SELECT 1
   FROM public.users u
  WHERE ((u.id = auth.uid()) AND (u.user_type = 'global'::public.user_type_enum)))));

Type: POLICY;

Schema: public;

--

CREATE POLICY "Admins can view all device sessions" ON public.user_device_sessions FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.user_type = 'global'::public.user_type_enum)))));

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow admin users to delete parent categories" ON public.expense_parent_categories FOR DELETE TO authenticated USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow admin users to delete sub categories" ON public.expense_sub_categories FOR DELETE TO authenticated USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow admin users to insert parent categories" ON public.expense_parent_categories FOR INSERT TO authenticated WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow admin users to insert sub categories" ON public.expense_sub_categories FOR INSERT TO authenticated WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow admin users to update parent categories" ON public.expense_parent_categories FOR UPDATE TO authenticated USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow admin users to update sub categories" ON public.expense_sub_categories FOR UPDATE TO authenticated USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to ai_chat_guide" ON public.ai_chat_guide USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to approval_permissions" ON public.approval_permissions USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to approver_branch_access" ON public.approver_branch_access USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to approver_visibility_config" ON public.approver_visibility_config USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to asset_main_categories" ON public.asset_main_categories USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to asset_sub_categories" ON public.asset_sub_categories USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to assets" ON public.assets USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to bank_reconciliations" ON public.bank_reconciliations USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to branch_default_delivery_receivers" ON public.branch_default_delivery_receivers USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to branch_default_positions" ON public.branch_default_positions USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to break_reasons" ON public.break_reasons USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to break_register" ON public.break_register USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to customer_product_requests" ON public.customer_product_requests USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to day_off_reasons" ON public.day_off_reasons USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to default_incident_users" ON public.default_incident_users USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to denomination_transactions" ON public.denomination_transactions USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to desktop_themes" ON public.desktop_themes USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to employee_checklist_assignments" ON public.employee_checklist_assignments USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to erp_synced_products" ON public.erp_synced_products USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to hr_analysed_attendance_data" ON public.hr_analysed_attendance_data USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to hr_basic_salary" ON public.hr_basic_salary USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to hr_checklist_operations" ON public.hr_checklist_operations USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to hr_checklist_questions" ON public.hr_checklist_questions USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to hr_checklists" ON public.hr_checklists USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to hr_employee_master" ON public.hr_employee_master USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to hr_insurance_companies" ON public.hr_insurance_companies USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to incident_actions" ON public.incident_actions USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to incident_types" ON public.incident_types USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to incidents" ON public.incidents USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to lease_rent_lease_parties" ON public.lease_rent_lease_parties USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to lease_rent_payments" ON public.lease_rent_payments USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to lease_rent_properties" ON public.lease_rent_properties USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to lease_rent_property_spaces" ON public.lease_rent_property_spaces USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to lease_rent_rent_parties" ON public.lease_rent_rent_parties USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to mobile_themes" ON public.mobile_themes USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to multi_shift_date_wise" ON public.multi_shift_date_wise USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to multi_shift_regular" ON public.multi_shift_regular USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to multi_shift_weekday" ON public.multi_shift_weekday USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to nationalities" ON public.nationalities USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to near_expiry_reports" ON public.near_expiry_reports USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to offer_names" ON public.offer_names USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to pos_deduction_transfers" ON public.pos_deduction_transfers USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to processed_fingerprint_transactions" ON public.processed_fingerprint_transactions USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to product_categories" ON public.product_categories USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to product_request_bt" ON public.product_request_bt USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to product_request_po" ON public.product_request_po USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to product_request_st" ON public.product_request_st USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to product_units" ON public.product_units USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to push_subscriptions" ON public.push_subscriptions USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to receiving_user_defaults" ON public.receiving_user_defaults USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to regular_shift" ON public.regular_shift USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to shelf_paper_fonts" ON public.shelf_paper_fonts USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to user_favorite_buttons" ON public.user_favorite_buttons USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to user_mobile_theme_assignments" ON public.user_mobile_theme_assignments USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to user_theme_assignments" ON public.user_theme_assignments USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to user_voice_preferences" ON public.user_voice_preferences USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to wa_accounts" ON public.wa_accounts USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to wa_broadcast_recipients" ON public.wa_broadcast_recipients USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to wa_broadcasts" ON public.wa_broadcasts USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to wa_conversations" ON public.wa_conversations USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to wa_templates" ON public.wa_templates USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to warning_main_category" ON public.warning_main_category USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to warning_sub_category" ON public.warning_sub_category USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all access to warning_violation" ON public.warning_violation USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all operations for authenticated users" ON public.user_voice_preferences TO authenticated USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all operations on day_off" ON public.day_off USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all operations on day_off_weekday" ON public.day_off_weekday USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all operations on employee_official_holidays" ON public.employee_official_holidays USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all operations on official_holidays" ON public.official_holidays USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all operations on special_shift_date_wise" ON public.special_shift_date_wise USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all to view approval permissions" ON public.approval_permissions FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all users to view hr_employee_master table" ON public.hr_employee_master FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow all users to view users table" ON public.users FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert approval_permissions" ON public.approval_permissions FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert biometric_connections" ON public.biometric_connections FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert bogo_offer_rules" ON public.bogo_offer_rules FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert coupon_campaigns" ON public.coupon_campaigns FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert coupon_claims" ON public.coupon_claims FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert coupon_eligible_customers" ON public.coupon_eligible_customers FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert coupon_products" ON public.coupon_products FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert customer_access_code_history" ON public.customer_access_code_history FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert customer_app_media" ON public.customer_app_media FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert customer_recovery_requests" ON public.customer_recovery_requests FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert customers" ON public.customers FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert deleted_bundle_offers" ON public.deleted_bundle_offers FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert delivery_fee_tiers" ON public.delivery_fee_tiers FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert delivery_service_settings" ON public.delivery_service_settings FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert employee_fine_payments" ON public.employee_fine_payments FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert erp_connections" ON public.erp_connections FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert erp_daily_sales" ON public.erp_daily_sales FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert expense_parent_categories" ON public.expense_parent_categories FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert expense_requisitions" ON public.expense_requisitions FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert expense_scheduler" ON public.expense_scheduler FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert expense_sub_categories" ON public.expense_sub_categories FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert flyer_offer_products" ON public.flyer_offer_products FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert flyer_offers" ON public.flyer_offers FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert flyer_templates" ON public.flyer_templates FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert hr_departments" ON public.hr_departments FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert hr_employee_master" ON public.hr_employee_master FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert hr_employees" ON public.hr_employees FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert hr_fingerprint_transactions" ON public.hr_fingerprint_transactions FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert hr_levels" ON public.hr_levels FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert hr_position_assignments" ON public.hr_position_assignments FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert hr_position_reporting_template" ON public.hr_position_reporting_template FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert hr_positions" ON public.hr_positions FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert interface_permissions" ON public.interface_permissions FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert non_approved_payment_scheduler" ON public.non_approved_payment_scheduler FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert notification_attachments" ON public.notification_attachments FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert notification_read_states" ON public.notification_read_states FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert notification_recipients" ON public.notification_recipients FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert notifications" ON public.notifications FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert offer_bundles" ON public.offer_bundles FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert offer_cart_tiers" ON public.offer_cart_tiers FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert offer_products" ON public.offer_products FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert offer_usage_logs" ON public.offer_usage_logs FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert order_audit_logs" ON public.order_audit_logs FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert order_items" ON public.order_items FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert orders" ON public.orders FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert privilege_cards_branch" ON public.privilege_cards_branch FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert privilege_cards_master" ON public.privilege_cards_master FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert quick_task_assignments" ON public.quick_task_assignments FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert quick_task_comments" ON public.quick_task_comments FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert quick_task_completions" ON public.quick_task_completions FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert quick_task_files" ON public.quick_task_files FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert quick_task_user_preferences" ON public.quick_task_user_preferences FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert quick_tasks" ON public.quick_tasks FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert receiving_task_templates" ON public.receiving_task_templates FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert receiving_tasks" ON public.receiving_tasks FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert recurring_assignment_schedules" ON public.recurring_assignment_schedules FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert recurring_schedule_check_log" ON public.recurring_schedule_check_log FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert requesters" ON public.requesters FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert shelf_paper_templates" ON public.shelf_paper_templates FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert task_assignments" ON public.task_assignments FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert task_completions" ON public.task_completions FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert task_images" ON public.task_images FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert task_reminder_logs" ON public.task_reminder_logs FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert tasks" ON public.tasks FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert user_audit_logs" ON public.user_audit_logs FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert user_device_sessions" ON public.user_device_sessions FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert user_password_history" ON public.user_password_history FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert user_sessions" ON public.user_sessions FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert users" ON public.users FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert variation_audit_log" ON public.variation_audit_log FOR INSERT TO anon WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon insert view_offer" ON public.view_offer FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow anon read" ON public.security_code_scroll_texts FOR SELECT TO anon USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated delete" ON public.security_code_scroll_texts FOR DELETE TO authenticated USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated full access on wa_catalog_orders" ON public.wa_catalog_orders TO authenticated USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated full access on wa_catalog_products" ON public.wa_catalog_products TO authenticated USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated full access on wa_catalogs" ON public.wa_catalogs TO authenticated USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated insert" ON public.security_code_scroll_texts FOR INSERT TO authenticated WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated read" ON public.security_code_scroll_texts FOR SELECT TO authenticated USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated update" ON public.security_code_scroll_texts FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to archive offers" ON public.deleted_bundle_offers FOR INSERT TO authenticated WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to create ERP connections" ON public.erp_connections FOR INSERT TO authenticated WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to create expense requisitions" ON public.expense_requisitions FOR INSERT TO authenticated WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to create expense scheduler" ON public.expense_scheduler FOR INSERT TO authenticated WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to create non approved scheduler" ON public.non_approved_payment_scheduler FOR INSERT TO authenticated WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to create privilege_cards_branch" ON public.privilege_cards_branch FOR INSERT TO authenticated WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to create privilege_cards_master" ON public.privilege_cards_master FOR INSERT TO authenticated WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to create view_offer" ON public.view_offer FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to delete ERP connections" ON public.erp_connections FOR DELETE TO authenticated USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to delete requisitions" ON public.expense_requisitions FOR DELETE TO authenticated USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to insert requisitions" ON public.expense_requisitions FOR INSERT TO authenticated WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to read ERP connections" ON public.erp_connections FOR SELECT TO authenticated USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to read expense requisitions" ON public.expense_requisitions FOR SELECT TO authenticated USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to read expense scheduler" ON public.expense_scheduler FOR SELECT TO authenticated USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to read non approved scheduler" ON public.non_approved_payment_scheduler FOR SELECT TO authenticated USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to read parent categories" ON public.expense_parent_categories FOR SELECT TO authenticated USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to read privilege_cards_branch" ON public.privilege_cards_branch FOR SELECT TO authenticated USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to read privilege_cards_master" ON public.privilege_cards_master FOR SELECT TO authenticated USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to read requisitions" ON public.expense_requisitions FOR SELECT TO authenticated USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to read sales data" ON public.erp_daily_sales FOR SELECT TO authenticated USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to read sub categories" ON public.expense_sub_categories FOR SELECT TO authenticated USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to read view_offer" ON public.view_offer FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to update ERP connections" ON public.erp_connections FOR UPDATE TO authenticated USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to update expense requisitions" ON public.expense_requisitions FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to update expense scheduler" ON public.expense_scheduler FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to update non approved scheduler" ON public.non_approved_payment_scheduler FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to update privilege_cards_branch" ON public.privilege_cards_branch FOR UPDATE TO authenticated USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to update privilege_cards_master" ON public.privilege_cards_master FOR UPDATE TO authenticated USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to update requisitions" ON public.expense_requisitions FOR UPDATE TO authenticated USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to update view_offer" ON public.view_offer FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow authenticated users to view deleted offers" ON public.deleted_bundle_offers FOR SELECT TO authenticated USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow read access to bogo_offer_rules" ON public.bogo_offer_rules FOR SELECT TO authenticated USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow service role full access to bogo_offer_rules" ON public.bogo_offer_rules TO service_role USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow service role full access to hr_employee_master" ON public.hr_employee_master TO authenticated USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow service role full access to quick_task_assignments" ON public.quick_task_assignments TO authenticated USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow service role full access to quick_task_completions" ON public.quick_task_completions TO authenticated USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow service role full access to quick_tasks" ON public.quick_tasks TO authenticated USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow service role full access to task_assignments" ON public.task_assignments TO authenticated USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow service role full access to task_completions" ON public.task_completions TO authenticated USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow service role full access to tasks" ON public.tasks TO authenticated USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow service role full access to users" ON public.users TO authenticated USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Allow service role to manage sales data" ON public.erp_daily_sales TO service_role USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Anyone can view app icons" ON public.app_icons FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Authenticated users can delete app icons" ON public.app_icons FOR DELETE TO authenticated USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Authenticated users can insert app icons" ON public.app_icons FOR INSERT TO authenticated WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Authenticated users can insert frontend_builds" ON public.frontend_builds FOR INSERT TO authenticated WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Authenticated users can manage offer products" ON public.offer_products TO authenticated USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Authenticated users can read frontend_builds" ON public.frontend_builds FOR SELECT TO authenticated USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Authenticated users can update app icons" ON public.app_icons FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Authenticated users can view all reminder logs" ON public.task_reminder_logs FOR SELECT USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY "Emergency: Allow all inserts for notifications" ON public.notifications FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Emergency: Allow all inserts for task_assignments" ON public.task_assignments FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Emergency: Allow all inserts for tasks" ON public.tasks FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Enable all access for social_links" ON public.social_links USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Enable all access for view_offer" ON public.view_offer USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Enable all access to system_api_keys" ON public.system_api_keys USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Enable delete for authenticated users" ON public.biometric_connections FOR DELETE USING ((auth.role() = 'authenticated'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY "Enable insert for authenticated users" ON public.biometric_connections FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY "Enable read for authenticated users" ON public.biometric_connections FOR SELECT USING ((auth.role() = 'authenticated'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY "Enable update for authenticated users" ON public.biometric_connections FOR UPDATE USING ((auth.role() = 'authenticated'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY "Managers can verify completions" ON public.quick_task_completions FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.user_type = 'global'::public.user_type_enum)))));

Type: POLICY;

Schema: public;

--

CREATE POLICY "Managers can view all completions" ON public.quick_task_completions FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.user_type = 'global'::public.user_type_enum)))));

Type: POLICY;

Schema: public;

--

CREATE POLICY "Only global users can view check logs" ON public.recurring_schedule_check_log FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.user_type = 'global'::public.user_type_enum)))));

Type: POLICY;

Schema: public;

--

CREATE POLICY "Public can view active offer products" ON public.offer_products FOR SELECT USING ((offer_id IN ( SELECT offers.id
   FROM public.offers
  WHERE ((offers.is_active = true) AND (offers.start_date <= now()) AND (offers.end_date >= now())))));

Type: POLICY;

Schema: public;

--

CREATE POLICY "Service role can insert reminder logs" ON public.task_reminder_logs FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Service role full access on erp_sync_logs" ON public.erp_sync_logs USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Service role full access on wa_ai_bot_config" ON public.wa_ai_bot_config USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Service role full access on wa_auto_reply_triggers" ON public.wa_auto_reply_triggers USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Service role full access on wa_contact_group_members" ON public.wa_contact_group_members USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Service role full access on wa_contact_groups" ON public.wa_contact_groups USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Service role full access on wa_messages" ON public.wa_messages USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Service role full access on wa_settings" ON public.wa_settings USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Service role full access on whatsapp_message_log" ON public.whatsapp_message_log USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Service role full access to frontend_builds" ON public.frontend_builds TO service_role USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Service role has full access to expense requisitions" ON public.expense_requisitions TO service_role USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Service role has full access to expense scheduler" ON public.expense_scheduler TO service_role USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Service role has full access to non approved scheduler" ON public.non_approved_payment_scheduler TO service_role USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Service role has full access to privilege_cards_branch" ON public.privilege_cards_branch TO service_role USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Service role has full access to privilege_cards_master" ON public.privilege_cards_master TO service_role USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Service role has full access to view_offer" ON public.view_offer USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Simple create task assignments policy" ON public.task_assignments FOR INSERT WITH CHECK (true);

Type: COMMENT;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY "Simple create task completions policy" ON public.task_completions FOR INSERT WITH CHECK (true);

Type: COMMENT;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY "Simple create task images policy" ON public.task_images FOR INSERT WITH CHECK (true);

Type: COMMENT;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY "Simple create tasks policy" ON public.tasks FOR INSERT WITH CHECK (true);

Type: COMMENT;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY "Simple delete task images policy" ON public.task_images FOR DELETE USING (true);

Type: COMMENT;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY "Simple update task assignments policy" ON public.task_assignments FOR UPDATE USING (true);

Type: COMMENT;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY "Simple update task completions policy" ON public.task_completions FOR UPDATE USING (true);

Type: COMMENT;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY "Simple update task images policy" ON public.task_images FOR UPDATE USING (true);

Type: COMMENT;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY "Simple update tasks policy" ON public.tasks FOR UPDATE USING (true);

Type: COMMENT;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY "Simple view task assignments policy" ON public.task_assignments FOR SELECT USING (true);

Type: COMMENT;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY "Simple view task completions policy" ON public.task_completions FOR SELECT USING (true);

Type: COMMENT;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY "Simple view task images policy" ON public.task_images FOR SELECT USING (true);

Type: COMMENT;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY "Simple view tasks policy" ON public.tasks FOR SELECT USING ((deleted_at IS NULL));

Type: COMMENT;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY "System can insert variation audit logs" ON public.variation_audit_log FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Users can create templates" ON public.shelf_paper_templates FOR INSERT WITH CHECK ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY "Users can delete offer products" ON public.offer_products FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Users can delete own templates" ON public.shelf_paper_templates FOR DELETE USING ((created_by = auth.uid()));

Type: POLICY;

Schema: public;

--

CREATE POLICY "Users can delete their own preferences" ON public.quick_task_user_preferences FOR DELETE USING ((auth.uid() = user_id));

Type: POLICY;

Schema: public;

--

CREATE POLICY "Users can insert offer products" ON public.offer_products FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Users can insert own read states" ON public.notification_read_states FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Users can insert requesters" ON public.requesters FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Users can insert their own completions" ON public.quick_task_completions FOR INSERT WITH CHECK ((completed_by_user_id = auth.uid()));

Type: POLICY;

Schema: public;

--

CREATE POLICY "Users can insert their own preferences" ON public.quick_task_user_preferences FOR INSERT WITH CHECK ((auth.uid() = user_id));

Type: POLICY;

Schema: public;

--

CREATE POLICY "Users can manage their own device sessions" ON public.user_device_sessions USING ((user_id = auth.uid()));

Type: POLICY;

Schema: public;

--

CREATE POLICY "Users can update offer products" ON public.offer_products FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Users can update own read states" ON public.notification_read_states FOR UPDATE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Users can update own templates" ON public.shelf_paper_templates FOR UPDATE USING ((created_by = auth.uid()));

Type: POLICY;

Schema: public;

--

CREATE POLICY "Users can update requesters" ON public.requesters FOR UPDATE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Users can update their own completions" ON public.quick_task_completions FOR UPDATE USING ((completed_by_user_id = auth.uid()));

Type: POLICY;

Schema: public;

--

CREATE POLICY "Users can update their own preferences" ON public.quick_task_user_preferences FOR UPDATE USING ((auth.uid() = user_id)) WITH CHECK ((auth.uid() = user_id));

Type: POLICY;

Schema: public;

--

CREATE POLICY "Users can view active flyer templates" ON public.flyer_templates FOR SELECT TO authenticated USING (((is_active = true) AND (deleted_at IS NULL)));

Type: POLICY;

Schema: public;

--

CREATE POLICY "Users can view active templates" ON public.shelf_paper_templates FOR SELECT USING ((is_active = true));

Type: POLICY;

Schema: public;

--

CREATE POLICY "Users can view all requesters" ON public.requesters FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Users can view offer products" ON public.offer_products FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Users can view own read states" ON public.notification_read_states FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY "Users can view their own completions" ON public.quick_task_completions FOR SELECT USING ((completed_by_user_id = auth.uid()));

Type: POLICY;

Schema: public;

--

CREATE POLICY "Users can view their own preferences" ON public.quick_task_user_preferences FOR SELECT USING ((auth.uid() = user_id));

Type: POLICY;

Schema: public;

--

CREATE POLICY "Users can view their own reminder logs" ON public.task_reminder_logs FOR SELECT USING ((assigned_to_user_id = auth.uid()));

Type: POLICY;

Schema: public;

--

CREATE POLICY "Users can view variation audit logs" ON public.variation_audit_log FOR SELECT USING (true);

Type: ROW SECURITY;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY admin_all_offer_cart_tiers ON public.offer_cart_tiers USING (true) WITH CHECK (true);

Type: ROW SECURITY;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_lease_rent_special_changes ON public.lease_rent_special_changes USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.approval_permissions USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.biometric_connections USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.bogo_offer_rules USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.coupon_campaigns USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.coupon_claims USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.coupon_eligible_customers USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.coupon_products USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.customer_access_code_history USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.customer_app_media USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.customer_recovery_requests USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.customers USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.deleted_bundle_offers USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.delivery_fee_tiers USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.delivery_service_settings USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.employee_fine_payments USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.erp_connections USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.erp_daily_sales USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.expense_parent_categories USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.expense_requisitions USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.expense_scheduler USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.expense_sub_categories USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.flyer_offer_products USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.flyer_offers USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.flyer_templates USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.hr_departments USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.hr_employees USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.hr_fingerprint_transactions USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.hr_levels USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.hr_position_assignments USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.hr_position_reporting_template USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.hr_positions USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.interface_permissions USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.non_approved_payment_scheduler USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.notification_attachments USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.notification_read_states USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.notification_recipients USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.notifications USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.offer_bundles USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.offer_cart_tiers USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.offer_products USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.offer_usage_logs USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.order_audit_logs USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.order_items USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.orders USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.privilege_cards_branch USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.privilege_cards_master USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.quick_task_assignments USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.quick_task_comments USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.quick_task_completions USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.quick_task_files USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.quick_task_user_preferences USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.quick_tasks USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.receiving_task_templates USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.receiving_tasks USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.recurring_assignment_schedules USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.recurring_schedule_check_log USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.requesters USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.shelf_paper_templates USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.task_assignments USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.task_completions USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.task_images USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.task_reminder_logs USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.tasks USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.user_audit_logs USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.user_device_sessions USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.user_password_history USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.user_sessions USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.users USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.variation_audit_log USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_operations ON public.view_offer USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_payment_entries ON public.lease_rent_payment_entries USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_wa_auto_reply ON public.wa_auto_reply_triggers USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_wa_bot_flows ON public.wa_bot_flows USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_all_wa_settings ON public.wa_settings USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.approval_permissions FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.biometric_connections FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.bogo_offer_rules FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.branches FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.button_main_sections FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.button_permissions FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.button_sub_sections FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.coupon_campaigns FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.coupon_claims FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.coupon_eligible_customers FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.coupon_products FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.customer_access_code_history FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.customer_app_media FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.customer_recovery_requests FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.customers FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.deleted_bundle_offers FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.delivery_fee_tiers FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.delivery_service_settings FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.employee_fine_payments FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.erp_connections FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.erp_daily_sales FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.expense_parent_categories FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.expense_requisitions FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.expense_scheduler FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.expense_sub_categories FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.flyer_offer_products FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.flyer_offers FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.flyer_templates FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.hr_departments FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.hr_employees FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.hr_fingerprint_transactions FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.hr_levels FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.hr_position_assignments FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.hr_position_reporting_template FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.hr_positions FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.interface_permissions FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.non_approved_payment_scheduler FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.notification_attachments FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.notification_read_states FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.notification_recipients FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.notifications FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.offer_bundles FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.offer_cart_tiers FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.offer_products FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.offer_usage_logs FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.order_audit_logs FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.order_items FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.orders FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.privilege_cards_branch FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.privilege_cards_master FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.quick_task_assignments FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.quick_task_comments FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.quick_task_completions FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.quick_task_files FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.quick_task_user_preferences FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.quick_tasks FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.receiving_records FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.receiving_task_templates FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.receiving_tasks FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.recurring_assignment_schedules FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.recurring_schedule_check_log FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.requesters FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.shelf_paper_templates FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.sidebar_buttons FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.task_assignments FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.task_completions FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.task_images FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.task_reminder_logs FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.tasks FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.user_audit_logs FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.user_device_sessions FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.user_password_history FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.user_sessions FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.users FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.variation_audit_log FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.vendors FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete ON public.view_offer FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete_all ON public.products FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_delete_offers ON public.offers FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.approval_permissions FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.biometric_connections FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.bogo_offer_rules FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.branches FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.button_main_sections FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.button_permissions FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.button_sub_sections FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.coupon_campaigns FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.coupon_claims FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.coupon_eligible_customers FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.coupon_products FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.customer_access_code_history FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.customer_app_media FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.customer_recovery_requests FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.customers FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.deleted_bundle_offers FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.delivery_fee_tiers FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.delivery_service_settings FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.employee_fine_payments FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.erp_connections FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.erp_daily_sales FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.expense_parent_categories FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.expense_requisitions FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.expense_scheduler FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.expense_sub_categories FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.flyer_offer_products FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.flyer_offers FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.flyer_templates FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.hr_departments FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.hr_employees FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.hr_fingerprint_transactions FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.hr_levels FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.hr_position_assignments FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.hr_position_reporting_template FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.hr_positions FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.interface_permissions FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.non_approved_payment_scheduler FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.notification_attachments FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.notification_read_states FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.notification_recipients FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.notifications FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.offer_bundles FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.offer_cart_tiers FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.offer_products FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.offer_usage_logs FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.order_audit_logs FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.order_items FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.orders FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.privilege_cards_branch FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.privilege_cards_master FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.quick_task_assignments FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.quick_task_comments FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.quick_task_completions FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.quick_task_files FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.quick_task_user_preferences FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.quick_tasks FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.receiving_records FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.receiving_task_templates FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.receiving_tasks FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.recurring_assignment_schedules FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.recurring_schedule_check_log FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.requesters FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.shelf_paper_templates FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.sidebar_buttons FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.task_assignments FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.task_completions FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.task_images FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.task_reminder_logs FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.tasks FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.user_audit_logs FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.user_device_sessions FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.user_password_history FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.user_sessions FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.users FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.variation_audit_log FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.vendors FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert ON public.view_offer FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert_all ON public.products FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert_offers ON public.offers FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_insert_order_items ON public.order_items FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_public_read_bogo ON public.bogo_offer_rules FOR SELECT TO authenticated, anon USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_public_read_bundles ON public.offer_bundles FOR SELECT TO authenticated, anon USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.approval_permissions FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.biometric_connections FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.bogo_offer_rules FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.branches FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.button_main_sections FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.button_permissions FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.button_sub_sections FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.coupon_campaigns FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.coupon_claims FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.coupon_eligible_customers FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.coupon_products FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.customer_access_code_history FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.customer_app_media FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.customer_recovery_requests FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.customers FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.deleted_bundle_offers FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.delivery_fee_tiers FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.delivery_service_settings FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.employee_fine_payments FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.erp_connections FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.erp_daily_sales FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.expense_parent_categories FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.expense_requisitions FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.expense_scheduler FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.expense_sub_categories FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.flyer_offer_products FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.flyer_offers FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.flyer_templates FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.hr_departments FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.hr_employees FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.hr_fingerprint_transactions FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.hr_levels FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.hr_position_assignments FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.hr_position_reporting_template FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.hr_positions FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.interface_permissions FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.non_approved_payment_scheduler FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.notification_attachments FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.notification_read_states FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.notification_recipients FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.notifications FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.offer_bundles FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.offer_cart_tiers FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.offer_products FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.offer_usage_logs FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.order_audit_logs FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.order_items FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.orders FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.privilege_cards_branch FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.privilege_cards_master FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.quick_task_assignments FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.quick_task_comments FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.quick_task_completions FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.quick_task_files FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.quick_task_user_preferences FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.quick_tasks FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.receiving_records FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.receiving_task_templates FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.receiving_tasks FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.recurring_assignment_schedules FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.recurring_schedule_check_log FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.requesters FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.shelf_paper_templates FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.sidebar_buttons FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.task_assignments FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.task_completions FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.task_images FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.task_reminder_logs FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.tasks FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.user_audit_logs FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.user_device_sessions FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.user_password_history FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.user_sessions FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.users FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.variation_audit_log FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.vendors FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select ON public.view_offer FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select_all ON public.products FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_select_offers ON public.offers FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.approval_permissions FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.biometric_connections FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.bogo_offer_rules FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.branches FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.button_main_sections FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.button_permissions FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.button_sub_sections FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.coupon_campaigns FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.coupon_claims FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.coupon_eligible_customers FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.coupon_products FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.customer_access_code_history FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.customer_app_media FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.customer_recovery_requests FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.customers FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.deleted_bundle_offers FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.delivery_fee_tiers FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.delivery_service_settings FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.employee_fine_payments FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.erp_connections FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.erp_daily_sales FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.expense_parent_categories FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.expense_requisitions FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.expense_scheduler FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.expense_sub_categories FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.flyer_offer_products FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.flyer_offers FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.flyer_templates FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.hr_departments FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.hr_employees FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.hr_fingerprint_transactions FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.hr_levels FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.hr_position_assignments FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.hr_position_reporting_template FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.hr_positions FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.interface_permissions FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.non_approved_payment_scheduler FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.notification_attachments FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.notification_read_states FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.notification_recipients FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.notifications FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.offer_bundles FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.offer_cart_tiers FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.offer_products FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.offer_usage_logs FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.order_audit_logs FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.order_items FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.orders FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.privilege_cards_branch FOR UPDATE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.privilege_cards_master FOR UPDATE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.quick_task_assignments FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.quick_task_comments FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.quick_task_completions FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.quick_task_files FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.quick_task_user_preferences FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.quick_tasks FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.receiving_records FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.receiving_task_templates FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.receiving_tasks FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.recurring_assignment_schedules FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.recurring_schedule_check_log FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.requesters FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.shelf_paper_templates FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.sidebar_buttons FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.task_assignments FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.task_completions FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.task_images FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.task_reminder_logs FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.tasks FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.user_audit_logs FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.user_device_sessions FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.user_password_history FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.user_sessions FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.users FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.variation_audit_log FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.vendors FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update ON public.view_offer FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update_all ON public.products FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY allow_update_offers ON public.offers FOR UPDATE USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.approval_permissions USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.biometric_connections USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.bogo_offer_rules USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.coupon_campaigns USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.coupon_claims USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.coupon_eligible_customers USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.coupon_products USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.customer_access_code_history USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.customer_app_media USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.customer_recovery_requests USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.customers USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.deleted_bundle_offers USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.delivery_fee_tiers USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.delivery_service_settings USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.employee_fine_payments USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.erp_connections USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.erp_daily_sales USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.expense_parent_categories USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.expense_requisitions USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.expense_scheduler USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.expense_sub_categories USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.flyer_offer_products USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.flyer_offers USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.flyer_templates USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.hr_departments USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.hr_employee_master FOR SELECT USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.hr_employees USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.hr_fingerprint_transactions USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.hr_levels USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.hr_position_assignments USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.hr_position_reporting_template USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.hr_positions USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.interface_permissions USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.non_approved_payment_scheduler USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.notification_attachments USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.notification_read_states USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.notification_recipients USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.notifications USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.offer_bundles USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.offer_cart_tiers USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.offer_products USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.offer_usage_logs USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.order_audit_logs USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.order_items USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.orders USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.privilege_cards_branch USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.privilege_cards_master USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.quick_task_assignments USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.quick_task_comments USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.quick_task_completions USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.quick_task_files USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.quick_task_user_preferences USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.quick_tasks USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.receiving_task_templates USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.receiving_tasks USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.recurring_assignment_schedules USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.recurring_schedule_check_log USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.requesters USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.shelf_paper_templates USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.task_assignments USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.task_completions USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.task_images USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.task_reminder_logs USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.tasks USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.user_audit_logs USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.user_device_sessions USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.user_password_history USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.user_sessions USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.users USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.variation_audit_log USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_full_access ON public.view_offer USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));

Type: POLICY;

Schema: public;

--

CREATE POLICY anon_insert ON public.access_code_otp FOR INSERT TO anon WITH CHECK (true);

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_check_eligibility ON public.coupon_eligible_customers FOR SELECT TO authenticated USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_create_claims ON public.coupon_claims FOR INSERT TO authenticated WITH CHECK ((claimed_by_user = auth.uid()));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.approval_permissions USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.biometric_connections USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.bogo_offer_rules USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.coupon_campaigns USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.coupon_claims USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.coupon_eligible_customers USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.coupon_products USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.customer_access_code_history USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.customer_app_media USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.customer_recovery_requests USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.customers USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.deleted_bundle_offers USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.delivery_fee_tiers USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.delivery_service_settings USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.employee_fine_payments USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.erp_connections USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.erp_daily_sales USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.expense_parent_categories USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.expense_requisitions USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.expense_scheduler USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.expense_sub_categories USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.flyer_offer_products USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.flyer_offers USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.flyer_templates USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.hr_departments USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.hr_employee_master FOR SELECT USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.hr_employees USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.hr_fingerprint_transactions USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.hr_levels USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.hr_position_assignments USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.hr_position_reporting_template USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.hr_positions USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.interface_permissions USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.non_approved_payment_scheduler USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.notification_attachments USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.notification_read_states USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.notification_recipients USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.notifications USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.offer_bundles USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.offer_cart_tiers USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.offer_products USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.offer_usage_logs USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.order_audit_logs USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.order_items USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.orders USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.privilege_cards_branch USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.privilege_cards_master USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.quick_task_assignments USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.quick_task_comments USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.quick_task_completions USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.quick_task_files USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.quick_task_user_preferences USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.quick_tasks USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.receiving_task_templates USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.receiving_tasks USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.recurring_assignment_schedules USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.recurring_schedule_check_log USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.requesters USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.shelf_paper_templates USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.task_assignments USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.task_completions USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.task_images USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.task_reminder_logs USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.tasks USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.user_audit_logs USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.user_device_sessions USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.user_password_history USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.user_sessions USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.users USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.variation_audit_log USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_full_access ON public.view_offer USING ((auth.uid() IS NOT NULL));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_view_active_campaigns ON public.coupon_campaigns FOR SELECT TO authenticated USING (((is_active = true) AND (deleted_at IS NULL)));

Type: POLICY;

Schema: public;

--

CREATE POLICY authenticated_view_active_products ON public.coupon_products FOR SELECT TO authenticated USING (((is_active = true) AND (deleted_at IS NULL)));

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY box_operations_delete ON public.box_operations FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY box_operations_insert ON public.box_operations FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY box_operations_select ON public.box_operations FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY box_operations_update ON public.box_operations FOR UPDATE USING (true);

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY branch_sync_config_modify ON public.branch_sync_config TO authenticated USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY branch_sync_config_select ON public.branch_sync_config FOR SELECT TO authenticated USING (true);

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY customer_access_code_history_insert_policy ON public.customer_access_code_history FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY customer_access_code_history_select_policy ON public.customer_access_code_history FOR SELECT USING (true);

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY customer_recovery_requests_delete_policy ON public.customer_recovery_requests FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY customer_recovery_requests_insert_policy ON public.customer_recovery_requests FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY customer_recovery_requests_select_policy ON public.customer_recovery_requests FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY customer_recovery_requests_update_policy ON public.customer_recovery_requests FOR UPDATE USING (true);

Type: ROW SECURITY;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY customers_create_orders ON public.orders FOR INSERT WITH CHECK ((auth.uid() = customer_id));

Type: POLICY;

Schema: public;

--

CREATE POLICY customers_delete_policy ON public.customers FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY customers_insert_policy ON public.customers FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY customers_select_policy ON public.customers FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY customers_update_policy ON public.customers FOR UPDATE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY customers_view_own_orders ON public.orders FOR SELECT USING (((auth.uid() = customer_id) OR public.has_order_management_access(auth.uid()) OR public.is_delivery_staff(auth.uid())));

Type: COMMENT;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY delivery_settings_allow_read ON public.delivery_service_settings FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY delivery_tiers_select_all ON public.delivery_fee_tiers FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY delivery_update_assigned_orders ON public.orders FOR UPDATE USING (((delivery_person_id = auth.uid()) OR public.is_delivery_staff(auth.uid()))) WITH CHECK ((((delivery_person_id = auth.uid()) OR public.is_delivery_staff(auth.uid())) AND ((order_status)::text = ANY (ARRAY[('out_for_delivery'::character varying)::text, ('delivered'::character varying)::text]))));

Type: POLICY;

Schema: public;

--

CREATE POLICY delivery_view_assigned_orders ON public.orders FOR SELECT USING (((delivery_person_id = auth.uid()) OR public.is_delivery_staff(auth.uid()) OR public.has_order_management_access(auth.uid())));

Type: COMMENT;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY denomination_audit_log_insert ON public.denomination_audit_log FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY denomination_audit_log_select ON public.denomination_audit_log FOR SELECT USING (true);

Type: ROW SECURITY;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY denomination_records_delete ON public.denomination_records FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY denomination_records_insert ON public.denomination_records FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY denomination_records_select ON public.denomination_records FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY denomination_records_update ON public.denomination_records FOR UPDATE USING (true);

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY denomination_types_delete ON public.denomination_types FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY denomination_types_insert ON public.denomination_types FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY denomination_types_select ON public.denomination_types FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY denomination_types_update ON public.denomination_types FOR UPDATE USING (true);

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY flyer_offer_products_delete_policy ON public.flyer_offer_products FOR DELETE TO authenticated USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY flyer_offer_products_insert_policy ON public.flyer_offer_products FOR INSERT TO authenticated WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY flyer_offer_products_select_policy ON public.flyer_offer_products FOR SELECT USING (true);

Type: COMMENT;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY flyer_offer_products_update_policy ON public.flyer_offer_products FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

Type: ROW SECURITY;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY flyer_offers_delete_policy ON public.flyer_offers FOR DELETE TO authenticated USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY flyer_offers_insert_policy ON public.flyer_offers FOR INSERT TO authenticated WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY flyer_offers_select_all_policy ON public.flyer_offers FOR SELECT TO authenticated USING (true);

Type: COMMENT;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY flyer_offers_select_policy ON public.flyer_offers FOR SELECT USING ((is_active = true));

Type: COMMENT;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY flyer_offers_update_policy ON public.flyer_offers FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY interface_permissions_delete_policy ON public.interface_permissions FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY interface_permissions_insert_policy ON public.interface_permissions FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY interface_permissions_select_policy ON public.interface_permissions FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY interface_permissions_update_policy ON public.interface_permissions FOR UPDATE USING (true);

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY management_delete_order_items ON public.order_items FOR DELETE USING (public.has_order_management_access(auth.uid()));

Type: POLICY;

Schema: public;

--

CREATE POLICY management_update_order_items ON public.order_items FOR UPDATE USING (public.has_order_management_access(auth.uid()));

Type: POLICY;

Schema: public;

--

CREATE POLICY management_update_orders ON public.orders FOR UPDATE USING (public.has_order_management_access(auth.uid()));

Type: POLICY;

Schema: public;

--

CREATE POLICY management_view_all_audit_logs ON public.order_audit_logs FOR SELECT USING (public.has_order_management_access(auth.uid()));

Type: POLICY;

Schema: public;

--

CREATE POLICY management_view_all_orders ON public.orders FOR SELECT USING ((public.has_order_management_access(auth.uid()) OR (picker_id = auth.uid()) OR (delivery_person_id = auth.uid())));

Type: COMMENT;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY overtime_registrations_all ON public.overtime_registrations USING (true) WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY pickers_update_assigned_orders ON public.orders FOR UPDATE USING ((picker_id = auth.uid())) WITH CHECK (((picker_id = auth.uid()) AND ((order_status)::text = ANY (ARRAY[('in_picking'::character varying)::text, ('ready'::character varying)::text]))));

Type: POLICY;

Schema: public;

--

CREATE POLICY pickers_view_assigned_orders ON public.orders FOR SELECT USING (((picker_id = auth.uid()) OR public.has_order_management_access(auth.uid())));

Type: COMMENT;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY pv_authenticated_all ON public.purchase_vouchers USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY pv_issue_types_authenticated_all ON public.purchase_voucher_issue_types USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY pv_issue_types_service_role_all ON public.purchase_voucher_issue_types USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY pv_service_role_all ON public.purchase_vouchers USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY pvi_authenticated_all ON public.purchase_voucher_items USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY pvi_service_role_all ON public.purchase_voucher_items USING (true);

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY realtime_access_code_history_select ON public.customer_access_code_history FOR SELECT TO authenticated, anon USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY realtime_customers_select ON public.customers FOR SELECT TO authenticated, anon USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY realtime_wa_messages_select ON public.wa_messages FOR SELECT TO authenticated, anon USING (true);

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY rls_delete ON public.branches FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY rls_delete ON public.receiving_records FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY rls_delete ON public.vendors FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY rls_insert ON public.branches FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY rls_insert ON public.receiving_records FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY rls_insert ON public.vendors FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY rls_select ON public.branches FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY rls_select ON public.receiving_records FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY rls_select ON public.vendors FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY rls_update ON public.branches FOR UPDATE WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY rls_update ON public.receiving_records FOR UPDATE WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY rls_update ON public.vendors FOR UPDATE WITH CHECK (true);

Type: ROW SECURITY;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY service_role_all ON public.access_code_otp TO service_role USING (true) WITH CHECK (true);

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY special_shift_weekday_policy ON public.special_shift_weekday USING (true) WITH CHECK (true);

Type: ROW SECURITY;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY system_insert_audit_logs ON public.order_audit_logs FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY system_insert_order_items ON public.order_items FOR INSERT WITH CHECK ((order_id IN ( SELECT orders.id
   FROM public.orders
  WHERE ((orders.customer_id = auth.uid()) OR public.has_order_management_access(auth.uid())))));

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY users_view_order_audit_logs ON public.order_audit_logs FOR SELECT USING ((order_id IN ( SELECT orders.id
   FROM public.orders
  WHERE ((orders.customer_id = auth.uid()) OR (orders.picker_id = auth.uid()) OR (orders.delivery_person_id = auth.uid()) OR public.has_order_management_access(auth.uid()) OR public.is_delivery_staff(auth.uid())))));

Type: COMMENT;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY users_view_order_items ON public.order_items FOR SELECT USING ((order_id IN ( SELECT orders.id
   FROM public.orders
  WHERE ((orders.customer_id = auth.uid()) OR (orders.picker_id = auth.uid()) OR (orders.delivery_person_id = auth.uid()) OR public.has_order_management_access(auth.uid()) OR public.is_delivery_staff(auth.uid())))));

Type: COMMENT;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: POLICY;

Schema: public;

--

CREATE POLICY vendor_payment_schedule_delete ON public.vendor_payment_schedule FOR DELETE USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY vendor_payment_schedule_insert ON public.vendor_payment_schedule FOR INSERT WITH CHECK (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY vendor_payment_schedule_select ON public.vendor_payment_schedule FOR SELECT USING (true);

Type: POLICY;

Schema: public;

--

CREATE POLICY vendor_payment_schedule_update ON public.vendor_payment_schedule FOR UPDATE USING (true);

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ROW SECURITY;

Schema: public;

Type: ACL;

Schema: -;

--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: ACL;

Schema: public;

Type: DEFAULT ACL;

Schema: public;

Type: DEFAULT ACL;

Schema: public;