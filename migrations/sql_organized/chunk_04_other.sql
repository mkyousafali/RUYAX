-- chunk_04_other.sql

SET lock_timeout = 0;

SET idle_in_transaction_session_timeout = 0;

SET client_encoding = 'UTF8';

SET standard_conforming_strings = on;

SELECT pg_catalog.set_config('search_path', '', false);

SET check_function_bodies = false;

SET xmloption = content;

SET client_min_messages = warning;

SET row_security = off;

ALTER TYPE public.audit_action_enum OWNER TO supabase_admin;

ALTER TYPE public.document_category_enum OWNER TO supabase_admin;

ALTER TYPE public.document_type_enum OWNER TO supabase_admin;

ALTER TYPE public.employee_status_enum OWNER TO supabase_admin;

ALTER TYPE public.fine_payment_status_enum OWNER TO supabase_admin;

ALTER TYPE public.notification_priority_enum OWNER TO supabase_admin;

ALTER TYPE public.notification_queue_status_enum OWNER TO supabase_admin;

ALTER TYPE public.notification_status_enum OWNER TO supabase_admin;

ALTER TYPE public.notification_target_type_enum OWNER TO supabase_admin;

ALTER TYPE public.notification_type_enum OWNER TO supabase_admin;

ALTER TYPE public.payment_method_type OWNER TO supabase_admin;

ALTER TYPE public.pos_deduction_status OWNER TO supabase_admin;

ALTER TYPE public.push_subscription_status_enum OWNER TO supabase_admin;

ALTER TYPE public.resolution_status OWNER TO supabase_admin;

ALTER TYPE public.role_type_enum OWNER TO supabase_admin;

ALTER TYPE public.session_status_enum OWNER TO supabase_admin;

ALTER TYPE public.task_priority_enum OWNER TO supabase_admin;

ALTER TYPE public.task_status_enum OWNER TO supabase_admin;

ALTER TYPE public.user_role OWNER TO supabase_admin;

ALTER TYPE public.user_status_enum OWNER TO supabase_admin;

ALTER TYPE public.user_type_enum OWNER TO supabase_admin;

ALTER TYPE public.vendor_status_enum OWNER TO supabase_admin;

ALTER TYPE public.warning_status_enum OWNER TO supabase_admin;

v_user_name VARCHAR(255);

BEGIN
    -- Get current status
    SELECT order_status INTO v_current_status
    FROM orders
    WHERE id = p_order_id;

IF NOT FOUND THEN
        RETURN QUERY SELECT FALSE, 'Order not found';

IF v_current_status != 'new' THEN
        RETURN QUERY SELECT FALSE, 'Order can only be accepted from new status';

RETURN QUERY SELECT TRUE, 'Order accepted successfully';

RETURN FOUND;

BEGIN
    -- Validate that product_id exists
    IF NEW.product_id IS NULL THEN
        RAISE EXCEPTION 'product_id is required';

RAISE NOTICE 'Product % stock decreased by %. New stock: %', 
        NEW.product_id, NEW.quantity, (current_quantity - NEW.quantity);

RETURN NEW;

v_approved_by UUID;

v_is_admin BOOLEAN;

v_is_master_admin BOOLEAN;

BEGIN
    -- p_approved_by is required since we use custom auth (not Supabase Auth)
    IF p_approved_by IS NULL THEN
        RAISE EXCEPTION 'User ID (p_approved_by) is required.';

IF NOT (v_is_admin = true OR v_is_master_admin = true) THEN
        RAISE EXCEPTION 'Access denied. Admin privileges required.';

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

RETURN result;

EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'success', false,
            'error', SQLERRM
        );

v_assigned_by_name VARCHAR(255);

BEGIN
    -- Get delivery person name
    SELECT username INTO v_delivery_name
    FROM users
    WHERE id = p_delivery_person_id;

IF NOT FOUND THEN
        RETURN QUERY SELECT FALSE, 'Delivery person not found';

RETURN QUERY SELECT TRUE, 'Delivery person assigned successfully';

v_assigned_by_name VARCHAR(255);

BEGIN
    -- Get picker name
    SELECT username INTO v_picker_name
    FROM users
    WHERE id = p_picker_id;

IF NOT FOUND THEN
        RETURN QUERY SELECT FALSE, 'Picker not found';

RETURN QUERY SELECT TRUE, 'Picker assigned successfully';

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

IF v_customer.registration_status = 'deleted' THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'ACCOUNT_DELETED',
            'message', 'This account has been deleted. Please register again.'
        );

IF v_customer.registration_status != 'approved' THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'Your account is pending approval. Please wait for admin confirmation.'
        );

RETURN jsonb_build_object(
        'success', true,
        'customer_id', v_customer.id,
        'customer_name', v_customer.name,
        'whatsapp_number', v_customer.whatsapp_number,
        'registration_status', v_customer.registration_status
    );

existing_schedule_id UUID;

v_vendor_name TEXT;

v_branch_name TEXT;

v_final_amount NUMERIC;

ELSIF NEW.credit_period IS NOT NULL THEN
                schedule_date := (NEW.created_at + (NEW.credit_period || ' days')::INTERVAL);

ELSE
                schedule_date := (NEW.created_at + INTERVAL '30 days'); -- Default 30 days
            END IF;

RAISE NOTICE 'Auto-created payment schedule for receiving record: % (certificate: %)', NEW.id, NEW.certificate_url;

ELSE
            RAISE NOTICE 'Payment schedule already exists for receiving record: %', NEW.id;

RETURN NEW;

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

FOREACH v_phone IN ARRAY p_phone_numbers
    LOOP
        -- Clean and format phone number
        v_formatted := regexp_replace(v_phone, '[^0-9]', '', 'g');

ELSIF length(v_formatted) = 10 AND v_formatted LIKE '0%' THEN
            v_formatted := '966' || substring(v_formatted from 2);

IF v_exists THEN
            v_skipped := v_skipped + 1;

v_inserted := v_inserted + 1;

RETURN jsonb_build_object(
        'success', true,
        'total', v_total,
        'inserted', v_inserted,
        'skipped', v_skipped,
        'message', v_inserted || ' customers imported, ' || v_skipped || ' skipped (duplicates or invalid)'
    );

GET DIAGNOSTICS v_count = ROW_COUNT;

RETURN NEW;

ELSE
    NEW.profit_percentage := 0;

RETURN NEW;

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

WHEN 'daily' THEN
            -- Daily visits: next day
            IF current_next_date IS NOT NULL THEN
                next_date := current_next_date + INTERVAL '1 day';

ELSE
                next_date := current_date + INTERVAL '1 day';

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

WHEN 'skip_days' THEN
            -- Skip specified number of days
            IF current_next_date IS NOT NULL THEN
                next_date := current_next_date + skip_days * INTERVAL '1 day';

ELSE
                next_date := COALESCE(start_date, current_date) + skip_days * INTERVAL '1 day';

ELSE
            -- Default: next day
            next_date := current_date + INTERVAL '1 day';

RETURN next_date;

ELSE
        NEW.profit_percentage = 0;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

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

NEW.working_hours := ROUND(hours_diff, 2);

RETURN NEW;

IF check_out <= check_in THEN
        RETURN 0.00;

RETURN ROUND(
        EXTRACT(EPOCH FROM (check_out - check_in)) / 3600.0,
        2
    );

ELSE
        -- For regular shifts: end_time - start_time
        RETURN ROUND(
            EXTRACT(EPOCH FROM (end_time - start_time)) / 3600.0, 2
        );

v_user_name VARCHAR(255);

BEGIN
    -- Get current status
    SELECT order_status INTO v_current_status
    FROM orders
    WHERE id = p_order_id;

IF NOT FOUND THEN
        RETURN QUERY SELECT FALSE, 'Order not found';

IF v_current_status = 'delivered' THEN
        RETURN QUERY SELECT FALSE, 'Cannot cancel delivered order';

IF v_current_status = 'cancelled' THEN
        RETURN QUERY SELECT FALSE, 'Order is already cancelled';

RETURN QUERY SELECT TRUE, 'Order cancelled successfully';

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

missing_files := ARRAY[]::TEXT[];

EXCEPTION WHEN OTHERS THEN
  RETURN jsonb_build_object(
    'can_complete', false,
    'error', SQLERRM,
    'error_code', 'INTERNAL_ERROR',
    'message', 'Error checking accountant dependencies: ' || SQLERRM
  );

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

notified_count INTEGER := 0;

rec RECORD;

BEGIN
    -- Run the notification check
    FOR rec IN SELECT * FROM check_and_notify_recurring_schedules()
    LOOP
        checked_count := checked_count + 1;

IF rec.notification_sent THEN
            notified_count := notified_count + 1;

notifications_sent := notified_count;

execution_date := CURRENT_DATE;

message := FORMAT('Checked %s schedules, sent %s notifications', checked_count, notified_count);

RETURN NEXT;

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

RETURN result_json;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'ERROR in status check function: %', SQLERRM;

RETURN jsonb_build_object(
            'success', false,
            'error', SQLERRM,
            'error_code', SQLSTATE
        );

v_customer_usage_count INTEGER;

BEGIN
    -- Get offer details
    SELECT * INTO v_offer FROM offers WHERE id = p_offer_id;

IF NOT FOUND THEN
        RETURN false;

IF v_customer_usage_count >= v_offer.max_uses_per_customer THEN
            RETURN false;

RETURN true;

notification_id UUID;

reminder_count INTEGER := 0;

BEGIN
  RAISE NOTICE 'Starting overdue task reminder check at %', NOW();

reminder_count := reminder_count + 1;

RAISE NOTICE 'Sent reminder for task "%" to user "%"', task_record.task_title, task_record.user_name;

EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'Failed to send reminder for task %: %', task_record.assignment_id, SQLERRM;

reminder_count := reminder_count + 1;

RAISE NOTICE 'Sent reminder for quick task "%" to user "%"', task_record.task_title, task_record.user_name;

EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'Failed to send reminder for quick task %: %', task_record.assignment_id, SQLERRM;

RAISE NOTICE 'Completed overdue task reminder check. Sent % reminders.', reminder_count;

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

WHEN 'warehouse_handler' THEN
          IF v_total_tasks > 1 THEN
            blocking_roles := array_append(blocking_roles, 'All Warehouse Handlers must complete their tasks first (' || v_completed_tasks || '/' || v_total_tasks || ' done)');

ELSE
            blocking_roles := array_append(blocking_roles, 'Warehouse Handler must complete their task first');

WHEN 'night_supervisor' THEN
          IF v_total_tasks > 1 THEN
            blocking_roles := array_append(blocking_roles, 'All Night Supervisors must complete their tasks first (' || v_completed_tasks || '/' || v_total_tasks || ' done)');

ELSE
            blocking_roles := array_append(blocking_roles, 'Night Supervisor must complete their task first');

ELSE
          blocking_roles := array_append(blocking_roles, dependency_role || ' must complete their task first');

ELSE
      completed_dependencies := array_append(completed_dependencies, dependency_role);

ELSE
    RETURN json_build_object(
      'can_complete', true,
      'missing_dependencies', ARRAY[]::TEXT[],
      'blocking_roles', ARRAY[]::TEXT[],
      'completed_dependencies', completed_dependencies
    );

BEGIN
    SELECT require_task_finished, require_photo_upload, require_erp_reference
    INTO task_record
    FROM tasks 
    WHERE id = task_uuid;

ELSE
        RETURN false;

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

IF v_stock_remaining IS NULL OR v_stock_remaining <= 0 THEN
    RETURN jsonb_build_object(
      'success', false,
      'error_message', 'Product is out of stock'
    );

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

PERFORM dblink_disconnect('analytics_conn');

RETURN format('Cleared %s log tables, freed ~%s', cnt, pg_size_pretty(GREATEST(db_size_before - db_size_after, 0)));

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

RETURN OLD;

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

EXCEPTION WHEN OTHERS THEN
    PERFORM set_config('session_replication_role', 'origin', true);

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

v_receiving_record_id := v_task.receiving_record_id;

IF NOT (accountant_dependency_result->>'can_complete')::BOOLEAN THEN
      RETURN jsonb_build_object(  -- Changed from json_build_object
        'success', false,
        'error', accountant_dependency_result->>'error',
        'error_code', accountant_dependency_result->>'error_code',
        'message', accountant_dependency_result->>'message'
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

RETURN jsonb_build_object(  -- Changed from json_build_object
        'success', false,
        'error', 'Cannot complete task. Missing dependencies: ' || 
                COALESCE(array_to_string(blocking_roles_array, ', '), 'Unknown dependencies'),
        'error_code', 'DEPENDENCIES_NOT_MET',
        'blocking_roles', blocking_roles_array,
        'dependency_details', dependency_check_result
      );

IF NOT has_pr_excel_file THEN
      RETURN jsonb_build_object(  -- Changed from json_build_object
        'success', false,
        'error', 'PR Excel file is required for Inventory Manager',
        'error_code', 'MISSING_PR_EXCEL'
      );

IF NOT has_original_bill THEN
      RETURN jsonb_build_object(  -- Changed from json_build_object
        'success', false,
        'error', 'Original bill is required for Inventory Manager',
        'error_code', 'MISSING_ORIGINAL_BILL'
      );

v_payment_schedule RECORD;

BEGIN
      -- Get receiving record details
      SELECT * INTO v_receiving_record
      FROM receiving_records
      WHERE id = v_task.receiving_record_id;

IF NOT FOUND THEN
        RETURN jsonb_build_object(  -- Changed from json_build_object
          'success', false,
          'error', 'Payment schedule not found. PR Excel may not be processed yet.',
          'error_code', 'PAYMENT_SCHEDULE_NOT_FOUND'
        );

IF v_payment_schedule.verification_status != 'verified' THEN
        RETURN jsonb_build_object(  -- Changed from json_build_object
          'success', false,
          'error', 'Payment schedule not verified. Current status: ' || COALESCE(v_payment_schedule.verification_status, 'unverified'),
          'error_code', 'PAYMENT_SCHEDULE_NOT_VERIFIED'
        );

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

IF NOT FOUND THEN
    RETURN json_build_object(
      'success', false,
      'error', 'Receiving record not found',
      'error_code', 'RECEIVING_RECORD_NOT_FOUND'
    );

IF NOT v_receiving_record.pr_excel_file_uploaded THEN
      RETURN json_build_object(
        'success', false,
        'error', 'PR Excel file not uploaded',
        'error_code', 'PR_EXCEL_REQUIRED'
      );

IF NOT v_receiving_record.original_bill_uploaded THEN
      RETURN json_build_object(
        'success', false,
        'error', 'Original bill not uploaded',
        'error_code', 'ORIGINAL_BILL_REQUIRED'
      );

ELSIF v_task.role_type = 'purchase_manager' THEN
    -- Check purchase manager requirements
    IF NOT v_receiving_record.pr_excel_file_uploaded THEN
      RETURN json_build_object(
        'success', false,
        'error', 'PR Excel file not uploaded by inventory manager',
        'error_code', 'PR_EXCEL_REQUIRED'
      );

ELSIF v_task.role_type = 'accountant' THEN
    -- Check accountant dependency on inventory manager original bill upload
    IF NOT v_receiving_record.original_bill_uploaded OR v_receiving_record.original_bill_url IS NULL THEN
      RETURN json_build_object(
        'success', false,
        'error', 'Original bill not uploaded by the inventory manager – please follow up.',
        'error_code', 'DEPENDENCIES_NOT_MET'
      );

RETURN v_result;

EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object(
    'success', false,
    'error', SQLERRM,
    'error_code', 'INTERNAL_ERROR'
  );

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

IF NOT FOUND THEN
    RETURN json_build_object(
      'success', false,
      'error', 'Receiving record not found',
      'error_code', 'RECEIVING_RECORD_NOT_FOUND'
    );

ELSIF v_task.role_type = 'accountant' THEN
    -- Check accountant dependency on inventory manager original bill upload
    -- CHANGED: Also check URL column for accountant
    IF v_receiving_record.original_bill_url IS NULL OR v_receiving_record.original_bill_url = '' THEN
      RETURN json_build_object(
        'success', false,
        'error', 'Original bill not uploaded by the inventory manager – please follow up.',
        'error_code', 'DEPENDENCIES_NOT_MET'
      );

RETURN v_result;

EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object(
    'success', false,
    'error', SQLERRM,
    'error_code', 'INTERNAL_ERROR'
  );

new_next_date DATE;

BEGIN
    -- Get the visit record
    SELECT * INTO visit_record FROM vendor_visits WHERE id = visit_id;

IF NOT FOUND THEN
        RAISE EXCEPTION 'Visit schedule not found with id: %', visit_id;

RETURN new_next_date;

RETURN NEW;

BEGIN
    -- Count receiving records where erp_purchase_invoice_reference is NULL or empty
    SELECT COUNT(*) INTO no_erp_count
    FROM receiving_records rr
    WHERE rr.erp_purchase_invoice_reference IS NULL 
    OR rr.erp_purchase_invoice_reference = ''
    OR TRIM(rr.erp_purchase_invoice_reference) = '';

RETURN COALESCE(no_erp_count, 0);

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

RETURN COALESCE(result_count, 0);

BEGIN
    -- Count receiving records where original_bill_url is NULL or empty
    SELECT COUNT(*) INTO no_original_count
    FROM receiving_records rr
    WHERE rr.original_bill_url IS NULL 
    OR rr.original_bill_url = ''
    OR TRIM(rr.original_bill_url) = '';

RETURN COALESCE(no_original_count, 0);

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

RETURN COALESCE(result_count, 0);

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

RETURN COALESCE(result_count, 0);

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

RETURN QUERY SELECT v_order_id, v_order_number, TRUE, 'Order created successfully';

v_access_code text;

v_hashed_code text;

v_formatted_number text;

v_existing_customer record;

v_system_user_id uuid := 'e1fdaee2-97f0-4fc1-872f-9d99c6bd684b';

BEGIN
    v_formatted_number := regexp_replace(p_whatsapp_number, '[^0-9]', '', 'g');

IF length(v_formatted_number) = 9 THEN
        v_formatted_number := '966' || v_formatted_number;

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

v_hashed_code := encode(digest(v_access_code::bytea, 'sha256'), 'hex');

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

RETURN NEW;

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

RAISE NOTICE 'Created recipients for notification %', NEW.id;

RETURN NEW;

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

assigned_to_name TEXT;

BEGIN
    -- Get the name of who assigned the task (from hr_employees if available, otherwise username)
    SELECT COALESCE(he.name, u.username, 'Admin') INTO assigned_by_name
    FROM users u
    LEFT JOIN hr_employees he ON u.employee_id = he.id
    WHERE u.id = (SELECT assigned_by FROM quick_tasks WHERE id = NEW.quick_task_id);

RETURN NEW;

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

RETURN task_id;

RETURN schedule_id;

next_exec_time TIMESTAMP WITH TIME ZONE;

BEGIN
    -- Calculate first execution time
    next_exec_time := (p_start_date::text || ' ' || p_execute_time::text)::timestamp with time zone;

RETURN assignment_id;

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

RETURN assignment_id;

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

qr_salt TEXT;

admin_user_id UUID;

main_branch_id BIGINT;

final_quick_code TEXT;

BEGIN
    -- Get main branch ID (or any branch)
    SELECT id INTO main_branch_id FROM branches WHERE is_main_branch = true LIMIT 1;

IF main_branch_id IS NULL THEN
        SELECT id INTO main_branch_id FROM branches LIMIT 1;

qr_salt := generate_salt();

final_quick_code := p_quick_access_code;

ELSE
        final_quick_code := generate_unique_quick_access_code();

RAISE NOTICE 'System admin user created with ID: %', admin_user_id;

RAISE NOTICE 'Username: %, Is Master Admin: %, Quick Access: %', p_username, p_is_master_admin, final_quick_code;

RETURN admin_user_id;

qr_salt TEXT;

admin_user_id UUID;

main_branch_id BIGINT;

final_quick_code TEXT;

BEGIN
    -- Get main branch ID (or any branch)
    SELECT id INTO main_branch_id FROM branches WHERE is_main_branch = true LIMIT 1;

IF main_branch_id IS NULL THEN
        SELECT id INTO main_branch_id FROM branches LIMIT 1;

qr_salt := generate_salt();

final_quick_code := p_quick_access_code;

ELSE
        final_quick_code := generate_unique_quick_access_code();

RAISE NOTICE 'System admin user created with ID: %', admin_user_id;

RAISE NOTICE 'Username: %, Role: %, Quick Access: %', p_username, p_role_type, final_quick_code;

RETURN admin_user_id;

calculated_due_datetime TIMESTAMPTZ;

BEGIN
    -- Calculate due_datetime if due_date is provided
    IF due_date_param IS NOT NULL THEN
        calculated_due_datetime := due_date_param + COALESCE(due_time_param, '23:59:59'::TIME);

RETURN task_id;

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

ELSE
    v_quick_access_code := p_quick_access_code;

IF EXISTS (SELECT 1 FROM users WHERE username = p_username) THEN
    RETURN json_build_object(
      'success', false,
      'message', 'Username already exists'
    );

v_password_hash := extensions.crypt(p_password, v_salt);

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

RETURN NEW;

v_barcode TEXT;

v_order INTEGER := 1;

BEGIN
  -- Validate parent product exists
  IF NOT EXISTS (SELECT 1 FROM products WHERE barcode = p_parent_barcode) THEN
    RETURN QUERY SELECT false, 'Parent product barcode does not exist', 0;

v_affected_count := v_affected_count + 1;

v_order := v_order + 1;

v_affected_count := v_affected_count + 1;

RETURN QUERY SELECT true, 'Variation group created successfully', v_affected_count;

RETURN NEW;

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

RETURN NULL;

EXCEPTION
  WHEN OTHERS THEN
    RETURN false;

result_text TEXT;

BEGIN
    -- Run the sync function
    SELECT * INTO sync_result FROM sync_all_missing_erp_references();

result_text := format('Daily ERP sync maintenance completed: %s records synced', 
                         sync_result.synced_count);

IF sync_result.synced_count > 0 THEN
        result_text := result_text || format('. Details: %s', sync_result.details);

RETURN result_text;

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

RAISE NOTICE 'Debug: Found % photos, returning %', found_count, result_photos;

EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'Debug: Error occurred - %', SQLERRM;

RETURN '{}'::JSON;

IF NOT FOUND THEN
        RAISE EXCEPTION 'Insufficient stock for voucher value %', voucher_value;

RETURN FOUND;

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

IF v_customer.is_deleted = true THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Account already deleted'
        );

RETURN json_build_object(
        'success', true,
        'message', 'Account deleted successfully'
    );

BEGIN
    -- Collect quick_task IDs linked to this incident
    SELECT ARRAY(SELECT id FROM quick_tasks WHERE incident_id = p_incident_id)
    INTO v_task_ids;

DELETE FROM quick_task_comments    WHERE quick_task_id = ANY(v_task_ids);

DELETE FROM quick_task_completions WHERE quick_task_id = ANY(v_task_ids);

DELETE FROM quick_task_files       WHERE quick_task_id = ANY(v_task_ids);

RETURN NEW;

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

RETURN NULL;

template_record RECORD;

BEGIN
  -- Get the original template
  SELECT * INTO template_record
  FROM flyer_templates
  WHERE id = template_id
    AND deleted_at IS NULL;

IF NOT FOUND THEN
    RAISE EXCEPTION 'Template not found';

RETURN new_template_id;

v_duration INTEGER;

BEGIN
  SELECT id, start_time INTO v_break
  FROM break_register
  WHERE user_id = p_user_id AND status = 'open'
  LIMIT 1;

IF v_break IS NULL THEN
    RETURN jsonb_build_object('success', false, 'error', 'No open break found');

v_duration := EXTRACT(EPOCH FROM (NOW() - v_break.start_time))::INTEGER;

RETURN jsonb_build_object('success', true, 'break_id', v_break.id, 'duration_seconds', v_duration);

v_start_time timestamptz;

v_duration integer;

BEGIN
    -- Validate security code (required)
    IF p_security_code IS NULL OR p_security_code = '' THEN
        RETURN jsonb_build_object('success', false, 'error', 'Security code is required. Please scan the QR code.');

IF NOT validate_break_code(p_security_code) THEN
        RETURN jsonb_build_object('success', false, 'error', 'Invalid or expired QR code. Please scan the current QR code displayed on the screen.');

IF v_break_id IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'No open break found');

RETURN jsonb_build_object('success', true, 'break_id', v_break_id, 'duration_seconds', v_duration);

RETURN NEW;

v_triggers text := '';

v_types text := '';

v_policies text := '';

v_grants text := '';

v_tables text := '';

v_indexes text := '';

v_sequences text := '';

v_columns text := '';

v_sequences := v_sequences || format(
            'GRANT USAGE, SELECT ON SEQUENCE public.%I TO authenticated, anon, service_role;',
            r.seq_name
        ) || E'\n';

ELSE
            v_functions := v_functions || format(
                'DROP FUNCTION IF EXISTS public.%I(%s) CASCADE;',
                r.proname, r.identity_args
            ) || E'\n';

v_functions := v_functions || r.funcdef || ';' || E'\n\n';

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

IF col.not_null THEN
                    v_cols := v_cols || ' NOT NULL';

v_tables := v_tables || v_cols || v_constraints || E'\n);\n';

IF col.default_val IS NOT NULL THEN
                    v_columns := v_columns || ' DEFAULT ' || col.default_val;

v_columns := v_columns || ';' || E'\n';

v_triggers := v_triggers || r.triggerdef || ';' || E'\n\n';

v_policies := v_policies || format(
            'CREATE POLICY %I ON public.%I AS %s FOR %s TO %s',
            r.policyname, r.tablename,
            r.permissive,
            r.cmd,
            array_to_string(r.roles, ', ')
        );

IF r.qual IS NOT NULL THEN
            v_policies := v_policies || ' USING (' || r.qual || ')';

IF r.with_check IS NOT NULL THEN
            v_policies := v_policies || ' WITH CHECK (' || r.with_check || ')';

v_policies := v_policies || ';' || E'\n\n';

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

EXECUTE format('SELECT COALESCE(jsonb_agg(row_to_json(t)::jsonb), ''[]''::jsonb) FROM %I t', p_table_name)
    INTO v_result;

RETURN v_result;

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

next_num INTEGER;

BEGIN
    -- Always generate branch_id if not provided or empty
    IF NEW.branch_id IS NULL OR NEW.branch_id = '' THEN
        -- Determine prefix based on branch type
        prefix := CASE 
            WHEN NEW.branch_type = 'head_branch' THEN 'HB'
            ELSE 'BR'
        END;

RETURN NEW;

code_exists BOOLEAN;

BEGIN
  LOOP
    -- Generate 8 character alphanumeric code
    new_code := upper(substring(md5(random()::text || clock_timestamp()::text) from 1 for 8));

EXIT WHEN NOT code_exists;

RETURN new_code;

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

RAISE NOTICE 'Night Supervisor tasks created: %', array_length(receiving_record.night_supervisor_user_ids, 1);

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

RAISE NOTICE 'Warehouse Handler tasks created: %', array_length(receiving_record.warehouse_handler_user_ids, 1);

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

RAISE NOTICE 'Shelf Stocker tasks created: %', array_length(receiving_record.shelf_stocker_user_ids, 1);

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

RAISE NOTICE 'Total tasks created: %, Total notifications sent: %', total_tasks, total_notifications;

RETURN QUERY SELECT total_tasks, total_notifications, created_task_ids, created_assignment_ids;

EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Error in generate_clearance_certificate_tasks: %', SQLERRM;

new_id VARCHAR(15);

BEGIN
  -- Extract the numeric part from the last ID and increment it
  SELECT COALESCE(MAX(CAST(SUBSTRING(id, 4) AS INTEGER)), 0) + 1
  INTO max_id
  FROM hr_insurance_companies
  WHERE id LIKE 'INC%';

NEW.id := new_id;

RETURN NEW;

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

SELECT c.access_code, c.whatsapp_number, c.name
    INTO v_old_hashed_code, v_whatsapp_number, v_customer_name
    FROM public.customers c WHERE c.id = p_customer_id;

IF v_customer_name IS NULL THEN
        RETURN json_build_object('success', false, 'error', 'Customer not found');

v_new_access_code := generate_unique_customer_access_code();

v_hashed_new_code := encode(digest(v_new_access_code::bytea, 'sha256'), 'hex');

IF v_new_access_code IS NULL THEN
        RETURN json_build_object('success', false, 'error', 'Failed to generate unique access code');

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

counter INTEGER;

BEGIN
    -- Format: ORD-YYYYMMDD-XXXX
    SELECT COUNT(*) + 1 INTO counter
    FROM orders
    WHERE DATE(created_at) = CURRENT_DATE;

new_order_number := 'ORD-' || TO_CHAR(CURRENT_DATE, 'YYYYMMDD') || '-' || LPAD(counter::TEXT, 4, '0');

RETURN new_order_number;

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

IF NOT FOUND THEN
        RAISE EXCEPTION 'Recurring schedule not found with ID: % in table: %', p_parent_id, p_source_table;

co_user_name_value := rec.co_user_name;

ELSE
        -- Use creator's ID and username from public.users table
        co_user_id_value := rec.created_by;

SELECT username INTO co_user_name_value
        FROM public.users
        WHERE id = rec.created_by;

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

occurrences_created := occurrences_created + 1;

current_date_iter := current_date_iter + INTERVAL '1 day';

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

occurrences_created := occurrences_created + 1;

current_date_iter := current_date_iter + INTERVAL '1 day';

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

occurrences_created := occurrences_created + 1;

current_month := current_month + INTERVAL '1 month';

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

occurrences_created := occurrences_created + 1;

current_month := current_month + INTERVAL '1 month';

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

occurrences_created := occurrences_created + 1;

ELSE
            RAISE EXCEPTION 'Unsupported recurring_type: %', rec.recurring_type;

ELSIF p_source_table = 'non_approved_payment_scheduler' THEN
        DELETE FROM non_approved_payment_scheduler WHERE id = p_parent_id;

occurrence_count := occurrences_created;

message := FORMAT('Successfully created %s occurrences for recurring schedule ID %s (parent deleted)', occurrences_created, p_parent_id);

RETURN NEXT;

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

attempts := attempts + 1;

IF attempts >= max_attempts THEN
            RAISE EXCEPTION 'Unable to generate unique access code after % attempts', max_attempts;

BEGIN
  LOOP
    v_code := LPAD(FLOOR(RANDOM() * 1000000)::TEXT, 6, '0');

EXIT WHEN NOT EXISTS (
      SELECT 1 FROM users
      WHERE extensions.crypt(v_code, quick_access_code) = quick_access_code
    );

RETURN v_code;

RETURN NEW;

v_reason RECORD;

BEGIN
  SELECT br.*, br.reason_id as rid
  INTO v_break
  FROM break_register br
  WHERE br.user_id = p_user_id AND br.status = 'open'
  LIMIT 1;

IF v_break IS NULL THEN
    RETURN jsonb_build_object('active', false);

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

ELSE
    v_vendor_payments := '[]'::JSONB;

ELSE
    v_purchase_vouchers := '[]'::JSONB;

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

ELSE
    v_day_off_requests := '[]'::JSONB;

RETURN v_result;

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

RETURN json_build_object(
    'totals', v_totals,
    'branch_stats', v_branch_stats,
    'task_type_stats', v_task_type_stats,
    'daily_stats', v_daily_stats,
    'top_employees', v_top_employees,
    'assigned_by_stats', v_assigned_by_stats,
    'checklist_stats', v_checklist_stats
  );

v_epoch bigint;

v_code text;

v_ttl integer;

BEGIN
    SELECT seed INTO v_seed FROM break_security_seed WHERE id = 1;

IF v_seed IS NULL THEN
        RETURN jsonb_build_object('error', 'No security seed configured');

RETURN jsonb_build_object(
        'code', v_code,
        'ttl', v_ttl,
        'epoch', v_epoch
    );

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

v_products JSONB;

v_max_claims INTEGER;

BEGIN
  -- Get campaign max claims
  SELECT COALESCE(max_claims_per_customer, 1)
  INTO v_max_claims
  FROM coupon_campaigns
  WHERE id = p_campaign_id;

v_boxes jsonb;

RETURN jsonb_build_object(
    'boxes', v_boxes,
    'total_count', v_total_count
  );

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

EXCEPTION
  WHEN OTHERS THEN
    RETURN NULL;

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

arg_list text;

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

IF rec.proisstrict THEN
      ddl := ddl || 'STRICT' || E'\n';

IF rec.secdef THEN
      ddl := ddl || 'SECURITY DEFINER' || E'\n';

ddl := ddl || 'AS $func$' || E'\n' || rec.fsrc || E'\n' || '$func$;';

func_name := rec.fname;

func_args := rec.fargs;

return_type := rec.fresult;

func_language := rec.flang;

func_type := rec.ftype;

is_security_definer := rec.secdef;

func_definition := ddl;

RETURN NEXT;

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

BEGIN
    -- Find the appropriate tier for the given order amount
    SELECT delivery_fee INTO calculated_fee
    FROM public.delivery_fee_tiers
    WHERE is_active = true
      AND min_order_amount <= order_amount
      AND (max_order_amount IS NULL OR max_order_amount >= order_amount)
    ORDER BY min_order_amount DESC
    LIMIT 1;

BEGIN
    -- Require a branch id; without it, no fee can be determined
    IF p_branch_id IS NULL THEN
        RETURN 0;

RETURN COALESCE(v_fee, 0);

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

EXCEPTION WHEN OTHERS THEN
  -- Return empty object on error
  RETURN '{}'::JSON;

BEGIN
    SELECT basic_hours INTO emp_basic_hours
    FROM employee_basic_hours 
    WHERE employee_id = p_employee_id;

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

v_count INTEGER := 0;

BEGIN
  -- Get employee's current branch
  SELECT current_branch_id INTO v_branch_id
  FROM hr_employee_master
  WHERE id = p_employee_id;

IF v_branch_id IS NULL THEN
    RETURN jsonb_build_object('count', 0);

RETURN jsonb_build_object('count', v_count);

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

RETURN COALESCE(v_result, '[]'::JSONB);

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

BEGIN
  IF p_pv_id IS NULL AND p_serial_number IS NULL THEN
    RETURN '[]'::jsonb;

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

SELECT COALESCE(json_agg(c ORDER BY c.created_at DESC), '[]'::json) INTO changes_json
    FROM lease_rent_special_changes c
    WHERE c.party_type = p_party_type;

RETURN json_build_object('parties', parties_json, 'changes', changes_json);

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

EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object('success', false, 'error', SQLERRM);

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

BEGIN
    -- Get current delivery fee
    current_fee := public.get_delivery_fee_for_amount(current_amount);

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

BEGIN
    -- Try to get existing function
    SELECT id INTO function_id 
    FROM app_functions 
    WHERE function_code = p_function_code;

RETURN function_id;

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

v_team_tasks json;

v_is_branch_manager boolean := false;

v_employee_names json;

v_cutoff timestamp;

BEGIN
  -- Calculate cutoff for completed tasks
  v_cutoff := NOW() - (p_completed_days || ' days')::interval;

IF v_team_tasks IS NULL THEN
      v_team_tasks := '[]'::json;

IF v_employee_names IS NULL THEN
      v_employee_names := '[]'::json;

ELSE
    v_team_tasks := '[]'::json;

v_employee_names := '[]'::json;

RETURN json_build_object(
    'my_tasks', v_my_tasks,
    'team_tasks', v_team_tasks,
    'is_branch_manager', v_is_branch_manager,
    'employee_names', v_employee_names
  );

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

col RECORD;

con RECORD;

idx RECORD;

trg RECORD;

pol RECORD;

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

first_col := false;

col_line := '  ' || quote_ident(col.column_name) || ' ';

IF col.data_type = 'USER-DEFINED' THEN
        col_line := col_line || col.udt_name;

ELSIF col.data_type = 'character varying' THEN
        IF col.character_maximum_length IS NOT NULL THEN
          col_line := col_line || 'varchar(' || col.character_maximum_length || ')';

ELSE
          col_line := col_line || 'varchar';

ELSIF col.data_type = 'ARRAY' THEN
        col_line := col_line || col.udt_name;

ELSE
        col_line := col_line || col.data_type;

IF col.is_nullable = 'NO' THEN
        col_line := col_line || ' NOT NULL';

IF col.column_default IS NOT NULL THEN
        col_line := col_line || ' DEFAULT ' || col.column_default;

ddl := ddl || col_line;

ddl := ddl || E'\n);';

IF pol.permissive = 'RESTRICTIVE' THEN
          ddl := ddl || ' AS RESTRICTIVE';

ddl := ddl || ' FOR ' || pol.cmd;

IF array_length(pol.roles, 1) IS NOT NULL AND pol.roles != ARRAY['public']::name[] THEN
          ddl := ddl || ' TO ' || array_to_string(pol.roles, ', ');

IF pol.using_expr IS NOT NULL THEN
          ddl := ddl || E'\n  USING (' || pol.using_expr || ')';

IF pol.check_expr IS NOT NULL THEN
          ddl := ddl || E'\n  WITH CHECK (' || pol.check_expr || ')';

ddl := ddl || ';';

table_name := rec.tname;

column_count := rec.col_cnt;

row_estimate := rec.row_est;

table_size := rec.tbl_size;

total_size := rec.tot_size;

schema_ddl := ddl;

RETURN NEXT;

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

v_user_type text;

result json;

BEGIN
    -- Get user type
    SELECT user_type INTO v_user_type
    FROM public.users
    WHERE id = p_user_id;

IF v_user_type IS NULL THEN
        RAISE EXCEPTION 'User not found';

RETURN result;

EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'success', false,
            'error', SQLERRM
        );

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

RETURN NEW;

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

IF v_order IS NULL THEN
        RETURN NEW;

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

RETURN NEW;

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

IF p_data IS NULL OR jsonb_array_length(p_data) = 0 THEN 
        RETURN 0;

GET DIAGNOSTICS v_count = ROW_COUNT;

RETURN v_count;

EXCEPTION WHEN OTHERS THEN
    PERFORM set_config('session_replication_role', 'origin', true);

RETURN NEW;

SELECT facebook_clicks INTO v_count FROM social_links WHERE branch_id = _branch_id;

SELECT whatsapp_clicks INTO v_count FROM social_links WHERE branch_id = _branch_id;

SELECT instagram_clicks INTO v_count FROM social_links WHERE branch_id = _branch_id;

SELECT tiktok_clicks INTO v_count FROM social_links WHERE branch_id = _branch_id;

SELECT snapchat_clicks INTO v_count FROM social_links WHERE branch_id = _branch_id;

SELECT website_clicks INTO v_count FROM social_links WHERE branch_id = _branch_id;

SELECT location_link_clicks INTO v_count FROM social_links WHERE branch_id = _branch_id;

RETURN json_build_object('branch_id', _branch_id, 'platform', _platform, 'click_count', v_count);

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

RETURN vendor_id;

vendor_company CHARACTER VARYING(255);

BEGIN
    -- Use English name as company if provided, otherwise use the main vendor name
    vendor_company := COALESCE(p_vendor_name_english, p_vendor_name_arabic, 'Unknown Company');

RETURN vendor_id;

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

user_is_admin BOOLEAN;

BEGIN
  SELECT is_master_admin, is_admin
  INTO user_is_master_admin, user_is_admin
  FROM users
  WHERE id = check_user_id;

RETURN COALESCE(user_is_master_admin, false) OR COALESCE(user_is_admin, false);

BEGIN
  SELECT is_master_admin
  INTO user_is_master_admin
  FROM users
  WHERE id = check_user_id;

RETURN COALESCE(user_is_master_admin, false);

BEGIN
    -- Find employee by employee_code and branch
    SELECT e.id INTO v_employee_id
    FROM public.employees e
    WHERE e.employee_id = p_employee_code
    AND e.branch_id = p_branch_id
    AND e.status = 'active';

RETURN v_employee_id;

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

RETURN CASE 
        WHEN TG_OP = 'DELETE' THEN OLD
        ELSE NEW
    END;

RETURN COALESCE(NEW, OLD);

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

IF v_order IS NULL OR v_order.customer_id IS NULL THEN
        RETURN NEW;

v_customer_id := v_order.customer_id;

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

v_url := '/customer-interface/track-order';

IF v_service_role_key IS NULL THEN
        BEGIN
            v_service_role_key := current_setting('supabase.service_role_key', true);

EXCEPTION WHEN OTHERS THEN
            v_service_role_key := NULL;

RAISE LOG 'Customer push notification queued for customer % (order %), request_id: %', 
        v_customer_id, v_order.order_number, v_request_id;

RETURN NEW;

RETURN COALESCE(NEW, OLD);

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

IF NOT FOUND THEN
    RETURN json_build_object(
      'success', false,
      'error', 'Receiving record not found',
      'error_code', 'RECORD_NOT_FOUND',
      'tasks_created', 0,
      'notifications_sent', 0
    );

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

IF v_user_ids IS NOT NULL AND array_length(v_user_ids, 1) > 0 THEN
          FOR v_user_idx IN 1..array_length(v_user_ids, 1) LOOP
            v_assigned_user_id := v_user_ids[v_user_idx];

v_task_id := gen_random_uuid();

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

v_task_id := gen_random_uuid();

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

EXCEPTION
  WHEN OTHERS THEN
    RETURN json_build_object(
      'success', false,
      'error', SQLERRM,
      'error_code', 'INTERNAL_ERROR',
      'tasks_created', 0,
      'notifications_sent', 0
    );

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

IF v_request_record.id IS NULL THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Recovery request not found or already processed'
        );

IF p_action = 'approve' THEN
        -- Generate new access code
        v_new_access_code := generate_unique_customer_access_code();

IF v_new_access_code IS NULL THEN
            RETURN json_build_object(
                'success', false,
                'error', 'Failed to generate unique access code'
            );

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

RETURN result;

EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Failed to process customer recovery: ' || SQLERRM
        );

RETURN NEW;

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

RETURN NEW;

new_assignment_id UUID;

response JSONB;

BEGIN
    -- Get the current receiving task
    SELECT * INTO receiving_task 
    FROM receiving_tasks 
    WHERE id = receiving_task_id_param;

IF NOT FOUND THEN
        RAISE EXCEPTION 'Receiving task not found: %', receiving_task_id_param;

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

RETURN FOUND;

original_assignment RECORD;

BEGIN
    -- Get original assignment details
    SELECT * INTO original_assignment 
    FROM public.task_assignments 
    WHERE id = p_assignment_id;

IF NOT FOUND THEN
        RAISE EXCEPTION 'Assignment not found: %', p_assignment_id;

IF NOT original_assignment.is_reassignable THEN
        RAISE EXCEPTION 'Assignment is not reassignable: %', p_assignment_id;

RETURN new_assignment_id;

total_paid DECIMAL(10,2);

fine_amount DECIMAL(10,2);

BEGIN
    -- Get the fine amount
    SELECT ew.fine_amount INTO fine_amount
    FROM employee_warnings ew
    WHERE ew.id = warning_id_param;

RETURN payment_id;

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

INSERT INTO public.edge_functions_cache (func_name, func_size, file_count, last_modified, has_index, func_code)
  SELECT
    (f->>'func_name')::text,
    (f->>'func_size')::text,
    (f->>'file_count')::int,
    to_timestamp((f->>'last_modified')::bigint),
    (f->>'has_index')::boolean,
    (f->>'func_code')::text
  FROM jsonb_array_elements(p_functions) AS f;

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

RETURN new_id;

ELSE
        -- Insert new function
        INSERT INTO app_functions (function_name, function_code, description, category, is_active)
        VALUES (p_function_name, p_function_code, p_description, p_category, p_enabled)
        RETURNING id INTO new_id;

RETURN new_id;

RETURN subscription_id;

RETURN new_role_id;

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

RETURN json_build_object(
    'success', true,
    'otp', v_otp,
    'whatsapp_number', v_whatsapp_clean,
    'message', 'OTP generated successfully'
  );

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

IF v_customer.registration_status != 'approved' THEN
        RETURN jsonb_build_object('success', false, 'error', 'not_approved',
            'message', 'Your account is not active. Please register again or contact support.');

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

EXCEPTION
        WHEN OTHERS THEN
            RETURN json_build_object(
                'success', false,
                'error', 'Failed to create recovery request: ' || SQLERRM
            );

BEGIN
            SELECT array_agg(id::text) INTO v_admin_user_ids
            FROM public.users 
            WHERE (is_admin = true OR is_master_admin = true)
            AND status = 'active';

EXCEPTION
        WHEN OTHERS THEN
            -- Don't fail the whole recovery if notification fails
            RAISE NOTICE 'Failed to create notification: %', SQLERRM;

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

RETURN 'Restart requested successfully. Services will restart within 30 seconds.';

IF NOT FOUND THEN
        RAISE EXCEPTION 'Visit schedule not found with id: %', visit_id;

RETURN new_date;

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

RETURN v_notification_id;

PERFORM set_config('app.is_master_admin', is_master_admin::text, false);

PERFORM set_config('app.is_admin', is_admin::text, false);

func_record RECORD;

permissions_set INTEGER := 0;

BEGIN
    -- Get role ID
    SELECT id INTO v_role_id FROM user_roles WHERE role_code = p_role_code;

IF v_role_id IS NULL THEN
        RAISE NOTICE 'Role % not found', p_role_code;

permissions_set := permissions_set + 1;

RETURN permissions_set;

IF NOT FOUND THEN
        RAISE EXCEPTION 'Visit schedule not found with id: %', visit_id;

BEGIN
  -- Check if it's the default template
  SELECT is_default INTO is_default_template
  FROM flyer_templates
  WHERE id = template_id;

RETURN FOUND;

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

IF v_emp IS NULL THEN
    RETURN jsonb_build_object('success', false, 'error', 'Employee record not found');

RETURN jsonb_build_object('success', true, 'break_id', v_break_id);

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

v_quick_task_id := v_assignment_record.quick_task_id;

v_require_photo := v_assignment_record.require_photo_upload;

v_require_erp := v_assignment_record.require_erp_reference;

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

RETURN v_completion_id;

total_synced INTEGER := 0;

sync_details TEXT := '';

total_synced := total_synced + 1;

sync_details := sync_details || format('Synced receiving_record %s with ERP %s; ', 
                                              sync_record.receiving_record_id, 
                                              TRIM(sync_record.erp_reference_number));

RETURN QUERY SELECT total_synced, sync_details;

total_synced INTEGER := 0;

sync_details JSONB := '[]'::JSONB;

record_detail JSONB;

total_synced := total_synced + 1;

sync_details := sync_details || record_detail;

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

result_text := format('Synchronized %s app functions from component metadata', result_count);

RETURN result_text;

RETURN FOUND;

result_json JSONB;

BEGIN
    RAISE NOTICE 'Starting ERP sync for receiving_record_id: %', receiving_record_id_param;

ELSE
        RAISE NOTICE 'No task completion found, checking for existing ERP reference';

RETURN result_json;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'ERROR in sync function: %', SQLERRM;

RETURN jsonb_build_object(
            'success', false,
            'error', SQLERRM,
            'error_code', SQLSTATE
        );

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

RETURN NEW;

IF NEW.is_active = false AND OLD.is_active = true THEN
        NEW.deactivated_at = NOW();

RETURN NEW;

RETURN OLD;

RETURN OLD;

RETURN NEW;

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

v_message := 'Order #' || NEW.order_number || ' from ' || COALESCE(v_customer_name, NEW.customer_name) || ' - Total: ' || NEW.total_amount || ' SAR - ' || v_fulfillment_label_en || '|||??? #' || NEW.order_number || ' ?? ' || COALESCE(v_customer_name, NEW.customer_name) || ' - ??????: ' || NEW.total_amount || ' ?.? - ' || v_fulfillment_label_ar;

RETURN NEW;

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

RAISE LOG 'Staff push for new order % sent to % branch receivers, request_id: %', 
        NEW.order_number, jsonb_array_length(v_user_ids), v_request_id;

RETURN NEW;

RETURN NEW;

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

RETURN COALESCE(NEW, OLD);

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

ELSIF NEW.check_in_time IS NOT NULL THEN
        NEW.status = 'present';

ELSE
        NEW.status = 'absent';

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

ELSE
        NEW.deadline_datetime = NULL;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

BEGIN
      -- Determine the base amount to deduct from
      base_amount := COALESCE(NEW.original_final_amount, NEW.bill_amount);

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

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

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

new_next_date DATE;

BEGIN
    -- Get the visit record
    SELECT * INTO visit_record FROM vendor_visits WHERE id = visit_id;

IF NOT FOUND THEN
        RAISE EXCEPTION 'Visit schedule not found with id: %', visit_id;

RETURN new_next_date;

RETURN NEW;

RETURN NEW;

RETURN OLD;

RETURN NULL;

RAISE NOTICE 'Marked delivery as failed for notification % user %', NEW.notification_id, NEW.user_id;

RETURN NEW;

RETURN NEW;

RETURN COALESCE(NEW, OLD);

RETURN NEW;

RETURN NEW;

RETURN NEW;

v_user_name VARCHAR(255);

BEGIN
    -- Get current status
    SELECT order_status INTO v_current_status
    FROM orders
    WHERE id = p_order_id;

IF NOT FOUND THEN
        RETURN QUERY SELECT FALSE, 'Order not found';

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

can_complete BOOLEAN := true;

BEGIN
    -- Get receiving task details
    SELECT * INTO receiving_task 
    FROM receiving_tasks 
    WHERE id = receiving_task_id_param;

IF NOT FOUND THEN
        RAISE EXCEPTION 'Receiving task not found: %', receiving_task_id_param;

RETURN true;

RETURN false;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN COALESCE(NEW, OLD);

RETURN NEW;

RETURN NEW;

RETURN NEW;

v_status_label TEXT;

v_status_label_ar TEXT;

v_notif_type TEXT;

v_message TEXT;

v_title TEXT;

v_tasks_completed INTEGER := 0;

v_task_record RECORD;

IF v_requester_user_id IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'Request not found');

v_tasks_completed := v_tasks_completed + 1;

v_status_label_ar := 'مقبول ✅';

v_notif_type := 'success';

v_message := 'Your Stock Request has been approved.' || E'\n---\n' || 'طلب المخزون الخاص بك تم قبوله.';

ELSE
        v_status_label := 'Rejected ❌';

v_status_label_ar := 'مرفوض ❌';

v_notif_type := 'error';

v_message := 'Your Stock Request has been rejected.' || E'\n---\n' || 'طلب المخزون الخاص بك تم رفضه.';

v_title := 'ST Request ' || v_status_label || ' | طلب ST ' || v_status_label_ar;

RETURN jsonb_build_object(
        'success', true,
        'status', p_new_status,
        'tasks_completed', v_tasks_completed,
        'notification_sent', true
    );

EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object('success', false, 'error', SQLERRM);

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

EXCEPTION
  WHEN OTHERS THEN
    RETURN json_build_object(
      'success', false,
      'message', SQLERRM
    );

RETURN NEW;

RETURN NEW;

total_deductions NUMERIC;

calculated_final_amount NUMERIC;

BEGIN
  -- Get the bill_amount (this is always our base for calculation)
  SELECT bill_amount
  INTO current_bill_amount
  FROM vendor_payment_schedule
  WHERE id = payment_id;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN NEW;

RETURN v_id;

RETURN v_id;

RETURN v_id;

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

v_epoch bigint;

v_current_code text;

v_previous_code text;

BEGIN
    SELECT seed INTO v_seed FROM break_security_seed WHERE id = 1;

IF v_seed IS NULL THEN
        RETURN false;

v_epoch := floor(extract(epoch from now()) / 10)::bigint;

RETURN (p_code = v_current_code OR p_code = v_previous_code);

BEGIN
    -- Get the offer type
    SELECT type INTO v_offer_type FROM offers WHERE id = NEW.offer_id;

IF v_offer_type IS NULL THEN
        RAISE EXCEPTION 'Offer with id % does not exist', NEW.offer_id;

IF v_offer_type != 'bundle' THEN
        RAISE EXCEPTION 'Offer with id % must be of type "bundle" but is "%"', NEW.offer_id, v_offer_type;

RETURN NEW;

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

IF NOT v_is_eligible THEN
    RETURN jsonb_build_object(
      'eligible', false,
      'error_message', 'Customer is not eligible for this campaign'
    );

required_keys TEXT[] := ARRAY['id', 'number', 'x', 'y', 'width', 'height', 'fields'];

BEGIN
  -- Check if config is an array
  IF jsonb_typeof(config) != 'array' THEN
    RAISE EXCEPTION 'Configuration must be a JSON array';

RETURN true;

method TEXT;

methods TEXT[];

BEGIN
    IF payment_methods IS NULL OR LENGTH(TRIM(payment_methods)) = 0 THEN
        RETURN TRUE;

RETURN TRUE;

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

IF NOT v_is_active THEN
    RETURN FALSE;

IF NOW() < v_start_date OR NOW() > v_end_date THEN
    RETURN FALSE;

IF p_quantity < v_offer_qty THEN
    RETURN FALSE;

RETURN TRUE;

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

RETURN NEW;

v_otp_record RECORD;

v_whatsapp_clean VARCHAR(20);

v_hashed_code VARCHAR(255);

v_existing_count INT;

BEGIN
  v_whatsapp_clean := REGEXP_REPLACE(p_whatsapp, '[\s\-]', '', 'g');

IF v_user_id IS NULL THEN
    RETURN json_build_object('success', false, 'message', 'User not found.');

IF v_otp_record IS NULL THEN
    RETURN json_build_object('success', false, 'message', 'No valid OTP found. Please request a new one.');

RETURN json_build_object('success', false, 'message', 'Too many failed attempts. Please request a new OTP.');

RETURN json_build_object('success', false, 'message', 'Invalid OTP code.');

IF v_existing_count > 0 THEN
    RETURN json_build_object('success', false, 'message', 'This access code is already in use. Please choose a different one.');

RETURN json_build_object('success', true, 'message', 'Access code changed successfully.');

BEGIN
  -- Validate input format
  IF p_code IS NULL OR LENGTH(p_code) != 6 OR p_code !~ '^[0-9]{6}$' THEN
    RETURN json_build_object('success', false, 'error', 'Invalid access code format');

IF NOT FOUND THEN
    RETURN json_build_object('success', false, 'error', 'Invalid access code');

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

BEGIN
    IF is_approved THEN
        new_status := 'verified';

ELSE
        new_status := 'rejected';

RETURN FOUND;

SET default_tablespace = '';

SET default_table_access_method = heap;

To set up automatic daily execution:
1. Enable pg_cron extension in Supabase (may require contacting support)
2. Create cron job: 
   SELECT cron.schedule(''check-recurring-schedules'', ''0 6 * * *'', 
   $$SELECT check_and_notify_recurring_schedules_with_logging();$$);

Alternatively, use external cron service (GitHub Actions, Vercel Cron, etc.) to call:
POST https://your-project.supabase.co/rest/v1/rpc/check_and_notify_recurring_schedules_with_logging
';

GRANT USAGE ON SCHEMA public TO anon;

GRANT USAGE ON SCHEMA public TO authenticated;

GRANT USAGE ON SCHEMA public TO service_role;

GRANT USAGE ON SCHEMA public TO replication_user;

GRANT ALL ON TYPE public.resolution_status TO service_role;

GRANT ALL ON TYPE public.resolution_status TO anon;

GRANT ALL ON FUNCTION public.accept_order(p_order_id uuid, p_user_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.accept_order(p_order_id uuid, p_user_id uuid) TO anon;

GRANT ALL ON FUNCTION public.acknowledge_warning(warning_id_param uuid, acknowledged_by_param uuid) TO service_role;

GRANT ALL ON FUNCTION public.acknowledge_warning(warning_id_param uuid, acknowledged_by_param uuid) TO anon;

GRANT ALL ON FUNCTION public.adjust_product_stock_on_order_insert() TO service_role;

GRANT ALL ON FUNCTION public.adjust_product_stock_on_order_insert() TO anon;

GRANT ALL ON FUNCTION public.approve_customer_account(p_customer_id uuid, p_status text, p_notes text, p_approved_by uuid) TO anon;

GRANT ALL ON FUNCTION public.approve_customer_account(p_customer_id uuid, p_status text, p_notes text, p_approved_by uuid) TO service_role;

GRANT ALL ON FUNCTION public.approve_customer_registration(p_customer_id uuid, p_approved_by uuid, p_notes text) TO service_role;

GRANT ALL ON FUNCTION public.approve_customer_registration(p_customer_id uuid, p_approved_by uuid, p_notes text) TO anon;

GRANT ALL ON FUNCTION public.assign_order_delivery(p_order_id uuid, p_delivery_person_id uuid, p_assigned_by uuid) TO service_role;

GRANT ALL ON FUNCTION public.assign_order_delivery(p_order_id uuid, p_delivery_person_id uuid, p_assigned_by uuid) TO anon;

GRANT ALL ON FUNCTION public.assign_order_picker(p_order_id uuid, p_picker_id uuid, p_assigned_by uuid) TO service_role;

GRANT ALL ON FUNCTION public.assign_order_picker(p_order_id uuid, p_picker_id uuid, p_assigned_by uuid) TO anon;

GRANT ALL ON FUNCTION public.assign_task_simple(task_id_param uuid, assigned_to_user_id_param uuid, assigned_by_param text, assigned_by_name_param text, deadline_datetime_param timestamp with time zone, priority_param text, notes_param text) TO service_role;

GRANT ALL ON FUNCTION public.assign_task_simple(task_id_param uuid, assigned_to_user_id_param uuid, assigned_by_param text, assigned_by_name_param text, deadline_datetime_param timestamp with time zone, priority_param text, notes_param text) TO anon;

GRANT ALL ON FUNCTION public.authenticate_customer_access_code(p_access_code text) TO anon;

GRANT ALL ON FUNCTION public.auto_create_payment_schedule() TO service_role;

GRANT ALL ON FUNCTION public.auto_create_payment_schedule() TO anon;

GRANT ALL ON FUNCTION public.bulk_import_customers(p_phone_numbers text[]) TO anon;

GRANT ALL ON FUNCTION public.bulk_import_customers(p_phone_numbers text[]) TO service_role;

GRANT ALL ON FUNCTION public.bulk_toggle_customer_product(p_barcodes text[], p_value boolean) TO service_role;

GRANT ALL ON FUNCTION public.calculate_category_days() TO service_role;

GRANT ALL ON FUNCTION public.calculate_category_days() TO anon;

GRANT ALL ON FUNCTION public.calculate_flyer_product_profit() TO service_role;

GRANT ALL ON FUNCTION public.calculate_flyer_product_profit() TO anon;

GRANT ALL ON FUNCTION public.calculate_next_visit_date(visit_type text, weekday_name text, fresh_type text, day_number integer, skip_days integer, start_date date, current_next_date date) TO service_role;

GRANT ALL ON FUNCTION public.calculate_next_visit_date(visit_type text, weekday_name text, fresh_type text, day_number integer, skip_days integer, start_date date, current_next_date date) TO anon;

GRANT ALL ON FUNCTION public.calculate_profit() TO service_role;

GRANT ALL ON FUNCTION public.calculate_profit() TO anon;

GRANT ALL ON FUNCTION public.calculate_receiving_amounts() TO service_role;

GRANT ALL ON FUNCTION public.calculate_receiving_amounts() TO anon;

GRANT ALL ON FUNCTION public.calculate_return_totals() TO service_role;

GRANT ALL ON FUNCTION public.calculate_return_totals() TO anon;

GRANT ALL ON FUNCTION public.calculate_schedule_details() TO service_role;

GRANT ALL ON FUNCTION public.calculate_schedule_details() TO anon;

GRANT ALL ON FUNCTION public.calculate_working_hours() TO service_role;

GRANT ALL ON FUNCTION public.calculate_working_hours() TO anon;

GRANT ALL ON FUNCTION public.calculate_working_hours(check_in timestamp with time zone, check_out timestamp with time zone) TO service_role;

GRANT ALL ON FUNCTION public.calculate_working_hours(check_in timestamp with time zone, check_out timestamp with time zone) TO anon;

GRANT ALL ON FUNCTION public.calculate_working_hours(start_time time without time zone, end_time time without time zone, is_overnight_shift boolean) TO service_role;

GRANT ALL ON FUNCTION public.calculate_working_hours(start_time time without time zone, end_time time without time zone, is_overnight_shift boolean) TO anon;

GRANT ALL ON FUNCTION public.cancel_order(p_order_id uuid, p_user_id uuid, p_cancellation_reason text) TO service_role;

GRANT ALL ON FUNCTION public.cancel_order(p_order_id uuid, p_user_id uuid, p_cancellation_reason text) TO anon;

GRANT ALL ON FUNCTION public.check_accountant_dependency(receiving_record_id_param uuid) TO service_role;

GRANT ALL ON FUNCTION public.check_accountant_dependency(receiving_record_id_param uuid) TO anon;

GRANT ALL ON FUNCTION public.check_and_notify_recurring_schedules() TO service_role;

GRANT ALL ON FUNCTION public.check_and_notify_recurring_schedules() TO anon;

GRANT ALL ON FUNCTION public.check_and_notify_recurring_schedules_with_logging() TO service_role;

GRANT ALL ON FUNCTION public.check_and_notify_recurring_schedules_with_logging() TO anon;

GRANT ALL ON FUNCTION public.check_erp_sync_status() TO service_role;

GRANT ALL ON FUNCTION public.check_erp_sync_status() TO anon;

GRANT ALL ON FUNCTION public.check_erp_sync_status_for_record(receiving_record_id_param uuid) TO service_role;

GRANT ALL ON FUNCTION public.check_erp_sync_status_for_record(receiving_record_id_param uuid) TO anon;

GRANT ALL ON FUNCTION public.check_offer_eligibility(p_offer_id integer, p_customer_id uuid, p_cart_total numeric, p_cart_quantity integer) TO service_role;

GRANT ALL ON FUNCTION public.check_offer_eligibility(p_offer_id integer, p_customer_id uuid, p_cart_total numeric, p_cart_quantity integer) TO anon;

GRANT ALL ON FUNCTION public.check_orphaned_variations() TO service_role;

GRANT ALL ON FUNCTION public.check_orphaned_variations() TO anon;

GRANT ALL ON FUNCTION public.check_overdue_tasks_and_send_reminders() TO service_role;

GRANT ALL ON FUNCTION public.check_overdue_tasks_and_send_reminders() TO anon;

GRANT ALL ON FUNCTION public.check_receiving_task_dependencies(receiving_record_id_param uuid, role_type_param text) TO service_role;

GRANT ALL ON FUNCTION public.check_receiving_task_dependencies(receiving_record_id_param uuid, role_type_param text) TO anon;

GRANT ALL ON FUNCTION public.check_task_completion_criteria(task_uuid uuid, task_finished_val boolean, photo_uploaded_val boolean, erp_reference_val boolean) TO service_role;

GRANT ALL ON FUNCTION public.check_task_completion_criteria(task_uuid uuid, task_finished_val boolean, photo_uploaded_val boolean, erp_reference_val boolean) TO anon;

GRANT ALL ON FUNCTION public.check_user_permission(p_function_code text, p_permission text) TO service_role;

GRANT ALL ON FUNCTION public.check_user_permission(p_function_code text, p_permission text) TO anon;

GRANT ALL ON FUNCTION public.check_visit_conflicts(branch_uuid uuid, visit_date_param date, visit_time_param time without time zone, duration_minutes integer, exclude_visit_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.check_visit_conflicts(branch_uuid uuid, visit_date_param date, visit_time_param time without time zone, duration_minutes integer, exclude_visit_id uuid) TO anon;

GRANT ALL ON FUNCTION public.claim_coupon(p_campaign_id uuid, p_mobile_number character varying, p_product_id uuid, p_branch_id bigint, p_user_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.claim_coupon(p_campaign_id uuid, p_mobile_number character varying, p_product_id uuid, p_branch_id bigint, p_user_id uuid) TO anon;

GRANT ALL ON FUNCTION public.cleanup_expired_sessions() TO service_role;

GRANT ALL ON FUNCTION public.cleanup_expired_sessions() TO anon;

GRANT ALL ON FUNCTION public.clear_main_document_columns() TO service_role;

GRANT ALL ON FUNCTION public.clear_main_document_columns() TO anon;

GRANT ALL ON FUNCTION public.clear_sync_tables(p_tables text[]) TO anon;

GRANT ALL ON FUNCTION public.clear_sync_tables(p_tables text[]) TO service_role;

GRANT ALL ON FUNCTION public.complete_receiving_task(receiving_task_id_param uuid, user_id_param uuid, erp_reference_param character varying, original_bill_file_path_param text, has_erp_purchase_invoice boolean, has_pr_excel_file boolean, has_original_bill boolean, completion_photo_url_param text, completion_notes_param text) TO service_role;

GRANT ALL ON FUNCTION public.complete_receiving_task(receiving_task_id_param uuid, user_id_param uuid, erp_reference_param character varying, original_bill_file_path_param text, has_erp_purchase_invoice boolean, has_pr_excel_file boolean, has_original_bill boolean, completion_photo_url_param text, completion_notes_param text) TO anon;

GRANT ALL ON FUNCTION public.complete_receiving_task_fixed(receiving_task_id_param uuid, user_id_param uuid, completion_photo_url_param text, completion_notes_param text) TO service_role;

GRANT ALL ON FUNCTION public.complete_receiving_task_fixed(receiving_task_id_param uuid, user_id_param uuid, completion_photo_url_param text, completion_notes_param text) TO anon;

GRANT ALL ON FUNCTION public.complete_receiving_task_simple(receiving_task_id_param uuid, user_id_param uuid, completion_photo_url_param text, completion_notes_param text) TO service_role;

GRANT ALL ON FUNCTION public.complete_receiving_task_simple(receiving_task_id_param uuid, user_id_param uuid, completion_photo_url_param text, completion_notes_param text) TO anon;

GRANT ALL ON FUNCTION public.copy_completion_requirements_to_assignment() TO service_role;

GRANT ALL ON FUNCTION public.copy_completion_requirements_to_assignment() TO anon;

GRANT ALL ON FUNCTION public.count_bills_without_erp_reference() TO service_role;

GRANT ALL ON FUNCTION public.count_bills_without_erp_reference() TO anon;

GRANT ALL ON FUNCTION public.count_bills_without_erp_reference_by_branch(branch_id_param bigint) TO service_role;

GRANT ALL ON FUNCTION public.count_bills_without_erp_reference_by_branch(branch_id_param bigint) TO anon;

GRANT ALL ON FUNCTION public.count_bills_without_original() TO service_role;

GRANT ALL ON FUNCTION public.count_bills_without_original() TO anon;

GRANT ALL ON FUNCTION public.count_bills_without_original_by_branch(branch_id_param bigint) TO service_role;

GRANT ALL ON FUNCTION public.count_bills_without_original_by_branch(branch_id_param bigint) TO anon;

GRANT ALL ON FUNCTION public.count_bills_without_pr_excel() TO service_role;

GRANT ALL ON FUNCTION public.count_bills_without_pr_excel() TO anon;

GRANT ALL ON FUNCTION public.count_bills_without_pr_excel_by_branch(branch_id_param bigint) TO service_role;

GRANT ALL ON FUNCTION public.count_bills_without_pr_excel_by_branch(branch_id_param bigint) TO anon;

GRANT ALL ON FUNCTION public.count_completed_receiving_tasks() TO service_role;

GRANT ALL ON FUNCTION public.count_completed_receiving_tasks() TO anon;

GRANT ALL ON FUNCTION public.count_finished_receiving_tasks() TO service_role;

GRANT ALL ON FUNCTION public.count_finished_receiving_tasks() TO anon;

GRANT ALL ON FUNCTION public.count_incomplete_receiving_tasks() TO service_role;

GRANT ALL ON FUNCTION public.count_incomplete_receiving_tasks() TO anon;

GRANT ALL ON FUNCTION public.count_incomplete_receiving_tasks_detailed() TO service_role;

GRANT ALL ON FUNCTION public.count_incomplete_receiving_tasks_detailed() TO anon;

GRANT ALL ON FUNCTION public.create_customer_order(p_customer_id uuid, p_branch_id bigint, p_selected_location jsonb, p_fulfillment_method character varying, p_payment_method character varying, p_subtotal_amount numeric, p_delivery_fee numeric, p_discount_amount numeric, p_tax_amount numeric, p_total_amount numeric, p_total_items integer, p_total_quantity integer, p_customer_notes text) TO service_role;

GRANT ALL ON FUNCTION public.create_customer_order(p_customer_id uuid, p_branch_id bigint, p_selected_location jsonb, p_fulfillment_method character varying, p_payment_method character varying, p_subtotal_amount numeric, p_delivery_fee numeric, p_discount_amount numeric, p_tax_amount numeric, p_total_amount numeric, p_total_items integer, p_total_quantity integer, p_customer_notes text) TO anon;

GRANT ALL ON FUNCTION public.create_customer_registration(p_name text, p_whatsapp_number text, p_branch_id uuid) TO anon;

GRANT ALL ON FUNCTION public.create_default_auto_schedule_config(p_branch_id bigint, p_start_time time without time zone, p_end_time time without time zone) TO service_role;

GRANT ALL ON FUNCTION public.create_default_auto_schedule_config(p_branch_id bigint, p_start_time time without time zone, p_end_time time without time zone) TO anon;

GRANT ALL ON FUNCTION public.create_default_auto_schedule_config(p_branch_id uuid, p_start_time time without time zone, p_end_time time without time zone) TO service_role;

GRANT ALL ON FUNCTION public.create_default_auto_schedule_config(p_branch_id uuid, p_start_time time without time zone, p_end_time time without time zone) TO anon;

GRANT ALL ON FUNCTION public.create_default_interface_permissions() TO service_role;

GRANT ALL ON FUNCTION public.create_default_interface_permissions() TO anon;

GRANT ALL ON FUNCTION public.create_notification_recipients() TO service_role;

GRANT ALL ON FUNCTION public.create_notification_recipients() TO anon;

GRANT ALL ON FUNCTION public.create_notification_simple(title_param text, message_param text, created_by_param text, created_by_name_param text, target_user_id_param uuid, task_id_param uuid, assignment_id_param uuid) TO service_role;

GRANT ALL ON FUNCTION public.create_notification_simple(title_param text, message_param text, created_by_param text, created_by_name_param text, target_user_id_param uuid, task_id_param uuid, assignment_id_param uuid) TO anon;

GRANT ALL ON FUNCTION public.create_quick_task_notification() TO service_role;

GRANT ALL ON FUNCTION public.create_quick_task_notification() TO anon;

GRANT ALL ON FUNCTION public.create_quick_task_with_assignments(title_param character varying, description_param text, priority_param character varying, deadline_param timestamp with time zone, created_by_param uuid, assigned_user_ids uuid[], require_task_finished_param boolean, require_photo_upload_param boolean, require_erp_reference_param boolean) TO service_role;

GRANT ALL ON FUNCTION public.create_quick_task_with_assignments(title_param character varying, description_param text, priority_param character varying, deadline_param timestamp with time zone, created_by_param uuid, assigned_user_ids uuid[], require_task_finished_param boolean, require_photo_upload_param boolean, require_erp_reference_param boolean) TO anon;

GRANT ALL ON FUNCTION public.create_recurring_assignment(task_id uuid, assigned_to uuid, assigned_by uuid, recurrence_pattern character varying, start_date date, end_date date) TO service_role;

GRANT ALL ON FUNCTION public.create_recurring_assignment(task_id uuid, assigned_to uuid, assigned_by uuid, recurrence_pattern character varying, start_date date, end_date date) TO anon;

GRANT ALL ON FUNCTION public.create_recurring_assignment(p_task_id uuid, p_assignment_type text, p_assigned_by text, p_repeat_type text, p_assigned_to_user_id text, p_assigned_to_branch_id uuid, p_assigned_by_name text, p_repeat_interval integer, p_repeat_on_days integer[], p_execute_time time without time zone, p_start_date date, p_end_date date, p_max_occurrences integer, p_notes text, p_is_reassignable boolean) TO service_role;

GRANT ALL ON FUNCTION public.create_recurring_assignment(p_task_id uuid, p_assignment_type text, p_assigned_by text, p_repeat_type text, p_assigned_to_user_id text, p_assigned_to_branch_id uuid, p_assigned_by_name text, p_repeat_interval integer, p_repeat_on_days integer[], p_execute_time time without time zone, p_start_date date, p_end_date date, p_max_occurrences integer, p_notes text, p_is_reassignable boolean) TO anon;

GRANT ALL ON FUNCTION public.create_schedule_template(p_branch_id bigint, p_template_name character varying, p_start_time time without time zone, p_end_time time without time zone, p_weekdays_only boolean) TO service_role;

GRANT ALL ON FUNCTION public.create_schedule_template(p_branch_id bigint, p_template_name character varying, p_start_time time without time zone, p_end_time time without time zone, p_weekdays_only boolean) TO anon;

GRANT ALL ON FUNCTION public.create_schedule_template(p_branch_id uuid, p_template_name character varying, p_start_time time without time zone, p_end_time time without time zone, p_weekdays_only boolean) TO service_role;

GRANT ALL ON FUNCTION public.create_schedule_template(p_branch_id uuid, p_template_name character varying, p_start_time time without time zone, p_end_time time without time zone, p_weekdays_only boolean) TO anon;

GRANT ALL ON FUNCTION public.create_scheduled_assignment(task_id uuid, assigned_to uuid, assigned_by uuid, scheduled_for timestamp with time zone, priority character varying) TO service_role;

GRANT ALL ON FUNCTION public.create_scheduled_assignment(task_id uuid, assigned_to uuid, assigned_by uuid, scheduled_for timestamp with time zone, priority character varying) TO anon;

GRANT ALL ON FUNCTION public.create_scheduled_assignment(p_task_id uuid, p_assignment_type text, p_assigned_by text, p_assigned_to_user_id text, p_assigned_to_branch_id uuid, p_assigned_by_name text, p_schedule_date date, p_schedule_time time without time zone, p_deadline_date date, p_deadline_time time without time zone, p_is_reassignable boolean, p_notes text, p_priority_override text, p_require_task_finished boolean, p_require_photo_upload boolean, p_require_erp_reference boolean) TO service_role;

GRANT ALL ON FUNCTION public.create_scheduled_assignment(p_task_id uuid, p_assignment_type text, p_assigned_by text, p_assigned_to_user_id text, p_assigned_to_branch_id uuid, p_assigned_by_name text, p_schedule_date date, p_schedule_time time without time zone, p_deadline_date date, p_deadline_time time without time zone, p_is_reassignable boolean, p_notes text, p_priority_override text, p_require_task_finished boolean, p_require_photo_upload boolean, p_require_erp_reference boolean) TO anon;

GRANT ALL ON FUNCTION public.create_system_admin(p_username text, p_password text, p_quick_access_code text, p_is_master_admin boolean, p_user_type public.user_type_enum) TO service_role;

GRANT ALL ON FUNCTION public.create_system_admin(p_username text, p_password text, p_quick_access_code text, p_is_master_admin boolean, p_user_type public.user_type_enum) TO anon;

GRANT ALL ON FUNCTION public.create_system_admin(p_username text, p_password text, p_quick_access_code text, p_role_type public.role_type_enum, p_user_type public.user_type_enum) TO service_role;

GRANT ALL ON FUNCTION public.create_system_admin(p_username text, p_password text, p_quick_access_code text, p_role_type public.role_type_enum, p_user_type public.user_type_enum) TO anon;

GRANT ALL ON FUNCTION public.create_task(title_param text, description_param text, created_by_param text, created_by_name_param text, created_by_role_param text, priority_param text, due_date_param date, due_time_param time without time zone, require_task_finished_param boolean, require_photo_upload_param boolean, require_erp_reference_param boolean, can_escalate_param boolean, can_reassign_param boolean) TO service_role;

GRANT ALL ON FUNCTION public.create_task(title_param text, description_param text, created_by_param text, created_by_name_param text, created_by_role_param text, priority_param text, due_date_param date, due_time_param time without time zone, require_task_finished_param boolean, require_photo_upload_param boolean, require_erp_reference_param boolean, can_escalate_param boolean, can_reassign_param boolean) TO anon;

GRANT ALL ON FUNCTION public.create_user(p_username character varying, p_password character varying, p_is_master_admin boolean, p_is_admin boolean, p_user_type character varying, p_branch_id bigint, p_employee_id uuid, p_position_id uuid, p_quick_access_code character varying) TO service_role;

GRANT ALL ON FUNCTION public.create_user(p_username character varying, p_password character varying, p_is_master_admin boolean, p_is_admin boolean, p_user_type character varying, p_branch_id bigint, p_employee_id uuid, p_position_id uuid, p_quick_access_code character varying) TO anon;

GRANT ALL ON FUNCTION public.create_user_profile() TO service_role;

GRANT ALL ON FUNCTION public.create_user_profile() TO anon;

GRANT ALL ON FUNCTION public.create_variation_group(p_parent_barcode text, p_variation_barcodes text[], p_group_name_en text, p_group_name_ar text, p_image_override text, p_user_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.create_variation_group(p_parent_barcode text, p_variation_barcodes text[], p_group_name_en text, p_group_name_ar text, p_image_override text, p_user_id uuid) TO anon;

GRANT ALL ON FUNCTION public.create_warning_history() TO service_role;

GRANT ALL ON FUNCTION public.create_warning_history() TO anon;

GRANT ALL ON FUNCTION public.current_user_is_admin() TO anon;

GRANT ALL ON FUNCTION public.current_user_is_admin() TO service_role;

GRANT ALL ON FUNCTION public.daily_erp_sync_maintenance() TO service_role;

GRANT ALL ON FUNCTION public.daily_erp_sync_maintenance() TO anon;

GRANT ALL ON FUNCTION public.deactivate_expired_media() TO service_role;

GRANT ALL ON FUNCTION public.deactivate_expired_media() TO anon;

GRANT ALL ON FUNCTION public.debug_get_dependency_photos(receiving_record_id_param uuid, dependency_role_types text[]) TO service_role;

GRANT ALL ON FUNCTION public.debug_get_dependency_photos(receiving_record_id_param uuid, dependency_role_types text[]) TO anon;

GRANT ALL ON FUNCTION public.debug_receiving_tasks_data() TO service_role;

GRANT ALL ON FUNCTION public.debug_receiving_tasks_data() TO anon;

GRANT ALL ON FUNCTION public.debug_users() TO service_role;

GRANT ALL ON FUNCTION public.debug_users() TO anon;

GRANT ALL ON FUNCTION public.decrement_voucher_stock(voucher_value numeric, decrement_amount integer) TO service_role;

GRANT ALL ON FUNCTION public.decrement_voucher_stock(voucher_value numeric, decrement_amount integer) TO anon;

GRANT ALL ON FUNCTION public.delete_branch_sync_config(p_id bigint) TO anon;

GRANT ALL ON FUNCTION public.delete_branch_sync_config(p_id bigint) TO service_role;

GRANT ALL ON FUNCTION public.delete_customer_account(p_customer_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.delete_customer_account(p_customer_id uuid) TO anon;

GRANT ALL ON FUNCTION public.delete_incident_cascade(p_incident_id text) TO anon;

GRANT ALL ON FUNCTION public.denomination_audit_trigger() TO service_role;

GRANT ALL ON FUNCTION public.denomination_audit_trigger() TO anon;

GRANT ALL ON FUNCTION public.duplicate_flyer_template(template_id uuid, new_name character varying, user_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.duplicate_flyer_template(template_id uuid, new_name character varying, user_id uuid) TO anon;

GRANT ALL ON FUNCTION public.end_break(p_user_id uuid) TO anon;

GRANT ALL ON FUNCTION public.end_break(p_user_id uuid, p_security_code text) TO anon;

GRANT ALL ON FUNCTION public.ensure_single_default_flyer_template() TO service_role;

GRANT ALL ON FUNCTION public.ensure_single_default_flyer_template() TO anon;

GRANT ALL ON FUNCTION public.export_schema_ddl() TO service_role;

GRANT ALL ON FUNCTION public.export_table_for_sync(p_table_name text) TO anon;

GRANT ALL ON FUNCTION public.format_file_size(size_bytes bigint) TO service_role;

GRANT ALL ON FUNCTION public.format_file_size(size_bytes bigint) TO anon;

GRANT ALL ON FUNCTION public.generate_branch_id() TO service_role;

GRANT ALL ON FUNCTION public.generate_branch_id() TO anon;

GRANT ALL ON FUNCTION public.generate_campaign_code() TO service_role;

GRANT ALL ON FUNCTION public.generate_campaign_code() TO anon;

GRANT ALL ON FUNCTION public.generate_clearance_certificate_tasks(receiving_record_id_param uuid, clearance_certificate_url_param text, created_by_user_id text, created_by_name text, created_by_role text) TO service_role;

GRANT ALL ON FUNCTION public.generate_clearance_certificate_tasks(receiving_record_id_param uuid, clearance_certificate_url_param text, created_by_user_id text, created_by_name text, created_by_role text) TO anon;

GRANT ALL ON FUNCTION public.generate_insurance_company_id() TO service_role;

GRANT ALL ON FUNCTION public.generate_insurance_company_id() TO anon;

GRANT ALL ON FUNCTION public.generate_new_customer_access_code(p_customer_id uuid, p_admin_user_id uuid, p_notes text) TO anon;

GRANT ALL ON FUNCTION public.generate_order_number() TO service_role;

GRANT ALL ON FUNCTION public.generate_order_number() TO anon;

GRANT ALL ON FUNCTION public.generate_recurring_occurrences(p_parent_id integer, p_source_table text) TO service_role;

GRANT ALL ON FUNCTION public.generate_recurring_occurrences(p_parent_id integer, p_source_table text) TO anon;

GRANT ALL ON FUNCTION public.generate_salt() TO service_role;

GRANT ALL ON FUNCTION public.generate_salt() TO anon;

GRANT ALL ON FUNCTION public.generate_unique_customer_access_code() TO service_role;

GRANT ALL ON FUNCTION public.generate_unique_customer_access_code() TO anon;

GRANT ALL ON FUNCTION public.generate_unique_quick_access_code() TO service_role;

GRANT ALL ON FUNCTION public.generate_unique_quick_access_code() TO anon;

GRANT ALL ON FUNCTION public.generate_warning_reference() TO service_role;

GRANT ALL ON FUNCTION public.generate_warning_reference() TO anon;

GRANT ALL ON FUNCTION public.get_active_break(p_user_id uuid) TO anon;

GRANT ALL ON FUNCTION public.get_active_customer_media() TO service_role;

GRANT ALL ON FUNCTION public.get_active_customer_media() TO anon;

GRANT ALL ON FUNCTION public.get_active_employees_by_branch(branch_uuid uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_active_employees_by_branch(branch_uuid uuid) TO anon;

GRANT ALL ON FUNCTION public.get_active_flyer_templates() TO service_role;

GRANT ALL ON FUNCTION public.get_active_flyer_templates() TO anon;

GRANT ALL ON FUNCTION public.get_active_offers_for_customer(p_customer_id uuid, p_branch_id integer, p_service_type character varying) TO service_role;

GRANT ALL ON FUNCTION public.get_active_offers_for_customer(p_customer_id uuid, p_branch_id integer, p_service_type character varying) TO anon;

GRANT ALL ON FUNCTION public.get_all_breaks(p_date_from date, p_date_to date, p_branch_id integer, p_status character varying) TO anon;

GRANT ALL ON FUNCTION public.get_all_delivery_tiers() TO service_role;

GRANT ALL ON FUNCTION public.get_all_delivery_tiers() TO anon;

GRANT ALL ON FUNCTION public.get_all_products_master() TO authenticated;

GRANT ALL ON FUNCTION public.get_all_products_master() TO service_role;

GRANT ALL ON FUNCTION public.get_all_receiving_tasks() TO service_role;

GRANT ALL ON FUNCTION public.get_all_receiving_tasks() TO anon;

GRANT ALL ON FUNCTION public.get_all_users() TO service_role;

GRANT ALL ON FUNCTION public.get_all_users() TO anon;

GRANT ALL ON FUNCTION public.get_app_icons() TO anon;

GRANT ALL ON FUNCTION public.get_approval_center_data(p_user_id uuid) TO anon;

GRANT ALL ON FUNCTION public.get_approval_center_data(p_user_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_assignments_with_deadlines(user_id uuid, days_ahead integer) TO service_role;

GRANT ALL ON FUNCTION public.get_assignments_with_deadlines(user_id uuid, days_ahead integer) TO anon;

GRANT ALL ON FUNCTION public.get_assignments_with_deadlines(p_user_id text, p_branch_id uuid, p_include_overdue boolean, p_days_ahead integer) TO service_role;

GRANT ALL ON FUNCTION public.get_assignments_with_deadlines(p_user_id text, p_branch_id uuid, p_include_overdue boolean, p_days_ahead integer) TO anon;

GRANT ALL ON FUNCTION public.get_branch_delivery_settings(p_branch_id bigint) TO service_role;

GRANT ALL ON FUNCTION public.get_branch_delivery_settings(p_branch_id bigint) TO anon;

GRANT ALL ON FUNCTION public.get_branch_promissory_notes_summary(branch_uuid uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_branch_promissory_notes_summary(branch_uuid uuid) TO anon;

GRANT ALL ON FUNCTION public.get_branch_service_availability(branch_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_branch_service_availability(branch_id uuid) TO anon;

GRANT ALL ON FUNCTION public.get_branch_sync_configs() TO anon;

GRANT ALL ON FUNCTION public.get_branch_sync_configs() TO service_role;

GRANT ALL ON FUNCTION public.get_branch_visits_summary(branch_uuid uuid, start_date date, end_date date) TO service_role;

GRANT ALL ON FUNCTION public.get_branch_visits_summary(branch_uuid uuid, start_date date, end_date date) TO anon;

GRANT ALL ON FUNCTION public.get_break_security_code() TO anon;

GRANT ALL ON FUNCTION public.get_break_summary_all_employees(p_date_from date, p_date_to date, p_branch_id integer) TO anon;

GRANT ALL ON FUNCTION public.get_broadcast_recipients(p_broadcast_id uuid, p_limit integer, p_offset integer, p_status_filter text) TO anon;

GRANT ALL ON FUNCTION public.get_broadcast_summary(p_broadcast_id uuid) TO anon;

GRANT ALL ON FUNCTION public.get_bt_assigned_ims(p_request_ids uuid[]) TO anon;

GRANT ALL ON FUNCTION public.get_bt_requests_with_details() TO anon;

GRANT ALL ON FUNCTION public.get_bucket_files(p_bucket_id text) TO anon;

GRANT ALL ON FUNCTION public.get_campaign_statistics(p_campaign_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_campaign_statistics(p_campaign_id uuid) TO anon;

GRANT ALL ON FUNCTION public.get_cart_tier_discount(p_offer_id integer, p_cart_amount numeric) TO service_role;

GRANT ALL ON FUNCTION public.get_cart_tier_discount(p_offer_id integer, p_cart_amount numeric) TO anon;

GRANT ALL ON FUNCTION public.get_close_purchase_voucher_data() TO anon;

GRANT ALL ON FUNCTION public.get_closed_boxes(p_branch_id text, p_date_from timestamp with time zone, p_date_to timestamp with time zone, p_limit integer, p_offset integer) TO anon;

GRANT ALL ON FUNCTION public.get_completed_receiving_tasks() TO service_role;

GRANT ALL ON FUNCTION public.get_completed_receiving_tasks() TO anon;

GRANT ALL ON FUNCTION public.get_contact_broadcast_stats(phone_number text) TO anon;

GRANT ALL ON FUNCTION public.get_current_user_id() TO anon;

GRANT ALL ON FUNCTION public.get_current_user_id() TO service_role;

GRANT ALL ON FUNCTION public.get_customer_products_with_offers(p_branch_id text, p_service_type text) TO service_role;

GRANT ALL ON FUNCTION public.get_customer_products_with_offers(p_branch_id text, p_service_type text) TO anon;

GRANT ALL ON FUNCTION public.get_customer_requests_with_details() TO anon;

GRANT ALL ON FUNCTION public.get_customers_list_paginated(p_search text, p_status text, p_limit integer, p_offset integer) TO anon;

GRANT ALL ON FUNCTION public.get_database_functions() TO anon;

GRANT ALL ON FUNCTION public.get_database_schema() TO service_role;

GRANT ALL ON FUNCTION public.get_database_schema() TO anon;

GRANT ALL ON FUNCTION public.get_database_triggers() TO service_role;

GRANT ALL ON FUNCTION public.get_database_triggers() TO anon;

GRANT ALL ON FUNCTION public.get_day_offs_with_details(p_date_from date, p_date_to date) TO anon;

GRANT ALL ON FUNCTION public.get_default_flyer_template() TO service_role;

GRANT ALL ON FUNCTION public.get_default_flyer_template() TO anon;

GRANT ALL ON FUNCTION public.get_delivery_fee_for_amount(order_amount numeric) TO service_role;

GRANT ALL ON FUNCTION public.get_delivery_fee_for_amount(order_amount numeric) TO anon;

GRANT ALL ON FUNCTION public.get_delivery_fee_for_amount_by_branch(p_branch_id bigint, p_order_amount numeric) TO service_role;

GRANT ALL ON FUNCTION public.get_delivery_fee_for_amount_by_branch(p_branch_id bigint, p_order_amount numeric) TO anon;

GRANT ALL ON FUNCTION public.get_delivery_service_settings() TO service_role;

GRANT ALL ON FUNCTION public.get_delivery_service_settings() TO anon;

GRANT ALL ON FUNCTION public.get_delivery_tiers_by_branch(p_branch_id bigint) TO service_role;

GRANT ALL ON FUNCTION public.get_delivery_tiers_by_branch(p_branch_id bigint) TO anon;

GRANT ALL ON FUNCTION public.get_dependency_completion_photos(receiving_record_id_param uuid, dependency_role_types text[]) TO service_role;

GRANT ALL ON FUNCTION public.get_dependency_completion_photos(receiving_record_id_param uuid, dependency_role_types text[]) TO anon;

GRANT ALL ON FUNCTION public.get_edge_function_logs(p_limit integer) TO service_role;

GRANT ALL ON FUNCTION public.get_edge_functions() TO anon;

GRANT ALL ON FUNCTION public.get_employee_basic_hours(p_employee_id bigint) TO service_role;

GRANT ALL ON FUNCTION public.get_employee_basic_hours(p_employee_id bigint) TO anon;

GRANT ALL ON FUNCTION public.get_employee_basic_hours(p_employee_id uuid, p_date date) TO service_role;

GRANT ALL ON FUNCTION public.get_employee_basic_hours(p_employee_id uuid, p_date date) TO anon;

GRANT ALL ON FUNCTION public.get_employee_document_category_stats(emp_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_employee_document_category_stats(emp_id uuid) TO anon;

GRANT ALL ON FUNCTION public.get_employee_schedules(p_employee_id bigint, p_start_date date, p_end_date date) TO service_role;

GRANT ALL ON FUNCTION public.get_employee_schedules(p_employee_id bigint, p_start_date date, p_end_date date) TO anon;

GRANT ALL ON FUNCTION public.get_employee_schedules(p_employee_id uuid, p_start_date date, p_end_date date) TO service_role;

GRANT ALL ON FUNCTION public.get_employee_schedules(p_employee_id uuid, p_start_date date, p_end_date date) TO anon;

GRANT ALL ON FUNCTION public.get_expense_category_stats() TO service_role;

GRANT ALL ON FUNCTION public.get_expense_category_stats() TO anon;

GRANT ALL ON FUNCTION public.get_file_extension(filename text) TO service_role;

GRANT ALL ON FUNCTION public.get_file_extension(filename text) TO anon;

GRANT ALL ON FUNCTION public.get_flyer_generator_data(p_offer_id uuid) TO anon;

GRANT ALL ON FUNCTION public.get_flyer_generator_data(p_offer_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_incident_manager_data() TO service_role;

GRANT ALL ON FUNCTION public.get_incident_manager_data() TO anon;

GRANT ALL ON FUNCTION public.get_incomplete_receiving_tasks() TO service_role;

GRANT ALL ON FUNCTION public.get_incomplete_receiving_tasks() TO anon;

GRANT ALL ON FUNCTION public.get_incomplete_receiving_tasks_breakdown() TO service_role;

GRANT ALL ON FUNCTION public.get_incomplete_receiving_tasks_breakdown() TO anon;

GRANT ALL ON FUNCTION public.get_issue_pv_vouchers(p_pv_id text, p_serial_number bigint) TO anon;

GRANT ALL ON FUNCTION public.get_latest_frontend_build() TO anon;

GRANT ALL ON FUNCTION public.get_latest_frontend_build() TO service_role;

GRANT ALL ON FUNCTION public.get_lease_rent_properties_with_spaces() TO service_role;

GRANT ALL ON FUNCTION public.get_lease_rent_properties_with_spaces() TO anon;

GRANT ALL ON FUNCTION public.get_lease_rent_tab_data(p_party_type text) TO service_role;

GRANT ALL ON FUNCTION public.get_lease_rent_tab_data(p_party_type text) TO anon;

GRANT ALL ON FUNCTION public.get_mobile_dashboard_data(p_user_id uuid) TO anon;

GRANT ALL ON FUNCTION public.get_next_delivery_tier(current_amount numeric) TO service_role;

GRANT ALL ON FUNCTION public.get_next_delivery_tier(current_amount numeric) TO anon;

GRANT ALL ON FUNCTION public.get_next_delivery_tier_by_branch(p_branch_id bigint, p_current_amount numeric) TO service_role;

GRANT ALL ON FUNCTION public.get_next_delivery_tier_by_branch(p_branch_id bigint, p_current_amount numeric) TO anon;

GRANT ALL ON FUNCTION public.get_next_product_serial() TO service_role;

GRANT ALL ON FUNCTION public.get_next_product_serial() TO anon;

GRANT ALL ON FUNCTION public.get_offer_products_data(p_exclude_offer_id integer) TO service_role;

GRANT ALL ON FUNCTION public.get_offer_products_data(p_exclude_offer_id integer) TO anon;

GRANT ALL ON FUNCTION public.get_offer_variation_summary(p_offer_id integer) TO service_role;

GRANT ALL ON FUNCTION public.get_offer_variation_summary(p_offer_id integer) TO anon;

GRANT ALL ON FUNCTION public.get_ongoing_quick_assignment_count(p_user_id uuid) TO anon;

GRANT ALL ON FUNCTION public.get_or_create_app_function(p_function_code text, p_function_name text, p_description text, p_category text) TO service_role;

GRANT ALL ON FUNCTION public.get_or_create_app_function(p_function_code text, p_function_name text, p_description text, p_category text) TO anon;

GRANT ALL ON FUNCTION public.get_overdue_tasks_without_reminders() TO service_role;

GRANT ALL ON FUNCTION public.get_overdue_tasks_without_reminders() TO anon;

GRANT ALL ON FUNCTION public.get_paid_expense_payments(p_date_from date, p_date_to date) TO anon;

GRANT ALL ON FUNCTION public.get_paid_vendor_payments(p_date_from date, p_date_to date) TO anon;

GRANT ALL ON FUNCTION public.get_party_payment_data(p_party_type text, p_party_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_party_payment_data(p_party_type text, p_party_id uuid) TO anon;

GRANT ALL ON FUNCTION public.get_po_requests_with_details() TO anon;

GRANT ALL ON FUNCTION public.get_pos_report(p_date_from timestamp with time zone, p_date_to timestamp with time zone) TO anon;

GRANT ALL ON FUNCTION public.get_product_master_init_data() TO authenticated;

GRANT ALL ON FUNCTION public.get_product_master_init_data() TO service_role;

GRANT ALL ON FUNCTION public.get_product_offers(p_product_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_product_offers(p_product_id uuid) TO anon;

GRANT ALL ON FUNCTION public.get_product_variations(p_barcode text) TO service_role;

GRANT ALL ON FUNCTION public.get_product_variations(p_barcode text) TO anon;

GRANT ALL ON FUNCTION public.get_products_dashboard_data(p_limit integer, p_offset integer) TO anon;

GRANT ALL ON FUNCTION public.get_products_dashboard_data(p_limit integer, p_offset integer) TO service_role;

GRANT ALL ON FUNCTION public.get_products_in_active_offers() TO service_role;

GRANT ALL ON FUNCTION public.get_products_in_active_offers() TO anon;

GRANT ALL ON FUNCTION public.get_purchase_voucher_manager_data() TO anon;

GRANT ALL ON FUNCTION public.get_pv_stock_manager_data() TO anon;

GRANT ALL ON FUNCTION public.get_pv_stock_voucher_items() TO anon;

GRANT ALL ON FUNCTION public.get_pv_stock_voucher_items(p_offset integer, p_limit integer) TO anon;

GRANT ALL ON FUNCTION public.get_quick_access_stats() TO service_role;

GRANT ALL ON FUNCTION public.get_quick_access_stats() TO anon;

GRANT ALL ON FUNCTION public.get_quick_task_completion_stats() TO service_role;

GRANT ALL ON FUNCTION public.get_quick_task_completion_stats() TO anon;

GRANT ALL ON FUNCTION public.get_receiving_records_with_details(p_limit integer, p_offset integer, p_branch_id text, p_vendor_search text, p_pr_excel_filter text, p_erp_ref_filter text) TO anon;

GRANT ALL ON FUNCTION public.get_receiving_task_statistics(branch_id_param integer, date_from date, date_to date) TO service_role;

GRANT ALL ON FUNCTION public.get_receiving_task_statistics(branch_id_param integer, date_from date, date_to date) TO anon;

GRANT ALL ON FUNCTION public.get_receiving_task_statistics(branch_id_param integer, date_from timestamp with time zone, date_to timestamp with time zone) TO service_role;

GRANT ALL ON FUNCTION public.get_receiving_task_statistics(branch_id_param integer, date_from timestamp with time zone, date_to timestamp with time zone) TO anon;

GRANT ALL ON FUNCTION public.get_reminder_statistics(p_user_id uuid, p_days integer) TO service_role;

GRANT ALL ON FUNCTION public.get_reminder_statistics(p_user_id uuid, p_days integer) TO anon;

GRANT ALL ON FUNCTION public.get_report_data(p_party_type text, p_party_ids uuid[]) TO service_role;

GRANT ALL ON FUNCTION public.get_report_data(p_party_type text, p_party_ids uuid[]) TO anon;

GRANT ALL ON FUNCTION public.get_report_party_paid_totals(p_party_type text) TO service_role;

GRANT ALL ON FUNCTION public.get_report_party_paid_totals(p_party_type text) TO anon;

GRANT ALL ON FUNCTION public.get_server_disk_usage() TO anon;

GRANT ALL ON FUNCTION public.get_stock_requests_with_details() TO anon;

GRANT ALL ON FUNCTION public.get_storage_buckets_info() TO anon;

GRANT ALL ON FUNCTION public.get_storage_stats() TO anon;

GRANT ALL ON FUNCTION public.get_storage_stats() TO service_role;

GRANT ALL ON FUNCTION public.get_system_expiry_dates(barcode_list text[], branch_id_param integer) TO anon;

GRANT ALL ON FUNCTION public.get_table_schemas() TO anon;

GRANT ALL ON FUNCTION public.get_task_dashboard(user_id_param text, branch_id_param uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_task_dashboard(user_id_param text, branch_id_param uuid) TO anon;

GRANT ALL ON FUNCTION public.get_task_statistics(user_id_param text) TO service_role;

GRANT ALL ON FUNCTION public.get_task_statistics(user_id_param text) TO anon;

GRANT ALL ON FUNCTION public.get_task_statistics(user_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_task_statistics(user_id uuid) TO anon;

GRANT ALL ON FUNCTION public.get_tasks_for_receiving_record(receiving_record_id_param uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_tasks_for_receiving_record(receiving_record_id_param uuid) TO anon;

GRANT ALL ON FUNCTION public.get_todays_scheduled_visits(target_date date) TO service_role;

GRANT ALL ON FUNCTION public.get_todays_scheduled_visits(target_date date) TO anon;

GRANT ALL ON FUNCTION public.get_todays_scheduled_visits(branch_uuid uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_todays_scheduled_visits(branch_uuid uuid) TO anon;

GRANT ALL ON FUNCTION public.get_todays_vendor_visits(branch_uuid uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_todays_vendor_visits(branch_uuid uuid) TO anon;

GRANT ALL ON FUNCTION public.get_todays_visits(branch_uuid uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_todays_visits(branch_uuid uuid) TO anon;

GRANT ALL ON FUNCTION public.get_upcoming_visits(branch_uuid uuid, days_ahead integer) TO service_role;

GRANT ALL ON FUNCTION public.get_upcoming_visits(branch_uuid uuid, days_ahead integer) TO anon;

GRANT ALL ON FUNCTION public.get_user_assigned_tasks(user_id_param text, branch_id_param uuid, status_filter text, limit_param integer, offset_param integer) TO service_role;

GRANT ALL ON FUNCTION public.get_user_assigned_tasks(user_id_param text, branch_id_param uuid, status_filter text, limit_param integer, offset_param integer) TO anon;

GRANT ALL ON FUNCTION public.get_user_interface_permissions(p_user_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_user_interface_permissions(p_user_id uuid) TO anon;

GRANT ALL ON FUNCTION public.get_user_receiving_tasks_dashboard(user_id_param uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_user_receiving_tasks_dashboard(user_id_param uuid) TO anon;

GRANT ALL ON FUNCTION public.get_users_with_employee_details() TO service_role;

GRANT ALL ON FUNCTION public.get_users_with_employee_details() TO anon;

GRANT ALL ON FUNCTION public.get_variation_group_info(p_barcode text) TO service_role;

GRANT ALL ON FUNCTION public.get_variation_group_info(p_barcode text) TO anon;

GRANT ALL ON FUNCTION public.get_vendor_count_by_branch() TO service_role;

GRANT ALL ON FUNCTION public.get_vendor_count_by_branch() TO anon;

GRANT ALL ON FUNCTION public.get_vendor_for_receiving_record(vendor_id_param integer, branch_id_param bigint) TO service_role;

GRANT ALL ON FUNCTION public.get_vendor_for_receiving_record(vendor_id_param integer, branch_id_param bigint) TO anon;

GRANT ALL ON FUNCTION public.get_vendor_pending_summary() TO anon;

GRANT ALL ON FUNCTION public.get_vendor_promissory_notes_summary(vendor_uuid uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_vendor_promissory_notes_summary(vendor_uuid uuid) TO anon;

GRANT ALL ON FUNCTION public.get_vendor_visits_summary(vendor_uuid uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_vendor_visits_summary(vendor_uuid uuid) TO anon;

GRANT ALL ON FUNCTION public.get_vendors_by_branch(branch_id_param bigint) TO service_role;

GRANT ALL ON FUNCTION public.get_vendors_by_branch(branch_id_param bigint) TO anon;

GRANT ALL ON FUNCTION public.get_visit_history(start_date_param date, end_date_param date, branch_uuid uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_visit_history(start_date_param date, end_date_param date, branch_uuid uuid) TO anon;

GRANT ALL ON FUNCTION public.get_visits_by_date_range(start_date date, end_date date) TO service_role;

GRANT ALL ON FUNCTION public.get_visits_by_date_range(start_date date, end_date date) TO anon;

GRANT ALL ON FUNCTION public.get_visits_by_date_range(start_date_param date, end_date_param date, branch_uuid uuid) TO service_role;

GRANT ALL ON FUNCTION public.get_visits_by_date_range(start_date_param date, end_date_param date, branch_uuid uuid) TO anon;

GRANT ALL ON FUNCTION public.get_wa_catalog_stats(p_account_id uuid) TO anon;

GRANT ALL ON FUNCTION public.get_wa_contacts(p_limit integer, p_offset integer, p_search text) TO anon;

GRANT ALL ON FUNCTION public.get_wa_conversations_fast(p_account_id uuid, p_limit integer, p_offset integer, p_search text, p_filter text) TO authenticated;

GRANT ALL ON FUNCTION public.get_wa_conversations_fast(p_account_id uuid, p_limit integer, p_offset integer, p_search text, p_filter text) TO service_role;

GRANT ALL ON FUNCTION public.get_wa_priority_conversations(p_account_id uuid) TO authenticated;

GRANT ALL ON FUNCTION public.get_wa_priority_conversations(p_account_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.handle_document_deactivation() TO service_role;

GRANT ALL ON FUNCTION public.handle_document_deactivation() TO anon;

GRANT ALL ON FUNCTION public.handle_order_task_completion() TO anon;

GRANT ALL ON FUNCTION public.has_order_management_access(user_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.has_order_management_access(user_id uuid) TO anon;

GRANT ALL ON FUNCTION public.hash_password(password text, salt text) TO service_role;

GRANT ALL ON FUNCTION public.hash_password(password text, salt text) TO anon;

GRANT ALL ON FUNCTION public.import_sync_batch(p_table_name text, p_data jsonb) TO anon;

GRANT ALL ON FUNCTION public.import_sync_batch(p_table_name text, p_data jsonb) TO service_role;

GRANT ALL ON FUNCTION public.increment_ai_token_usage(config_id uuid, p_tokens integer, p_prompt integer, p_completion integer) TO anon;

GRANT ALL ON FUNCTION public.increment_ai_token_usage(config_id uuid, p_tokens integer, p_prompt integer, p_completion integer) TO authenticated;

GRANT ALL ON FUNCTION public.increment_flyer_template_usage() TO service_role;

GRANT ALL ON FUNCTION public.increment_flyer_template_usage() TO anon;

GRANT ALL ON FUNCTION public.increment_page_visit_count(offer_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.increment_page_visit_count(offer_id uuid) TO anon;

GRANT ALL ON FUNCTION public.increment_social_link_click(_branch_id bigint, _platform text) TO authenticated;

GRANT ALL ON FUNCTION public.increment_social_link_click(_branch_id bigint, _platform text) TO service_role;

GRANT ALL ON FUNCTION public.increment_view_button_count(offer_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.increment_view_button_count(offer_id uuid) TO anon;

GRANT ALL ON FUNCTION public.insert_order_items(p_order_items jsonb) TO service_role;

GRANT ALL ON FUNCTION public.insert_order_items(p_order_items jsonb) TO anon;

GRANT ALL ON FUNCTION public.insert_vendor_from_excel(p_erp_vendor_code character varying, p_vendor_name character varying, p_vat_number character varying) TO service_role;

GRANT ALL ON FUNCTION public.insert_vendor_from_excel(p_erp_vendor_code character varying, p_vendor_name character varying, p_vat_number character varying) TO anon;

GRANT ALL ON FUNCTION public.insert_vendor_from_excel(p_erp_vendor_code character varying, p_vendor_name_english character varying, p_vendor_name_arabic character varying, p_vat_number character varying) TO service_role;

GRANT ALL ON FUNCTION public.insert_vendor_from_excel(p_erp_vendor_code character varying, p_vendor_name_english character varying, p_vendor_name_arabic character varying, p_vat_number character varying) TO anon;

GRANT ALL ON FUNCTION public.is_delivery_staff(user_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.is_delivery_staff(user_id uuid) TO anon;

GRANT ALL ON FUNCTION public.is_overnight_shift(start_time time without time zone, end_time time without time zone) TO service_role;

GRANT ALL ON FUNCTION public.is_overnight_shift(start_time time without time zone, end_time time without time zone) TO anon;

GRANT ALL ON FUNCTION public.is_product_in_active_bundle(p_product_id uuid, p_exclude_offer_id integer) TO service_role;

GRANT ALL ON FUNCTION public.is_product_in_active_bundle(p_product_id uuid, p_exclude_offer_id integer) TO anon;

GRANT ALL ON FUNCTION public.is_quick_access_code_available(p_quick_access_code text) TO service_role;

GRANT ALL ON FUNCTION public.is_quick_access_code_available(p_quick_access_code text) TO anon;

GRANT ALL ON FUNCTION public.is_quick_access_code_available(p_quick_access_code character varying) TO anon;

GRANT ALL ON FUNCTION public.is_quick_access_code_available(p_quick_access_code character varying) TO service_role;

GRANT ALL ON FUNCTION public.is_user_admin(check_user_id uuid) TO anon;

GRANT ALL ON FUNCTION public.is_user_admin(check_user_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.is_user_master_admin(check_user_id uuid) TO anon;

GRANT ALL ON FUNCTION public.is_user_master_admin(check_user_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.link_finger_transaction_to_employee(p_employee_code character varying, p_branch_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.link_finger_transaction_to_employee(p_employee_code character varying, p_branch_id uuid) TO anon;

GRANT ALL ON FUNCTION public.log_offer_usage(p_offer_id integer, p_customer_id uuid, p_order_id integer, p_discount_applied numeric, p_original_amount numeric, p_final_amount numeric, p_cart_items jsonb) TO service_role;

GRANT ALL ON FUNCTION public.log_offer_usage(p_offer_id integer, p_customer_id uuid, p_order_id integer, p_discount_applied numeric, p_original_amount numeric, p_final_amount numeric, p_cart_items jsonb) TO anon;

GRANT ALL ON FUNCTION public.log_user_action() TO service_role;

GRANT ALL ON FUNCTION public.log_user_action() TO anon;

GRANT ALL ON FUNCTION public.mark_overdue_quick_tasks() TO service_role;

GRANT ALL ON FUNCTION public.mark_overdue_quick_tasks() TO anon;

GRANT ALL ON FUNCTION public.notify_branches_change() TO service_role;

GRANT ALL ON FUNCTION public.notify_branches_change() TO anon;

GRANT ALL ON FUNCTION public.notify_customer_order_status_change() TO anon;

GRANT ALL ON FUNCTION public.notify_customer_order_status_change() TO service_role;

GRANT ALL ON FUNCTION public.notify_erp_daily_sales_change() TO service_role;

GRANT ALL ON FUNCTION public.notify_erp_daily_sales_change() TO anon;

GRANT ALL ON FUNCTION public.process_clearance_certificate_generation(receiving_record_id_param uuid, clearance_certificate_url_param text, generated_by_user_id uuid, generated_by_name text, generated_by_role text) TO service_role;

GRANT ALL ON FUNCTION public.process_clearance_certificate_generation(receiving_record_id_param uuid, clearance_certificate_url_param text, generated_by_user_id uuid, generated_by_name text, generated_by_role text) TO anon;

GRANT ALL ON FUNCTION public.process_customer_recovery(p_request_id uuid, p_admin_user_id uuid, p_action text, p_notes text) TO service_role;

GRANT ALL ON FUNCTION public.process_customer_recovery(p_request_id uuid, p_admin_user_id uuid, p_action text, p_notes text) TO anon;

GRANT ALL ON FUNCTION public.process_finger_transaction_linking() TO service_role;

GRANT ALL ON FUNCTION public.process_finger_transaction_linking() TO anon;

GRANT ALL ON FUNCTION public.queue_push_notification(p_notification_id uuid, p_target_type text, p_target_users jsonb, p_target_roles text[], p_target_branches uuid[]) TO service_role;

GRANT ALL ON FUNCTION public.queue_push_notification(p_notification_id uuid, p_target_type text, p_target_users jsonb, p_target_roles text[], p_target_branches uuid[]) TO anon;

GRANT ALL ON FUNCTION public.queue_quick_task_push_notifications() TO service_role;

GRANT ALL ON FUNCTION public.queue_quick_task_push_notifications() TO anon;

GRANT ALL ON FUNCTION public.reassign_receiving_task(receiving_task_id_param uuid, new_assigned_user_id uuid, reassigned_by_user_id text, reassignment_reason text) TO service_role;

GRANT ALL ON FUNCTION public.reassign_receiving_task(receiving_task_id_param uuid, new_assigned_user_id uuid, reassigned_by_user_id text, reassignment_reason text) TO anon;

GRANT ALL ON FUNCTION public.reassign_task(assignment_id uuid, new_assignee uuid, reassigned_by uuid, reason text) TO service_role;

GRANT ALL ON FUNCTION public.reassign_task(assignment_id uuid, new_assignee uuid, reassigned_by uuid, reason text) TO anon;

GRANT ALL ON FUNCTION public.reassign_task(p_assignment_id uuid, p_reassigned_by text, p_new_user_id text, p_new_branch_id uuid, p_reassignment_reason text, p_copy_deadline boolean) TO service_role;

GRANT ALL ON FUNCTION public.reassign_task(p_assignment_id uuid, p_reassigned_by text, p_new_user_id text, p_new_branch_id uuid, p_reassignment_reason text, p_copy_deadline boolean) TO anon;

GRANT ALL ON FUNCTION public.record_fine_payment(warning_id_param uuid, payment_amount_param numeric, payment_method_param character varying, payment_reference_param character varying, processed_by_param uuid) TO service_role;

GRANT ALL ON FUNCTION public.record_fine_payment(warning_id_param uuid, payment_amount_param numeric, payment_method_param character varying, payment_reference_param character varying, processed_by_param uuid) TO anon;

GRANT ALL ON FUNCTION public.refresh_broadcast_status(p_broadcast_id uuid) TO anon;

GRANT ALL ON FUNCTION public.refresh_edge_functions_cache(p_functions jsonb) TO anon;

GRANT ALL ON FUNCTION public.refresh_user_roles_from_positions() TO service_role;

GRANT ALL ON FUNCTION public.refresh_user_roles_from_positions() TO anon;

GRANT ALL ON FUNCTION public.register_app_function(p_function_name text, p_function_code text, p_description text, p_category text, p_enabled boolean) TO service_role;

GRANT ALL ON FUNCTION public.register_app_function(p_function_name text, p_function_code text, p_description text, p_category text, p_enabled boolean) TO anon;

GRANT ALL ON FUNCTION public.register_push_subscription(p_user_id uuid, p_device_id character varying, p_endpoint text, p_p256dh text, p_auth text, p_device_type character varying, p_browser_name character varying, p_user_agent text) TO service_role;

GRANT ALL ON FUNCTION public.register_push_subscription(p_user_id uuid, p_device_id character varying, p_endpoint text, p_p256dh text, p_auth text, p_device_type character varying, p_browser_name character varying, p_user_agent text) TO anon;

GRANT ALL ON FUNCTION public.register_system_role(p_role_name text, p_role_code text, p_description text) TO service_role;

GRANT ALL ON FUNCTION public.register_system_role(p_role_name text, p_role_code text, p_description text) TO anon;

GRANT ALL ON FUNCTION public.request_access_code_change(p_email character varying, p_whatsapp character varying) TO anon;

GRANT ALL ON FUNCTION public.request_access_code_change(p_email character varying, p_whatsapp character varying) TO service_role;

GRANT ALL ON FUNCTION public.request_access_code_resend(p_whatsapp_number text) TO anon;

GRANT ALL ON FUNCTION public.request_new_access_code(p_whatsapp_number text) TO service_role;

GRANT ALL ON FUNCTION public.request_new_access_code(p_whatsapp_number text) TO anon;

GRANT ALL ON FUNCTION public.request_server_restart() TO service_role;

GRANT ALL ON FUNCTION public.reschedule_visit(visit_id uuid, new_date date) TO service_role;

GRANT ALL ON FUNCTION public.reschedule_visit(visit_id uuid, new_date date) TO anon;

GRANT ALL ON FUNCTION public.search_tasks(search_query text, user_id_param text, limit_param integer, offset_param integer) TO service_role;

GRANT ALL ON FUNCTION public.search_tasks(search_query text, user_id_param text, limit_param integer, offset_param integer) TO anon;

GRANT ALL ON FUNCTION public.search_tasks(search_term text, task_status text, assigned_user_id uuid, created_by_user_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.search_tasks(search_term text, task_status text, assigned_user_id uuid, created_by_user_id uuid) TO anon;

GRANT ALL ON FUNCTION public.select_random_product(p_campaign_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.select_random_product(p_campaign_id uuid) TO anon;

GRANT ALL ON FUNCTION public.send_order_notification(p_order_id uuid, p_title text, p_message text, p_type text, p_priority text, p_performed_by uuid, p_target_user_id uuid) TO anon;

GRANT ALL ON FUNCTION public.set_user_context(user_id uuid, is_master_admin boolean, is_admin boolean) TO anon;

GRANT ALL ON FUNCTION public.set_user_context(user_id uuid, is_master_admin boolean, is_admin boolean) TO service_role;

GRANT ALL ON FUNCTION public.setup_role_permissions(p_role_code text, p_permissions jsonb) TO service_role;

GRANT ALL ON FUNCTION public.setup_role_permissions(p_role_code text, p_permissions jsonb) TO anon;

GRANT ALL ON FUNCTION public.skip_visit(visit_id uuid, skip_reason text) TO service_role;

GRANT ALL ON FUNCTION public.skip_visit(visit_id uuid, skip_reason text) TO anon;

GRANT ALL ON FUNCTION public.soft_delete_flyer_template(template_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.soft_delete_flyer_template(template_id uuid) TO anon;

GRANT ALL ON FUNCTION public.start_break(p_user_id uuid, p_reason_id integer, p_reason_note text) TO anon;

GRANT ALL ON FUNCTION public.submit_quick_task_completion(p_assignment_id uuid, p_user_id uuid, p_completion_notes text, p_photos text[], p_erp_reference text) TO service_role;

GRANT ALL ON FUNCTION public.submit_quick_task_completion(p_assignment_id uuid, p_user_id uuid, p_completion_notes text, p_photos text[], p_erp_reference text) TO anon;

GRANT ALL ON FUNCTION public.sync_all_missing_erp_references() TO service_role;

GRANT ALL ON FUNCTION public.sync_all_missing_erp_references() TO anon;

GRANT ALL ON FUNCTION public.sync_all_pending_erp_references() TO service_role;

GRANT ALL ON FUNCTION public.sync_all_pending_erp_references() TO anon;

GRANT ALL ON FUNCTION public.sync_app_functions_from_components(component_metadata jsonb) TO service_role;

GRANT ALL ON FUNCTION public.sync_app_functions_from_components(component_metadata jsonb) TO anon;

GRANT ALL ON FUNCTION public.sync_employee_with_hr(p_employee_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.sync_employee_with_hr(p_employee_id uuid) TO anon;

GRANT ALL ON FUNCTION public.sync_erp_reference_for_receiving_record(receiving_record_id_param uuid) TO service_role;

GRANT ALL ON FUNCTION public.sync_erp_reference_for_receiving_record(receiving_record_id_param uuid) TO anon;

GRANT ALL ON FUNCTION public.sync_erp_references_from_task_completions() TO service_role;

GRANT ALL ON FUNCTION public.sync_erp_references_from_task_completions() TO anon;

GRANT ALL ON FUNCTION public.sync_requisition_balance() TO service_role;

GRANT ALL ON FUNCTION public.sync_requisition_balance() TO anon;

GRANT ALL ON FUNCTION public.sync_user_roles_from_positions() TO service_role;

GRANT ALL ON FUNCTION public.sync_user_roles_from_positions() TO anon;

GRANT ALL ON FUNCTION public.track_media_activation() TO service_role;

GRANT ALL ON FUNCTION public.track_media_activation() TO anon;

GRANT ALL ON FUNCTION public.trigger_cleanup_assignment_notifications() TO service_role;

GRANT ALL ON FUNCTION public.trigger_cleanup_assignment_notifications() TO anon;

GRANT ALL ON FUNCTION public.trigger_cleanup_task_notifications() TO service_role;

GRANT ALL ON FUNCTION public.trigger_cleanup_task_notifications() TO anon;

GRANT ALL ON FUNCTION public.trigger_log_order_offer_usage() TO service_role;

GRANT ALL ON FUNCTION public.trigger_log_order_offer_usage() TO anon;

GRANT ALL ON FUNCTION public.trigger_notify_new_order() TO service_role;

GRANT ALL ON FUNCTION public.trigger_notify_new_order() TO anon;

GRANT ALL ON FUNCTION public.trigger_order_status_audit() TO service_role;

GRANT ALL ON FUNCTION public.trigger_order_status_audit() TO anon;

GRANT ALL ON FUNCTION public.trigger_sync_erp_reference_on_task_completion() TO service_role;

GRANT ALL ON FUNCTION public.trigger_sync_erp_reference_on_task_completion() TO anon;

GRANT ALL ON FUNCTION public.upsert_branch_sync_config(p_branch_id bigint, p_local_supabase_url text, p_local_supabase_key text, p_tunnel_url text) TO authenticated;

GRANT ALL ON FUNCTION public.upsert_branch_sync_config(p_branch_id bigint, p_local_supabase_url text, p_local_supabase_key text, p_tunnel_url text) TO service_role;

GRANT ALL ON FUNCTION public.upsert_branch_sync_config(p_branch_id bigint, p_local_supabase_url text, p_local_supabase_key text, p_tunnel_url text, p_ssh_user text) TO anon;

GRANT ALL ON FUNCTION public.upsert_branch_sync_config(p_branch_id bigint, p_local_supabase_url text, p_local_supabase_key text, p_tunnel_url text, p_ssh_user text) TO service_role;

GRANT ALL ON FUNCTION public.upsert_social_links(_branch_id bigint, _facebook text, _whatsapp text, _instagram text, _tiktok text, _snapchat text, _website text, _location_link text) TO authenticated;

GRANT ALL ON FUNCTION public.upsert_social_links(_branch_id bigint, _facebook text, _whatsapp text, _instagram text, _tiktok text, _snapchat text, _website text, _location_link text) TO service_role;

GRANT ALL ON FUNCTION public.validate_break_code(p_code text) TO anon;

GRANT ALL ON FUNCTION public.validate_bundle_offer_type() TO service_role;

GRANT ALL ON FUNCTION public.validate_bundle_offer_type() TO anon;

GRANT ALL ON FUNCTION public.validate_coupon_eligibility(p_campaign_code character varying, p_mobile_number character varying) TO service_role;

GRANT ALL ON FUNCTION public.validate_coupon_eligibility(p_campaign_code character varying, p_mobile_number character varying) TO anon;

GRANT ALL ON FUNCTION public.validate_flyer_template_configuration(config jsonb) TO service_role;

GRANT ALL ON FUNCTION public.validate_flyer_template_configuration(config jsonb) TO anon;

GRANT ALL ON FUNCTION public.validate_payment_methods(payment_methods text) TO service_role;

GRANT ALL ON FUNCTION public.validate_payment_methods(payment_methods text) TO anon;

GRANT ALL ON FUNCTION public.validate_product_offer(p_offer_id integer, p_product_id uuid, p_quantity integer) TO service_role;

GRANT ALL ON FUNCTION public.validate_product_offer(p_offer_id integer, p_product_id uuid, p_quantity integer) TO anon;

GRANT ALL ON FUNCTION public.validate_task_completion_requirements(receiving_task_id_param uuid, user_id_param uuid) TO service_role;

GRANT ALL ON FUNCTION public.validate_task_completion_requirements(receiving_task_id_param uuid, user_id_param uuid) TO anon;

GRANT ALL ON FUNCTION public.validate_variation_prices(p_offer_id integer, p_group_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.validate_variation_prices(p_offer_id integer, p_group_id uuid) TO anon;

GRANT ALL ON FUNCTION public.validate_vendor_branch_match() TO service_role;

GRANT ALL ON FUNCTION public.validate_vendor_branch_match() TO anon;

GRANT ALL ON FUNCTION public.verify_otp_and_change_access_code(p_email character varying, p_whatsapp character varying, p_otp character varying, p_new_code character varying) TO anon;

GRANT ALL ON FUNCTION public.verify_otp_and_change_access_code(p_email character varying, p_whatsapp character varying, p_otp character varying, p_new_code character varying) TO service_role;

GRANT ALL ON FUNCTION public.verify_password(password text, hash text) TO service_role;

GRANT ALL ON FUNCTION public.verify_password(password text, hash text) TO anon;

GRANT ALL ON FUNCTION public.verify_password(input_username character varying, input_password character varying) TO service_role;

GRANT ALL ON FUNCTION public.verify_password(input_username character varying, input_password character varying) TO anon;

GRANT ALL ON FUNCTION public.verify_quick_access_code(p_code character varying) TO anon;

GRANT ALL ON FUNCTION public.verify_quick_access_code(p_code character varying) TO service_role;

GRANT ALL ON FUNCTION public.verify_quick_task_completion(completion_id_param uuid, verified_by_user_id_param uuid, verification_notes_param text, is_approved boolean) TO service_role;

GRANT ALL ON FUNCTION public.verify_quick_task_completion(completion_id_param uuid, verified_by_user_id_param uuid, verification_notes_param text, is_approved boolean) TO anon;

GRANT SELECT ON TABLE public.access_code_otp TO authenticated;

GRANT ALL ON TABLE public.access_code_otp TO service_role;

GRANT SELECT ON TABLE public.access_code_otp TO replication_user;

GRANT ALL ON TABLE public.ai_chat_guide TO authenticated;

GRANT ALL ON TABLE public.ai_chat_guide TO service_role;

GRANT SELECT ON TABLE public.ai_chat_guide TO replication_user;

GRANT SELECT,USAGE ON SEQUENCE public.ai_chat_guide_id_seq TO anon;

GRANT SELECT,USAGE ON SEQUENCE public.ai_chat_guide_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.ai_chat_guide_id_seq TO replication_user;

GRANT SELECT ON TABLE public.app_icons TO authenticated;

GRANT ALL ON TABLE public.app_icons TO service_role;

GRANT SELECT ON TABLE public.app_icons TO replication_user;

GRANT ALL ON TABLE public.approval_permissions TO authenticated;

GRANT ALL ON TABLE public.approval_permissions TO service_role;

GRANT SELECT ON TABLE public.approval_permissions TO replication_user;

GRANT ALL ON SEQUENCE public.approval_permissions_id_seq TO anon;

GRANT ALL ON SEQUENCE public.approval_permissions_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.approval_permissions_id_seq TO replication_user;

GRANT ALL ON TABLE public.approver_branch_access TO authenticated;

GRANT ALL ON TABLE public.approver_branch_access TO service_role;

GRANT SELECT ON TABLE public.approver_branch_access TO replication_user;

GRANT ALL ON SEQUENCE public.approver_branch_access_id_seq TO anon;

GRANT ALL ON SEQUENCE public.approver_branch_access_id_seq TO authenticated;

GRANT ALL ON TABLE public.approver_visibility_config TO authenticated;

GRANT ALL ON TABLE public.approver_visibility_config TO service_role;

GRANT SELECT ON TABLE public.approver_visibility_config TO replication_user;

GRANT ALL ON SEQUENCE public.approver_visibility_config_id_seq TO anon;

GRANT ALL ON SEQUENCE public.approver_visibility_config_id_seq TO authenticated;

GRANT ALL ON TABLE public.asset_main_categories TO authenticated;

GRANT ALL ON TABLE public.asset_main_categories TO service_role;

GRANT SELECT ON TABLE public.asset_main_categories TO replication_user;

GRANT SELECT,USAGE ON SEQUENCE public.asset_main_categories_id_seq TO anon;

GRANT SELECT,USAGE ON SEQUENCE public.asset_main_categories_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.asset_main_categories_id_seq TO replication_user;

GRANT ALL ON TABLE public.asset_sub_categories TO authenticated;

GRANT ALL ON TABLE public.asset_sub_categories TO service_role;

GRANT SELECT ON TABLE public.asset_sub_categories TO replication_user;

GRANT SELECT,USAGE ON SEQUENCE public.asset_sub_categories_id_seq TO anon;

GRANT SELECT,USAGE ON SEQUENCE public.asset_sub_categories_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.asset_sub_categories_id_seq TO replication_user;

GRANT ALL ON TABLE public.assets TO authenticated;

GRANT ALL ON TABLE public.assets TO service_role;

GRANT SELECT ON TABLE public.assets TO replication_user;

GRANT SELECT,USAGE ON SEQUENCE public.assets_id_seq TO anon;

GRANT SELECT,USAGE ON SEQUENCE public.assets_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.assets_id_seq TO replication_user;

GRANT ALL ON TABLE public.bank_reconciliations TO authenticated;

GRANT ALL ON TABLE public.bank_reconciliations TO service_role;

GRANT SELECT ON TABLE public.bank_reconciliations TO replication_user;

GRANT SELECT,USAGE ON SEQUENCE public.bank_reconciliations_id_seq TO authenticated;

GRANT SELECT,USAGE ON SEQUENCE public.bank_reconciliations_id_seq TO anon;

GRANT SELECT ON TABLE public.biometric_connections TO authenticated;

GRANT ALL ON TABLE public.biometric_connections TO service_role;

GRANT SELECT ON TABLE public.biometric_connections TO replication_user;

GRANT SELECT ON TABLE public.bogo_offer_rules TO authenticated;

GRANT ALL ON TABLE public.bogo_offer_rules TO service_role;

GRANT SELECT ON TABLE public.bogo_offer_rules TO replication_user;

GRANT ALL ON SEQUENCE public.bogo_offer_rules_id_seq TO anon;

GRANT ALL ON SEQUENCE public.bogo_offer_rules_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.bogo_offer_rules_id_seq TO replication_user;

GRANT ALL ON TABLE public.box_operations TO authenticated;

GRANT ALL ON TABLE public.box_operations TO service_role;

GRANT SELECT ON TABLE public.box_operations TO replication_user;

GRANT ALL ON TABLE public.branch_default_delivery_receivers TO authenticated;

GRANT ALL ON TABLE public.branch_default_delivery_receivers TO service_role;

GRANT SELECT ON TABLE public.branch_default_delivery_receivers TO replication_user;

GRANT ALL ON TABLE public.branch_default_positions TO authenticated;

GRANT ALL ON TABLE public.branch_default_positions TO service_role;

GRANT SELECT ON TABLE public.branch_default_positions TO replication_user;

GRANT SELECT ON TABLE public.branch_sync_config TO authenticated;

GRANT ALL ON TABLE public.branch_sync_config TO service_role;

GRANT SELECT ON TABLE public.branch_sync_config TO replication_user;

GRANT SELECT ON SEQUENCE public.branch_sync_config_id_seq TO replication_user;

GRANT ALL ON TABLE public.branches TO service_role;

GRANT SELECT ON TABLE public.branches TO replication_user;

GRANT ALL ON SEQUENCE public.branches_id_seq TO anon;

GRANT ALL ON SEQUENCE public.branches_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.branches_id_seq TO replication_user;

GRANT ALL ON TABLE public.break_reasons TO authenticated;

GRANT ALL ON TABLE public.break_reasons TO service_role;

GRANT SELECT ON TABLE public.break_reasons TO replication_user;

GRANT SELECT,USAGE ON SEQUENCE public.break_reasons_id_seq TO authenticated;

GRANT ALL ON TABLE public.break_register TO authenticated;

GRANT ALL ON TABLE public.break_register TO service_role;

GRANT SELECT ON TABLE public.break_register TO replication_user;

GRANT SELECT ON TABLE public.break_security_seed TO authenticated;

GRANT ALL ON TABLE public.break_security_seed TO service_role;

GRANT SELECT ON TABLE public.break_security_seed TO replication_user;

GRANT SELECT ON TABLE public.button_main_sections TO authenticated;

GRANT ALL ON TABLE public.button_main_sections TO service_role;

GRANT SELECT ON TABLE public.button_main_sections TO replication_user;

GRANT SELECT,USAGE ON SEQUENCE public.button_main_sections_id_seq TO anon;

GRANT SELECT,USAGE ON SEQUENCE public.button_main_sections_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.button_main_sections_id_seq TO replication_user;

GRANT SELECT ON TABLE public.button_permissions TO authenticated;

GRANT ALL ON TABLE public.button_permissions TO service_role;

GRANT SELECT ON TABLE public.button_permissions TO replication_user;

GRANT SELECT,USAGE ON SEQUENCE public.button_permissions_id_seq TO anon;

GRANT SELECT,USAGE ON SEQUENCE public.button_permissions_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.button_permissions_id_seq TO replication_user;

GRANT SELECT ON TABLE public.button_sub_sections TO authenticated;

GRANT ALL ON TABLE public.button_sub_sections TO service_role;

GRANT SELECT ON TABLE public.button_sub_sections TO replication_user;

GRANT SELECT,USAGE ON SEQUENCE public.button_sub_sections_id_seq TO anon;

GRANT SELECT,USAGE ON SEQUENCE public.button_sub_sections_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.button_sub_sections_id_seq TO replication_user;

GRANT SELECT ON TABLE public.coupon_campaigns TO authenticated;

GRANT ALL ON TABLE public.coupon_campaigns TO service_role;

GRANT SELECT ON TABLE public.coupon_campaigns TO replication_user;

GRANT SELECT ON TABLE public.coupon_claims TO authenticated;

GRANT ALL ON TABLE public.coupon_claims TO service_role;

GRANT SELECT ON TABLE public.coupon_claims TO replication_user;

GRANT SELECT ON TABLE public.coupon_eligible_customers TO authenticated;

GRANT ALL ON TABLE public.coupon_eligible_customers TO service_role;

GRANT SELECT ON TABLE public.coupon_eligible_customers TO replication_user;

GRANT SELECT ON TABLE public.coupon_products TO authenticated;

GRANT ALL ON TABLE public.coupon_products TO service_role;

GRANT SELECT ON TABLE public.coupon_products TO replication_user;

GRANT SELECT ON TABLE public.customer_access_code_history TO authenticated;

GRANT ALL ON TABLE public.customer_access_code_history TO service_role;

GRANT SELECT ON TABLE public.customer_access_code_history TO replication_user;

GRANT SELECT ON TABLE public.customer_app_media TO authenticated;

GRANT ALL ON TABLE public.customer_app_media TO service_role;

GRANT SELECT ON TABLE public.customer_app_media TO replication_user;

GRANT ALL ON TABLE public.customer_product_requests TO authenticated;

GRANT ALL ON TABLE public.customer_product_requests TO service_role;

GRANT SELECT ON TABLE public.customer_product_requests TO replication_user;

GRANT SELECT ON TABLE public.customer_recovery_requests TO authenticated;

GRANT ALL ON TABLE public.customer_recovery_requests TO service_role;

GRANT SELECT ON TABLE public.customer_recovery_requests TO replication_user;

GRANT SELECT ON TABLE public.customers TO authenticated;

GRANT ALL ON TABLE public.customers TO service_role;

GRANT SELECT ON TABLE public.customers TO replication_user;

GRANT ALL ON TABLE public.day_off TO authenticated;

GRANT ALL ON TABLE public.day_off TO service_role;

GRANT SELECT ON TABLE public.day_off TO replication_user;

GRANT ALL ON TABLE public.day_off_reasons TO authenticated;

GRANT ALL ON TABLE public.day_off_reasons TO service_role;

GRANT SELECT ON TABLE public.day_off_reasons TO replication_user;

GRANT ALL ON TABLE public.day_off_weekday TO authenticated;

GRANT ALL ON TABLE public.day_off_weekday TO service_role;

GRANT SELECT ON TABLE public.day_off_weekday TO replication_user;

GRANT ALL ON TABLE public.default_incident_users TO authenticated;

GRANT ALL ON TABLE public.default_incident_users TO service_role;

GRANT SELECT ON TABLE public.default_incident_users TO replication_user;

GRANT SELECT ON TABLE public.deleted_bundle_offers TO authenticated;

GRANT ALL ON TABLE public.deleted_bundle_offers TO service_role;

GRANT SELECT ON TABLE public.deleted_bundle_offers TO replication_user;

GRANT SELECT ON TABLE public.delivery_fee_tiers TO authenticated;

GRANT ALL ON TABLE public.delivery_fee_tiers TO service_role;

GRANT SELECT ON TABLE public.delivery_fee_tiers TO replication_user;

GRANT SELECT ON TABLE public.delivery_service_settings TO authenticated;

GRANT ALL ON TABLE public.delivery_service_settings TO service_role;

GRANT SELECT ON TABLE public.delivery_service_settings TO replication_user;

GRANT ALL ON TABLE public.denomination_audit_log TO authenticated;

GRANT ALL ON TABLE public.denomination_audit_log TO service_role;

GRANT SELECT ON TABLE public.denomination_audit_log TO replication_user;

GRANT ALL ON TABLE public.denomination_records TO authenticated;

GRANT ALL ON TABLE public.denomination_records TO service_role;

GRANT SELECT ON TABLE public.denomination_records TO replication_user;

GRANT ALL ON TABLE public.denomination_transactions TO authenticated;

GRANT ALL ON TABLE public.denomination_transactions TO service_role;

GRANT SELECT ON TABLE public.denomination_transactions TO replication_user;

GRANT ALL ON TABLE public.denomination_types TO authenticated;

GRANT ALL ON TABLE public.denomination_types TO service_role;

GRANT SELECT ON TABLE public.denomination_types TO replication_user;

GRANT SELECT,USAGE ON SEQUENCE public.denomination_types_id_seq TO authenticated;

GRANT SELECT,USAGE ON SEQUENCE public.denomination_types_id_seq TO anon;

GRANT SELECT ON SEQUENCE public.denomination_types_id_seq TO replication_user;

GRANT ALL ON TABLE public.denomination_user_preferences TO authenticated;

GRANT ALL ON TABLE public.denomination_user_preferences TO service_role;

GRANT SELECT ON TABLE public.denomination_user_preferences TO replication_user;

GRANT ALL ON TABLE public.desktop_themes TO authenticated;

GRANT ALL ON TABLE public.desktop_themes TO service_role;

GRANT SELECT ON TABLE public.desktop_themes TO replication_user;

GRANT SELECT,USAGE ON SEQUENCE public.desktop_themes_id_seq TO authenticated;

GRANT SELECT,USAGE ON SEQUENCE public.desktop_themes_id_seq TO anon;

GRANT SELECT ON SEQUENCE public.desktop_themes_id_seq TO replication_user;

GRANT SELECT ON TABLE public.edge_functions_cache TO authenticated;

GRANT ALL ON TABLE public.edge_functions_cache TO service_role;

GRANT SELECT ON TABLE public.edge_functions_cache TO replication_user;

GRANT ALL ON TABLE public.employee_checklist_assignments TO authenticated;

GRANT ALL ON TABLE public.employee_checklist_assignments TO service_role;

GRANT SELECT ON TABLE public.employee_checklist_assignments TO replication_user;

GRANT ALL ON SEQUENCE public.employee_checklist_assignments_id_seq TO anon;

GRANT SELECT ON SEQUENCE public.employee_checklist_assignments_id_seq TO replication_user;

GRANT SELECT ON TABLE public.employee_fine_payments TO authenticated;

GRANT ALL ON TABLE public.employee_fine_payments TO service_role;

GRANT SELECT ON TABLE public.employee_fine_payments TO replication_user;

GRANT ALL ON TABLE public.employee_official_holidays TO authenticated;

GRANT ALL ON TABLE public.employee_official_holidays TO service_role;

GRANT SELECT ON TABLE public.employee_official_holidays TO replication_user;

GRANT SELECT ON TABLE public.erp_connections TO authenticated;

GRANT ALL ON TABLE public.erp_connections TO service_role;

GRANT SELECT ON TABLE public.erp_connections TO replication_user;

GRANT SELECT ON TABLE public.erp_daily_sales TO authenticated;

GRANT ALL ON TABLE public.erp_daily_sales TO service_role;

GRANT SELECT ON TABLE public.erp_daily_sales TO replication_user;

GRANT SELECT ON TABLE public.erp_sync_logs TO authenticated;

GRANT ALL ON TABLE public.erp_sync_logs TO service_role;

GRANT SELECT ON TABLE public.erp_sync_logs TO replication_user;

GRANT SELECT ON SEQUENCE public.erp_sync_logs_id_seq TO replication_user;

GRANT ALL ON TABLE public.erp_synced_products TO authenticated;

GRANT ALL ON TABLE public.erp_synced_products TO service_role;

GRANT SELECT ON TABLE public.erp_synced_products TO replication_user;

GRANT SELECT,USAGE ON SEQUENCE public.erp_synced_products_id_seq TO authenticated;

GRANT SELECT,USAGE ON SEQUENCE public.erp_synced_products_id_seq TO anon;

GRANT SELECT ON SEQUENCE public.erp_synced_products_id_seq TO replication_user;

GRANT SELECT ON TABLE public.expense_parent_categories TO authenticated;

GRANT ALL ON TABLE public.expense_parent_categories TO service_role;

GRANT SELECT ON TABLE public.expense_parent_categories TO replication_user;

GRANT ALL ON SEQUENCE public.expense_parent_categories_id_seq TO anon;

GRANT ALL ON SEQUENCE public.expense_parent_categories_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.expense_parent_categories_id_seq TO replication_user;

GRANT SELECT ON TABLE public.expense_requisitions TO authenticated;

GRANT ALL ON TABLE public.expense_requisitions TO service_role;

GRANT SELECT ON TABLE public.expense_requisitions TO replication_user;

GRANT ALL ON SEQUENCE public.expense_requisitions_id_seq TO anon;

GRANT ALL ON SEQUENCE public.expense_requisitions_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.expense_requisitions_id_seq TO replication_user;

GRANT SELECT ON TABLE public.expense_scheduler TO authenticated;

GRANT ALL ON TABLE public.expense_scheduler TO service_role;

GRANT SELECT ON TABLE public.expense_scheduler TO replication_user;

GRANT ALL ON SEQUENCE public.expense_scheduler_id_seq TO anon;

GRANT ALL ON SEQUENCE public.expense_scheduler_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.expense_scheduler_id_seq TO replication_user;

GRANT SELECT ON TABLE public.expense_sub_categories TO authenticated;

GRANT ALL ON TABLE public.expense_sub_categories TO service_role;

GRANT SELECT ON TABLE public.expense_sub_categories TO replication_user;

GRANT ALL ON SEQUENCE public.expense_sub_categories_id_seq TO anon;

GRANT ALL ON SEQUENCE public.expense_sub_categories_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.expense_sub_categories_id_seq TO replication_user;

GRANT SELECT ON TABLE public.flyer_offer_products TO authenticated;

GRANT ALL ON TABLE public.flyer_offer_products TO service_role;

GRANT SELECT ON TABLE public.flyer_offer_products TO replication_user;

GRANT SELECT ON TABLE public.flyer_offers TO authenticated;

GRANT ALL ON TABLE public.flyer_offers TO service_role;

GRANT SELECT ON TABLE public.flyer_offers TO replication_user;

GRANT SELECT ON TABLE public.flyer_templates TO authenticated;

GRANT ALL ON TABLE public.flyer_templates TO service_role;

GRANT SELECT ON TABLE public.flyer_templates TO replication_user;

GRANT SELECT,INSERT ON TABLE public.frontend_builds TO authenticated;

GRANT ALL ON TABLE public.frontend_builds TO service_role;

GRANT SELECT ON TABLE public.frontend_builds TO replication_user;

GRANT SELECT,USAGE ON SEQUENCE public.frontend_builds_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.frontend_builds_id_seq TO replication_user;

GRANT ALL ON TABLE public.hr_analysed_attendance_data TO authenticated;

GRANT ALL ON TABLE public.hr_analysed_attendance_data TO service_role;

GRANT SELECT ON TABLE public.hr_analysed_attendance_data TO replication_user;

GRANT SELECT,USAGE ON SEQUENCE public.hr_analysed_attendance_data_id_seq TO anon;

GRANT SELECT,USAGE ON SEQUENCE public.hr_analysed_attendance_data_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.hr_analysed_attendance_data_id_seq TO replication_user;

GRANT ALL ON TABLE public.hr_basic_salary TO authenticated;

GRANT ALL ON TABLE public.hr_basic_salary TO service_role;

GRANT SELECT ON TABLE public.hr_basic_salary TO replication_user;

GRANT SELECT,USAGE ON SEQUENCE public.hr_checklist_operations_id_seq TO anon;

GRANT SELECT,USAGE ON SEQUENCE public.hr_checklist_operations_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.hr_checklist_operations_id_seq TO replication_user;

GRANT ALL ON TABLE public.hr_checklist_operations TO authenticated;

GRANT ALL ON TABLE public.hr_checklist_operations TO service_role;

GRANT SELECT ON TABLE public.hr_checklist_operations TO replication_user;

GRANT SELECT,USAGE ON SEQUENCE public.hr_checklist_questions_id_seq TO anon;

GRANT SELECT,USAGE ON SEQUENCE public.hr_checklist_questions_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.hr_checklist_questions_id_seq TO replication_user;

GRANT ALL ON TABLE public.hr_checklist_questions TO authenticated;

GRANT ALL ON TABLE public.hr_checklist_questions TO service_role;

GRANT SELECT ON TABLE public.hr_checklist_questions TO replication_user;

GRANT SELECT,USAGE ON SEQUENCE public.hr_checklists_id_seq TO anon;

GRANT SELECT,USAGE ON SEQUENCE public.hr_checklists_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.hr_checklists_id_seq TO replication_user;

GRANT ALL ON TABLE public.hr_checklists TO authenticated;

GRANT ALL ON TABLE public.hr_checklists TO service_role;

GRANT SELECT ON TABLE public.hr_checklists TO replication_user;

GRANT SELECT ON TABLE public.hr_departments TO authenticated;

GRANT ALL ON TABLE public.hr_departments TO service_role;

GRANT SELECT ON TABLE public.hr_departments TO replication_user;

GRANT ALL ON TABLE public.hr_employee_master TO authenticated;

GRANT ALL ON TABLE public.hr_employee_master TO service_role;

GRANT SELECT ON TABLE public.hr_employee_master TO replication_user;

GRANT SELECT ON TABLE public.hr_employees TO authenticated;

GRANT ALL ON TABLE public.hr_employees TO service_role;

GRANT SELECT ON TABLE public.hr_employees TO replication_user;

GRANT SELECT ON TABLE public.hr_fingerprint_transactions TO authenticated;

GRANT ALL ON TABLE public.hr_fingerprint_transactions TO service_role;

GRANT SELECT ON TABLE public.hr_fingerprint_transactions TO replication_user;

GRANT ALL ON TABLE public.hr_insurance_companies TO authenticated;

GRANT ALL ON TABLE public.hr_insurance_companies TO service_role;

GRANT SELECT ON TABLE public.hr_insurance_companies TO replication_user;

GRANT SELECT ON SEQUENCE public.hr_insurance_company_id_seq TO replication_user;

GRANT SELECT ON TABLE public.hr_levels TO authenticated;

GRANT ALL ON TABLE public.hr_levels TO service_role;

GRANT SELECT ON TABLE public.hr_levels TO replication_user;

GRANT SELECT ON TABLE public.hr_position_assignments TO authenticated;

GRANT ALL ON TABLE public.hr_position_assignments TO service_role;

GRANT SELECT ON TABLE public.hr_position_assignments TO replication_user;

GRANT SELECT ON TABLE public.hr_position_reporting_template TO authenticated;

GRANT ALL ON TABLE public.hr_position_reporting_template TO service_role;

GRANT SELECT ON TABLE public.hr_position_reporting_template TO replication_user;

GRANT SELECT ON TABLE public.hr_positions TO authenticated;

GRANT ALL ON TABLE public.hr_positions TO service_role;

GRANT SELECT ON TABLE public.hr_positions TO replication_user;

GRANT SELECT,USAGE ON SEQUENCE public.incident_actions_id_seq TO authenticated;

GRANT SELECT,USAGE ON SEQUENCE public.incident_actions_id_seq TO anon;

GRANT SELECT ON SEQUENCE public.incident_actions_id_seq TO replication_user;

GRANT ALL ON TABLE public.incident_actions TO authenticated;

GRANT ALL ON TABLE public.incident_actions TO service_role;

GRANT SELECT ON TABLE public.incident_actions TO replication_user;

GRANT ALL ON TABLE public.incident_types TO authenticated;

GRANT ALL ON TABLE public.incident_types TO service_role;

GRANT SELECT ON TABLE public.incident_types TO replication_user;

GRANT ALL ON TABLE public.incidents TO authenticated;

GRANT ALL ON TABLE public.incidents TO service_role;

GRANT SELECT ON TABLE public.incidents TO replication_user;

GRANT SELECT ON TABLE public.interface_permissions TO authenticated;

GRANT ALL ON TABLE public.interface_permissions TO service_role;

GRANT SELECT ON TABLE public.interface_permissions TO replication_user;

GRANT ALL ON TABLE public.lease_rent_lease_parties TO authenticated;

GRANT ALL ON TABLE public.lease_rent_lease_parties TO service_role;

GRANT SELECT ON TABLE public.lease_rent_lease_parties TO replication_user;

GRANT ALL ON TABLE public.lease_rent_payment_entries TO authenticated;

GRANT ALL ON TABLE public.lease_rent_payment_entries TO service_role;

GRANT SELECT ON TABLE public.lease_rent_payment_entries TO replication_user;

GRANT ALL ON TABLE public.lease_rent_payments TO authenticated;

GRANT ALL ON TABLE public.lease_rent_payments TO service_role;

GRANT SELECT ON TABLE public.lease_rent_payments TO replication_user;

GRANT ALL ON TABLE public.lease_rent_properties TO authenticated;

GRANT ALL ON TABLE public.lease_rent_properties TO service_role;

GRANT SELECT ON TABLE public.lease_rent_properties TO replication_user;

GRANT ALL ON TABLE public.lease_rent_property_spaces TO authenticated;

GRANT ALL ON TABLE public.lease_rent_property_spaces TO service_role;

GRANT SELECT ON TABLE public.lease_rent_property_spaces TO replication_user;

GRANT ALL ON TABLE public.lease_rent_rent_parties TO authenticated;

GRANT ALL ON TABLE public.lease_rent_rent_parties TO service_role;

GRANT SELECT ON TABLE public.lease_rent_rent_parties TO replication_user;

GRANT ALL ON TABLE public.lease_rent_special_changes TO authenticated;

GRANT ALL ON TABLE public.lease_rent_special_changes TO service_role;

GRANT SELECT ON TABLE public.lease_rent_special_changes TO replication_user;

GRANT ALL ON TABLE public.mobile_themes TO authenticated;

GRANT ALL ON TABLE public.mobile_themes TO service_role;

GRANT SELECT ON TABLE public.mobile_themes TO replication_user;

GRANT SELECT,USAGE ON SEQUENCE public.mobile_themes_id_seq TO authenticated;

GRANT SELECT,USAGE ON SEQUENCE public.mobile_themes_id_seq TO anon;

GRANT ALL ON TABLE public.multi_shift_date_wise TO authenticated;

GRANT ALL ON TABLE public.multi_shift_date_wise TO service_role;

GRANT SELECT ON TABLE public.multi_shift_date_wise TO replication_user;

GRANT SELECT,USAGE ON SEQUENCE public.multi_shift_date_wise_id_seq TO authenticated;

GRANT SELECT,USAGE ON SEQUENCE public.multi_shift_date_wise_id_seq TO anon;

GRANT ALL ON TABLE public.multi_shift_regular TO authenticated;

GRANT ALL ON TABLE public.multi_shift_regular TO service_role;

GRANT SELECT ON TABLE public.multi_shift_regular TO replication_user;

GRANT SELECT,USAGE ON SEQUENCE public.multi_shift_regular_id_seq TO authenticated;

GRANT SELECT,USAGE ON SEQUENCE public.multi_shift_regular_id_seq TO anon;

GRANT ALL ON TABLE public.multi_shift_weekday TO authenticated;

GRANT ALL ON TABLE public.multi_shift_weekday TO service_role;

GRANT SELECT ON TABLE public.multi_shift_weekday TO replication_user;

GRANT SELECT,USAGE ON SEQUENCE public.multi_shift_weekday_id_seq TO authenticated;

GRANT SELECT,USAGE ON SEQUENCE public.multi_shift_weekday_id_seq TO anon;

GRANT SELECT ON TABLE public.mv_expiry_products TO authenticated;

GRANT ALL ON TABLE public.mv_expiry_products TO service_role;

GRANT SELECT ON TABLE public.mv_expiry_products TO replication_user;

GRANT ALL ON TABLE public.nationalities TO authenticated;

GRANT ALL ON TABLE public.nationalities TO service_role;

GRANT SELECT ON TABLE public.nationalities TO replication_user;

GRANT ALL ON TABLE public.near_expiry_reports TO authenticated;

GRANT ALL ON TABLE public.near_expiry_reports TO service_role;

GRANT SELECT ON TABLE public.near_expiry_reports TO replication_user;

GRANT SELECT ON TABLE public.non_approved_payment_scheduler TO authenticated;

GRANT ALL ON TABLE public.non_approved_payment_scheduler TO service_role;

GRANT SELECT ON TABLE public.non_approved_payment_scheduler TO replication_user;

GRANT ALL ON SEQUENCE public.non_approved_payment_scheduler_id_seq TO anon;

GRANT ALL ON SEQUENCE public.non_approved_payment_scheduler_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.non_approved_payment_scheduler_id_seq TO replication_user;

GRANT SELECT ON TABLE public.notification_attachments TO authenticated;

GRANT ALL ON TABLE public.notification_attachments TO service_role;

GRANT SELECT ON TABLE public.notification_attachments TO replication_user;

GRANT SELECT ON TABLE public.notification_read_states TO authenticated;

GRANT ALL ON TABLE public.notification_read_states TO service_role;

GRANT SELECT ON TABLE public.notification_read_states TO replication_user;

GRANT SELECT ON TABLE public.notification_recipients TO authenticated;

GRANT ALL ON TABLE public.notification_recipients TO service_role;

GRANT SELECT ON TABLE public.notification_recipients TO replication_user;

GRANT SELECT ON TABLE public.notifications TO authenticated;

GRANT ALL ON TABLE public.notifications TO service_role;

GRANT SELECT ON TABLE public.notifications TO replication_user;

GRANT SELECT ON TABLE public.offer_bundles TO authenticated;

GRANT ALL ON TABLE public.offer_bundles TO service_role;

GRANT SELECT ON TABLE public.offer_bundles TO replication_user;

GRANT ALL ON SEQUENCE public.offer_bundles_id_seq TO anon;

GRANT ALL ON SEQUENCE public.offer_bundles_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.offer_bundles_id_seq TO replication_user;

GRANT SELECT ON TABLE public.offer_cart_tiers TO authenticated;

GRANT ALL ON TABLE public.offer_cart_tiers TO service_role;

GRANT SELECT ON TABLE public.offer_cart_tiers TO replication_user;

GRANT ALL ON SEQUENCE public.offer_cart_tiers_id_seq TO anon;

GRANT ALL ON SEQUENCE public.offer_cart_tiers_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.offer_cart_tiers_id_seq TO replication_user;

GRANT ALL ON TABLE public.offer_names TO authenticated;

GRANT ALL ON TABLE public.offer_names TO service_role;

GRANT SELECT ON TABLE public.offer_names TO replication_user;

GRANT SELECT ON TABLE public.offer_products TO authenticated;

GRANT ALL ON TABLE public.offer_products TO service_role;

GRANT SELECT ON TABLE public.offer_products TO replication_user;

GRANT SELECT ON TABLE public.offer_usage_logs TO authenticated;

GRANT ALL ON TABLE public.offer_usage_logs TO service_role;

GRANT SELECT ON TABLE public.offer_usage_logs TO replication_user;

GRANT ALL ON SEQUENCE public.offer_usage_logs_id_seq TO anon;

GRANT ALL ON SEQUENCE public.offer_usage_logs_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.offer_usage_logs_id_seq TO replication_user;

GRANT SELECT ON TABLE public.offers TO authenticated;

GRANT ALL ON TABLE public.offers TO service_role;

GRANT SELECT ON TABLE public.offers TO replication_user;

GRANT ALL ON SEQUENCE public.offers_id_seq TO anon;

GRANT ALL ON SEQUENCE public.offers_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.offers_id_seq TO replication_user;

GRANT ALL ON TABLE public.official_holidays TO authenticated;

GRANT ALL ON TABLE public.official_holidays TO service_role;

GRANT SELECT ON TABLE public.official_holidays TO replication_user;

GRANT SELECT ON TABLE public.order_audit_logs TO authenticated;

GRANT ALL ON TABLE public.order_audit_logs TO service_role;

GRANT SELECT ON TABLE public.order_audit_logs TO replication_user;

GRANT SELECT ON TABLE public.order_items TO authenticated;

GRANT ALL ON TABLE public.order_items TO service_role;

GRANT SELECT ON TABLE public.order_items TO replication_user;

GRANT SELECT ON TABLE public.orders TO authenticated;

GRANT ALL ON TABLE public.orders TO service_role;

GRANT SELECT ON TABLE public.orders TO replication_user;

GRANT SELECT ON TABLE public.overtime_registrations TO authenticated;

GRANT ALL ON TABLE public.overtime_registrations TO service_role;

GRANT SELECT ON TABLE public.overtime_registrations TO replication_user;

GRANT ALL ON TABLE public.pos_deduction_transfers TO authenticated;

GRANT ALL ON TABLE public.pos_deduction_transfers TO service_role;

GRANT SELECT ON TABLE public.pos_deduction_transfers TO replication_user;

GRANT SELECT ON TABLE public.privilege_cards_branch TO authenticated;

GRANT ALL ON TABLE public.privilege_cards_branch TO service_role;

GRANT SELECT ON TABLE public.privilege_cards_branch TO replication_user;

GRANT SELECT ON TABLE public.privilege_cards_master TO authenticated;

GRANT ALL ON TABLE public.privilege_cards_master TO service_role;

GRANT SELECT ON TABLE public.privilege_cards_master TO replication_user;

GRANT ALL ON TABLE public.processed_fingerprint_transactions TO authenticated;

GRANT ALL ON TABLE public.processed_fingerprint_transactions TO service_role;

GRANT SELECT ON TABLE public.processed_fingerprint_transactions TO replication_user;

GRANT SELECT ON SEQUENCE public.processed_fingerprint_transactions_seq TO replication_user;

GRANT ALL ON TABLE public.product_categories TO authenticated;

GRANT ALL ON TABLE public.product_categories TO service_role;

GRANT SELECT ON TABLE public.product_categories TO replication_user;

GRANT ALL ON TABLE public.product_request_bt TO authenticated;

GRANT ALL ON TABLE public.product_request_bt TO service_role;

GRANT SELECT ON TABLE public.product_request_bt TO replication_user;

GRANT ALL ON TABLE public.product_request_po TO authenticated;

GRANT ALL ON TABLE public.product_request_po TO service_role;

GRANT SELECT ON TABLE public.product_request_po TO replication_user;

GRANT ALL ON TABLE public.product_request_st TO authenticated;

GRANT ALL ON TABLE public.product_request_st TO service_role;

GRANT SELECT ON TABLE public.product_request_st TO replication_user;

GRANT ALL ON TABLE public.product_units TO authenticated;

GRANT ALL ON TABLE public.product_units TO service_role;

GRANT SELECT ON TABLE public.product_units TO replication_user;

GRANT ALL ON TABLE public.products TO service_role;

GRANT SELECT ON TABLE public.products TO replication_user;

GRANT ALL ON TABLE public.purchase_voucher_issue_types TO authenticated;

GRANT ALL ON TABLE public.purchase_voucher_issue_types TO service_role;

GRANT SELECT ON TABLE public.purchase_voucher_issue_types TO replication_user;

GRANT ALL ON TABLE public.purchase_voucher_items TO authenticated;

GRANT ALL ON TABLE public.purchase_voucher_items TO service_role;

GRANT SELECT ON TABLE public.purchase_voucher_items TO replication_user;

GRANT ALL ON TABLE public.purchase_vouchers TO authenticated;

GRANT ALL ON TABLE public.purchase_vouchers TO service_role;

GRANT SELECT ON TABLE public.purchase_vouchers TO replication_user;

GRANT SELECT,USAGE ON SEQUENCE public.purchase_vouchers_book_seq TO anon;

GRANT SELECT,USAGE ON SEQUENCE public.purchase_vouchers_book_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.purchase_vouchers_book_seq TO replication_user;

GRANT ALL ON TABLE public.push_subscriptions TO authenticated;

GRANT ALL ON TABLE public.push_subscriptions TO service_role;

GRANT SELECT ON TABLE public.push_subscriptions TO replication_user;

GRANT SELECT ON TABLE public.quick_task_assignments TO authenticated;

GRANT ALL ON TABLE public.quick_task_assignments TO service_role;

GRANT SELECT ON TABLE public.quick_task_assignments TO replication_user;

GRANT SELECT ON TABLE public.quick_task_comments TO authenticated;

GRANT ALL ON TABLE public.quick_task_comments TO service_role;

GRANT SELECT ON TABLE public.quick_task_comments TO replication_user;

GRANT SELECT ON TABLE public.quick_task_completions TO authenticated;

GRANT ALL ON TABLE public.quick_task_completions TO service_role;

GRANT SELECT ON TABLE public.quick_task_completions TO replication_user;

GRANT SELECT ON TABLE public.quick_tasks TO authenticated;

GRANT ALL ON TABLE public.quick_tasks TO service_role;

GRANT SELECT ON TABLE public.quick_tasks TO replication_user;

GRANT SELECT ON TABLE public.users TO authenticated;

GRANT ALL ON TABLE public.users TO service_role;

GRANT SELECT ON TABLE public.users TO replication_user;

GRANT SELECT ON TABLE public.quick_task_completion_details TO authenticated;

GRANT ALL ON TABLE public.quick_task_completion_details TO service_role;

GRANT SELECT ON TABLE public.quick_task_completion_details TO replication_user;

GRANT SELECT ON TABLE public.quick_task_files TO authenticated;

GRANT ALL ON TABLE public.quick_task_files TO service_role;

GRANT SELECT ON TABLE public.quick_task_files TO replication_user;

GRANT SELECT ON TABLE public.quick_task_files_with_details TO authenticated;

GRANT ALL ON TABLE public.quick_task_files_with_details TO service_role;

GRANT SELECT ON TABLE public.quick_task_files_with_details TO replication_user;

GRANT SELECT ON TABLE public.quick_task_user_preferences TO authenticated;

GRANT ALL ON TABLE public.quick_task_user_preferences TO service_role;

GRANT SELECT ON TABLE public.quick_task_user_preferences TO replication_user;

GRANT SELECT ON TABLE public.quick_tasks_with_details TO authenticated;

GRANT ALL ON TABLE public.quick_tasks_with_details TO service_role;

GRANT SELECT ON TABLE public.quick_tasks_with_details TO replication_user;

GRANT SELECT ON TABLE public.receiving_records TO authenticated;

GRANT ALL ON TABLE public.receiving_records TO service_role;

GRANT SELECT ON TABLE public.receiving_records TO replication_user;

GRANT SELECT ON TABLE public.vendors TO authenticated;

GRANT ALL ON TABLE public.vendors TO service_role;

GRANT SELECT ON TABLE public.vendors TO replication_user;

GRANT SELECT ON TABLE public.receiving_records_pr_excel_status TO authenticated;

GRANT ALL ON TABLE public.receiving_records_pr_excel_status TO service_role;

GRANT SELECT ON TABLE public.receiving_records_pr_excel_status TO replication_user;

GRANT SELECT ON TABLE public.receiving_task_templates TO authenticated;

GRANT ALL ON TABLE public.receiving_task_templates TO service_role;

GRANT SELECT ON TABLE public.receiving_task_templates TO replication_user;

GRANT SELECT ON TABLE public.receiving_tasks TO authenticated;

GRANT ALL ON TABLE public.receiving_tasks TO service_role;

GRANT SELECT ON TABLE public.receiving_tasks TO replication_user;

GRANT ALL ON TABLE public.receiving_user_defaults TO authenticated;

GRANT ALL ON TABLE public.receiving_user_defaults TO service_role;

GRANT SELECT ON TABLE public.receiving_user_defaults TO replication_user;

GRANT SELECT ON TABLE public.recurring_assignment_schedules TO authenticated;

GRANT ALL ON TABLE public.recurring_assignment_schedules TO service_role;

GRANT SELECT ON TABLE public.recurring_assignment_schedules TO replication_user;

GRANT SELECT ON TABLE public.recurring_schedule_check_log TO authenticated;

GRANT ALL ON TABLE public.recurring_schedule_check_log TO service_role;

GRANT SELECT ON TABLE public.recurring_schedule_check_log TO replication_user;

GRANT ALL ON SEQUENCE public.recurring_schedule_check_log_id_seq TO anon;

GRANT ALL ON SEQUENCE public.recurring_schedule_check_log_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.recurring_schedule_check_log_id_seq TO replication_user;

GRANT ALL ON TABLE public.regular_shift TO authenticated;

GRANT ALL ON TABLE public.regular_shift TO service_role;

GRANT SELECT ON TABLE public.regular_shift TO replication_user;

GRANT SELECT ON TABLE public.requesters TO authenticated;

GRANT ALL ON TABLE public.requesters TO service_role;

GRANT SELECT ON TABLE public.requesters TO replication_user;

GRANT ALL ON TABLE public.security_code_scroll_texts TO authenticated;

GRANT ALL ON TABLE public.security_code_scroll_texts TO service_role;

GRANT SELECT ON TABLE public.security_code_scroll_texts TO replication_user;

GRANT SELECT,USAGE ON SEQUENCE public.shelf_paper_fonts_id_seq TO anon;

GRANT SELECT,USAGE ON SEQUENCE public.shelf_paper_fonts_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.shelf_paper_fonts_id_seq TO replication_user;

GRANT ALL ON TABLE public.shelf_paper_fonts TO authenticated;

GRANT ALL ON TABLE public.shelf_paper_fonts TO service_role;

GRANT SELECT ON TABLE public.shelf_paper_fonts TO replication_user;

GRANT SELECT ON TABLE public.shelf_paper_templates TO authenticated;

GRANT ALL ON TABLE public.shelf_paper_templates TO service_role;

GRANT SELECT ON TABLE public.shelf_paper_templates TO replication_user;

GRANT SELECT ON TABLE public.sidebar_buttons TO authenticated;

GRANT ALL ON TABLE public.sidebar_buttons TO service_role;

GRANT SELECT ON TABLE public.sidebar_buttons TO replication_user;

GRANT SELECT,USAGE ON SEQUENCE public.sidebar_buttons_id_seq TO anon;

GRANT SELECT,USAGE ON SEQUENCE public.sidebar_buttons_id_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.sidebar_buttons_id_seq TO replication_user;

GRANT ALL ON TABLE public.social_links TO authenticated;

GRANT ALL ON TABLE public.social_links TO service_role;

GRANT SELECT ON TABLE public.social_links TO replication_user;

GRANT ALL ON TABLE public.special_shift_date_wise TO authenticated;

GRANT ALL ON TABLE public.special_shift_date_wise TO service_role;

GRANT SELECT ON TABLE public.special_shift_date_wise TO replication_user;

GRANT ALL ON TABLE public.special_shift_weekday TO authenticated;

GRANT ALL ON TABLE public.special_shift_weekday TO service_role;

GRANT SELECT ON TABLE public.special_shift_weekday TO replication_user;

GRANT ALL ON TABLE public.system_api_keys TO authenticated;

GRANT ALL ON TABLE public.system_api_keys TO service_role;

GRANT SELECT ON TABLE public.system_api_keys TO replication_user;

GRANT SELECT,USAGE ON SEQUENCE public.system_api_keys_id_seq TO authenticated;

GRANT SELECT,USAGE ON SEQUENCE public.system_api_keys_id_seq TO anon;

GRANT SELECT ON TABLE public.task_assignments TO authenticated;

GRANT ALL ON TABLE public.task_assignments TO service_role;

GRANT SELECT ON TABLE public.task_assignments TO replication_user;

GRANT SELECT ON TABLE public.task_images TO authenticated;

GRANT ALL ON TABLE public.task_images TO service_role;

GRANT SELECT ON TABLE public.task_images TO replication_user;

GRANT SELECT ON TABLE public.task_attachments TO authenticated;

GRANT ALL ON TABLE public.task_attachments TO service_role;

GRANT SELECT ON TABLE public.task_attachments TO replication_user;

GRANT SELECT ON TABLE public.task_completions TO authenticated;

GRANT ALL ON TABLE public.task_completions TO service_role;

GRANT SELECT ON TABLE public.task_completions TO replication_user;

GRANT SELECT ON TABLE public.tasks TO authenticated;

GRANT ALL ON TABLE public.tasks TO service_role;

GRANT SELECT ON TABLE public.tasks TO replication_user;

GRANT SELECT ON TABLE public.task_completion_summary TO authenticated;

GRANT ALL ON TABLE public.task_completion_summary TO service_role;

GRANT SELECT ON TABLE public.task_completion_summary TO replication_user;

GRANT SELECT ON TABLE public.task_reminder_logs TO authenticated;

GRANT ALL ON TABLE public.task_reminder_logs TO service_role;

GRANT SELECT ON TABLE public.task_reminder_logs TO replication_user;

GRANT SELECT ON TABLE public.user_audit_logs TO authenticated;

GRANT ALL ON TABLE public.user_audit_logs TO service_role;

GRANT SELECT ON TABLE public.user_audit_logs TO replication_user;

GRANT SELECT ON TABLE public.user_device_sessions TO authenticated;

GRANT ALL ON TABLE public.user_device_sessions TO service_role;

GRANT SELECT ON TABLE public.user_device_sessions TO replication_user;

GRANT ALL ON TABLE public.user_favorite_buttons TO authenticated;

GRANT ALL ON TABLE public.user_favorite_buttons TO service_role;

GRANT SELECT ON TABLE public.user_favorite_buttons TO replication_user;

GRANT SELECT ON TABLE public.user_management_view TO authenticated;

GRANT ALL ON TABLE public.user_management_view TO service_role;

GRANT SELECT ON TABLE public.user_management_view TO replication_user;

GRANT ALL ON TABLE public.user_mobile_theme_assignments TO authenticated;

GRANT ALL ON TABLE public.user_mobile_theme_assignments TO service_role;

GRANT SELECT ON TABLE public.user_mobile_theme_assignments TO replication_user;

GRANT SELECT,USAGE ON SEQUENCE public.user_mobile_theme_assignments_id_seq TO authenticated;

GRANT SELECT,USAGE ON SEQUENCE public.user_mobile_theme_assignments_id_seq TO anon;

GRANT SELECT ON TABLE public.user_password_history TO authenticated;

GRANT ALL ON TABLE public.user_password_history TO service_role;

GRANT SELECT ON TABLE public.user_password_history TO replication_user;

GRANT SELECT ON TABLE public.user_permissions_view TO authenticated;

GRANT ALL ON TABLE public.user_permissions_view TO service_role;

GRANT SELECT ON TABLE public.user_permissions_view TO replication_user;

GRANT SELECT ON TABLE public.user_sessions TO authenticated;

GRANT ALL ON TABLE public.user_sessions TO service_role;

GRANT SELECT ON TABLE public.user_sessions TO replication_user;

GRANT ALL ON TABLE public.user_theme_assignments TO authenticated;

GRANT ALL ON TABLE public.user_theme_assignments TO service_role;

GRANT SELECT ON TABLE public.user_theme_assignments TO replication_user;

GRANT SELECT,USAGE ON SEQUENCE public.user_theme_assignments_id_seq TO authenticated;

GRANT SELECT,USAGE ON SEQUENCE public.user_theme_assignments_id_seq TO anon;

GRANT SELECT ON SEQUENCE public.user_theme_assignments_id_seq TO replication_user;

GRANT ALL ON TABLE public.user_voice_preferences TO authenticated;

GRANT ALL ON TABLE public.user_voice_preferences TO service_role;

GRANT SELECT ON TABLE public.user_voice_preferences TO replication_user;

GRANT SELECT ON TABLE public.variation_audit_log TO authenticated;

GRANT ALL ON TABLE public.variation_audit_log TO service_role;

GRANT SELECT ON TABLE public.variation_audit_log TO replication_user;

GRANT SELECT ON TABLE public.vendor_payment_schedule TO authenticated;

GRANT ALL ON TABLE public.vendor_payment_schedule TO service_role;

GRANT SELECT ON TABLE public.vendor_payment_schedule TO replication_user;

GRANT ALL ON TABLE public.view_offer TO service_role;

GRANT SELECT ON TABLE public.view_offer TO replication_user;

GRANT ALL ON TABLE public.wa_accounts TO authenticated;

GRANT ALL ON TABLE public.wa_accounts TO service_role;

GRANT SELECT ON TABLE public.wa_accounts TO replication_user;

GRANT ALL ON TABLE public.wa_ai_bot_config TO authenticated;

GRANT ALL ON TABLE public.wa_ai_bot_config TO service_role;

GRANT SELECT ON TABLE public.wa_ai_bot_config TO replication_user;

GRANT ALL ON TABLE public.wa_auto_reply_triggers TO authenticated;

GRANT ALL ON TABLE public.wa_auto_reply_triggers TO service_role;

GRANT SELECT ON TABLE public.wa_auto_reply_triggers TO replication_user;

GRANT ALL ON TABLE public.wa_bot_flows TO authenticated;

GRANT ALL ON TABLE public.wa_bot_flows TO service_role;

GRANT SELECT ON TABLE public.wa_bot_flows TO replication_user;

GRANT ALL ON TABLE public.wa_broadcast_recipients TO authenticated;

GRANT ALL ON TABLE public.wa_broadcast_recipients TO service_role;

GRANT SELECT ON TABLE public.wa_broadcast_recipients TO replication_user;

GRANT ALL ON TABLE public.wa_broadcasts TO authenticated;

GRANT ALL ON TABLE public.wa_broadcasts TO service_role;

GRANT SELECT ON TABLE public.wa_broadcasts TO replication_user;

GRANT ALL ON TABLE public.wa_catalog_orders TO authenticated;

GRANT ALL ON TABLE public.wa_catalog_orders TO service_role;

GRANT SELECT ON TABLE public.wa_catalog_orders TO replication_user;

GRANT ALL ON TABLE public.wa_catalog_products TO authenticated;

GRANT ALL ON TABLE public.wa_catalog_products TO service_role;

GRANT SELECT ON TABLE public.wa_catalog_products TO replication_user;

GRANT ALL ON TABLE public.wa_catalogs TO authenticated;

GRANT ALL ON TABLE public.wa_catalogs TO service_role;

GRANT SELECT ON TABLE public.wa_catalogs TO replication_user;

GRANT ALL ON TABLE public.wa_contact_group_members TO authenticated;

GRANT ALL ON TABLE public.wa_contact_group_members TO service_role;

GRANT SELECT ON TABLE public.wa_contact_group_members TO replication_user;

GRANT ALL ON TABLE public.wa_contact_groups TO authenticated;

GRANT ALL ON TABLE public.wa_contact_groups TO service_role;

GRANT SELECT ON TABLE public.wa_contact_groups TO replication_user;

GRANT ALL ON TABLE public.wa_conversations TO authenticated;

GRANT ALL ON TABLE public.wa_conversations TO service_role;

GRANT SELECT ON TABLE public.wa_conversations TO replication_user;

GRANT ALL ON TABLE public.wa_messages TO authenticated;

GRANT ALL ON TABLE public.wa_messages TO service_role;

GRANT SELECT ON TABLE public.wa_messages TO replication_user;

GRANT ALL ON TABLE public.wa_settings TO authenticated;

GRANT ALL ON TABLE public.wa_settings TO service_role;

GRANT SELECT ON TABLE public.wa_settings TO replication_user;

GRANT ALL ON TABLE public.wa_templates TO authenticated;

GRANT ALL ON TABLE public.wa_templates TO service_role;

GRANT SELECT ON TABLE public.wa_templates TO replication_user;

GRANT ALL ON TABLE public.warning_main_category TO authenticated;

GRANT ALL ON TABLE public.warning_main_category TO service_role;

GRANT SELECT ON TABLE public.warning_main_category TO replication_user;

GRANT ALL ON SEQUENCE public.warning_ref_seq TO anon;

GRANT ALL ON SEQUENCE public.warning_ref_seq TO authenticated;

GRANT SELECT ON SEQUENCE public.warning_ref_seq TO replication_user;

GRANT ALL ON TABLE public.warning_sub_category TO authenticated;

GRANT ALL ON TABLE public.warning_sub_category TO service_role;

GRANT SELECT ON TABLE public.warning_sub_category TO replication_user;

GRANT ALL ON TABLE public.warning_violation TO authenticated;

GRANT ALL ON TABLE public.warning_violation TO service_role;

GRANT SELECT ON TABLE public.warning_violation TO replication_user;

GRANT SELECT ON TABLE public.whatsapp_message_log TO authenticated;

GRANT ALL ON TABLE public.whatsapp_message_log TO service_role;

GRANT SELECT ON TABLE public.whatsapp_message_log TO replication_user;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT SELECT ON TABLES  TO authenticated;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO service_role;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT SELECT ON TABLES  TO replication_user;