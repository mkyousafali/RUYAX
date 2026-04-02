-- chunk_03_update.sql

BEGIN
    -- Only proceed if certificate_url was updated (from NULL to a value)
    IF (TG_OP = 'UPDATE' AND OLD.certificate_url IS NULL AND NEW.certificate_url IS NOT NULL) OR
       (TG_OP = 'INSERT' AND NEW.certificate_url IS NOT NULL) THEN
        
        -- Check if payment schedule already exists
        SELECT id INTO existing_schedule_id
        FROM vendor_payment_schedule
        WHERE receiving_record_id = NEW.id
        LIMIT 1;

BEGIN
    UPDATE products
    SET is_customer_product = p_value
    WHERE barcode = ANY(p_barcodes);

RETURN json_build_object(
        'success', true,
        'updated_count', v_count
    );

UPDATE public.customers
            SET name = p_name,
                access_code = v_hashed_code,
                access_code_generated_at = now(),
                registration_status = 'approved',
                updated_at = now()
            WHERE id = v_existing_customer.id
            RETURNING id INTO v_customer_id;

INSERT INTO public.customers (
        name, whatsapp_number, access_code, access_code_generated_at,
        registration_status, created_at, updated_at
    ) VALUES (
        p_name, v_formatted_number, v_hashed_code, now(),
        'approved', now(), now()
    )
    RETURNING id INTO v_customer_id;

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

UPDATE break_register
  SET end_time = NOW(),
      duration_seconds = v_duration,
      status = 'closed'
  WHERE id = v_break.id;

UPDATE public.customers
    SET access_code = v_hashed_new_code,
        access_code_generated_at = v_current_time,
        updated_at = v_current_time
    WHERE id = p_customer_id;

INSERT INTO public.notifications (title, message, type, priority, metadata, deleted_at)
    VALUES (
        'New Access Code Generated',
        'Your access code has been updated by an administrator.',
        'customer_notification', 'high',
        json_build_object('customer_id', p_customer_id, 'generated_by', v_admin_name,
            'generated_at', v_current_time, 'notes', p_notes),
        NULL
    );

BEGIN
  -- Get total count for the filtered set
  SELECT COUNT(*)
  INTO v_total_count
  FROM box_operations bo
  WHERE bo.status = 'completed'
    AND (p_branch_id = 'all' OR bo.branch_id = p_branch_id::int)
    AND (p_date_from IS NULL OR bo.updated_at >= p_date_from)
    AND (p_date_to IS NULL OR bo.updated_at <= p_date_to);

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

BEGIN
  IF _platform = 'facebook' THEN
    UPDATE social_links SET facebook_clicks = facebook_clicks + 1 WHERE branch_id = _branch_id;

ELSIF _platform = 'whatsapp' THEN
    UPDATE social_links SET whatsapp_clicks = whatsapp_clicks + 1 WHERE branch_id = _branch_id;

ELSIF _platform = 'instagram' THEN
    UPDATE social_links SET instagram_clicks = instagram_clicks + 1 WHERE branch_id = _branch_id;

ELSIF _platform = 'tiktok' THEN
    UPDATE social_links SET tiktok_clicks = tiktok_clicks + 1 WHERE branch_id = _branch_id;

ELSIF _platform = 'snapchat' THEN
    UPDATE social_links SET snapchat_clicks = snapchat_clicks + 1 WHERE branch_id = _branch_id;

ELSIF _platform = 'website' THEN
    UPDATE social_links SET website_clicks = website_clicks + 1 WHERE branch_id = _branch_id;

ELSIF _platform = 'location_link' THEN
    UPDATE social_links SET location_link_clicks = location_link_clicks + 1 WHERE branch_id = _branch_id;

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

ELSE -- p_action = 'reject'
        -- Update recovery request status
        UPDATE public.customer_recovery_requests
        SET 
            verification_status = 'rejected',
            processed_by = p_admin_user_id,
            processed_at = v_current_time,
            verification_notes = p_notes
        WHERE id = p_request_id;

NEW.updated_at := NOW();

BEGIN
    -- Step 1: Update broadcast recipients whose wa_messages have a higher status
    UPDATE wa_broadcast_recipients r
    SET status = sub.new_status
    FROM (
        SELECT 
            r2.id AS recipient_id,
            (
                SELECT m.status
                FROM wa_messages m
                WHERE m.whatsapp_message_id = r2.whatsapp_message_id
                ORDER BY 
                    CASE m.status
                        WHEN 'read' THEN 3
                        WHEN 'delivered' THEN 2
                        WHEN 'sent' THEN 1
                        ELSE 0
                    END DESC
                LIMIT 1
            ) AS new_status
        FROM wa_broadcast_recipients r2
        WHERE r2.broadcast_id = p_broadcast_id
          AND r2.whatsapp_message_id IS NOT NULL
    ) sub
    WHERE r.id = sub.recipient_id
      AND sub.new_status IS NOT NULL
      AND (
          CASE sub.new_status
              WHEN 'read' THEN 3
              WHEN 'delivered' THEN 2
              WHEN 'sent' THEN 1
              ELSE 0
          END
      ) > (
          CASE r.status
              WHEN 'read' THEN 3
              WHEN 'delivered' THEN 2
              WHEN 'sent' THEN 1
              ELSE 0
          END
      );

GET DIAGNOSTICS roles_updated = ROW_COUNT;

RETURN roles_updated;

BEGIN
    -- Check if function already exists
    IF EXISTS (SELECT 1 FROM app_functions WHERE function_code = p_function_code) THEN
        -- Update existing function
        UPDATE app_functions 
        SET function_name = p_function_name,
            description = COALESCE(p_description, description),
            category = p_category,
            is_active = p_enabled,
            updated_at = CURRENT_TIMESTAMP
        WHERE function_code = p_function_code
        RETURNING id INTO new_id;

BEGIN
    -- Try to update existing subscription first
    UPDATE push_subscriptions 
    SET 
        endpoint = p_endpoint,
        p256dh = p_p256dh,
        auth = p_auth,
        device_type = p_device_type,
        browser_name = p_browser_name,
        user_agent = p_user_agent,
        is_active = true,
        last_seen = NOW(),
        updated_at = NOW()
    WHERE user_id = p_user_id AND device_id = p_device_id
    RETURNING id INTO subscription_id;

BEGIN
    INSERT INTO user_roles (role_name, role_code, description, is_system_role)
    VALUES (p_role_name, p_role_code, p_description, true)
    ON CONFLICT (role_name) DO UPDATE SET
        role_code = p_role_code,
        description = p_description,
        updated_at = NOW()
    RETURNING id INTO new_role_id;

UPDATE public.customers
    SET access_code = v_hashed_new_code,
        access_code_generated_at = now(),
        updated_at = now()
    WHERE id = v_customer.id;

IF v_existing_completion_id IS NOT NULL THEN
        -- Update existing completion
        UPDATE quick_task_completions
        SET
            completion_notes = COALESCE(p_completion_notes, completion_notes),
            photo_path = COALESCE(array_to_string(p_photos, ','), photo_path),
            erp_reference = COALESCE(p_erp_reference, erp_reference),
            updated_at = now()
        WHERE id = v_existing_completion_id;

BEGIN
    -- Process all unsynced inventory manager task completions
    FOR sync_record IN
        SELECT 
            tc.id as completion_id,
            tc.task_id,
            tc.erp_reference_number,
            rt.receiving_record_id,
            rt.role_type,
            rr.erp_purchase_invoice_reference as current_erp
        FROM task_completions tc
        JOIN receiving_tasks rt ON tc.task_id = rt.task_id AND tc.assignment_id = rt.assignment_id
        JOIN receiving_records rr ON rt.receiving_record_id = rr.id
        WHERE tc.erp_reference_completed = true 
          AND tc.erp_reference_number IS NOT NULL 
          AND TRIM(tc.erp_reference_number) != ''
          AND rt.role_type = 'inventory_manager'
          AND (rr.erp_purchase_invoice_reference IS NULL 
               OR rr.erp_purchase_invoice_reference != TRIM(tc.erp_reference_number))
    LOOP
        -- Update the receiving record
        UPDATE receiving_records 
        SET 
            erp_purchase_invoice_reference = TRIM(sync_record.erp_reference_number),
            updated_at = now()
        WHERE id = sync_record.receiving_record_id;

BEGIN
    -- Find all receiving records that need ERP sync
    FOR sync_record IN
        SELECT 
            rr.id as receiving_record_id,
            tc.erp_reference_number,
            rr.erp_purchase_invoice_reference as current_erp,
            tc.completed_by
        FROM receiving_records rr
        JOIN receiving_tasks rt ON rr.id = rt.receiving_record_id
        JOIN task_completions tc ON rt.task_id = tc.task_id AND rt.assignment_id = tc.assignment_id
        WHERE rt.role_type = 'inventory_manager'
          AND tc.erp_reference_completed = true
          AND tc.erp_reference_number IS NOT NULL
          AND TRIM(tc.erp_reference_number) != ''
          AND (rr.erp_purchase_invoice_reference IS NULL 
               OR rr.erp_purchase_invoice_reference != TRIM(tc.erp_reference_number))
        ORDER BY tc.completed_at DESC
    LOOP
        -- Update the receiving record
        UPDATE receiving_records 
        SET 
            erp_purchase_invoice_reference = TRIM(sync_record.erp_reference_number),
            updated_at = now()
        WHERE id = sync_record.receiving_record_id;

updated_count INTEGER := 0;

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

ELSE
            -- Balance still exists - update the amounts
            UPDATE expense_requisitions
            SET 
                remaining_balance = scheduler_balance,
                used_amount = original_amount - scheduler_balance,
                updated_at = NOW()
            WHERE id = NEW.requisition_id;

NEW.updated_at = NOW();

ELSIF TG_OP = 'DELETE' THEN
        UPDATE notifications 
        SET has_attachments = (
            SELECT COUNT(*) > 0 
            FROM notification_attachments 
            WHERE notification_id = OLD.notification_id
        ),
        updated_at = NOW()
        WHERE id = OLD.notification_id;

RAISE NOTICE 'Updated delivery status for notification % user %', NEW.notification_id, NEW.user_id;

ELSIF TG_OP = 'UPDATE' AND OLD.is_read = TRUE AND NEW.is_read = FALSE THEN
        UPDATE notifications 
        SET read_count = GREATEST(read_count - 1, 0),
            updated_at = NOW()
        WHERE id = NEW.notification_id;

RETURN QUERY SELECT TRUE, 'Order status updated successfully';

BEGIN
    -- 1. Update the request status
    UPDATE product_request_st
    SET status = p_new_status, updated_at = NOW()
    WHERE id = p_request_id
    RETURNING requester_user_id INTO v_requester_user_id;

IF p_is_master_admin IS NOT NULL THEN
    UPDATE users SET is_master_admin = p_is_master_admin, updated_at = NOW() WHERE id = p_user_id;

IF p_is_admin IS NOT NULL THEN
    UPDATE users SET is_admin = p_is_admin, updated_at = NOW() WHERE id = p_user_id;

IF p_user_type IS NOT NULL THEN
    UPDATE users SET user_type = p_user_type::user_type_enum, updated_at = NOW() WHERE id = p_user_id;

IF p_branch_id IS NOT NULL THEN
    UPDATE users SET branch_id = p_branch_id, updated_at = NOW() WHERE id = p_user_id;

IF p_employee_id IS NOT NULL THEN
    UPDATE users SET employee_id = p_employee_id, updated_at = NOW() WHERE id = p_user_id;

IF p_position_id IS NOT NULL THEN
    UPDATE users SET position_id = p_position_id, updated_at = NOW() WHERE id = p_user_id;

IF p_status IS NOT NULL THEN
    UPDATE users SET status = p_status, updated_at = NOW() WHERE id = p_user_id;

IF p_avatar IS NOT NULL THEN
    UPDATE users SET avatar = p_avatar, updated_at = NOW() WHERE id = p_user_id;

RETURN json_build_object(
    'success', true,
    'message', 'User updated successfully'
  );

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

BEGIN
    INSERT INTO branch_sync_config (branch_id, local_supabase_url, local_supabase_key, tunnel_url, is_active)
    VALUES (p_branch_id, p_local_supabase_url, p_local_supabase_key, p_tunnel_url, true)
    ON CONFLICT (branch_id) DO UPDATE SET
        local_supabase_url = EXCLUDED.local_supabase_url,
        local_supabase_key = EXCLUDED.local_supabase_key,
        tunnel_url = COALESCE(EXCLUDED.tunnel_url, branch_sync_config.tunnel_url),
        updated_at = now()
    RETURNING id INTO v_id;

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

v_updated int := 0;

UPDATE erp_synced_products
      SET 
        auto_barcode = COALESCE(v_product->>'auto_barcode', auto_barcode),
        parent_barcode = COALESCE(v_product->>'parent_barcode', parent_barcode),
        product_name_en = COALESCE(v_product->>'product_name_en', product_name_en),
        product_name_ar = COALESCE(v_product->>'product_name_ar', product_name_ar),
        unit_name = COALESCE(v_product->>'unit_name', unit_name),
        unit_qty = COALESCE((v_product->>'unit_qty')::numeric, unit_qty),
        is_base_unit = COALESCE((v_product->>'is_base_unit')::boolean, is_base_unit),
        expiry_dates = v_merged_expiry,
        synced_at = NOW()
      WHERE barcode = v_product->>'barcode';

v_updated := v_updated + 1;

RETURN jsonb_build_object(
    'inserted', v_inserted,
    'updated', v_updated
  );

ELSE
            -- Auto-update the receiving task if bill is already uploaded
            UPDATE receiving_tasks 
            SET 
                original_bill_uploaded = true,
                original_bill_file_path = receiving_record.original_bill_url,
                updated_at = now()
            WHERE id = receiving_task_id_param;

UPDATE users
  SET quick_access_code = v_hashed_code,
      updated_at = NOW()
  WHERE id = v_user_id;

UPDATE quick_task_completions 
    SET completion_status = new_status,
        verified_by_user_id = verified_by_user_id_param,
        verified_at = now(),
        verification_notes = verification_notes_param,
        updated_at = now()
    WHERE id = completion_id_param;

GRANT ALL ON FUNCTION public.complete_visit_and_update_next(visit_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.complete_visit_and_update_next(visit_id uuid) TO anon;

GRANT ALL ON FUNCTION public.trigger_update_order_totals() TO service_role;

GRANT ALL ON FUNCTION public.trigger_update_order_totals() TO anon;

GRANT ALL ON FUNCTION public.update_approval_permissions_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_approval_permissions_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_attendance_hours() TO service_role;

GRANT ALL ON FUNCTION public.update_attendance_hours() TO anon;

GRANT ALL ON FUNCTION public.update_bogo_offer_rules_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_bogo_offer_rules_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_box_operations_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_box_operations_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_branch_sync_status(p_branch_id bigint, p_status text, p_details jsonb) TO anon;

GRANT ALL ON FUNCTION public.update_branch_sync_status(p_branch_id bigint, p_status text, p_details jsonb) TO service_role;

GRANT ALL ON FUNCTION public.update_branches_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_branches_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_coupon_campaigns_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_coupon_campaigns_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_coupon_products_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_coupon_products_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_customer_app_media_timestamp() TO service_role;

GRANT ALL ON FUNCTION public.update_customer_app_media_timestamp() TO anon;

GRANT ALL ON FUNCTION public.update_customer_recovery_requests_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_customer_recovery_requests_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_customers_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_customers_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_day_off_reasons_timestamp() TO service_role;

GRANT ALL ON FUNCTION public.update_day_off_reasons_timestamp() TO anon;

GRANT ALL ON FUNCTION public.update_day_off_timestamp() TO service_role;

GRANT ALL ON FUNCTION public.update_day_off_timestamp() TO anon;

GRANT ALL ON FUNCTION public.update_day_off_weekday_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_day_off_weekday_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_deadline_datetime() TO service_role;

GRANT ALL ON FUNCTION public.update_deadline_datetime() TO anon;

GRANT ALL ON FUNCTION public.update_delivery_tiers_timestamp() TO service_role;

GRANT ALL ON FUNCTION public.update_delivery_tiers_timestamp() TO anon;

GRANT ALL ON FUNCTION public.update_denomination_transactions_timestamp() TO service_role;

GRANT ALL ON FUNCTION public.update_denomination_transactions_timestamp() TO anon;

GRANT ALL ON FUNCTION public.update_denomination_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_denomination_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_departments_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_departments_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_duty_schedule_timestamp() TO service_role;

GRANT ALL ON FUNCTION public.update_duty_schedule_timestamp() TO anon;

GRANT ALL ON FUNCTION public.update_early_leave_timestamp() TO service_role;

GRANT ALL ON FUNCTION public.update_early_leave_timestamp() TO anon;

GRANT ALL ON FUNCTION public.update_employee_positions_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_employee_positions_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_erp_connections_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_erp_connections_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_erp_daily_sales_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_erp_daily_sales_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_expense_categories_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_expense_categories_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_expense_parent_categories_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_expense_parent_categories_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_expense_scheduler_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_expense_scheduler_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_final_bill_amount_on_adjustment() TO service_role;

GRANT ALL ON FUNCTION public.update_final_bill_amount_on_adjustment() TO anon;

GRANT ALL ON FUNCTION public.update_flyer_templates_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_flyer_templates_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_hr_employee_master_timestamp() TO service_role;

GRANT ALL ON FUNCTION public.update_hr_employee_master_timestamp() TO anon;

GRANT ALL ON FUNCTION public.update_interface_permissions_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_interface_permissions_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_issue_types_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_issue_types_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_levels_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_levels_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_main_document_columns() TO service_role;

GRANT ALL ON FUNCTION public.update_main_document_columns() TO anon;

GRANT ALL ON FUNCTION public.update_next_visit_date(visit_id uuid) TO service_role;

GRANT ALL ON FUNCTION public.update_next_visit_date(visit_id uuid) TO anon;

GRANT ALL ON FUNCTION public.update_non_approved_scheduler_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_non_approved_scheduler_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_notification_attachments_flag() TO service_role;

GRANT ALL ON FUNCTION public.update_notification_attachments_flag() TO anon;

GRANT ALL ON FUNCTION public.update_notification_delivery_status() TO service_role;

GRANT ALL ON FUNCTION public.update_notification_delivery_status() TO anon;

GRANT ALL ON FUNCTION public.update_notification_queue_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_notification_queue_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_notification_read_count() TO service_role;

GRANT ALL ON FUNCTION public.update_notification_read_count() TO anon;

GRANT ALL ON FUNCTION public.update_offer_cart_tiers_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_offer_cart_tiers_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_offers_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_offers_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_order_status(p_order_id uuid, p_new_status character varying, p_user_id uuid, p_notes text) TO service_role;

GRANT ALL ON FUNCTION public.update_order_status(p_order_id uuid, p_new_status character varying, p_user_id uuid, p_notes text) TO anon;

GRANT ALL ON FUNCTION public.update_payment_transactions_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_payment_transactions_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_pos_deduction_transfers_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_pos_deduction_transfers_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_positions_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_positions_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_product_categories_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_product_categories_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_product_units_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_product_units_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_products_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_products_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_purchase_voucher_items_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_purchase_voucher_items_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_purchase_vouchers_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_purchase_vouchers_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_push_subscriptions_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_push_subscriptions_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_quick_task_completions_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_quick_task_completions_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_quick_task_status() TO service_role;

GRANT ALL ON FUNCTION public.update_quick_task_status() TO anon;

GRANT ALL ON FUNCTION public.update_receiving_records_pr_excel_timestamp() TO service_role;

GRANT ALL ON FUNCTION public.update_receiving_records_pr_excel_timestamp() TO anon;

GRANT ALL ON FUNCTION public.update_receiving_records_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_receiving_records_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_receiving_task_completion(receiving_task_id_param uuid, erp_reference_param character varying, original_bill_uploaded_param boolean, original_bill_file_path_param text) TO service_role;

GRANT ALL ON FUNCTION public.update_receiving_task_completion(receiving_task_id_param uuid, erp_reference_param character varying, original_bill_uploaded_param boolean, original_bill_file_path_param text) TO anon;

GRANT ALL ON FUNCTION public.update_receiving_task_templates_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_receiving_task_templates_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_receiving_tasks_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_receiving_tasks_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_regular_shift_timestamp() TO service_role;

GRANT ALL ON FUNCTION public.update_regular_shift_timestamp() TO anon;

GRANT ALL ON FUNCTION public.update_requisition_balance() TO service_role;

GRANT ALL ON FUNCTION public.update_requisition_balance() TO anon;

GRANT ALL ON FUNCTION public.update_requisition_balance_old() TO service_role;

GRANT ALL ON FUNCTION public.update_requisition_balance_old() TO anon;

GRANT ALL ON FUNCTION public.update_social_links_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_social_links_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_special_shift_date_wise_timestamp() TO service_role;

GRANT ALL ON FUNCTION public.update_special_shift_date_wise_timestamp() TO anon;

GRANT ALL ON FUNCTION public.update_special_shift_weekday_timestamp() TO service_role;

GRANT ALL ON FUNCTION public.update_special_shift_weekday_timestamp() TO anon;

GRANT ALL ON FUNCTION public.update_stock_request_status(p_request_id uuid, p_new_status character varying) TO anon;

GRANT ALL ON FUNCTION public.update_tax_categories_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_tax_categories_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_updated_at_column() TO service_role;

GRANT ALL ON FUNCTION public.update_updated_at_column() TO anon;

GRANT ALL ON FUNCTION public.update_user(p_user_id uuid, p_username character varying, p_is_master_admin boolean, p_is_admin boolean, p_user_type character varying, p_branch_id bigint, p_employee_id uuid, p_position_id uuid, p_status character varying, p_avatar text) TO anon;

GRANT ALL ON FUNCTION public.update_user(p_user_id uuid, p_username character varying, p_is_master_admin boolean, p_is_admin boolean, p_user_type character varying, p_branch_id bigint, p_employee_id uuid, p_position_id uuid, p_status character varying, p_avatar text) TO service_role;

GRANT ALL ON FUNCTION public.update_user_device_sessions_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_user_device_sessions_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_vendor_payment_with_exact_calculation(payment_id uuid, new_discount_amount numeric, new_grr_amount numeric, new_pri_amount numeric, discount_notes_val text, grr_reference_val text, grr_notes_val text, pri_reference_val text, pri_notes_val text, history_val jsonb) TO service_role;

GRANT ALL ON FUNCTION public.update_vendor_payment_with_exact_calculation(payment_id uuid, new_discount_amount numeric, new_grr_amount numeric, new_pri_amount numeric, discount_notes_val text, grr_reference_val text, grr_notes_val text, pri_reference_val text, pri_notes_val text, history_val jsonb) TO anon;

GRANT ALL ON FUNCTION public.update_warning_main_category_timestamp() TO service_role;

GRANT ALL ON FUNCTION public.update_warning_main_category_timestamp() TO anon;

GRANT ALL ON FUNCTION public.update_warning_sub_category_timestamp() TO service_role;

GRANT ALL ON FUNCTION public.update_warning_sub_category_timestamp() TO anon;

GRANT ALL ON FUNCTION public.update_warning_updated_at() TO service_role;

GRANT ALL ON FUNCTION public.update_warning_updated_at() TO anon;

GRANT ALL ON FUNCTION public.update_warning_violation_timestamp() TO service_role;

GRANT ALL ON FUNCTION public.update_warning_violation_timestamp() TO anon;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.branches TO authenticated;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.products TO authenticated;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.view_offer TO authenticated;