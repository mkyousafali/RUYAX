--

CREATE FUNCTION public.handle_document_deactivation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- If document is being deactivated, clear the main document columns
    IF OLD.is_active = TRUE AND NEW.is_active = FALSE THEN
        IF NEW.document_type = 'health_card' THEN
            NEW.health_card_number := NULL;
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



--
-- Name: handle_order_task_completion(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.handle_order_task_completion() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_task RECORD;
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

    -- Get the task details
    SELECT * INTO v_task FROM quick_tasks WHERE id = NEW.quick_task_id;
    
    -- Only handle order-related tasks
    IF v_task.order_id IS NULL THEN
        RETURN NEW;
    END IF;

    -- Get the order
    SELECT * INTO v_order FROM orders WHERE id = v_task.order_id;
    
    IF v_order IS NULL THEN
        RETURN NEW;
    END IF;

    -- Update quick_tasks status to completed too
    UPDATE quick_tasks SET status = 'completed', completed_at = NOW(), updated_at = NOW() WHERE id = v_task.id;

    -- ==========================================
    -- STEP 1: Start Picking completed
    -- ==========================================
    IF v_task.issue_type = 'order-start-picking' THEN
        -- Update order status to in_picking (Preparing)
        UPDATE orders SET 
            order_status = 'in_picking',
            updated_at = NOW()
        WHERE id = v_order.id;

        -- Log audit: picking started/preparing
        INSERT INTO order_audit_logs (order_id, action_type, from_status, to_status, performed_by, notes)
        VALUES (v_order.id, 'status_change', v_order.order_status, 'in_picking', NEW.assigned_to_user_id, 
                'Start picking completed - preparing order');

        -- Auto-create "Finish Picking" task for the same picker
        INSERT INTO quick_tasks (
            title, description, priority, issue_type, price_tag,
            assigned_by, assigned_to_branch_id, order_id,
            deadline_datetime, require_task_finished, require_photo_upload, require_erp_reference
        ) VALUES (
            'Finish Picking #' || v_order.order_number || '|||إنهاء تحضير #' || v_order.order_number,
            'Finish picking products for order #' || v_order.order_number || E'\nCustomer: ' || v_order.customer_name || '|||أنهِ تحضير المنتجات للطلب #' || v_order.order_number || E'\nالعميل: ' || v_order.customer_name,
            'high',
            'order-finish-picking',
            'high',
            v_task.assigned_by,
            v_task.assigned_to_branch_id,
            v_order.id,
            NOW() + INTERVAL '15 minutes',
            true, false, false
        ) RETURNING id INTO v_finish_task_id;

        -- Assign to the same picker
        INSERT INTO quick_task_assignments (
            quick_task_id, assigned_to_user_id, status,
            require_task_finished, require_photo_upload, require_erp_reference
        ) VALUES (
            v_finish_task_id, NEW.assigned_to_user_id, 'assigned',
            true, false, false
        );

        -- Notify picker about finish task
        v_notif_title := 'Finish Picking: Order #' || v_order.order_number || '|||إنهاء التحضير: طلب #' || v_order.order_number;
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

    -- ==========================================
    -- STEP 2: Finish Picking completed (or legacy order-picking)
    -- ==========================================
    ELSIF v_task.issue_type IN ('order-finish-picking', 'order-picking') THEN
        -- Picker completed → Order is ready
        UPDATE orders SET 
            order_status = 'ready',
            ready_at = NOW(),
            updated_at = NOW()
        WHERE id = v_order.id AND order_status IN ('in_picking', 'accepted');

        -- Create bilingual notification: Order Ready
        v_notif_title := 'Order #' || v_order.order_number || ' Ready|||طلب #' || v_order.order_number || ' جاهز';
        
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

        -- Create recipients for admins
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

        -- Log audit
        INSERT INTO order_audit_logs (order_id, action_type, from_status, to_status, performed_by, notes)
        VALUES (v_order.id, 'status_change', 'in_picking', 'ready', NEW.assigned_to_user_id, 
                'Picking completed - order ready');

    -- ==========================================
    -- STEP 3: Delivery completed
    -- ==========================================
    ELSIF v_task.issue_type = 'order-delivery' THEN
        -- Delivery completed → Order is delivered
        UPDATE orders SET 
            order_status = 'delivered',
            delivered_at = NOW(),
            actual_delivery_time = NOW(),
            updated_at = NOW()
        WHERE id = v_order.id AND order_status = 'out_for_delivery';

        -- Create bilingual notification: Order Delivered
        v_notif_title := 'Order #' || v_order.order_number || ' Delivered|||طلب #' || v_order.order_number || ' تم التوصيل';
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

        -- Log audit
        INSERT INTO order_audit_logs (order_id, action_type, from_status, to_status, performed_by, notes)
        VALUES (v_order.id, 'status_change', 'out_for_delivery', 'delivered', NEW.assigned_to_user_id,
                'Delivery completed');
    END IF;

    RETURN NEW;
END;
$$;



--
-- Name: has_order_management_access(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.has_order_management_access(user_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM users u
        LEFT JOIN user_roles ur ON u.position_id::text = ur.role_code
        WHERE u.id = user_id
        AND (
            -- Use boolean flags instead of role_type
            u.is_admin = true 
            OR u.is_master_admin = true
            OR ur.role_code IN (
                'CEO',
                'OPERATIONS_MANAGER',
                'BRANCH_MANAGER',
                'CUSTOMER_SERVICE_SUPERVISOR',
                'NIGHT_SUPERVISORS',
                'IT_SYSTEMS_MANAGER'
            )
        )
    );
END;
$$;



--
-- Name: FUNCTION has_order_management_access(user_id uuid); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.has_order_management_access(user_id uuid) IS 'Check if user has management-level access to orders (Admin, Master Admin, CEO, Operations Manager, Branch Manager, Customer Service Supervisor, Night Supervisors, IT Systems Manager)';


--
-- Name: hash_password(text, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.hash_password(password text, salt text) RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN crypt(password, salt);
END;
$$;



--
-- Name: import_sync_batch(text, jsonb); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.import_sync_batch(p_table_name text, p_data jsonb) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $_$
DECLARE 
    v_count integer := 0;
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

    -- Disable FK constraint triggers
    PERFORM set_config('session_replication_role', 'replica', true);
    
    -- Insert with OVERRIDING SYSTEM VALUE to handle GENERATED ALWAYS identity columns
    EXECUTE format(
        'INSERT INTO %I OVERRIDING SYSTEM VALUE SELECT * FROM jsonb_populate_recordset(null::%I, $1)',
        p_table_name, p_table_name
    ) USING p_data;
    
    GET DIAGNOSTICS v_count = ROW_COUNT;
    
    -- Re-enable
    PERFORM set_config('session_replication_role', 'origin', true);
    
    RETURN v_count;
EXCEPTION WHEN OTHERS THEN
    PERFORM set_config('session_replication_role', 'origin', true);
    RAISE;
END;
$_$;



--
-- Name: increment_ai_token_usage(uuid, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.increment_ai_token_usage(config_id uuid, p_tokens integer, p_prompt integer, p_completion integer) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  UPDATE wa_ai_bot_config SET
    tokens_used = COALESCE(tokens_used, 0) + p_tokens,
    prompt_tokens_used = COALESCE(prompt_tokens_used, 0) + p_prompt,
    completion_tokens_used = COALESCE(completion_tokens_used, 0) + p_completion,
    total_requests = COALESCE(total_requests, 0) + 1
  WHERE id = config_id;
END;
$$;



--
-- Name: increment_flyer_template_usage(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.increment_flyer_template_usage() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE flyer_templates
  SET 
    usage_count = usage_count + 1,
    last_used_at = now()
  WHERE id = NEW.template_id;
  
  RETURN NEW;
END;
$$;



--
-- Name: increment_page_visit_count(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.increment_page_visit_count(offer_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE view_offer
  SET page_visit_count = page_visit_count + 1
  WHERE id = offer_id;
END;
$$;



--
-- Name: increment_social_link_click(bigint, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.increment_social_link_click(_branch_id bigint, _platform text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_count BIGINT;
BEGIN
  IF _platform = 'facebook' THEN
    UPDATE social_links SET facebook_clicks = facebook_clicks + 1 WHERE branch_id = _branch_id;
    SELECT facebook_clicks INTO v_count FROM social_links WHERE branch_id = _branch_id;
  ELSIF _platform = 'whatsapp' THEN
    UPDATE social_links SET whatsapp_clicks = whatsapp_clicks + 1 WHERE branch_id = _branch_id;
    SELECT whatsapp_clicks INTO v_count FROM social_links WHERE branch_id = _branch_id;
  ELSIF _platform = 'instagram' THEN
    UPDATE social_links SET instagram_clicks = instagram_clicks + 1 WHERE branch_id = _branch_id;
    SELECT instagram_clicks INTO v_count FROM social_links WHERE branch_id = _branch_id;
  ELSIF _platform = 'tiktok' THEN
    UPDATE social_links SET tiktok_clicks = tiktok_clicks + 1 WHERE branch_id = _branch_id;
    SELECT tiktok_clicks INTO v_count FROM social_links WHERE branch_id = _branch_id;
  ELSIF _platform = 'snapchat' THEN
    UPDATE social_links SET snapchat_clicks = snapchat_clicks + 1 WHERE branch_id = _branch_id;
    SELECT snapchat_clicks INTO v_count FROM social_links WHERE branch_id = _branch_id;
  ELSIF _platform = 'website' THEN
    UPDATE social_links SET website_clicks = website_clicks + 1 WHERE branch_id = _branch_id;
    SELECT website_clicks INTO v_count FROM social_links WHERE branch_id = _branch_id;
  ELSIF _platform = 'location_link' THEN
    UPDATE social_links SET location_link_clicks = location_link_clicks + 1 WHERE branch_id = _branch_id;
    SELECT location_link_clicks INTO v_count FROM social_links WHERE branch_id = _branch_id;
  END IF;

  RETURN json_build_object('branch_id', _branch_id, 'platform', _platform, 'click_count', v_count);
END;
$$;



--
-- Name: increment_view_button_count(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.increment_view_button_count(offer_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE view_offer
  SET view_button_count = view_button_count + 1
  WHERE id = offer_id;
END;
$$;



--
-- Name: insert_order_items(jsonb); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.insert_order_items(p_order_items jsonb) RETURNS TABLE(success boolean, message text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_count integer;
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



--
-- Name: insert_vendor_from_excel(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.insert_vendor_from_excel(p_erp_vendor_code character varying, p_vendor_name character varying, p_vat_number character varying DEFAULT NULL::character varying) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    vendor_id UUID;
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



--
-- Name: insert_vendor_from_excel(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.insert_vendor_from_excel(p_erp_vendor_code character varying, p_vendor_name_english character varying, p_vendor_name_arabic character varying DEFAULT NULL::character varying, p_vat_number character varying DEFAULT NULL::character varying) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    vendor_id UUID;
    vendor_company CHARACTER VARYING(255);
BEGIN
    -- Use English name as company if provided, otherwise use the main vendor name
    vendor_company := COALESCE(p_vendor_name_english, p_vendor_name_arabic, 'Unknown Company');
    
    -- Insert vendor with Excel column mapping
    INSERT INTO public.vendors (
        erp_vendor_code,
        name,
        name_ar,
        vat_number,
        company,
        tax_id,
        category,
        status,
        payment_terms
    ) VALUES (
        p_erp_vendor_code,
        COALESCE(p_vendor_name_english, p_vendor_name_arabic),
        p_vendor_name_arabic,
        p_vat_number,
        vendor_company,
        p_vat_number, -- Map VAT number to tax_id as well
        'General',
        'active',
        'N/A'
    )
    ON CONFLICT (erp_vendor_code) 
    DO UPDATE SET
        name = EXCLUDED.name,
        name_ar = EXCLUDED.name_ar,
        vat_number = EXCLUDED.vat_number,
        company = EXCLUDED.company,
        tax_id = EXCLUDED.tax_id,
        payment_terms = EXCLUDED.payment_terms,
        updated_at = NOW()
    RETURNING id INTO vendor_id;
    
    RETURN vendor_id;
END;
$$;



--
-- Name: is_delivery_staff(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.is_delivery_staff(user_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM users u
        LEFT JOIN user_roles ur ON u.position_id::text = ur.role_code
        WHERE u.id = user_id
        AND ur.role_code IN ('DELIVERY_STAFF', 'DRIVER')
    );
END;
$$;



--
-- Name: FUNCTION is_delivery_staff(user_id uuid); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.is_delivery_staff(user_id uuid) IS 'Check if user is delivery staff (Delivery Staff, Driver)';


--
-- Name: is_overnight_shift(time without time zone, time without time zone); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.is_overnight_shift(start_time time without time zone, end_time time without time zone) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
    RETURN start_time > end_time;
END;
$$;



--
-- Name: is_product_in_active_bundle(uuid, integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.is_product_in_active_bundle(p_product_id uuid, p_exclude_offer_id integer DEFAULT NULL::integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_found BOOLEAN;
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



--
-- Name: is_quick_access_code_available(text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.is_quick_access_code_available(p_quick_access_code text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
BEGIN
    -- Validate format first
    IF LENGTH(p_quick_access_code) != 6 OR p_quick_access_code !~ '^[0-9]{6}$' THEN
        RETURN false;
    END IF;
    
    -- Check if code exists
    RETURN NOT EXISTS (SELECT 1 FROM users WHERE quick_access_code = p_quick_access_code);
END;
$_$;



--
-- Name: is_quick_access_code_available(character varying); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.is_quick_access_code_available(p_quick_access_code character varying) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  RETURN NOT EXISTS (
    SELECT 1 FROM users
    WHERE extensions.crypt(p_quick_access_code, quick_access_code) = quick_access_code
  );
END;
$$;



--
-- Name: is_user_admin(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.is_user_admin(check_user_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  user_is_master_admin BOOLEAN;
  user_is_admin BOOLEAN;
BEGIN
  SELECT is_master_admin, is_admin
  INTO user_is_master_admin, user_is_admin
  FROM users
  WHERE id = check_user_id;
  
  RETURN COALESCE(user_is_master_admin, false) OR COALESCE(user_is_admin, false);
END;
$$;



--
-- Name: is_user_master_admin(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.is_user_master_admin(check_user_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  user_is_master_admin BOOLEAN;
BEGIN
  SELECT is_master_admin
  INTO user_is_master_admin
  FROM users
  WHERE id = check_user_id;
  
  RETURN COALESCE(user_is_master_admin, false);
END;
$$;



--
-- Name: link_finger_transaction_to_employee(character varying, uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.link_finger_transaction_to_employee(p_employee_code character varying, p_branch_id uuid) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_employee_id UUID;
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



--
-- Name: log_offer_usage(integer, uuid, integer, numeric, numeric, numeric, jsonb); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.log_offer_usage(p_offer_id integer, p_customer_id uuid, p_order_id integer, p_discount_applied numeric, p_original_amount numeric, p_final_amount numeric, p_cart_items jsonb DEFAULT NULL::jsonb) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_log_id INTEGER;
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
    
    -- Increment offer usage counter
    UPDATE offers
    SET current_total_uses = current_total_uses + 1
    WHERE id = p_offer_id;
    
    -- Update customer_offers if customer-specific
    UPDATE customer_offers
    SET is_used = true,
        used_at = NOW(),
        usage_count = usage_count + 1
    WHERE offer_id = p_offer_id AND customer_id = p_customer_id;
    
    RETURN v_log_id;
END;
$$;



--
-- Name: log_user_action(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.log_user_action() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO user_audit_logs (
        user_id,
        action,
        table_name,
        record_id,
        old_values,
        new_values,
        created_at
    ) VALUES (
        CASE 
            WHEN TG_OP = 'DELETE' THEN OLD.id
            ELSE NEW.id
        END,
        TG_OP,
        TG_TABLE_NAME,
        CASE 
            WHEN TG_OP = 'DELETE' THEN OLD.id
            ELSE NEW.id
        END,
        CASE 
            WHEN TG_OP = 'UPDATE' THEN row_to_json(OLD)
            WHEN TG_OP = 'DELETE' THEN row_to_json(OLD)
            ELSE NULL
        END,
        CASE 
            WHEN TG_OP = 'INSERT' THEN row_to_json(NEW)
            WHEN TG_OP = 'UPDATE' THEN row_to_json(NEW)
            ELSE NULL
        END,
        now()
    );
    
    RETURN CASE 
        WHEN TG_OP = 'DELETE' THEN OLD
        ELSE NEW
    END;
END;
$$;



--
-- Name: mark_overdue_quick_tasks(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.mark_overdue_quick_tasks() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Mark main tasks as overdue
    UPDATE quick_tasks 
    SET status = 'overdue', updated_at = NOW()
    WHERE deadline_datetime < NOW() 
    AND status NOT IN ('completed', 'overdue');
    
    -- Mark individual assignments as overdue
    UPDATE quick_task_assignments
    SET status = 'overdue', updated_at = NOW()
    WHERE quick_task_id IN (
        SELECT id FROM quick_tasks 
        WHERE deadline_datetime < NOW()
    )
    AND status NOT IN ('completed', 'overdue');
END;
$$;



--
-- Name: notify_branches_change(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.notify_branches_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM pg_notify(
        'branches_changed',
        json_build_object(
            'operation', TG_OP,
            'id', COALESCE(NEW.id, OLD.id),
            'timestamp', NOW()
        )::text
    );
    RETURN COALESCE(NEW, OLD);
END;
$$;



--
-- Name: notify_customer_order_status_change(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.notify_customer_order_status_change() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_order RECORD;
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

    -- Get the order with customer_id
    SELECT id, order_number, customer_id, customer_name, fulfillment_method
    INTO v_order
    FROM orders
    WHERE id = NEW.order_id;

    IF v_order IS NULL OR v_order.customer_id IS NULL THEN
        RETURN NEW;
    END IF;

    v_customer_id := v_order.customer_id;

    -- Check if this customer has any active push subscriptions
    IF NOT EXISTS (
        SELECT 1 FROM push_subscriptions 
        WHERE customer_id = v_customer_id AND is_active = true
    ) THEN
        RETURN NEW;
    END IF;

    -- Build bilingual push notification content (Arabic primary)
    CASE NEW.to_status
        WHEN 'accepted' THEN
            v_title := 'تم قبول طلبك ✅';
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

    -- Use internal Kong URL for pg_net call
    v_supabase_url := 'http://supabase-kong:8000';
    
    -- Get service role key
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

    -- Fallback to anon key
    IF v_service_role_key IS NULL THEN
        v_service_role_key := 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6InN1cGFiYXNlIiwiaWF0IjoxNzY0ODc1NTI3LCJleHAiOjIwODA0NTE1Mjd9.IT_YSPU9oivuGveKfRarwccr59SNMzX_36cw04Lf448';
    END IF;

    -- Send HTTP request to edge function via pg_net
    SELECT net.http_post(
        url := v_supabase_url || '/functions/v1/send-push-notification',
        headers := jsonb_build_object(
            'Content-Type', 'application/json',
            'Authorization', 'Bearer ' || v_service_role_key
        ),
        body := jsonb_build_object(
            'notificationId', NEW.id::text,
            'customerIds', jsonb_build_array(v_customer_id::text),
            'payload', jsonb_build_object(
                'title', v_title,
                'body', v_body,
                'url', v_url,
                'type', v_type,
                'icon', '/icons/icon-192x192.png',
                'badge', '/icons/icon-72x72.png'
            )
        )
    ) INTO v_request_id;

    RAISE LOG 'Customer push notification queued for customer % (order %), request_id: %', 
        v_customer_id, v_order.order_number, v_request_id;

    RETURN NEW;
END;
$$;



--
-- Name: notify_erp_daily_sales_change(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.notify_erp_daily_sales_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM pg_notify(
        'erp_daily_sales_changed',
        json_build_object(
            'operation', TG_OP,
            'id', COALESCE(NEW.id, OLD.id),
            'sale_date', COALESCE(NEW.sale_date, OLD.sale_date),
            'timestamp', extract(epoch from now())
        )::text
    );
    RETURN COALESCE(NEW, OLD);
END;
$$;



--
-- Name: process_clearance_certificate_generation(uuid, text, uuid, text, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.process_clearance_certificate_generation(receiving_record_id_param uuid, clearance_certificate_url_param text, generated_by_user_id uuid, generated_by_name text DEFAULT NULL::text, generated_by_role text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_tasks_created INT := 0;
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

  -- =======================================================
  -- STEP 2: LOAD RECEIVING RECORD WITH RELATED DATA
  -- =======================================================
  SELECT
    rr.*,
    v.vendor_name,
    b.name_en as branch_name,
    COALESCE(emp.name, u.username) as received_by_name
  INTO v_receiving_record
  FROM receiving_records rr
  LEFT JOIN vendors v ON v.erp_vendor_id = rr.vendor_id AND v.branch_id = rr.branch_id
  LEFT JOIN branches b ON b.id = rr.branch_id
  LEFT JOIN users u ON u.id = rr.user_id
  LEFT JOIN hr_employees emp ON emp.id = u.employee_id
  WHERE rr.id = receiving_record_id_param;

  IF NOT FOUND THEN
    RETURN json_build_object(
      'success', false,
      'error', 'Receiving record not found',
      'error_code', 'RECORD_NOT_FOUND',
      'tasks_created', 0,
      'notifications_sent', 0
    );
  END IF;

  -- =======================================================
  -- STEP 3: CREATE TASKS FROM TEMPLATES
  -- =======================================================
  FOR v_template IN
    SELECT * FROM receiving_task_templates
    ORDER BY priority DESC, id ASC
  LOOP

    -- Replace placeholders in title
    v_title := v_template.title_template;
    v_title := REPLACE(v_title, '{bill_number}', COALESCE(v_receiving_record.bill_number, 'N/A'));
    v_title := REPLACE(v_title, '{vendor_name}', COALESCE(v_receiving_record.vendor_name, 'Unknown Vendor'));
    v_title := REPLACE(v_title, '{branch_name}', COALESCE(v_receiving_record.branch_name, 'Unknown Branch'));

    -- Replace placeholders in description
    v_description := v_template.description_template;
    v_description := REPLACE(v_description, '{bill_number}', COALESCE(v_receiving_record.bill_number, 'N/A'));
    v_description := REPLACE(v_description, '{vendor_name}', COALESCE(v_receiving_record.vendor_name, 'Unknown Vendor'));
    v_description := REPLACE(v_description, '{branch_name}', COALESCE(v_receiving_record.branch_name, 'Unknown Branch'));
    v_description := REPLACE(v_description, '{vendor_id}', COALESCE(v_receiving_record.vendor_id::TEXT, 'N/A'));
    v_description := REPLACE(v_description, '{bill_amount}', COALESCE(v_receiving_record.bill_amount::TEXT, 'N/A'));
    v_description := REPLACE(v_description, '{bill_date}', COALESCE(TO_CHAR(v_receiving_record.bill_date, 'YYYY-MM-DD'), 'N/A'));
    v_description := REPLACE(v_description, '{received_by}', COALESCE(v_receiving_record.received_by_name, 'Unknown'));
    v_description := REPLACE(v_description, '{certificate_url}', COALESCE(clearance_certificate_url_param, 'Not Available'));

    -- Calculate due date based on template deadline_hours
    v_due_date := (NOW() AT TIME ZONE 'UTC' AT TIME ZONE '+03:00') + (v_template.deadline_hours || ' hours')::INTERVAL;

    -- Replace {deadline} placeholder
    v_description := REPLACE(v_description, '{deadline}', TO_CHAR(v_due_date, 'YYYY-MM-DD HH24:MI') || ' UTC+3');

    -- =======================================================
    -- ROLE-BASED USER ASSIGNMENT
    -- For array roles (night_supervisor, warehouse_handler, shelf_stocker):
    --   create a task for EACH user in the array
    -- For single-user roles: create one task
    -- =======================================================

    IF v_template.role_type IN ('night_supervisor', 'warehouse_handler', 'shelf_stocker') THEN
      -- ARRAY ROLES: loop through ALL users in the array
      DECLARE
        v_user_ids UUID[];
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

            -- Send notification
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

  -- =======================================================
  -- STEP 6: RETURN SUCCESS RESPONSE
  -- =======================================================
  RETURN json_build_object(
    'success', true,
    'tasks_created', v_tasks_created,
    'notifications_sent', v_notifications_sent,
    'receiving_record_id', receiving_record_id_param,
    'certificate_url', clearance_certificate_url_param
  );

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



--
-- Name: FUNCTION process_clearance_certificate_generation(receiving_record_id_param uuid, clearance_certificate_url_param text, generated_by_user_id uuid, generated_by_name text, generated_by_role text); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.process_clearance_certificate_generation(receiving_record_id_param uuid, clearance_certificate_url_param text, generated_by_user_id uuid, generated_by_name text, generated_by_role text) IS 'Generates tasks and notifications when a clearance certificate is created. Fixed to properly set deadline_date, deadline_time, and require_task_finished=true for all task assignments. Purchasing Manager gets 72-hour deadline, all others get 24-hour deadline.';


--
-- Name: process_customer_recovery(uuid, uuid, text, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.process_customer_recovery(p_request_id uuid, p_admin_user_id uuid, p_action text, p_notes text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_request_record record;
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
    
    -- Validate action
    IF p_action NOT IN ('approve', 'reject') THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Action must be either "approve" or "reject"'
        );
    END IF;
    
    -- Get recovery request details
    SELECT 
        r.id,
        r.customer_id,
        r.customer_name,
        r.whatsapp_number,
        r.verification_status,
        r.request_type
    INTO v_request_record
    FROM public.customer_recovery_requests r
    WHERE r.id = p_request_id
    AND r.verification_status = 'pending';
    
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
        
        -- Update customer with new access code
        UPDATE public.customers
        SET 
            access_code = v_new_access_code,
            access_code_generated_at = v_current_time,
            updated_at = v_current_time
        WHERE id = v_request_record.customer_id;
        
        -- Update recovery request status
        UPDATE public.customer_recovery_requests
        SET 
            verification_status = 'processed',
            processed_by = p_admin_user_id,
            processed_at = v_current_time,
            verification_notes = p_notes
        WHERE id = p_request_id;
        
        -- Create success notification
        INSERT INTO public.notifications (
            title,
            message,
            type,
            priority,
            metadata,
            deleted_at
        ) VALUES (
            'Customer Recovery Approved',
            'Recovery request for ' || v_request_record.customer_name || ' has been approved by ' || v_admin_name,
            'customer_recovery_approved',
            'high',
            json_build_object(
                'customer_id', v_request_record.customer_id,
                'customer_name', v_request_record.customer_name,
                'whatsapp_number', v_request_record.whatsapp_number,
                'new_access_code', v_new_access_code,
                'processed_by', v_admin_name,
                'processed_at', v_current_time,
                'request_id', p_request_id,
                'notes', p_notes
            ),
            NULL
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
        
    ELSE -- p_action = 'reject'
        -- Update recovery request status
        UPDATE public.customer_recovery_requests
        SET 
            verification_status = 'rejected',
            processed_by = p_admin_user_id,
            processed_at = v_current_time,
            verification_notes = p_notes
        WHERE id = p_request_id;
        
        -- Create rejection notification
        INSERT INTO public.notifications (
            title,
            message,
            type,
            priority,
            metadata,
            deleted_at
        ) VALUES (
            'Customer Recovery Rejected',
            'Recovery request for ' || v_request_record.customer_name || ' has been rejected by ' || v_admin_name,
            'customer_recovery_rejected',
            'medium',
            json_build_object(
                'customer_id', v_request_record.customer_id,
                'customer_name', v_request_record.customer_name,
                'whatsapp_number', v_request_record.whatsapp_number,
                'processed_by', v_admin_name,
                'processed_at', v_current_time,
                'request_id', p_request_id,
                'notes', p_notes
            ),
            NULL
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
    
    -- Log admin activity
    INSERT INTO public.user_activity_logs (
        user_id,
        activity_type,
        description,
        metadata,
        created_at
    ) VALUES (
        p_admin_user_id,
        'customer_recovery_' || p_action,
        p_action || 'ed customer recovery request for: ' || v_request_record.customer_name,
        json_build_object(
            'customer_id', v_request_record.customer_id,
            'customer_name', v_request_record.customer_name,
            'whatsapp_number', v_request_record.whatsapp_number,
            'request_id', p_request_id,
            'new_access_code', CASE WHEN p_action = 'approve' THEN v_new_access_code ELSE NULL END,
            'notes', p_notes
        ),
        v_current_time
    );
    
    RETURN result;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Failed to process customer recovery: ' || SQLERRM
        );
END;
$$;



--
-- Name: process_finger_transaction_linking(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.process_finger_transaction_linking() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Link with employee if not already set
    IF NEW.employee_id IS NULL THEN
        NEW.employee_id := link_finger_transaction_to_employee(
            NEW.employee_code,
            NEW.branch_id
        );
    END IF;
    
    NEW.updated_at := NOW();
    RETURN NEW;
END;
$$;



--
-- Name: queue_push_notification(uuid, text, jsonb, text[], uuid[]); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.queue_push_notification(p_notification_id uuid, p_target_type text, p_target_users jsonb DEFAULT NULL::jsonb, p_target_roles text[] DEFAULT NULL::text[], p_target_branches uuid[] DEFAULT NULL::uuid[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    user_record RECORD;
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
    
    -- Process based on target type
    CASE p_target_type
        WHEN 'all_users' THEN
            -- Queue for all active users with push subscriptions
            FOR subscription_record IN 
                SELECT DISTINCT ps.user_id, ps.endpoint, ps.p256dh, ps.auth
                FROM push_subscriptions ps
                JOIN users u ON ps.user_id = u.id
                WHERE u.status = 'active'
                  AND ps.status = 'active'
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



--
-- Name: queue_quick_task_push_notifications(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.queue_quick_task_push_notifications() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    user_record RECORD;
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

        -- Queue push notifications for each target user
        FOR user_record IN 
            SELECT DISTINCT jsonb_array_elements_text(NEW.target_users) as user_id
        LOOP
            INSERT INTO notification_queue (
                notification_id,
                user_id,
                status,
                payload,
                created_at
            ) VALUES (
                NEW.id,
                user_record.user_id::uuid,
                'pending',
                notification_payload,
                NOW()
            );
        END LOOP;
    END IF;
    
    RETURN NEW;
END;
$$;



--
-- Name: FUNCTION queue_quick_task_push_notifications(); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.queue_quick_task_push_notifications() IS 'Enhanced queue function with better payload information for Quick Task notifications';


--
-- Name: reassign_receiving_task(uuid, uuid, text, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.reassign_receiving_task(receiving_task_id_param uuid, new_assigned_user_id uuid, reassigned_by_user_id text, reassignment_reason text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    receiving_task RECORD;
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
    
    -- Check if reassignment is allowed for this task type
    IF NOT receiving_task.requires_reassignment THEN
        RAISE EXCEPTION 'This task type does not allow reassignment';
    END IF;
    
    -- Reassign the task assignment
    SELECT reassign_task(
        receiving_task.assignment_id,
        new_assigned_user_id::TEXT,
        NULL, -- branch_id
        reassigned_by_user_id,
        reassignment_reason
    ) INTO new_assignment_id;
    
    -- Update the receiving task with new assignment
    UPDATE receiving_tasks 
    SET 
        assignment_id = new_assignment_id,
        assigned_user_id = new_assigned_user_id,
        updated_at = now()
    WHERE id = receiving_task_id_param;
    
    -- Create notification for new assignee
    INSERT INTO notifications (
        title, message, created_by, created_by_name,
        target_type, target_users, type, priority,
        task_id, task_assignment_id, has_attachments,
        metadata
    ) VALUES (
        'Task Reassigned to You',
        format('A %s task has been reassigned to you. Reason: %s', 
               receiving_task.role_type, 
               COALESCE(reassignment_reason, 'No reason provided')),
        reassigned_by_user_id, 'System',
        'specific_users', to_jsonb(ARRAY[new_assigned_user_id::TEXT]),
        'task', 'medium',
        receiving_task.task_id, new_assignment_id,
        receiving_task.clearance_certificate_url IS NOT NULL,
        jsonb_build_object(
            'receiving_task_id', receiving_task_id_param,
            'original_assignee', receiving_task.assigned_user_id,
            'reassignment_reason', reassignment_reason
        )
    );
    
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



--
-- Name: reassign_task(uuid, uuid, uuid, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.reassign_task(assignment_id uuid, new_assignee uuid, reassigned_by uuid, reason text DEFAULT NULL::text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    UPDATE task_assignments 
    SET 
        assigned_to = new_assignee,
        reassigned_by = reassigned_by,
        reassignment_reason = reason,
        updated_at = NOW()
    WHERE id = assignment_id;
    
    RETURN FOUND;
END;
$$;



--
-- Name: reassign_task(uuid, text, text, uuid, text, boolean); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.reassign_task(p_assignment_id uuid, p_reassigned_by text, p_new_user_id text DEFAULT NULL::text, p_new_branch_id uuid DEFAULT NULL::uuid, p_reassignment_reason text DEFAULT NULL::text, p_copy_deadline boolean DEFAULT true) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_assignment_id UUID;
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
    
    -- Create new assignment
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
        require_erp_reference,
        reassigned_from,
        reassignment_reason,
        reassigned_at
    ) VALUES (
        original_assignment.task_id,
        original_assignment.assignment_type,
        p_new_user_id,
        p_new_branch_id,
        p_reassigned_by,
        NULL, -- Will be filled by the application
        CASE WHEN p_copy_deadline THEN original_assignment.schedule_date ELSE NULL END,
        CASE WHEN p_copy_deadline THEN original_assignment.schedule_time ELSE NULL END,
        CASE WHEN p_copy_deadline THEN original_assignment.deadline_date ELSE NULL END,
        CASE WHEN p_copy_deadline THEN original_assignment.deadline_time ELSE NULL END,
        original_assignment.is_reassignable,
        original_assignment.notes,
        original_assignment.priority_override,
        original_assignment.require_task_finished,
        original_assignment.require_photo_upload,
        original_assignment.require_erp_reference,
        p_assignment_id,
        p_reassignment_reason,
        now()
    )
    RETURNING id INTO new_assignment_id;
    
    -- Mark original assignment as reassigned
    UPDATE public.task_assignments 
    SET status = 'reassigned',
        completed_at = now()
    WHERE id = p_assignment_id;
    
    RETURN new_assignment_id;
END;
$$;



--
-- Name: FUNCTION reassign_task(p_assignment_id uuid, p_reassigned_by text, p_new_user_id text, p_new_branch_id uuid, p_reassignment_reason text, p_copy_deadline boolean); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.reassign_task(p_assignment_id uuid, p_reassigned_by text, p_new_user_id text, p_new_branch_id uuid, p_reassignment_reason text, p_copy_deadline boolean) IS 'Reassigns a task to a different user or branch while maintaining audit trail';


--
-- Name: record_fine_payment(uuid, numeric, character varying, character varying, uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

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
-- Name: refresh_broadcast_status(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.refresh_broadcast_status(p_broadcast_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_total int;
    v_sent_count int;
    v_delivered_count int;
    v_read_count int;
    v_failed_count int;
    v_pending_count int;
    v_broadcast_status text;
    v_old_status text;
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

    -- Step 2: Count statuses (exclusive - each recipient counted in exactly one category)
    SELECT 
        count(*) FILTER (WHERE status = 'pending'),
        count(*) FILTER (WHERE status = 'sent'),
        count(*) FILTER (WHERE status = 'delivered'),
        count(*) FILTER (WHERE status = 'read'),
        count(*) FILTER (WHERE status = 'failed'),
        count(*)
    INTO v_pending_count, v_sent_count, v_delivered_count, v_read_count, v_failed_count, v_total
    FROM wa_broadcast_recipients
    WHERE broadcast_id = p_broadcast_id;

    -- Step 3: Determine broadcast status
    SELECT status INTO v_old_status FROM wa_broadcasts WHERE id = p_broadcast_id;
    v_broadcast_status := v_old_status;
    
    IF v_pending_count > 0 THEN
        v_broadcast_status := 'sending';
    ELSIF v_failed_count = v_total AND v_total > 0 THEN
        v_broadcast_status := 'failed';
    ELSIF v_pending_count = 0 AND v_total > 0 THEN
        v_broadcast_status := 'completed';
    END IF;

    -- Step 4: Update the broadcast row with exclusive counts
    UPDATE wa_broadcasts
    SET 
        sent_count = v_sent_count,
        delivered_count = v_delivered_count,
        read_count = v_read_count,
        failed_count = v_failed_count,
        total_recipients = v_total,
        status = v_broadcast_status
    WHERE id = p_broadcast_id;

    -- Return summary
    RETURN jsonb_build_object(
        'status', v_broadcast_status,
        'total_recipients', v_total,
        'sent_count', v_sent_count,
        'delivered_count', v_delivered_count,
        'read_count', v_read_count,
        'failed_count', v_failed_count,
        'pending_count', v_pending_count
    );
END;
$$;



--
-- Name: refresh_edge_functions_cache(jsonb); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.refresh_edge_functions_cache(p_functions jsonb) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  DELETE FROM public.edge_functions_cache;
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



--
-- Name: refresh_expiry_cache(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.refresh_expiry_cache() RETURNS void
    LANGUAGE sql
    AS $$
  REFRESH MATERIALIZED VIEW CONCURRENTLY mv_expiry_products;
$$;



--
-- Name: refresh_user_roles_from_positions(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.refresh_user_roles_from_positions() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    roles_updated INTEGER := 0;
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
    
    -- Update existing roles to ensure they're active
    UPDATE user_roles 
    SET is_active = true, updated_at = NOW()
    WHERE role_name IN (
        SELECT position_title_en 
        FROM hr_positions 
        WHERE position_title_en IS NOT NULL
    )
    AND is_system_role = false;
    
    RETURN roles_updated;
END;
$$;



--
-- Name: register_app_function(text, text, text, text, boolean); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.register_app_function(p_function_name text, p_function_code text, p_description text DEFAULT NULL::text, p_category text DEFAULT 'Application'::text, p_enabled boolean DEFAULT true) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_id UUID;
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



--
-- Name: register_push_subscription(uuid, character varying, text, text, text, character varying, character varying, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.register_push_subscription(p_user_id uuid, p_device_id character varying, p_endpoint text, p_p256dh text, p_auth text, p_device_type character varying DEFAULT 'desktop'::character varying, p_browser_name character varying DEFAULT NULL::character varying, p_user_agent text DEFAULT NULL::text) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    subscription_id UUID;
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
    
    -- If no existing subscription found, create new one
    IF subscription_id IS NULL THEN
        INSERT INTO push_subscriptions (
            user_id,
            device_id,
            endpoint,
            p256dh,
            auth,
            device_type,
            browser_name,
            user_agent,
            is_active,
            last_seen,
            created_at,
            updated_at
        ) VALUES (
            p_user_id,
            p_device_id,
            p_endpoint,
            p_p256dh,
            p_auth,
            p_device_type,
            p_browser_name,
            p_user_agent,
            true,
            NOW(),
            NOW(),
            NOW()
        ) RETURNING id INTO subscription_id;
    END IF;
    
    RETURN subscription_id;
END;
$$;



--
-- Name: register_system_role(text, text, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.register_system_role(p_role_name text, p_role_code text, p_description text) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_role_id UUID;
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



--
-- Name: request_access_code_change(character varying, character varying); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.request_access_code_change(p_email character varying, p_whatsapp character varying) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_user_id UUID;
  v_otp VARCHAR(6);
  v_whatsapp_clean VARCHAR(20);
BEGIN
  -- Clean WhatsApp number (remove spaces, dashes)
  v_whatsapp_clean := REGEXP_REPLACE(p_whatsapp, '[\s\-]', '', 'g');

  -- Find the user by matching email AND whatsapp_number in hr_employee_master
  -- Correct relationship: hr_employee_master.user_id = users.id
  SELECT u.id INTO v_user_id
  FROM users u
  JOIN hr_employee_master e ON e.user_id = u.id
  WHERE LOWER(TRIM(e.email)) = LOWER(TRIM(p_email))
    AND REGEXP_REPLACE(e.whatsapp_number, '[\s\-]', '', 'g') = v_whatsapp_clean
    AND u.status = 'active'
  LIMIT 1;

  IF v_user_id IS NULL THEN
    RETURN json_build_object(
      'success', false,
      'message', 'No matching user found. Please check your email and WhatsApp number.'
    );
  END IF;

  -- Rate limit: max 3 OTP requests per hour per user
  IF (
    SELECT COUNT(*) FROM access_code_otp
    WHERE user_id = v_user_id
      AND created_at > NOW() - INTERVAL '1 hour'
  ) >= 3 THEN
    RETURN json_build_object(
      'success', false,
      'message', 'Too many requests. Please try again later.'
    );
  END IF;

  -- Delete any existing unused OTPs for this user
  DELETE FROM access_code_otp WHERE user_id = v_user_id AND verified = false;

  -- Generate 6-digit OTP
  v_otp := LPAD(FLOOR(RANDOM() * 1000000)::TEXT, 6, '0');

  -- Store OTP (expires in 5 minutes)
  INSERT INTO access_code_otp (user_id, otp_code, email, whatsapp_number, expires_at)
  VALUES (v_user_id, v_otp, p_email, v_whatsapp_clean, NOW() + INTERVAL '5 minutes');

  RETURN json_build_object(
    'success', true,
    'otp', v_otp,
    'whatsapp_number', v_whatsapp_clean,
    'message', 'OTP generated successfully'
  );
END;
$$;



--
-- Name: request_access_code_resend(text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.request_access_code_resend(p_whatsapp_number text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'extensions'
    AS $$
DECLARE
    v_customer record;
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
    
    -- Generate NEW code (can't retrieve hashed one)
    v_new_access_code := generate_unique_customer_access_code();
    v_hashed_new_code := encode(digest(v_new_access_code::bytea, 'sha256'), 'hex');

    UPDATE public.customers
    SET access_code = v_hashed_new_code,
        access_code_generated_at = now(),
        updated_at = now()
    WHERE id = v_customer.id;

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



--
-- Name: request_new_access_code(text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.request_new_access_code(p_whatsapp_number text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_customer_id uuid;
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
    
    -- Clean WhatsApp number (remove non-digits)
    p_whatsapp_number := regexp_replace(p_whatsapp_number, '[^0-9]', '', 'g');
    
    -- Add country code if not present (assume Saudi +966 for 9-digit numbers)
    IF length(p_whatsapp_number) = 9 THEN
        p_whatsapp_number := '966' || p_whatsapp_number;
    END IF;
    
    -- Find customer by WhatsApp number (check both formats: with and without +)
    SELECT 
        id,
        name
    INTO 
        v_customer_id,
        v_customer_name
    FROM public.customers
    WHERE (whatsapp_number = p_whatsapp_number 
           OR whatsapp_number = '+' || p_whatsapp_number
           OR regexp_replace(whatsapp_number, '[^0-9]', '', 'g') = p_whatsapp_number)
    AND registration_status = 'approved'
    LIMIT 1;
    
    -- Check if customer exists
    IF v_customer_id IS NULL THEN
        RETURN json_build_object(
            'success', false,
            'error', 'No approved customer account found with this WhatsApp number. Please contact support if you believe this is an error.'
        );
    END IF;
    
    -- Create recovery request record
    BEGIN
        INSERT INTO public.customer_recovery_requests (
            customer_id,
            whatsapp_number,
            customer_name,
            request_type,
            verification_status
        ) VALUES (
            v_customer_id,
            p_whatsapp_number,
            v_customer_name,
            'account_recovery',
            'pending'
        ) RETURNING id INTO v_request_id;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN json_build_object(
                'success', false,
                'error', 'Failed to create recovery request: ' || SQLERRM
            );
    END;

    -- Create notification for admin users
    BEGIN
        -- Get all admin user IDs (using boolean flags instead of role_type)
        DECLARE
            v_admin_user_ids text[];
        BEGIN
            SELECT array_agg(id::text) INTO v_admin_user_ids
            FROM public.users 
            WHERE (is_admin = true OR is_master_admin = true)
            AND status = 'active';
            
            -- Create notification for specific admin users
            INSERT INTO public.notifications (
                title,
                message,
                type,
                priority,
                target_type,
                target_users,
                status,
                created_by,
                created_by_name,
                created_by_role,
                metadata
            ) VALUES (
                'Account Recovery Request',
                'Customer ' || v_customer_name || ' has requested account recovery via WhatsApp: +' || p_whatsapp_number,
                'info',
                'high',
                'specific_users',
                array_to_json(v_admin_user_ids)::jsonb,
                'published',
                'b658eca1-3cc1-48b2-bd3c-33b81fab5a0f',
                'System',
                'Master Admin',
                json_build_object(
                    'customer_id', v_customer_id,
                    'customer_name', v_customer_name,
                    'whatsapp_number', '+' || p_whatsapp_number,
                    'request_id', v_request_id,
                    'verification_required', true,
                    'requested_at', v_current_time
                )
            );
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



--
-- Name: request_server_restart(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.request_server_restart() RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  -- Write a trigger file to the shared volume (PG data dir)
  -- Host path: /opt/supabase/supabase/docker/volumes/db/data/restart_trigger
  -- Container path: /var/lib/postgresql/data/restart_trigger
  COPY (SELECT 'restart_requested_at_' || now()::text) 
    TO '/var/lib/postgresql/data/restart_trigger';
  
  RETURN 'Restart requested successfully. Services will restart within 30 seconds.';
END;
$$;



--
-- Name: reschedule_visit(uuid, date); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.reschedule_visit(visit_id uuid, new_date date) RETURNS date
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update the visit with the new date
    UPDATE vendor_visits 
    SET next_visit_date = new_date, updated_at = NOW()
    WHERE id = visit_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Visit schedule not found with id: %', visit_id;
    END IF;
    
    RETURN new_date;
END;
$$;



--
-- Name: search_tasks(text, text, integer, integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.search_tasks(search_query text, user_id_param text DEFAULT NULL::text, limit_param integer DEFAULT 50, offset_param integer DEFAULT 0) RETURNS TABLE(id uuid, title text, description text, require_task_finished boolean, require_photo_upload boolean, require_erp_reference boolean, can_escalate boolean, can_reassign boolean, created_by text, created_by_name text, status text, priority text, created_at timestamp with time zone, updated_at timestamp with time zone, due_date date, due_time time without time zone, rank real)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        t.id, t.title, t.description, t.require_task_finished, t.require_photo_upload, t.require_erp_reference,
        t.can_escalate, t.can_reassign, t.created_by, t.created_by_name, t.status, t.priority,
        t.created_at, t.updated_at, t.due_date, t.due_time,
        ts_rank(t.search_vector, plainto_tsquery('english', search_query)) as rank
    FROM public.tasks t
    WHERE t.deleted_at IS NULL
    AND (
        search_query IS NULL 
        OR search_query = '' 
        OR t.search_vector @@ plainto_tsquery('english', search_query)
        OR t.title ILIKE '%' || search_query || '%'
        OR t.description ILIKE '%' || search_query || '%'
    )
    ORDER BY 
        CASE WHEN search_query IS NOT NULL AND search_query != '' 
        THEN ts_rank(t.search_vector, plainto_tsquery('english', search_query)) 
        ELSE 0 END DESC,
        t.created_at DESC
    LIMIT limit_param OFFSET offset_param;
END;
$$;



--
-- Name: search_tasks(text, text, uuid, uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.search_tasks(search_term text DEFAULT NULL::text, task_status text DEFAULT NULL::text, assigned_user_id uuid DEFAULT NULL::uuid, created_by_user_id uuid DEFAULT NULL::uuid) RETURNS TABLE(id uuid, title character varying, description text, status character varying, priority character varying, assigned_to uuid, created_by uuid, created_at timestamp with time zone, updated_at timestamp with time zone, due_date date, assignee_name character varying, creator_name character varying)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        t.id,
        t.title,
        t.description,
        t.status,
        t.priority,
        ta.assigned_to,
        t.created_by,
        t.created_at,
        t.updated_at,
        t.due_date,
        COALESCE(u_assignee.username, 'Unassigned')::VARCHAR as assignee_name,
        COALESCE(u_creator.username, 'Unknown')::VARCHAR as creator_name
    FROM tasks t
    LEFT JOIN task_assignments ta ON t.id = ta.task_id
    LEFT JOIN users u_assignee ON ta.assigned_to = u_assignee.id
    LEFT JOIN users u_creator ON t.created_by = u_creator.id
    WHERE (search_term IS NULL OR t.title ILIKE '%' || search_term || '%' OR t.description ILIKE '%' || search_term || '%')
      AND (task_status IS NULL OR t.status = task_status)
      AND (assigned_user_id IS NULL OR ta.assigned_to = assigned_user_id)
      AND (created_by_user_id IS NULL OR t.created_by = created_by_user_id)
      AND t.deleted_at IS NULL
    ORDER BY t.created_at DESC;
END;
$$;



--
-- Name: select_random_product(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.select_random_product(p_campaign_id uuid) RETURNS TABLE(id uuid, product_name_en character varying, product_name_ar character varying, product_image_url text, original_price numeric, offer_price numeric, special_barcode character varying, stock_remaining integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    p.id,
    p.product_name_en,
    p.product_name_ar,
    p.product_image_url,
    p.original_price,
    p.offer_price,
    p.special_barcode,
    p.stock_remaining
  FROM coupon_products p
  WHERE p.campaign_id = p_campaign_id
    AND p.is_active = true
    AND p.stock_remaining > 0
    AND p.deleted_at IS NULL
  ORDER BY RANDOM()
  LIMIT 1
  FOR UPDATE SKIP LOCKED;
END;
$$;



--
-- Name: send_order_notification(uuid, text, text, text, text, uuid, uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.send_order_notification(p_order_id uuid, p_title text, p_message text, p_type text DEFAULT 'info'::text, p_priority text DEFAULT 'medium'::text, p_performed_by uuid DEFAULT NULL::uuid, p_target_user_id uuid DEFAULT NULL::uuid) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_notification_id UUID;
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

    -- If targeting a specific user
    IF p_target_user_id IS NOT NULL THEN
        INSERT INTO notification_recipients (notification_id, user_id, role, is_read, delivery_status)
        VALUES (v_notification_id, p_target_user_id, 'User', FALSE, 'delivered');
    END IF;

    -- Always notify admins
    FOR v_admin_user IN
        SELECT id,
               CASE WHEN is_master_admin THEN 'Master Admin'
                    WHEN is_admin THEN 'Admin'
                    ELSE 'User' END as role_type
        FROM users
        WHERE status = 'active' AND (is_admin = true OR is_master_admin = true)
        AND id <> COALESCE(p_target_user_id, '00000000-0000-0000-0000-000000000000'::uuid)
    LOOP
        INSERT INTO notification_recipients (notification_id, user_id, role, is_read, delivery_status)
        VALUES (v_notification_id, v_admin_user.id, v_admin_user.role_type, FALSE, 'delivered');
    END LOOP;

    RETURN v_notification_id;
END;
$$;



--
-- Name: set_user_context(uuid, boolean, boolean); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.set_user_context(user_id uuid, is_master_admin boolean DEFAULT false, is_admin boolean DEFAULT false) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  -- Set configuration variables that RLS policies can access
  PERFORM set_config('app.current_user_id', user_id::text, false);
  PERFORM set_config('app.is_master_admin', is_master_admin::text, false);
  PERFORM set_config('app.is_admin', is_admin::text, false);
END;
$$;



--
-- Name: setup_role_permissions(text, jsonb); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.setup_role_permissions(p_role_code text, p_permissions jsonb DEFAULT '{"can_add": false, "can_edit": false, "can_view": true, "can_delete": false, "can_export": false}'::jsonb) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_role_id UUID;
    func_record RECORD;
    permissions_set INTEGER := 0;
BEGIN
    -- Get role ID
    SELECT id INTO v_role_id FROM user_roles WHERE role_code = p_role_code;
    
    IF v_role_id IS NULL THEN
        RAISE NOTICE 'Role % not found', p_role_code;
        RETURN 0;
    END IF;
    
    -- Set permissions for all active functions
    FOR func_record IN SELECT id FROM app_functions WHERE is_active = true LOOP
        INSERT INTO role_permissions (
            role_id, 
            function_id, 
            can_view, 
            can_add, 
            can_edit, 
            can_delete, 
            can_export
        ) VALUES (
            v_role_id, 
            func_record.id,
            COALESCE((p_permissions->>'can_view')::BOOLEAN, false),
            COALESCE((p_permissions->>'can_add')::BOOLEAN, false),
            COALESCE((p_permissions->>'can_edit')::BOOLEAN, false),
            COALESCE((p_permissions->>'can_delete')::BOOLEAN, false),
            COALESCE((p_permissions->>'can_export')::BOOLEAN, false)
        ) ON CONFLICT (role_id, function_id) DO UPDATE SET
            can_view = COALESCE((p_permissions->>'can_view')::BOOLEAN, false),
            can_add = COALESCE((p_permissions->>'can_add')::BOOLEAN, false),
            can_edit = COALESCE((p_permissions->>'can_edit')::BOOLEAN, false),
            can_delete = COALESCE((p_permissions->>'can_delete')::BOOLEAN, false),
            can_export = COALESCE((p_permissions->>'can_export')::BOOLEAN, false),
            updated_at = NOW();
        
        permissions_set := permissions_set + 1;
    END LOOP;
    
    RETURN permissions_set;
END;
$$;



--
-- Name: skip_visit(uuid, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.skip_visit(visit_id uuid, skip_reason text DEFAULT ''::text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update the record to mark as handled (no date change for skip)
    UPDATE vendor_visits 
    SET updated_at = NOW()
    WHERE id = visit_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Visit schedule not found with id: %', visit_id;
    END IF;
    
    -- Note: In a full system, you might want to log this skip in a separate visits_log table
    -- For now, we just return success
    RETURN TRUE;
END;
$$;



--
-- Name: soft_delete_flyer_template(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.soft_delete_flyer_template(template_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  is_default_template BOOLEAN;
BEGIN
  -- Check if it's the default template
  SELECT is_default INTO is_default_template
  FROM flyer_templates
  WHERE id = template_id;
  
  -- Prevent deletion of default template
  IF is_default_template = true THEN
    RAISE EXCEPTION 'Cannot delete the default template. Please set another template as default first.';
  END IF;
  
  -- Soft delete
  UPDATE flyer_templates
  SET 
    deleted_at = now(),
    is_active = false
  WHERE id = template_id
    AND deleted_at IS NULL;
  
  RETURN FOUND;
END;
$$;



--
-- Name: start_break(uuid, integer, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.start_break(p_user_id uuid, p_reason_id integer, p_reason_note text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_emp RECORD;
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

  -- Get employee info
  SELECT id, name_en, name_ar, current_branch_id
  INTO v_emp
  FROM hr_employee_master
  WHERE user_id = p_user_id
  LIMIT 1;

  IF v_emp IS NULL THEN
    RETURN jsonb_build_object('success', false, 'error', 'Employee record not found');
  END IF;

  -- Insert break
  INSERT INTO break_register (user_id, employee_id, employee_name_en, employee_name_ar, branch_id, reason_id, reason_note, start_time, status)
  VALUES (p_user_id, v_emp.id, v_emp.name_en, v_emp.name_ar, v_emp.current_branch_id, p_reason_id, p_reason_note, NOW(), 'open')
  RETURNING id INTO v_break_id;

  RETURN jsonb_build_object('success', true, 'break_id', v_break_id);
END;
$$;



--
-- Name: submit_quick_task_completion(uuid, uuid, text, text[], text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.submit_quick_task_completion(p_assignment_id uuid, p_user_id uuid, p_completion_notes text DEFAULT NULL::text, p_photos text[] DEFAULT NULL::text[], p_erp_reference text DEFAULT NULL::text) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_quick_task_id uuid;
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

    -- Check if assignment exists
    IF v_assignment_record.quick_task_id IS NULL THEN
        RAISE EXCEPTION 'Assignment not found with ID: %', p_assignment_id;
    END IF;

    -- Check if assignment is already completed
    IF v_assignment_record.status = 'completed' THEN
        RAISE EXCEPTION 'This assignment is already completed';
    END IF;

    v_quick_task_id := v_assignment_record.quick_task_id;
    v_require_photo := v_assignment_record.require_photo_upload;
    v_require_erp := v_assignment_record.require_erp_reference;

    -- ====================================================================
    -- VALIDATE COMPLETION REQUIREMENTS
    -- ====================================================================
    
    -- Check if photo is required but not provided
    IF v_require_photo = true AND (p_photos IS NULL OR array_length(p_photos, 1) IS NULL OR array_length(p_photos, 1) = 0) THEN
        RAISE EXCEPTION 'Photo upload is required for this task. Please upload at least one photo before completing.';
    END IF;
    
    -- Check if ERP reference is required but not provided
    IF v_require_erp = true AND (p_erp_reference IS NULL OR trim(p_erp_reference) = '') THEN
        RAISE EXCEPTION 'ERP reference is required for this task. Please provide an ERP reference before completing.';
    END IF;

    -- ====================================================================
    -- CREATE OR UPDATE COMPLETION RECORD
    -- ====================================================================

    -- Check if completion already exists
    SELECT id INTO v_existing_completion_id
    FROM quick_task_completions
    WHERE assignment_id = p_assignment_id;

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

    -- ====================================================================
    -- UPDATE ASSIGNMENT STATUS
    -- ====================================================================

    UPDATE quick_task_assignments
    SET
        status = 'completed',
        completed_at = now(),
        updated_at = now()
    WHERE id = p_assignment_id;

    -- ====================================================================
    -- UPDATE QUICK TASK STATUS IF ALL ASSIGNMENTS COMPLETED
    -- ====================================================================

    UPDATE quick_tasks
    SET
        status = CASE
            WHEN NOT EXISTS (
                SELECT 1
                FROM quick_task_assignments
                WHERE quick_task_id = v_quick_task_id
                AND status != 'completed'
            ) THEN 'completed'
            ELSE status
        END,
        completed_at = CASE
            WHEN NOT EXISTS (
                SELECT 1
                FROM quick_task_assignments
                WHERE quick_task_id = v_quick_task_id
                AND status != 'completed'
            ) THEN now()
            ELSE completed_at
        END,
        updated_at = now()
    WHERE id = v_quick_task_id;

    RETURN v_completion_id;
END;
$$;



--
-- Name: sync_all_missing_erp_references(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.sync_all_missing_erp_references() RETURNS TABLE(synced_count integer, details text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    sync_record RECORD;
    total_synced INTEGER := 0;
    sync_details TEXT := '';
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
        
        total_synced := total_synced + 1;
        sync_details := sync_details || format('Synced receiving_record %s with ERP %s; ', 
                                              sync_record.receiving_record_id, 
                                              TRIM(sync_record.erp_reference_number));
        
    END LOOP;
    
    RETURN QUERY SELECT total_synced, sync_details;
END;
$$;



--
-- Name: sync_all_pending_erp_references(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.sync_all_pending_erp_references() RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    sync_record RECORD;
    total_synced INTEGER := 0;
    sync_details JSONB := '[]'::JSONB;
    record_detail JSONB;
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
        
        total_synced := total_synced + 1;
        
        -- Add details to the result
        record_detail := jsonb_build_object(
            'receiving_record_id', sync_record.receiving_record_id,
            'erp_reference', TRIM(sync_record.erp_reference_number),
            'previous_erp', sync_record.current_erp,
            'completed_by', sync_record.completed_by
        );
        
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



--
-- Name: FUNCTION sync_all_pending_erp_references(); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.sync_all_pending_erp_references() IS 'Sync all receiving records that have pending ERP references from task completions';


--
-- Name: sync_app_functions_from_components(jsonb); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.sync_app_functions_from_components(component_metadata jsonb) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    component JSONB;
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



--
-- Name: sync_employee_with_hr(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.sync_employee_with_hr(p_employee_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    -- Update user information based on employee record
    UPDATE users u
    SET 
        updated_at = NOW()
    FROM hr_employees e
    WHERE u.employee_id = e.id
      AND e.id = p_employee_id;
    
    RETURN FOUND;
END;
$$;



--
-- Name: sync_erp_reference_for_receiving_record(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.sync_erp_reference_for_receiving_record(receiving_record_id_param uuid) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    sync_record RECORD;
    updated_count INTEGER := 0;
    result_json JSONB;
BEGIN
    RAISE NOTICE 'Starting ERP sync for receiving_record_id: %', receiving_record_id_param;
    
    -- First, try to find task completion with ERP reference
    SELECT 
        tc.erp_reference_number,
        tc.erp_reference_completed,
        rt.role_type,
        rr.erp_purchase_invoice_reference as current_erp,
        tc.completed_at,
        tc.completed_by
    INTO sync_record
    FROM receiving_records rr
    JOIN receiving_tasks rt ON rr.id = rt.receiving_record_id
    JOIN task_completions tc ON rt.task_id = tc.task_id AND rt.assignment_id = tc.assignment_id
    WHERE rr.id = receiving_record_id_param
      AND rt.role_type = 'inventory_manager'
      AND tc.erp_reference_completed = true
      AND tc.erp_reference_number IS NOT NULL
      AND TRIM(tc.erp_reference_number) != ''
    ORDER BY tc.completed_at DESC
    LIMIT 1;

    -- If we found a task completion with ERP reference
    IF FOUND THEN
        RAISE NOTICE 'Found task completion with ERP: %', sync_record.erp_reference_number;
        
        -- Check if sync is needed
        IF sync_record.current_erp IS NULL OR sync_record.current_erp != TRIM(sync_record.erp_reference_number) THEN
            -- Update the receiving record
            UPDATE receiving_records 
            SET 
                erp_purchase_invoice_reference = TRIM(sync_record.erp_reference_number),
                updated_at = now()
            WHERE id = receiving_record_id_param;
            
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
        
        -- If no task completion, check if the record already has an ERP reference
        SELECT 
            rr.erp_purchase_invoice_reference as current_erp,
            rr.created_at,
            rr.updated_at
        INTO sync_record
        FROM receiving_records rr
        WHERE rr.id = receiving_record_id_param;
        
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



--
-- Name: FUNCTION sync_erp_reference_for_receiving_record(receiving_record_id_param uuid); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.sync_erp_reference_for_receiving_record(receiving_record_id_param uuid) IS 'Manually sync ERP reference from task completion to specific receiving record';


--
-- Name: sync_erp_references_from_task_completions(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.sync_erp_references_from_task_completions() RETURNS TABLE(receiving_record_id uuid, erp_reference_updated text, sync_status text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    WITH erp_updates AS (
        UPDATE receiving_records rr
        SET 
            erp_purchase_invoice_reference = tc.erp_reference_number,
            updated_at = now()
        FROM task_completions tc
        JOIN receiving_tasks rt ON tc.task_id = rt.task_id AND tc.assignment_id = rt.assignment_id
        WHERE rt.receiving_record_id = rr.id
        AND rt.role_type = 'inventory_manager'
        AND tc.erp_reference_completed = true
        AND tc.erp_reference_number IS NOT NULL
        AND tc.erp_reference_number != ''
        AND (rr.erp_purchase_invoice_reference IS NULL OR rr.erp_purchase_invoice_reference != tc.erp_reference_number)
        RETURNING rr.id as receiving_record_id, tc.erp_reference_number::TEXT, 'updated'::TEXT as sync_status
    )
    SELECT 
        eu.receiving_record_id,
        eu.erp_reference_number,
        eu.sync_status
    FROM erp_updates eu;
END;
$$;



--
-- Name: sync_requisition_balance(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

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
-- Name: sync_user_roles_from_positions(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.sync_user_roles_from_positions() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- This function would sync user roles based on position changes
    -- Implementation depends on business logic
    RETURN NEW;
END;
$$;



--
-- Name: track_media_activation(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.track_media_activation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.is_active = true AND (OLD.is_active IS NULL OR OLD.is_active = false) THEN
        NEW.activated_at = NOW();
    END IF;
    
    IF NEW.is_active = false AND OLD.is_active = true THEN
        NEW.deactivated_at = NOW();
    END IF;
    
    RETURN NEW;
END;
$$;



--
-- Name: trigger_cleanup_assignment_notifications(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.trigger_cleanup_assignment_notifications() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Clean up notifications related to the deleted assignment
    DELETE FROM notifications 
    WHERE task_assignment_id = OLD.id;
    RETURN OLD;
END;
$$;



--
-- Name: FUNCTION trigger_cleanup_assignment_notifications(); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.trigger_cleanup_assignment_notifications() IS 'Trigger function to clean up notifications when task assignments are deleted';


--
-- Name: trigger_cleanup_task_notifications(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.trigger_cleanup_task_notifications() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Clean up notifications related to the deleted task
    DELETE FROM notifications 
    WHERE task_id = OLD.id;
    RETURN OLD;
END;
$$;



--
-- Name: FUNCTION trigger_cleanup_task_notifications(); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.trigger_cleanup_task_notifications() IS 'Trigger function to clean up notifications when tasks are deleted';


--
-- Name: trigger_log_order_offer_usage(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.trigger_log_order_offer_usage() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update offer_usage_logs with order_id for items that have offers
    UPDATE offer_usage_logs
    SET order_id = NEW.order_id
    WHERE offer_id IN (
        SELECT offer_id
        FROM order_items
        WHERE order_id = NEW.order_id
        AND has_offer = TRUE
        AND offer_id IS NOT NULL
    )
    AND order_id IS NULL
    AND customer_id = (
        SELECT customer_id FROM orders WHERE id = NEW.order_id
    )
    AND used_at >= (
        SELECT created_at FROM orders WHERE id = NEW.order_id
    ) - INTERVAL '1 minute';
    
    RETURN NEW;
END;
$$;



--
-- Name: FUNCTION trigger_log_order_offer_usage(); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.trigger_log_order_offer_usage() IS 'Links offer usage logs to orders for tracking';


--
-- Name: trigger_notify_new_order(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.trigger_notify_new_order() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_customer_name VARCHAR(255);
    v_notification_id UUID;
    v_admin_user RECORD;
    v_title TEXT;
    v_message TEXT;
    v_fulfillment_label_en TEXT;
    v_fulfillment_label_ar TEXT;
    -- Push notification vars
    v_push_title TEXT;
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

    -- Determine fulfillment labels
    IF NEW.fulfillment_method = 'pickup' THEN
        v_fulfillment_label_en := 'Pickup';
        v_fulfillment_label_ar := '??????';
    ELSE
        v_fulfillment_label_en := 'Delivery';
        v_fulfillment_label_ar := '?????';
    END IF;

    -- Bilingual title and message for in-app notification
    v_title := 'New Order #' || NEW.order_number || ' (' || v_fulfillment_label_en || ')|||??? ???? #' || NEW.order_number || ' (' || v_fulfillment_label_ar || ')';
    v_message := 'Order #' || NEW.order_number || ' from ' || COALESCE(v_customer_name, NEW.customer_name) || ' - Total: ' || NEW.total_amount || ' SAR - ' || v_fulfillment_label_en || '|||??? #' || NEW.order_number || ' ?? ' || COALESCE(v_customer_name, NEW.customer_name) || ' - ??????: ' || NEW.total_amount || ' ?.? - ' || v_fulfillment_label_ar;

    -- Create the in-app notification
    INSERT INTO notifications (
        title, message, type, created_by, created_by_name, created_by_role,
        priority, status, target_type, target_roles, sent_at
    ) VALUES (
        v_title, v_message, 'order_new',
        NEW.customer_id::text,
        COALESCE(v_customer_name, NEW.customer_name),
        'Customer',
        'high', 'published', 'role_based',
        to_jsonb(ARRAY['Admin', 'Master Admin']),
        NOW()
    ) RETURNING id INTO v_notification_id;

    -- Create notification_recipients for all Admin and Master Admin users
    FOR v_admin_user IN
        SELECT id,
               CASE WHEN is_master_admin THEN 'Master Admin'
                    WHEN is_admin THEN 'Admin'
                    ELSE 'User' END as role_type
        FROM users
        WHERE status = 'active' AND (is_admin = true OR is_master_admin = true)
    LOOP
        INSERT INTO notification_recipients (
            notification_id, user_id, role, is_read, delivery_status
        ) VALUES (
            v_notification_id, v_admin_user.id, v_admin_user.role_type, FALSE, 'delivered'
        );
    END LOOP;

    -- ===== PUSH NOTIFICATION TO BRANCH DELIVERY RECEIVERS =====
    -- Collect user_ids of branch default delivery receivers
    SELECT jsonb_agg(to_jsonb(dr.user_id::text))
    INTO v_user_ids
    FROM branch_default_delivery_receivers dr
    WHERE dr.branch_id = NEW.branch_id AND dr.is_active = true;

    -- If no branch receivers, skip push
    IF v_user_ids IS NULL OR jsonb_array_length(v_user_ids) = 0 THEN
        RAISE LOG 'No branch delivery receivers for branch %, skipping push for order %', NEW.branch_id, NEW.order_number;
        RETURN NEW;
    END IF;

    -- Build push content (Arabic primary)
    v_push_title := '??? ????  #' || NEW.order_number;
    v_push_body := '??? ???? ?? ' || COALESCE(v_customer_name, NEW.customer_name) || ' - ' || NEW.total_amount || ' ?.? - ' || v_fulfillment_label_ar
        || chr(10) || 'New order from ' || COALESCE(v_customer_name, NEW.customer_name) || ' - ' || NEW.total_amount || ' SAR - ' || v_fulfillment_label_en;

    -- Get service role key
    v_supabase_url := 'http://supabase-kong:8000';
    
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

    -- Fallback to anon key
    IF v_service_role_key IS NULL THEN
        v_service_role_key := 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6InN1cGFiYXNlIiwiaWF0IjoxNzY0ODc1NTI3LCJleHAiOjIwODA0NTE1Mjd9.IT_YSPU9oivuGveKfRarwccr59SNMzX_36cw04Lf448';
    END IF;

    -- Send push via edge function to branch receivers only
    SELECT net.http_post(
        url := v_supabase_url || '/functions/v1/send-push-notification',
        headers := jsonb_build_object(
            'Content-Type', 'application/json',
            'Authorization', 'Bearer ' || v_service_role_key
        ),
        body := jsonb_build_object(
            'notificationId', v_notification_id::text,
            'userIds', v_user_ids,
            'payload', jsonb_build_object(
                'title', v_push_title,
                'body', v_push_body,
                'url', '/desktop',
                'type', 'order_new',
                'icon', '/icons/icon-192x192.png',
                'badge', '/icons/icon-72x72.png'
            )
        )
    ) INTO v_request_id;

    RAISE LOG 'Staff push for new order % sent to % branch receivers, request_id: %', 
        NEW.order_number, jsonb_array_length(v_user_ids), v_request_id;

    RETURN NEW;
END;
$$;



--
-- Name: FUNCTION trigger_notify_new_order(); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.trigger_notify_new_order() IS 'Notifies all Admin and Master Admin users when a new order is placed';


--
-- Name: trigger_order_status_audit(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.trigger_order_status_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Only log if status actually changed
    IF OLD.order_status IS DISTINCT FROM NEW.order_status THEN
        INSERT INTO order_audit_logs (
            order_id,
            action_type,
            from_status,
            to_status,
            performed_by,
            notes
        ) VALUES (
            NEW.id,
            'status_changed',
            OLD.order_status,
            NEW.order_status,
            NEW.updated_by,
            'Status changed from ' || OLD.order_status || ' to ' || NEW.order_status
        );
    END IF;
    
    RETURN NEW;
END;
$$;



--
-- Name: FUNCTION trigger_order_status_audit(); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.trigger_order_status_audit() IS 'Automatically creates audit log when order status changes';


--
-- Name: trigger_sync_erp_reference_on_task_completion(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.trigger_sync_erp_reference_on_task_completion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    update_count INTEGER := 0;
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
        
        -- Note: For payment tasks, the ERP reference sync is handled in the application code
        -- (TaskCompletionModal.svelte) which updates vendor_payment_schedule.payment_reference
        
    END IF;
    
    RETURN NEW;
END;
$$;



--
-- Name: trigger_update_order_totals(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.trigger_update_order_totals() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Recalculate total items and quantities when order_items change
    UPDATE orders
    SET total_items = (
            SELECT COUNT(*)
            FROM order_items
            WHERE order_id = COALESCE(NEW.order_id, OLD.order_id)
        ),
        total_quantity = (
            SELECT COALESCE(SUM(quantity), 0)
            FROM order_items
            WHERE order_id = COALESCE(NEW.order_id, OLD.order_id)
        ),
        updated_at = NOW()
    WHERE id = COALESCE(NEW.order_id, OLD.order_id);
    
    RETURN COALESCE(NEW, OLD);
END;
$$;



--
-- Name: FUNCTION trigger_update_order_totals(); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.trigger_update_order_totals() IS 'Recalculates order item counts when order_items change';


--
-- Name: update_ai_chat_guide_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_ai_chat_guide_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;



--
-- Name: update_app_icons_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_app_icons_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;



--
-- Name: update_approval_permissions_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_approval_permissions_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;



--
-- Name: update_approver_visibility_config_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_approver_visibility_config_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;



--
-- Name: update_attendance_hours(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_attendance_hours() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Calculate actual hours
    NEW.actual_hours = calculate_working_hours(NEW.check_in_time, NEW.check_out_time);
    
    -- Calculate overtime (if there's a duty schedule)
    IF NEW.duty_schedule_id IS NOT NULL THEN
        SELECT 
            GREATEST(0, NEW.actual_hours - ds.scheduled_hours)
        INTO NEW.overtime_hours
        FROM duty_schedules ds
        WHERE ds.id = NEW.duty_schedule_id;
    END IF;
    
    -- Update status based on attendance
    IF NEW.check_in_time IS NOT NULL AND NEW.check_out_time IS NOT NULL THEN
        NEW.status = 'present';
    ELSIF NEW.check_in_time IS NOT NULL THEN
        NEW.status = 'present';
    ELSE
        NEW.status = 'absent';
    END IF;
    
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;



--
-- Name: update_bank_reconciliations_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_bank_reconciliations_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;



--
-- Name: update_bogo_offer_rules_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_bogo_offer_rules_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;



--
-- Name: update_box_operations_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_box_operations_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;



--
-- Name: update_branch_default_positions_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_branch_default_positions_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;



--
-- Name: update_branch_delivery_receivers_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_branch_delivery_receivers_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;



--
-- Name: update_branch_sync_status(bigint, text, jsonb); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_branch_sync_status(p_branch_id bigint, p_status text, p_details jsonb DEFAULT '{}'::jsonb) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    UPDATE branch_sync_config
    SET last_sync_at = now(),
        last_sync_status = p_status,
        last_sync_details = p_details,
        updated_at = now()
    WHERE branch_id = p_branch_id;
$$;



--
-- Name: update_branches_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_branches_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;



--
-- Name: update_coupon_campaigns_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_coupon_campaigns_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;



--
-- Name: update_coupon_products_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_coupon_products_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;



--
-- Name: update_customer_app_media_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_customer_app_media_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;



--
-- Name: update_customer_recovery_requests_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_customer_recovery_requests_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;



--
-- Name: update_customers_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_customers_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;



--
-- Name: update_day_off_reasons_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_day_off_reasons_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;



--
-- Name: update_day_off_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_day_off_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;



--
-- Name: update_day_off_weekday_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_day_off_weekday_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;



--
-- Name: update_deadline_datetime(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_deadline_datetime() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.deadline_date IS NOT NULL THEN
        NEW.deadline_datetime = (NEW.deadline_date || ' ' || COALESCE(NEW.deadline_time::text, '23:59:59'))::timestamp with time zone;
    ELSE
        NEW.deadline_datetime = NULL;
    END IF;
    RETURN NEW;
END;
$$;



--
-- Name: update_delivery_tiers_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_delivery_tiers_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;



--
-- Name: update_denomination_transactions_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_denomination_transactions_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;



--
-- Name: update_denomination_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_denomination_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;



--
-- Name: update_departments_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_departments_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;



--
-- Name: update_desktop_themes_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_desktop_themes_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;



--
-- Name: update_duty_schedule_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_duty_schedule_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;



--
-- Name: update_early_leave_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_early_leave_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;



--
-- Name: update_employee_positions_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_employee_positions_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;



--
-- Name: update_erp_connections_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_erp_connections_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;



--
-- Name: update_erp_daily_sales_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_erp_daily_sales_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;



--
-- Name: update_expense_categories_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_expense_categories_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;



--
-- Name: update_expense_parent_categories_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_expense_parent_categories_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;



--
-- Name: update_expense_scheduler_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_expense_scheduler_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;



--
-- Name: update_final_bill_amount_on_adjustment(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_final_bill_amount_on_adjustment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Only recalculate if there are actual adjustments (discount, GRR, or PRI)
  -- This prevents the trigger from interfering with split payments
  IF (COALESCE(NEW.discount_amount, 0) > 0 OR 
      COALESCE(NEW.grr_amount, 0) > 0 OR 
      COALESCE(NEW.pri_amount, 0) > 0) THEN
    
    DECLARE
      base_amount DECIMAL(15, 2);
    BEGIN
      -- Determine the base amount to deduct from
      base_amount := COALESCE(NEW.original_final_amount, NEW.bill_amount);
      
      -- Calculate new final_bill_amount by deducting discount, GRR, and PRI amounts
      NEW.final_bill_amount := base_amount - 
        COALESCE(NEW.discount_amount, 0) - 
        COALESCE(NEW.grr_amount, 0) - 
        COALESCE(NEW.pri_amount, 0);
    END;
  END IF;
  
  RETURN NEW;
END;
$$;



--
-- Name: update_flyer_templates_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_flyer_templates_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;



--
-- Name: update_hr_checklist_operations_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_hr_checklist_operations_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;



--
-- Name: update_hr_checklist_questions_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_hr_checklist_questions_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;



--
-- Name: update_hr_checklists_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_hr_checklists_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;



--
-- Name: update_hr_employee_master_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_hr_employee_master_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;



--
-- Name: update_interface_permissions_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_interface_permissions_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;



--
-- Name: update_issue_types_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_issue_types_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;



--
-- Name: update_lease_rent_lease_parties_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_lease_rent_lease_parties_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;



--
-- Name: update_lease_rent_property_spaces_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_lease_rent_property_spaces_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;



--
-- Name: update_lease_rent_rent_parties_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_lease_rent_rent_parties_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;



--
-- Name: update_levels_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_levels_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;



--
-- Name: update_main_document_columns(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_main_document_columns() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update the dedicated columns based on document type
    IF NEW.document_type = 'health_card' THEN
        NEW.health_card_number := NEW.document_number;
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



--
-- Name: update_multi_shift_date_wise_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_multi_shift_date_wise_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;



--
-- Name: update_multi_shift_regular_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_multi_shift_regular_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;



--
-- Name: update_multi_shift_weekday_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_multi_shift_weekday_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;



--
-- Name: update_near_expiry_reports_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_near_expiry_reports_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;



--
-- Name: update_next_visit_date(uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_next_visit_date(visit_id uuid) RETURNS date
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
    
    -- Update the record
    UPDATE vendor_visits 
    SET next_visit_date = new_next_date, updated_at = NOW()
    WHERE id = visit_id;
    
    RETURN new_next_date;
END;
$$;



--
-- Name: update_non_approved_scheduler_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_non_approved_scheduler_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;



--
-- Name: update_notification_attachments_flag(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_notification_attachments_flag() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE notifications 
        SET has_attachments = TRUE,
            updated_at = NOW()
        WHERE id = NEW.notification_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE notifications 
        SET has_attachments = (
            SELECT COUNT(*) > 0 
            FROM notification_attachments 
            WHERE notification_id = OLD.notification_id
        ),
        updated_at = NOW()
        WHERE id = OLD.notification_id;
        RETURN OLD;
    END IF;
    
    RETURN NULL;
END;
$$;



--
-- Name: update_notification_delivery_status(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_notification_delivery_status() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    -- When a notification_queue item is marked as 'sent', update the recipient's delivery status
    IF NEW.status = 'sent' AND OLD.status != 'sent' THEN
        UPDATE notification_recipients
        SET 
            delivery_status = 'delivered',
            delivery_attempted_at = NEW.sent_at,
            updated_at = NOW()
        WHERE notification_id = NEW.notification_id
        AND user_id = NEW.user_id;
        
        RAISE NOTICE 'Updated delivery status for notification % user %', NEW.notification_id, NEW.user_id;
    
    -- When a notification_queue item is marked as 'failed', update the recipient's delivery status
    ELSIF NEW.status = 'failed' AND OLD.status != 'failed' THEN
        UPDATE notification_recipients
        SET 
            delivery_status = 'failed',
            delivery_attempted_at = NEW.last_attempt_at,
            error_message = NEW.error_message,
            updated_at = NOW()
        WHERE notification_id = NEW.notification_id
        AND user_id = NEW.user_id;
        
        RAISE NOTICE 'Marked delivery as failed for notification % user %', NEW.notification_id, NEW.user_id;
    END IF;
    
    RETURN NEW;
END;
$$;



--
-- Name: FUNCTION update_notification_delivery_status(); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.update_notification_delivery_status() IS 'Updates notification_recipients.delivery_status when push notifications are sent or failed.';


--
-- Name: update_notification_queue_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_notification_queue_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;



--
-- Name: update_notification_read_count(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_notification_read_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update read_count in notifications table when recipient read status changes
    IF TG_OP = 'UPDATE' AND OLD.is_read = FALSE AND NEW.is_read = TRUE THEN
        UPDATE notifications 
        SET read_count = read_count + 1,
            updated_at = NOW()
        WHERE id = NEW.notification_id;
    ELSIF TG_OP = 'UPDATE' AND OLD.is_read = TRUE AND NEW.is_read = FALSE THEN
        UPDATE notifications 
        SET read_count = GREATEST(read_count - 1, 0),
            updated_at = NOW()
        WHERE id = NEW.notification_id;
    END IF;
    
    RETURN COALESCE(NEW, OLD);
END;
$$;



--
-- Name: update_offer_cart_tiers_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_offer_cart_tiers_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;



--
-- Name: update_offers_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_offers_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;



--
-- Name: update_official_holidays_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_official_holidays_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;



--
-- Name: update_order_status(uuid, character varying, uuid, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_order_status(p_order_id uuid, p_new_status character varying, p_user_id uuid, p_notes text DEFAULT NULL::text) RETURNS TABLE(success boolean, message text)
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
    
    -- Get user name
    SELECT username INTO v_user_name
    FROM users
    WHERE id = p_user_id;
    
    -- Update order with status-specific timestamps
    UPDATE orders
    SET order_status = p_new_status,
        ready_at = CASE WHEN p_new_status = 'ready' THEN NOW() ELSE ready_at END,
        delivered_at = CASE WHEN p_new_status = 'delivered' THEN NOW() ELSE delivered_at END,
        actual_delivery_time = CASE WHEN p_new_status = 'delivered' THEN NOW() ELSE actual_delivery_time END,
        payment_status = CASE WHEN p_new_status = 'delivered' AND payment_method = 'cash' THEN 'paid' ELSE payment_status END,
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
        v_current_status,
        p_new_status,
        p_user_id,
        v_user_name,
        COALESCE(p_notes, 'Status changed to ' || p_new_status)
    );
    
    RETURN QUERY SELECT TRUE, 'Order status updated successfully';
END;
$$;



--
-- Name: FUNCTION update_order_status(p_order_id uuid, p_new_status character varying, p_user_id uuid, p_notes text); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.update_order_status(p_order_id uuid, p_new_status character varying, p_user_id uuid, p_notes text) IS 'Updates order status with audit trail';


--
-- Name: update_payment_transactions_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_payment_transactions_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;



--
-- Name: update_pos_deduction_transfers_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_pos_deduction_transfers_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;



--
-- Name: update_positions_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_positions_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;



--
-- Name: update_product_categories_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_product_categories_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;



--
-- Name: update_product_request_bt_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_product_request_bt_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;



--
-- Name: update_product_request_po_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_product_request_po_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;



--
-- Name: update_product_request_st_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_product_request_st_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;



--
-- Name: update_product_units_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_product_units_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;



--
-- Name: update_products_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_products_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;



--
-- Name: update_purchase_voucher_items_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_purchase_voucher_items_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;



--
-- Name: update_purchase_vouchers_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_purchase_vouchers_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;



--
-- Name: update_push_subscriptions_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_push_subscriptions_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;



--
-- Name: update_quick_task_completions_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_quick_task_completions_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    
    -- Auto-set verification timestamp
    IF NEW.completion_status = 'verified' AND OLD.completion_status != 'verified' AND NEW.verified_at IS NULL THEN
        NEW.verified_at = now();
    END IF;
    
    RETURN NEW;
END;
$$;



--
-- Name: update_quick_task_status(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_quick_task_status() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update main task status based on individual assignments
    IF TG_OP = 'UPDATE' THEN
        -- Check if all assignments are completed
        IF (SELECT COUNT(*) FROM quick_task_assignments 
            WHERE quick_task_id = NEW.quick_task_id AND status != 'completed') = 0 THEN
            
            UPDATE quick_tasks 
            SET status = 'completed', completed_at = NOW(), updated_at = NOW()
            WHERE id = NEW.quick_task_id;
            
        -- Check if task is overdue
        ELSIF NOW() > (SELECT deadline_datetime FROM quick_tasks WHERE id = NEW.quick_task_id) THEN
            UPDATE quick_tasks 
            SET status = 'overdue', updated_at = NOW()
            WHERE id = NEW.quick_task_id AND status != 'completed';
            
            -- Mark individual assignments as overdue if not completed
            UPDATE quick_task_assignments
            SET status = 'overdue', updated_at = NOW()
            WHERE quick_task_id = NEW.quick_task_id AND status IN ('pending', 'accepted', 'in_progress');
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$;



--
-- Name: update_receiving_records_pr_excel_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_receiving_records_pr_excel_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF OLD.pr_excel_file_url IS DISTINCT FROM NEW.pr_excel_file_url THEN
        NEW.updated_at = now();
    END IF;
    RETURN NEW;
END;
$$;



--
-- Name: update_receiving_records_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_receiving_records_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;



--
-- Name: update_receiving_task_completion(uuid, character varying, boolean, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_receiving_task_completion(receiving_task_id_param uuid, erp_reference_param character varying DEFAULT NULL::character varying, original_bill_uploaded_param boolean DEFAULT NULL::boolean, original_bill_file_path_param text DEFAULT NULL::text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    receiving_task RECORD;
    can_complete BOOLEAN := true;
BEGIN
    -- Get receiving task details
    SELECT * INTO receiving_task 
    FROM receiving_tasks 
    WHERE id = receiving_task_id_param;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Receiving task not found: %', receiving_task_id_param;
    END IF;
    
    -- Update the receiving task
    UPDATE receiving_tasks 
    SET 
        erp_reference_number = COALESCE(erp_reference_param, erp_reference_number),
        original_bill_uploaded = COALESCE(original_bill_uploaded_param, original_bill_uploaded),
        original_bill_file_path = COALESCE(original_bill_file_path_param, original_bill_file_path),
        updated_at = now()
    WHERE id = receiving_task_id_param;
    
    -- Check if task can be completed based on requirements
    SELECT * INTO receiving_task FROM receiving_tasks WHERE id = receiving_task_id_param;
    
    -- Check ERP reference requirement
    IF receiving_task.requires_erp_reference AND receiving_task.erp_reference_number IS NULL THEN
        can_complete := false;
    END IF;
    
    -- Check original bill upload requirement
    IF receiving_task.requires_original_bill_upload AND NOT receiving_task.original_bill_uploaded THEN
        can_complete := false;
    END IF;
    
    -- If all requirements are met, mark as completed
    IF can_complete AND NOT receiving_task.task_completed THEN
        UPDATE receiving_tasks 
        SET 
            task_completed = true,
            completed_at = now(),
            updated_at = now()
        WHERE id = receiving_task_id_param;
        
        -- Update the main task assignment status
        UPDATE task_assignments 
        SET 
            status = 'completed',
            completed_at = now()
        WHERE id = receiving_task.assignment_id;
        
        -- Update the main task status
        UPDATE tasks 
        SET 
            status = 'completed',
            completion_percentage = 100,
            updated_at = now()
        WHERE id = receiving_task.task_id;
        
        RETURN true;
    END IF;
    
    RETURN false;
END;
$$;



--
-- Name: update_receiving_task_templates_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_receiving_task_templates_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;



--
-- Name: update_receiving_tasks_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_receiving_tasks_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;



--
-- Name: update_receiving_user_defaults_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_receiving_user_defaults_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;



--
-- Name: update_regular_shift_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_regular_shift_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;



--
-- Name: update_requisition_balance(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_requisition_balance() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Only update if requisition_id is not null
  IF NEW.requisition_id IS NOT NULL THEN
    -- Update the expense_requisitions table
    UPDATE public.expense_requisitions
    SET 
      used_amount = (
        SELECT COALESCE(SUM(amount), 0)
        FROM public.expense_scheduler
        WHERE requisition_id = NEW.requisition_id
          AND status != 'cancelled'
      ),
      remaining_balance = amount - (
        SELECT COALESCE(SUM(amount), 0)
        FROM public.expense_scheduler
        WHERE requisition_id = NEW.requisition_id
          AND status != 'cancelled'
      ),
      updated_at = now()
    WHERE id = NEW.requisition_id;
  END IF;
  
  RETURN NEW;
END;
$$;



--
-- Name: update_requisition_balance_old(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_requisition_balance_old() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Handle the old requisition_id if it exists and is different
  IF OLD.requisition_id IS NOT NULL AND (TG_OP = 'DELETE' OR OLD.requisition_id != NEW.requisition_id) THEN
    UPDATE public.expense_requisitions
    SET 
      used_amount = (
        SELECT COALESCE(SUM(amount), 0)
        FROM public.expense_scheduler
        WHERE requisition_id = OLD.requisition_id
          AND status != 'cancelled'
      ),
      remaining_balance = amount - (
        SELECT COALESCE(SUM(amount), 0)
        FROM public.expense_scheduler
        WHERE requisition_id = OLD.requisition_id
          AND status != 'cancelled'
      ),
      updated_at = now()
    WHERE id = OLD.requisition_id;
  END IF;
  
  RETURN COALESCE(NEW, OLD);
END;
$$;



--
-- Name: update_social_links_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_social_links_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;



--
-- Name: update_special_shift_date_wise_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_special_shift_date_wise_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;



--
-- Name: update_special_shift_weekday_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_special_shift_weekday_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;



--
-- Name: update_stock_request_status(uuid, character varying); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_stock_request_status(p_request_id uuid, p_new_status character varying) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_requester_user_id UUID;
    v_status_label TEXT;
    v_status_label_ar TEXT;
    v_notif_type TEXT;
    v_message TEXT;
    v_title TEXT;
    v_tasks_completed INTEGER := 0;
    v_task_record RECORD;
BEGIN
    -- 1. Update the request status
    UPDATE product_request_st
    SET status = p_new_status, updated_at = NOW()
    WHERE id = p_request_id
    RETURNING requester_user_id INTO v_requester_user_id;

    IF v_requester_user_id IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'Request not found');
    END IF;

    -- 2. Auto-complete linked quick tasks
    FOR v_task_record IN
        SELECT id FROM quick_tasks
        WHERE product_request_id = p_request_id
          AND product_request_type = 'ST'
    LOOP
        -- Complete task assignments
        UPDATE quick_task_assignments
        SET status = 'completed', completed_at = NOW()
        WHERE quick_task_id = v_task_record.id;

        -- Complete the task itself
        UPDATE quick_tasks
        SET status = 'completed', completed_at = NOW()
        WHERE id = v_task_record.id;

        v_tasks_completed := v_tasks_completed + 1;
    END LOOP;

    -- 3. Build notification content
    IF p_new_status = 'approved' THEN
        v_status_label := 'Accepted ✅';
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

    -- 4. Insert notification
    INSERT INTO notifications (
        title, message, type, priority,
        target_type, target_users, status,
        total_recipients, created_at
    ) VALUES (
        v_title, v_message, v_notif_type, 'normal',
        'specific_users', jsonb_build_array(v_requester_user_id::TEXT), 'published',
        1, NOW()
    );

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



--
-- Name: update_system_api_keys_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_system_api_keys_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;



--
-- Name: update_tax_categories_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_tax_categories_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;



--
-- Name: update_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;



--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = TIMEZONE('utc'::text, NOW());
    RETURN NEW;
END;
$$;



--
-- Name: FUNCTION update_updated_at_column(); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.update_updated_at_column() IS 'Automatically updates the updated_at timestamp on row modification';


--
-- Name: update_user(uuid, character varying, boolean, boolean, character varying, bigint, uuid, uuid, character varying, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_user(p_user_id uuid, p_username character varying DEFAULT NULL::character varying, p_is_master_admin boolean DEFAULT NULL::boolean, p_is_admin boolean DEFAULT NULL::boolean, p_user_type character varying DEFAULT NULL::character varying, p_branch_id bigint DEFAULT NULL::bigint, p_employee_id uuid DEFAULT NULL::uuid, p_position_id uuid DEFAULT NULL::uuid, p_status character varying DEFAULT NULL::character varying, p_avatar text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  -- Check if user exists
  IF NOT EXISTS (SELECT 1 FROM users WHERE id = p_user_id) THEN
    RETURN json_build_object(
      'success', false,
      'message', 'User not found'
    );
  END IF;

  -- Check if username is being changed and if it's already taken
  IF p_username IS NOT NULL AND p_username != (SELECT username FROM users WHERE id = p_user_id) THEN
    IF EXISTS (SELECT 1 FROM users WHERE username = p_username AND id != p_user_id) THEN
      RETURN json_build_object(
        'success', false,
        'message', 'Username already exists'
      );
    END IF;
  END IF;

  -- Update user with provided fields
  -- Use conditional updates to avoid type casting issues
  IF p_username IS NOT NULL THEN
    UPDATE users SET username = p_username, updated_at = NOW() WHERE id = p_user_id;
  END IF;
  
  IF p_is_master_admin IS NOT NULL THEN
    UPDATE users SET is_master_admin = p_is_master_admin, updated_at = NOW() WHERE id = p_user_id;
  END IF;
  
  IF p_is_admin IS NOT NULL THEN
    UPDATE users SET is_admin = p_is_admin, updated_at = NOW() WHERE id = p_user_id;
  END IF;
  
  IF p_user_type IS NOT NULL THEN
    UPDATE users SET user_type = p_user_type::user_type_enum, updated_at = NOW() WHERE id = p_user_id;
  END IF;
  
  IF p_branch_id IS NOT NULL THEN
    UPDATE users SET branch_id = p_branch_id, updated_at = NOW() WHERE id = p_user_id;
  END IF;
  
  IF p_employee_id IS NOT NULL THEN
    UPDATE users SET employee_id = p_employee_id, updated_at = NOW() WHERE id = p_user_id;
  END IF;
  
  IF p_position_id IS NOT NULL THEN
    UPDATE users SET position_id = p_position_id, updated_at = NOW() WHERE id = p_user_id;
  END IF;
  
  IF p_status IS NOT NULL THEN
    UPDATE users SET status = p_status, updated_at = NOW() WHERE id = p_user_id;
  END IF;
  
  IF p_avatar IS NOT NULL THEN
    UPDATE users SET avatar = p_avatar, updated_at = NOW() WHERE id = p_user_id;
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



--
-- Name: update_user_device_sessions_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_user_device_sessions_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;



--
-- Name: update_user_theme_assignments_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_user_theme_assignments_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;



--
-- Name: update_vendor_payment_with_exact_calculation(uuid, numeric, numeric, numeric, text, text, text, text, text, jsonb); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_vendor_payment_with_exact_calculation(payment_id uuid, new_discount_amount numeric DEFAULT NULL::numeric, new_grr_amount numeric DEFAULT NULL::numeric, new_pri_amount numeric DEFAULT NULL::numeric, discount_notes_val text DEFAULT NULL::text, grr_reference_val text DEFAULT NULL::text, grr_notes_val text DEFAULT NULL::text, pri_reference_val text DEFAULT NULL::text, pri_notes_val text DEFAULT NULL::text, history_val jsonb DEFAULT NULL::jsonb) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  current_bill_amount NUMERIC;
  total_deductions NUMERIC;
  calculated_final_amount NUMERIC;
BEGIN
  -- Get the bill_amount (this is always our base for calculation)
  SELECT bill_amount
  INTO current_bill_amount
  FROM vendor_payment_schedule
  WHERE id = payment_id;
  
  -- STEP 1: First reset final_bill_amount to bill_amount (original amount)
  UPDATE vendor_payment_schedule
  SET final_bill_amount = current_bill_amount
  WHERE id = payment_id;
  
  -- STEP 2: Calculate total deductions using bill_amount as base
  total_deductions := COALESCE(new_discount_amount, 0) + COALESCE(new_grr_amount, 0) + COALESCE(new_pri_amount, 0);
  
  -- STEP 3: Calculate final amount after deductions: bill_amount - deductions
  calculated_final_amount := current_bill_amount - total_deductions;
  
  -- Validate that final amount is not negative
  IF calculated_final_amount < 0 THEN
    RAISE EXCEPTION 'Total deductions (%) exceed the bill amount (%). Final amount would be negative.', 
      total_deductions, current_bill_amount;
  END IF;
  
  -- STEP 4: Apply deductions and set final_bill_amount after deductions
  UPDATE vendor_payment_schedule
  SET 
    original_final_amount = current_bill_amount,  -- Preserve original bill amount for constraint
    final_bill_amount = calculated_final_amount,  -- Set final amount after deductions
    discount_amount = new_discount_amount,
    discount_notes = discount_notes_val,
    grr_amount = new_grr_amount,
    grr_reference_number = grr_reference_val,
    grr_notes = grr_notes_val,
    pri_amount = new_pri_amount,
    pri_reference_number = pri_reference_val,
    pri_notes = pri_notes_val,
    adjustment_history = COALESCE(history_val, adjustment_history),
    updated_at = NOW()
  WHERE id = payment_id;
  
  -- Verify the update succeeded
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Payment record not found: %', payment_id;
  END IF;
  
END;
$$;



--
-- Name: update_warning_main_category_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_warning_main_category_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;



--
-- Name: update_warning_sub_category_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_warning_sub_category_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;



--
-- Name: update_warning_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_warning_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;



--
-- Name: update_warning_violation_timestamp(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_warning_violation_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;



--
-- Name: upsert_app_icon(text, text, text, text, text, bigint, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.upsert_app_icon(p_icon_key text, p_name text, p_category text, p_storage_path text, p_mime_type text DEFAULT NULL::text, p_file_size bigint DEFAULT 0, p_description text DEFAULT NULL::text) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_id uuid;
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



--
-- Name: upsert_branch_sync_config(bigint, text, text, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.upsert_branch_sync_config(p_branch_id bigint, p_local_supabase_url text, p_local_supabase_key text, p_tunnel_url text DEFAULT NULL::text) RETURNS bigint
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_id BIGINT;
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



--
-- Name: upsert_branch_sync_config(bigint, text, text, text, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.upsert_branch_sync_config(p_branch_id bigint, p_local_supabase_url text, p_local_supabase_key text, p_tunnel_url text DEFAULT NULL::text, p_ssh_user text DEFAULT 'u'::text) RETURNS bigint
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_id bigint;
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



--
-- Name: upsert_erp_products_with_expiry(jsonb); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.upsert_erp_products_with_expiry(p_products jsonb) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_inserted int := 0;
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
    
    -- Try to get existing record
    SELECT expiry_dates INTO v_existing_expiry
    FROM erp_synced_products
    WHERE barcode = v_product->>'barcode';
    
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
      
      -- Append new entries
      v_merged_expiry := v_merged_expiry || v_new_expiry;
      
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



--
-- Name: upsert_social_links(bigint, text, text, text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.upsert_social_links(_branch_id bigint, _facebook text DEFAULT NULL::text, _whatsapp text DEFAULT NULL::text, _instagram text DEFAULT NULL::text, _tiktok text DEFAULT NULL::text, _snapchat text DEFAULT NULL::text, _website text DEFAULT NULL::text, _location_link text DEFAULT NULL::text) RETURNS TABLE(id uuid, branch_id bigint, facebook text, whatsapp text, instagram text, tiktok text, snapchat text, website text, location_link text, created_at timestamp with time zone, updated_at timestamp with time zone)
    LANGUAGE sql
    AS $$
  INSERT INTO public.social_links (branch_id, facebook, whatsapp, instagram, tiktok, snapchat, website, location_link)
  VALUES (_branch_id, _facebook, _whatsapp, _instagram, _tiktok, _snapchat, _website, _location_link)
  ON CONFLICT (branch_id) DO UPDATE SET
    facebook = _facebook,
    whatsapp = _whatsapp,
    instagram = _instagram,
    tiktok = _tiktok,
    snapchat = _snapchat,
    website = _website,
    location_link = _location_link,
    updated_at = NOW()
  RETURNING id, branch_id, facebook, whatsapp, instagram, tiktok, snapchat, website, location_link, created_at, updated_at
$$;



--
-- Name: validate_break_code(text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.validate_break_code(p_code text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_seed text;
    v_epoch bigint;
    v_current_code text;
    v_previous_code text;
BEGIN
    SELECT seed INTO v_seed FROM break_security_seed WHERE id = 1;
    
    IF v_seed IS NULL THEN
        RETURN false;
    END IF;
    
    v_epoch := floor(extract(epoch from now()) / 10)::bigint;
    
    -- Current 10-sec window code
    v_current_code := substring(md5(v_seed || v_epoch::text) from 1 for 12);
    
    -- Previous 10-sec window code (for network delay tolerance)
    v_previous_code := substring(md5(v_seed || (v_epoch - 1)::text) from 1 for 12);
    
    RETURN (p_code = v_current_code OR p_code = v_previous_code);
END;
$$;



--
-- Name: validate_bundle_offer_type(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.validate_bundle_offer_type() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_offer_type VARCHAR;
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



--
-- Name: validate_coupon_eligibility(character varying, character varying); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.validate_coupon_eligibility(p_campaign_code character varying, p_mobile_number character varying) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_campaign_id UUID;
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
  
  -- Check if campaign exists
  IF v_campaign_id IS NULL THEN
    RETURN jsonb_build_object(
      'eligible', false,
      'error_message', 'Campaign code not found'
    );
  END IF;
  
  -- Check if campaign is active
  IF NOT v_is_active THEN
    RETURN jsonb_build_object(
      'eligible', false,
      'error_message', 'Campaign is not active'
    );
  END IF;
  
  -- Check if within validity period
  IF now() < v_validity_start OR now() > v_validity_end THEN
    RETURN jsonb_build_object(
      'eligible', false,
      'error_message', 'Campaign is not valid at this time'
    );
  END IF;
  
  -- Check if customer is in eligible list
  SELECT EXISTS(
    SELECT 1 
    FROM coupon_eligible_customers
    WHERE campaign_id = v_campaign_id
      AND mobile_number = p_mobile_number
  ) INTO v_is_eligible;
  
  IF NOT v_is_eligible THEN
    RETURN jsonb_build_object(
      'eligible', false,
      'error_message', 'Customer is not eligible for this campaign'
    );
  END IF;
  
  -- Count current claims
  SELECT COUNT(*)
  INTO v_current_claim_count
  FROM coupon_claims
  WHERE campaign_id = v_campaign_id
    AND customer_mobile = p_mobile_number;
  
  -- Check if reached maximum claims
  IF v_current_claim_count >= v_max_claims_per_customer THEN
    RETURN jsonb_build_object(
      'eligible', false,
      'already_claimed', true,
      'current_claims', v_current_claim_count,
      'max_claims', v_max_claims_per_customer,
      'error_message', 'Customer has reached the maximum number of claims (' || v_current_claim_count || '/' || v_max_claims_per_customer || ')'
    );
  END IF;
  
  -- All checks passed
  RETURN jsonb_build_object(
    'eligible', true,
    'campaign_id', v_campaign_id,
    'campaign_name', v_campaign_name,
    'already_claimed', false,
    'current_claims', v_current_claim_count,
    'max_claims', v_max_claims_per_customer,
    'remaining_claims', v_max_claims_per_customer - v_current_claim_count
  );
END;
$$;



--
-- Name: validate_flyer_template_configuration(jsonb); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.validate_flyer_template_configuration(config jsonb) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
  field JSONB;
  required_keys TEXT[] := ARRAY['id', 'number', 'x', 'y', 'width', 'height', 'fields'];
BEGIN
  -- Check if config is an array
  IF jsonb_typeof(config) != 'array' THEN
    RAISE EXCEPTION 'Configuration must be a JSON array';
  END IF;
  
  -- Validate each field
  FOR field IN SELECT * FROM jsonb_array_elements(config)
  LOOP
    -- Check required keys exist
    IF NOT (field ?& required_keys) THEN
      RAISE EXCEPTION 'Field missing required keys. Required: %', required_keys;
    END IF;
    
    -- Validate data types
    IF jsonb_typeof(field->'fields') != 'array' THEN
      RAISE EXCEPTION 'Field "fields" must be an array';
    END IF;
    
    -- Validate numeric ranges
    IF (field->>'width')::int <= 0 OR (field->>'height')::int <= 0 THEN
      RAISE EXCEPTION 'Field width and height must be positive';
    END IF;
  END LOOP;
  
  RETURN true;
END;
$$;



--
-- Name: validate_payment_methods(text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.validate_payment_methods(payment_methods text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    valid_methods TEXT[] := ARRAY['Cash on Delivery', 'Bank on Delivery', 'Cash Credit', 'Bank Credit'];
    method TEXT;
    methods TEXT[];
BEGIN
    IF payment_methods IS NULL OR LENGTH(TRIM(payment_methods)) = 0 THEN
        RETURN TRUE;
    END IF;
    
    -- Split comma-separated values
    methods := string_to_array(payment_methods, ',');
    
    -- Check each method
    FOREACH method IN ARRAY methods
    LOOP
        IF TRIM(method) != ANY(valid_methods) THEN
            RETURN FALSE;
        END IF;
    END LOOP;
    
    RETURN TRUE;
END;
$$;



--
-- Name: validate_product_offer(integer, uuid, integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.validate_product_offer(p_offer_id integer, p_product_id uuid, p_quantity integer) RETURNS boolean
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
  v_offer_qty INTEGER;
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



--
-- Name: FUNCTION validate_product_offer(p_offer_id integer, p_product_id uuid, p_quantity integer); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.validate_product_offer(p_offer_id integer, p_product_id uuid, p_quantity integer) IS 'Validate if product offer can be applied';


--
-- Name: validate_task_completion_requirements(uuid, uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.validate_task_completion_requirements(receiving_task_id_param uuid, user_id_param uuid) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    receiving_task RECORD;
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
    
    -- Get receiving record
    SELECT * INTO receiving_record 
    FROM receiving_records 
    WHERE id = receiving_task.receiving_record_id;
    
    -- Check ERP reference requirement
    IF receiving_task.requires_erp_reference AND receiving_task.erp_reference_number IS NULL THEN
        missing_requirements := missing_requirements || 'ERP reference number required';
    END IF;
    
    -- Check original bill upload requirement (especially for inventory manager)
    IF receiving_task.requires_original_bill_upload THEN
        -- Check if original bill has been uploaded to receiving record
        IF receiving_record.original_bill_url IS NULL OR receiving_record.original_bill_url = '' THEN
            missing_requirements := missing_requirements || 'Original bill must be uploaded through Receive Record window';
        ELSE
            -- Auto-update the receiving task if bill is already uploaded
            UPDATE receiving_tasks 
            SET 
                original_bill_uploaded = true,
                original_bill_file_path = receiving_record.original_bill_url,
                updated_at = now()
            WHERE id = receiving_task_id_param;
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



--
-- Name: validate_variation_prices(integer, uuid); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.validate_variation_prices(p_offer_id integer, p_group_id uuid) RETURNS TABLE(barcode text, product_name_en text, offer_price numeric, offer_percentage numeric, price_mismatch boolean)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN QUERY
  WITH group_prices AS (
    SELECT 
      op.offer_price,
      op.offer_percentage,
      COUNT(DISTINCT op.offer_price) OVER () as price_count,
      COUNT(DISTINCT op.offer_percentage) OVER () as percentage_count
    FROM offer_products op
    WHERE op.offer_id = p_offer_id
      AND op.variation_group_id = p_group_id
    LIMIT 1
  )
  SELECT 
    p.barcode,
    p.product_name_en,
    op.offer_price,
    op.offer_percentage,
    CASE 
      WHEN gp.price_count > 1 OR gp.percentage_count > 1 THEN true
      ELSE false
    END as price_mismatch
  FROM offer_products op
  JOIN products p ON op.product_id = p.id
  CROSS JOIN group_prices gp
  WHERE op.offer_id = p_offer_id
    AND op.variation_group_id = p_group_id
  ORDER BY p.variation_order, p.product_name_en;
END;
$$;



--
-- Name: validate_vendor_branch_match(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.validate_vendor_branch_match() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if vendor belongs to the selected branch or is unassigned
    IF NOT EXISTS (
        SELECT 1 FROM vendors 
        WHERE erp_vendor_id = NEW.vendor_id 
        AND (branch_id = NEW.branch_id OR branch_id IS NULL)
    ) THEN
        RAISE EXCEPTION 'Vendor % does not belong to branch % or is not assigned to any branch', 
            NEW.vendor_id, NEW.branch_id;
    END IF;
    
    RETURN NEW;
END;
$$;



--
-- Name: FUNCTION validate_vendor_branch_match(); Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON FUNCTION public.validate_vendor_branch_match() IS 'Validates that vendor belongs to the branch specified in receiving record';


--
-- Name: verify_otp_and_change_access_code(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.verify_otp_and_change_access_code(p_email character varying, p_whatsapp character varying, p_otp character varying, p_new_code character varying) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_user_id UUID;
  v_otp_record RECORD;
  v_whatsapp_clean VARCHAR(20);
  v_hashed_code VARCHAR(255);
  v_existing_count INT;
BEGIN
  v_whatsapp_clean := REGEXP_REPLACE(p_whatsapp, '[\s\-]', '', 'g');

  -- Find matching user (correct JOIN: e.user_id = u.id)
  SELECT u.id INTO v_user_id
  FROM users u
  JOIN hr_employee_master e ON e.user_id = u.id
  WHERE LOWER(TRIM(e.email)) = LOWER(TRIM(p_email))
    AND REGEXP_REPLACE(e.whatsapp_number, '[\s\-]', '', 'g') = v_whatsapp_clean
    AND u.status = 'active'
  LIMIT 1;

  IF v_user_id IS NULL THEN
    RETURN json_build_object('success', false, 'message', 'User not found.');
  END IF;

  -- Find valid OTP
  SELECT id, otp_code, attempts INTO v_otp_record
  FROM access_code_otp
  WHERE user_id = v_user_id
    AND verified = false
    AND expires_at > NOW()
  ORDER BY created_at DESC
  LIMIT 1;

  IF v_otp_record IS NULL THEN
    RETURN json_build_object('success', false, 'message', 'No valid OTP found. Please request a new one.');
  END IF;

  -- Check attempts
  IF v_otp_record.attempts >= 5 THEN
    UPDATE access_code_otp SET verified = true WHERE id = v_otp_record.id;
    RETURN json_build_object('success', false, 'message', 'Too many failed attempts. Please request a new OTP.');
  END IF;

  -- Verify OTP
  IF v_otp_record.otp_code != p_otp THEN
    UPDATE access_code_otp SET attempts = attempts + 1 WHERE id = v_otp_record.id;
    RETURN json_build_object('success', false, 'message', 'Invalid OTP code.');
  END IF;

  -- Check new code is not already used by another user
  SELECT COUNT(*) INTO v_existing_count
  FROM users
  WHERE id != v_user_id
    AND quick_access_code IS NOT NULL
    AND quick_access_code != ''
    AND extensions.crypt(p_new_code, quick_access_code) = quick_access_code;

  IF v_existing_count > 0 THEN
    RETURN json_build_object('success', false, 'message', 'This access code is already in use. Please choose a different one.');
  END IF;

  -- Hash the new code and update
  v_hashed_code := extensions.crypt(p_new_code, extensions.gen_salt('bf'));

  UPDATE users
  SET quick_access_code = v_hashed_code,
      updated_at = NOW()
  WHERE id = v_user_id;

  -- Mark OTP as verified
  UPDATE access_code_otp SET verified = true WHERE id = v_otp_record.id;

  RETURN json_build_object('success', true, 'message', 'Access code changed successfully.');
END;
$$;



--
-- Name: verify_password(text, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.verify_password(password text, hash text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN hash = crypt(password, hash);
END;
$$;



--
-- Name: verify_password(character varying, character varying); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.verify_password(input_username character varying, input_password character varying) RETURNS TABLE(user_id uuid, username character varying, email character varying, role_type character varying, is_valid boolean)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        u.id as user_id,
        u.username,
        u.email,
        -- Return derived role_type for backward compatibility
        CASE 
            WHEN u.is_master_admin = true THEN 'Master Admin'::character varying
            WHEN u.is_admin = true THEN 'Admin'::character varying
            ELSE 'User'::character varying
        END as role_type,
        (u.password_hash = crypt(input_password, u.password_hash)) as is_valid
    FROM users u
    WHERE u.username = input_username
      AND u.deleted_at IS NULL
    LIMIT 1;
END;
$$;



--
-- Name: verify_quick_access_code(character varying); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.verify_quick_access_code(p_code character varying) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $_$
DECLARE
  v_user RECORD;
BEGIN
  -- Validate input format
  IF p_code IS NULL OR LENGTH(p_code) != 6 OR p_code !~ '^[0-9]{6}$' THEN
    RETURN json_build_object('success', false, 'error', 'Invalid access code format');
  END IF;

  -- Find user where crypt(input, stored_hash) = stored_hash
  SELECT id, username, user_type, status, is_master_admin, is_admin,
         employee_id, branch_id, position_id, avatar, quick_access_code, quick_access_salt
  INTO v_user
  FROM users
  WHERE status = 'active'
    AND extensions.crypt(p_code, quick_access_code) = quick_access_code;

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



--
-- Name: verify_quick_task_completion(uuid, uuid, text, boolean); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.verify_quick_task_completion(completion_id_param uuid, verified_by_user_id_param uuid, verification_notes_param text DEFAULT NULL::text, is_approved boolean DEFAULT true) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_status VARCHAR(50);
BEGIN
    IF is_approved THEN
        new_status := 'verified';
    ELSE
        new_status := 'rejected';
    END IF;
    
    UPDATE quick_task_completions 
    SET completion_status = new_status,
        verified_by_user_id = verified_by_user_id_param,
        verified_at = now(),
        verification_notes = verification_notes_param,
        updated_at = now()
    WHERE id = completion_id_param;
    
    RETURN FOUND;
END;
$$;



SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: access_code_otp; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.access_code_otp (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    otp_code character varying(6) NOT NULL,
    email character varying(255) NOT NULL,
    whatsapp_number character varying(20) NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:05:00'::interval) NOT NULL,
    verified boolean DEFAULT false,
    attempts integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now()
);



--
-- Name: ai_chat_guide; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.ai_chat_guide (
    id integer NOT NULL,
    guide_text text DEFAULT ''::text NOT NULL,
    updated_by uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);



--
-- Name: ai_chat_guide_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.ai_chat_guide_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: ai_chat_guide_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.ai_chat_guide_id_seq OWNED BY public.ai_chat_guide.id;


--
-- Name: app_icons; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.app_icons (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    icon_key text NOT NULL,
    category text DEFAULT 'general'::text NOT NULL,
    storage_path text NOT NULL,
    mime_type text,
    file_size bigint DEFAULT 0,
    description text,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid
);



--
-- Name: TABLE app_icons; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.app_icons IS 'Stores metadata for all application icons managed dynamically';


--
-- Name: COLUMN app_icons.icon_key; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.app_icons.icon_key IS 'Unique key used in code to reference this icon (e.g. logo, saudi-currency)';


--
-- Name: COLUMN app_icons.category; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.app_icons.category IS 'Category: logo, currency, social, pwa, misc';


--
-- Name: COLUMN app_icons.storage_path; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.app_icons.storage_path IS 'Path within the app-icons storage bucket';


--
-- Name: approval_permissions; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.approval_permissions (
    id bigint NOT NULL,
    user_id uuid NOT NULL,
    can_approve_requisitions boolean DEFAULT false NOT NULL,
    requisition_amount_limit numeric(15,2) DEFAULT 0.00,
    can_approve_single_bill boolean DEFAULT false NOT NULL,
    single_bill_amount_limit numeric(15,2) DEFAULT 0.00,
    can_approve_multiple_bill boolean DEFAULT false NOT NULL,
    multiple_bill_amount_limit numeric(15,2) DEFAULT 0.00,
    can_approve_recurring_bill boolean DEFAULT false NOT NULL,
    recurring_bill_amount_limit numeric(15,2) DEFAULT 0.00,
    can_approve_vendor_payments boolean DEFAULT false NOT NULL,
    vendor_payment_amount_limit numeric(15,2) DEFAULT 0.00,
    can_approve_leave_requests boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid,
    updated_by uuid,
    is_active boolean DEFAULT true NOT NULL,
    can_approve_purchase_vouchers boolean DEFAULT false NOT NULL,
    can_add_missing_punches boolean DEFAULT false NOT NULL,
    can_receive_customer_incidents boolean DEFAULT false NOT NULL,
    can_receive_employee_incidents boolean DEFAULT false NOT NULL,
    can_receive_maintenance_incidents boolean DEFAULT false NOT NULL,
    can_receive_vendor_incidents boolean DEFAULT false NOT NULL,
    can_receive_vehicle_incidents boolean DEFAULT false NOT NULL,
    can_receive_government_incidents boolean DEFAULT false NOT NULL,
    can_receive_other_incidents boolean DEFAULT false NOT NULL,
    can_receive_finance_incidents boolean DEFAULT false NOT NULL,
    can_receive_pos_incidents boolean DEFAULT false NOT NULL,
    CONSTRAINT approval_permissions_multiple_bill_limit_check CHECK ((multiple_bill_amount_limit >= (0)::numeric)),
    CONSTRAINT approval_permissions_recurring_bill_limit_check CHECK ((recurring_bill_amount_limit >= (0)::numeric)),
    CONSTRAINT approval_permissions_requisition_limit_check CHECK ((requisition_amount_limit >= (0)::numeric)),
    CONSTRAINT approval_permissions_single_bill_limit_check CHECK ((single_bill_amount_limit >= (0)::numeric)),
    CONSTRAINT approval_permissions_vendor_payment_limit_check CHECK ((vendor_payment_amount_limit >= (0)::numeric))
);



--
-- Name: TABLE approval_permissions; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.approval_permissions IS 'Stores granular approval permissions for different types of requests (requisitions, schedules, vendor payments, etc.)';


--
-- Name: COLUMN approval_permissions.user_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.approval_permissions.user_id IS 'Reference to the user who has these approval permissions';


--
-- Name: COLUMN approval_permissions.can_approve_requisitions; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.approval_permissions.can_approve_requisitions IS 'Whether user can approve expense requisitions';


--
-- Name: COLUMN approval_permissions.requisition_amount_limit; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.approval_permissions.requisition_amount_limit IS 'Maximum amount user can approve for requisitions (0 = unlimited)';


--
-- Name: COLUMN approval_permissions.can_approve_single_bill; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.approval_permissions.can_approve_single_bill IS 'Whether user can approve single bill payment schedules';


--
-- Name: COLUMN approval_permissions.single_bill_amount_limit; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.approval_permissions.single_bill_amount_limit IS 'Maximum amount user can approve for single bills (0 = unlimited)';


--
-- Name: COLUMN approval_permissions.can_approve_multiple_bill; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.approval_permissions.can_approve_multiple_bill IS 'Whether user can approve multiple bill payment schedules';


--
-- Name: COLUMN approval_permissions.multiple_bill_amount_limit; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.approval_permissions.multiple_bill_amount_limit IS 'Maximum amount user can approve for multiple bills (0 = unlimited)';


--
-- Name: COLUMN approval_permissions.can_approve_recurring_bill; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.approval_permissions.can_approve_recurring_bill IS 'Whether user can approve recurring bill payment schedules';


--
-- Name: COLUMN approval_permissions.recurring_bill_amount_limit; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.approval_permissions.recurring_bill_amount_limit IS 'Maximum amount user can approve for recurring bills (0 = unlimited)';


--
-- Name: COLUMN approval_permissions.can_approve_vendor_payments; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.approval_permissions.can_approve_vendor_payments IS 'Whether user can approve vendor payments';


--
-- Name: COLUMN approval_permissions.vendor_payment_amount_limit; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.approval_permissions.vendor_payment_amount_limit IS 'Maximum amount user can approve for vendor payments (0 = unlimited)';


--
-- Name: COLUMN approval_permissions.is_active; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.approval_permissions.is_active IS 'Whether these permissions are currently active';


--
-- Name: COLUMN approval_permissions.can_receive_customer_incidents; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.approval_permissions.can_receive_customer_incidents IS 'Permission to receive and review customer-related incident reports';


--
-- Name: COLUMN approval_permissions.can_receive_employee_incidents; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.approval_permissions.can_receive_employee_incidents IS 'Permission to receive and review employee-related incident reports';


--
-- Name: COLUMN approval_permissions.can_receive_maintenance_incidents; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.approval_permissions.can_receive_maintenance_incidents IS 'Permission to receive and review maintenance-related incident reports';


--
-- Name: COLUMN approval_permissions.can_receive_vendor_incidents; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.approval_permissions.can_receive_vendor_incidents IS 'Permission to receive and review vendor-related incident reports';


--
-- Name: COLUMN approval_permissions.can_receive_vehicle_incidents; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.approval_permissions.can_receive_vehicle_incidents IS 'Permission to receive and review vehicle-related incident reports';


--
-- Name: COLUMN approval_permissions.can_receive_government_incidents; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.approval_permissions.can_receive_government_incidents IS 'Permission to receive and review government-related incident reports';


--
-- Name: COLUMN approval_permissions.can_receive_other_incidents; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.approval_permissions.can_receive_other_incidents IS 'Permission to receive and review other types of incident reports';


--
-- Name: COLUMN approval_permissions.can_receive_finance_incidents; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.approval_permissions.can_receive_finance_incidents IS 'Permission to receive and review finance department incident reports (IN8)';


--
-- Name: COLUMN approval_permissions.can_receive_pos_incidents; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.approval_permissions.can_receive_pos_incidents IS 'Permission to receive and review customer/POS incident reports (IN9)';


--
-- Name: approval_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.approval_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: approval_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.approval_permissions_id_seq OWNED BY public.approval_permissions.id;


--
-- Name: approver_branch_access; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.approver_branch_access (
    id bigint NOT NULL,
    user_id uuid NOT NULL,
    branch_id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid,
    is_active boolean DEFAULT true NOT NULL,
    CONSTRAINT approver_branch_access_active_check CHECK (((is_active = true) OR (is_active = false)))
);



--
-- Name: approver_branch_access_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.approver_branch_access_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: approver_branch_access_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.approver_branch_access_id_seq OWNED BY public.approver_branch_access.id;


--
-- Name: approver_visibility_config; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.approver_visibility_config (
    id bigint NOT NULL,
    user_id uuid NOT NULL,
    visibility_type character varying(50) DEFAULT 'global'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid,
    updated_by uuid,
    is_active boolean DEFAULT true NOT NULL,
    CONSTRAINT approver_visibility_type_check CHECK (((visibility_type)::text = ANY ((ARRAY['global'::character varying, 'branch_specific'::character varying, 'multiple_branches'::character varying])::text[])))
);



--
-- Name: approver_visibility_config_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.approver_visibility_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: approver_visibility_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.approver_visibility_config_id_seq OWNED BY public.approver_visibility_config.id;


--
-- Name: asset_main_categories; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.asset_main_categories (
    id integer NOT NULL,
    group_code character varying(20) NOT NULL,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);



--
-- Name: asset_main_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.asset_main_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: asset_main_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.asset_main_categories_id_seq OWNED BY public.asset_main_categories.id;


--
-- Name: asset_sub_categories; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.asset_sub_categories (
    id integer NOT NULL,
    category_id integer NOT NULL,
    group_code character varying(20) NOT NULL,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    useful_life_years character varying(20),
    annual_depreciation_pct numeric(8,4) DEFAULT 0,
    monthly_depreciation_pct numeric(8,4) DEFAULT 0,
    residual_pct character varying(20) DEFAULT '0%'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);



--
-- Name: asset_sub_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.asset_sub_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: asset_sub_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.asset_sub_categories_id_seq OWNED BY public.asset_sub_categories.id;


--
-- Name: assets; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.assets (
    id integer NOT NULL,
    asset_id character varying(30) NOT NULL,
    sub_category_id integer NOT NULL,
    asset_name_en character varying(255) NOT NULL,
    asset_name_ar character varying(255) NOT NULL,
    purchase_date date,
    purchase_value numeric(12,2) DEFAULT 0,
    branch_id integer,
    invoice_url text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);



--
-- Name: assets_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.assets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: assets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.assets_id_seq OWNED BY public.assets.id;


--
-- Name: bank_reconciliations; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.bank_reconciliations (
    id integer NOT NULL,
    operation_id uuid NOT NULL,
    branch_id integer,
    pos_number integer DEFAULT 1 NOT NULL,
    supervisor_id uuid,
    cashier_id uuid,
    reconciliation_number character varying(100) DEFAULT ''::character varying NOT NULL,
    mada_amount numeric(12,2) DEFAULT 0 NOT NULL,
    visa_amount numeric(12,2) DEFAULT 0 NOT NULL,
    mastercard_amount numeric(12,2) DEFAULT 0 NOT NULL,
    google_pay_amount numeric(12,2) DEFAULT 0 NOT NULL,
    other_amount numeric(12,2) DEFAULT 0 NOT NULL,
    total_amount numeric(12,2) DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);



--
-- Name: bank_reconciliations_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.bank_reconciliations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: bank_reconciliations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.bank_reconciliations_id_seq OWNED BY public.bank_reconciliations.id;


--
-- Name: biometric_connections; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.biometric_connections (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    branch_id integer NOT NULL,
    branch_name text NOT NULL,
    server_ip text NOT NULL,
    server_name text,
    database_name text NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    device_id text NOT NULL,
    terminal_sn text,
    is_active boolean DEFAULT true,
    last_sync_at timestamp with time zone,
    last_employee_sync_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    branch_location_code text
);



--
-- Name: TABLE biometric_connections; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.biometric_connections IS 'Stores biometric server connection configurations for ZKBioTime attendance sync';


--
-- Name: COLUMN biometric_connections.branch_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.biometric_connections.branch_id IS 'References branches.id - which Aqura branch this config belongs to';


--
-- Name: COLUMN biometric_connections.server_ip; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.biometric_connections.server_ip IS 'IP address of ZKBioTime SQL Server (e.g., 192.168.0.3)';


--
-- Name: COLUMN biometric_connections.server_name; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.biometric_connections.server_name IS 'SQL Server instance name (e.g., SQLEXPRESS, WIN-D1D6EN8240A)';


--
-- Name: COLUMN biometric_connections.database_name; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.biometric_connections.database_name IS 'ZKBioTime database name (e.g., Zkurbard)';


--
-- Name: COLUMN biometric_connections.device_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.biometric_connections.device_id IS 'Computer name/ID running the sync app';


--
-- Name: COLUMN biometric_connections.terminal_sn; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.biometric_connections.terminal_sn IS 'Optional: Filter by specific terminal serial number (e.g., MFP3243700773)';


--
-- Name: COLUMN biometric_connections.last_sync_at; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.biometric_connections.last_sync_at IS 'Timestamp of last punch transaction sync';


--
-- Name: COLUMN biometric_connections.last_employee_sync_at; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.biometric_connections.last_employee_sync_at IS 'Timestamp of last employee sync';


--
-- Name: bogo_offer_rules; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.bogo_offer_rules (
    id integer NOT NULL,
    offer_id integer NOT NULL,
    buy_product_id character varying(50) NOT NULL,
    buy_quantity integer NOT NULL,
    get_product_id character varying(50) NOT NULL,
    get_quantity integer NOT NULL,
    discount_type character varying(20) NOT NULL,
    discount_value numeric(10,2) DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT bogo_offer_rules_buy_quantity_check CHECK ((buy_quantity > 0)),
    CONSTRAINT bogo_offer_rules_discount_type_check CHECK (((discount_type)::text = ANY (ARRAY[('free'::character varying)::text, ('percentage'::character varying)::text, ('amount'::character varying)::text]))),
    CONSTRAINT bogo_offer_rules_discount_value_check CHECK ((discount_value >= (0)::numeric)),
    CONSTRAINT bogo_offer_rules_get_quantity_check CHECK ((get_quantity > 0)),
    CONSTRAINT valid_discount_value CHECK ((((discount_type)::text = 'free'::text) OR (((discount_type)::text = 'percentage'::text) AND (discount_value > (0)::numeric) AND (discount_value <= (100)::numeric)) OR (((discount_type)::text = 'amount'::text) AND (discount_value > (0)::numeric))))
);



--
-- Name: TABLE bogo_offer_rules; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.bogo_offer_rules IS 'Stores Buy X Get Y (BOGO) offer rules - each rule defines a condition where buying X product(s) qualifies for discount on Y product(s)';


--
-- Name: COLUMN bogo_offer_rules.buy_product_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.bogo_offer_rules.buy_product_id IS 'Product customer must buy (X)';


--
-- Name: COLUMN bogo_offer_rules.buy_quantity; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.bogo_offer_rules.buy_quantity IS 'Quantity of buy product required';


--
-- Name: COLUMN bogo_offer_rules.get_product_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.bogo_offer_rules.get_product_id IS 'Product customer gets discount on (Y)';


--
-- Name: COLUMN bogo_offer_rules.get_quantity; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.bogo_offer_rules.get_quantity IS 'Quantity of get product that receives discount';


--
-- Name: COLUMN bogo_offer_rules.discount_type; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.bogo_offer_rules.discount_type IS 'Type of discount: free (100% off), percentage (% off), or amount (fixed amount off)';


--
-- Name: COLUMN bogo_offer_rules.discount_value; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.bogo_offer_rules.discount_value IS 'Discount value - 0 for free, 1-100 for percentage, or amount for fixed discount';


--
-- Name: bogo_offer_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.bogo_offer_rules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: bogo_offer_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.bogo_offer_rules_id_seq OWNED BY public.bogo_offer_rules.id;


--
-- Name: box_operations; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.box_operations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    box_number smallint NOT NULL,
    branch_id integer NOT NULL,
    user_id uuid NOT NULL,
    denomination_record_id uuid NOT NULL,
    counts_before jsonb NOT NULL,
    counts_after jsonb NOT NULL,
    total_before numeric(15,2) NOT NULL,
    total_after numeric(15,2) NOT NULL,
    difference numeric(15,2) NOT NULL,
    is_matched boolean NOT NULL,
    status character varying(20) DEFAULT 'in_use'::character varying NOT NULL,
    start_time timestamp with time zone DEFAULT now() NOT NULL,
    end_time timestamp with time zone,
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    closing_details jsonb,
    supervisor_verified_at timestamp with time zone,
    supervisor_id uuid,
    closing_start_date date,
    closing_start_time time without time zone,
    closing_end_date date,
    closing_end_time time without time zone,
    recharge_opening_balance numeric(15,2),
    recharge_close_balance numeric(15,2),
    recharge_sales numeric(15,2),
    bank_mada numeric(15,2),
    bank_visa numeric(15,2),
    bank_mastercard numeric(15,2),
    bank_google_pay numeric(15,2),
    bank_other numeric(15,2),
    bank_total numeric(15,2),
    system_cash_sales numeric(15,2),
    system_card_sales numeric(15,2),
    system_return numeric(15,2),
    difference_cash_sales numeric(15,2),
    difference_card_sales numeric(15,2),
    total_difference numeric(15,2),
    closing_total numeric(15,2),
    closing_cash_500 integer,
    closing_cash_200 integer,
    closing_cash_100 integer,
    closing_cash_50 integer,
    closing_cash_20 integer,
    closing_cash_10 integer,
    closing_cash_5 integer,
    closing_cash_2 integer,
    closing_cash_1 integer,
    closing_cash_050 integer,
    closing_cash_025 integer,
    closing_coins integer,
    total_cash_sales numeric(15,2),
    cash_sales_per_count numeric(15,2),
    vouchers_total numeric(15,2),
    total_erp_cash_sales numeric(15,2),
    total_erp_sales numeric(15,2),
    suspense_paid jsonb,
    suspense_received jsonb,
    pos_before_url text,
    completed_by_user_id uuid,
    completed_by_name text,
    complete_details jsonb,
    CONSTRAINT box_operations_box_number_check CHECK (((box_number >= 1) AND (box_number <= 12))),
    CONSTRAINT box_operations_status_check CHECK (((status)::text = ANY ((ARRAY['in_use'::character varying, 'pending_close'::character varying, 'completed'::character varying, 'cancelled'::character varying, 'draft'::character varying])::text[])))
);



--
-- Name: TABLE box_operations; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.box_operations IS 'Tracks POS cash box operations and counter check sessions';


--
-- Name: COLUMN box_operations.difference; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.box_operations.difference IS 'Difference between before and after totals (before - after)';


--
-- Name: COLUMN box_operations.is_matched; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.box_operations.is_matched IS 'True if counter check matched, false if there was a difference';


--
-- Name: COLUMN box_operations.status; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.box_operations.status IS 'Operation status: in_use (active), pending_close (waiting for final close), completed, or cancelled';


--
-- Name: COLUMN box_operations.closing_details; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.box_operations.closing_details IS 'JSON containing all closing form data';


--
-- Name: COLUMN box_operations.supervisor_verified_at; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.box_operations.supervisor_verified_at IS 'Timestamp when supervisor code was verified';


--
-- Name: COLUMN box_operations.supervisor_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.box_operations.supervisor_id IS 'ID of supervisor who verified the closing';


--
-- Name: COLUMN box_operations.difference_cash_sales; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.box_operations.difference_cash_sales IS 'Difference between total cash sales and system cash sales';


--
-- Name: COLUMN box_operations.difference_card_sales; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.box_operations.difference_card_sales IS 'Difference between bank total and system card sales';


--
-- Name: COLUMN box_operations.total_difference; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.box_operations.total_difference IS 'Total of cash and card differences';


--
-- Name: COLUMN box_operations.pos_before_url; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.box_operations.pos_before_url IS 'URL to the stored POS before closing image in pos-before storage bucket';


--
-- Name: branch_default_delivery_receivers; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.branch_default_delivery_receivers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    branch_id bigint NOT NULL,
    user_id uuid NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid
);



--
-- Name: branch_default_positions; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.branch_default_positions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    branch_id integer NOT NULL,
    branch_manager_user_id uuid,
    purchasing_manager_user_id uuid,
    inventory_manager_user_id uuid,
    accountant_user_id uuid,
    night_supervisor_user_ids uuid[] DEFAULT '{}'::uuid[],
    warehouse_handler_user_id uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);



--
-- Name: branch_sync_config; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.branch_sync_config (
    id bigint NOT NULL,
    branch_id bigint NOT NULL,
    local_supabase_url text NOT NULL,
    local_supabase_key text NOT NULL,
    is_active boolean DEFAULT true,
    last_sync_at timestamp with time zone,
    last_sync_status text,
    last_sync_details jsonb DEFAULT '{}'::jsonb,
    sync_tables text[] DEFAULT ARRAY['branches'::text, 'users'::text, 'user_sessions'::text, 'user_device_sessions'::text, 'button_permissions'::text, 'sidebar_buttons'::text, 'button_main_sections'::text, 'button_sub_sections'::text, 'interface_permissions'::text, 'user_favorite_buttons'::text, 'erp_synced_products'::text, 'product_categories'::text, 'products'::text, 'product_units'::text, 'offers'::text, 'offer_products'::text, 'offer_names'::text, 'offer_bundles'::text, 'offer_cart_tiers'::text, 'bogo_offer_rules'::text, 'flyer_offers'::text, 'flyer_offer_products'::text, 'customers'::text, 'privilege_cards_master'::text, 'privilege_cards_branch'::text, 'desktop_themes'::text, 'user_theme_assignments'::text, 'erp_connections'::text, 'erp_sync_logs'::text],
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    tunnel_url text,
    ssh_user text DEFAULT 'u'::text,
    CONSTRAINT branch_sync_config_last_sync_status_check CHECK ((last_sync_status = ANY (ARRAY['success'::text, 'failed'::text, 'in_progress'::text])))
);



--
-- Name: COLUMN branch_sync_config.tunnel_url; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.branch_sync_config.tunnel_url IS 'Cloudflare Tunnel URL for the branch Supabase (used when local URL is unreachable)';


--
-- Name: branch_sync_config_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.branch_sync_config ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.branch_sync_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: branches; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.branches (
    id bigint NOT NULL,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    location_en character varying(500) NOT NULL,
    location_ar character varying(500) NOT NULL,
    is_active boolean DEFAULT true,
    is_main_branch boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by bigint,
    updated_by bigint,
    vat_number character varying(50),
    delivery_service_enabled boolean DEFAULT true NOT NULL,
    pickup_service_enabled boolean DEFAULT true NOT NULL,
    minimum_order_amount numeric(10,2) DEFAULT 15.00,
    is_24_hours boolean DEFAULT true,
    operating_start_time time without time zone,
    operating_end_time time without time zone,
    delivery_message_ar text,
    delivery_message_en text,
    delivery_is_24_hours boolean DEFAULT true,
    delivery_start_time time without time zone,
    delivery_end_time time without time zone,
    pickup_is_24_hours boolean DEFAULT true,
    pickup_start_time time without time zone,
    pickup_end_time time without time zone,
    location_url text,
    latitude double precision,
    longitude double precision,
    CONSTRAINT check_vat_number_not_empty CHECK (((vat_number IS NULL) OR (length(TRIM(BOTH FROM vat_number)) > 0)))
);



--
-- Name: COLUMN branches.vat_number; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.branches.vat_number IS 'VAT registration number for the branch';


--
-- Name: COLUMN branches.delivery_service_enabled; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.branches.delivery_service_enabled IS 'Enable/disable delivery service for this branch';


--
-- Name: COLUMN branches.pickup_service_enabled; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.branches.pickup_service_enabled IS 'Enable/disable store pickup service for this branch';


--
-- Name: COLUMN branches.minimum_order_amount; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.branches.minimum_order_amount IS 'Minimum order amount for this branch (SAR)';


--
-- Name: COLUMN branches.is_24_hours; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.branches.is_24_hours IS 'Whether delivery service is available 24/7 for this branch';


--
-- Name: COLUMN branches.operating_start_time; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.branches.operating_start_time IS 'Delivery service start time (if not 24/7)';


--
-- Name: COLUMN branches.operating_end_time; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.branches.operating_end_time IS 'Delivery service end time (if not 24/7)';


--
-- Name: COLUMN branches.delivery_message_ar; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.branches.delivery_message_ar IS 'Custom delivery message in Arabic for this branch';


--
-- Name: COLUMN branches.delivery_message_en; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.branches.delivery_message_en IS 'Custom delivery message in English for this branch';


--
-- Name: COLUMN branches.delivery_is_24_hours; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.branches.delivery_is_24_hours IS 'Whether delivery service is available 24/7';


--
-- Name: COLUMN branches.delivery_start_time; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.branches.delivery_start_time IS 'Delivery service start time';


--
-- Name: COLUMN branches.delivery_end_time; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.branches.delivery_end_time IS 'Delivery service end time';


--
-- Name: COLUMN branches.pickup_is_24_hours; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.branches.pickup_is_24_hours IS 'Whether pickup service is available 24/7';


--
-- Name: COLUMN branches.pickup_start_time; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.branches.pickup_start_time IS 'Pickup service start time';


--
-- Name: COLUMN branches.pickup_end_time; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.branches.pickup_end_time IS 'Pickup service end time';


--
-- Name: COLUMN branches.location_url; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.branches.location_url IS 'Google Maps URL for the branch location';


--
-- Name: COLUMN branches.latitude; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.branches.latitude IS 'Branch latitude for distance calculation';


--
-- Name: COLUMN branches.longitude; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.branches.longitude IS 'Branch longitude for distance calculation';


--
-- Name: branches_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.branches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: branches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.branches_id_seq OWNED BY public.branches.id;


--
-- Name: break_reasons; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.break_reasons (
    id integer NOT NULL,
    name_en character varying(100) NOT NULL,
    name_ar character varying(100) NOT NULL,
    sort_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    requires_note boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now()
);



--
-- Name: break_reasons_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.break_reasons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: break_reasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.break_reasons_id_seq OWNED BY public.break_reasons.id;


--
-- Name: break_register; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.break_register (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    employee_id character varying(50) NOT NULL,
    employee_name_en character varying(200),
    employee_name_ar character varying(200),
    branch_id integer,
    reason_id integer NOT NULL,
    reason_note text,
    start_time timestamp with time zone DEFAULT now() NOT NULL,
    end_time timestamp with time zone,
    duration_seconds integer,
    status character varying(20) DEFAULT 'open'::character varying,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT break_register_status_check CHECK (((status)::text = ANY ((ARRAY['open'::character varying, 'closed'::character varying])::text[])))
);

ALTER TABLE ONLY public.break_register REPLICA IDENTITY FULL;



--
-- Name: break_security_seed; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.break_security_seed (
    id integer DEFAULT 1 NOT NULL,
    seed text DEFAULT encode(extensions.gen_random_bytes(32), 'hex'::text) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT break_security_seed_id_check CHECK ((id = 1))
);



--
-- Name: button_main_sections; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.button_main_sections (
    id bigint NOT NULL,
    section_name_en character varying(255) NOT NULL,
    section_name_ar character varying(255) NOT NULL,
    section_code character varying(50) NOT NULL,
    display_order integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);



--
-- Name: button_main_sections_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.button_main_sections ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.button_main_sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: button_permissions; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.button_permissions (
    id bigint NOT NULL,
    user_id uuid NOT NULL,
    button_id bigint NOT NULL,
    is_enabled boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);



--
-- Name: button_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.button_permissions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.button_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: button_sub_sections; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.button_sub_sections (
    id bigint NOT NULL,
    main_section_id bigint NOT NULL,
    subsection_name_en character varying(255) NOT NULL,
    subsection_name_ar character varying(255) NOT NULL,
    subsection_code character varying(50) NOT NULL,
    display_order integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);



--
-- Name: button_sub_sections_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.button_sub_sections ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.button_sub_sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: coupon_campaigns; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.coupon_campaigns (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    campaign_name character varying(255),
    campaign_code character varying(50) NOT NULL,
    description text,
    validity_start_date timestamp with time zone,
    validity_end_date timestamp with time zone,
    is_active boolean DEFAULT true,
    terms_conditions_en text,
    terms_conditions_ar text,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    start_date timestamp with time zone NOT NULL,
    end_date timestamp with time zone NOT NULL,
    max_claims_per_customer integer DEFAULT 1,
    CONSTRAINT valid_campaign_dates CHECK ((end_date > start_date)),
    CONSTRAINT valid_max_claims CHECK ((max_claims_per_customer > 0))
);



--
-- Name: coupon_claims; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.coupon_claims (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    campaign_id uuid NOT NULL,
    customer_mobile character varying(20) NOT NULL,
    product_id uuid,
    branch_id bigint,
    claimed_by_user uuid,
    claimed_at timestamp with time zone DEFAULT now(),
    print_count integer DEFAULT 1,
    barcode_scanned boolean DEFAULT false,
    validity_date date NOT NULL,
    status character varying(20) DEFAULT 'claimed'::character varying,
    created_at timestamp with time zone DEFAULT now(),
    max_claims_per_customer integer DEFAULT 1,
    CONSTRAINT valid_status CHECK (((status)::text = ANY (ARRAY[('claimed'::character varying)::text, ('redeemed'::character varying)::text, ('expired'::character varying)::text])))
);



--
-- Name: coupon_eligible_customers; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.coupon_eligible_customers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    campaign_id uuid NOT NULL,
    mobile_number character varying(20) NOT NULL,
    customer_name character varying(255),
    import_batch_id uuid,
    imported_at timestamp with time zone DEFAULT now(),
    imported_by uuid,
    created_at timestamp with time zone DEFAULT now()
);



--
-- Name: coupon_products; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.coupon_products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    campaign_id uuid NOT NULL,
    product_name_en character varying(255) NOT NULL,
    product_name_ar character varying(255) NOT NULL,
    product_image_url text,
    original_price numeric(10,2) NOT NULL,
    offer_price numeric(10,2) NOT NULL,
    special_barcode character varying(50) NOT NULL,
    stock_limit integer DEFAULT 0 NOT NULL,
    stock_remaining integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    flyer_product_id character varying(10),
    CONSTRAINT valid_price CHECK (((offer_price >= (0)::numeric) AND (original_price >= offer_price))),
    CONSTRAINT valid_stock CHECK (((stock_remaining >= 0) AND (stock_remaining <= stock_limit)))
);



--
-- Name: customer_access_code_history; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.customer_access_code_history (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    customer_id uuid NOT NULL,
    old_access_code text,
    new_access_code text NOT NULL,
    generated_by uuid NOT NULL,
    reason text NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT customer_access_code_history_reason_check CHECK ((reason = ANY (ARRAY['initial_generation'::text, 'admin_regeneration'::text, 'security_reset'::text, 'customer_request'::text, 're_registration'::text, 'forgot_code_resend'::text, 'pre_registered_upgrade'::text])))
);



--
-- Name: TABLE customer_access_code_history; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.customer_access_code_history IS 'Audit trail of customer access code changes';


--
-- Name: COLUMN customer_access_code_history.reason; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.customer_access_code_history.reason IS 'Reason for access code change';


--
-- Name: customer_app_media; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.customer_app_media (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    media_type character varying(10) NOT NULL,
    slot_number integer NOT NULL,
    title_en character varying(255) NOT NULL,
    title_ar character varying(255) NOT NULL,
    description_en text,
    description_ar text,
    file_url text NOT NULL,
    file_size bigint,
    file_type character varying(50),
    duration integer,
    is_active boolean DEFAULT false,
    display_order integer DEFAULT 0,
    is_infinite boolean DEFAULT false,
    expiry_date timestamp with time zone,
    uploaded_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    activated_at timestamp with time zone,
    deactivated_at timestamp with time zone,
    CONSTRAINT customer_app_media_media_type_check CHECK (((media_type)::text = ANY (ARRAY[('video'::character varying)::text, ('image'::character varying)::text]))),
    CONSTRAINT customer_app_media_slot_number_check CHECK (((slot_number >= 1) AND (slot_number <= 6))),
    CONSTRAINT expiry_required_unless_infinite CHECK (((is_infinite = true) OR (expiry_date IS NOT NULL)))
);



--
-- Name: TABLE customer_app_media; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.customer_app_media IS 'Stores videos and images displayed on customer home page with expiry management';


--
-- Name: customer_product_requests; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.customer_product_requests (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    requester_user_id uuid NOT NULL,
    branch_id integer,
    target_user_id uuid,
    status text DEFAULT 'pending'::text NOT NULL,
    items jsonb DEFAULT '[]'::jsonb NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT customer_product_requests_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'reviewed'::text, 'resolved'::text, 'dismissed'::text])))
);



--
-- Name: customer_recovery_requests; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.customer_recovery_requests (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    customer_id uuid,
    whatsapp_number character varying(20) NOT NULL,
    customer_name text,
    request_type text DEFAULT 'account_recovery'::text NOT NULL,
    verification_status text DEFAULT 'pending'::text NOT NULL,
    verification_notes text,
    processed_by uuid,
    processed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT customer_recovery_requests_request_type_check CHECK ((request_type = ANY (ARRAY['account_recovery'::text, 'access_code_request'::text]))),
    CONSTRAINT customer_recovery_requests_verification_status_check CHECK ((verification_status = ANY (ARRAY['pending'::text, 'verified'::text, 'rejected'::text, 'processed'::text]))),
    CONSTRAINT customer_recovery_requests_whatsapp_format_check CHECK (((whatsapp_number)::text ~ '^\+?[1-9]\d{1,14}$'::text))
);



--
-- Name: TABLE customer_recovery_requests; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.customer_recovery_requests IS 'Customer account recovery requests for admin processing';


--
-- Name: COLUMN customer_recovery_requests.request_type; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.customer_recovery_requests.request_type IS 'Type of recovery request';


--
-- Name: COLUMN customer_recovery_requests.verification_status; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.customer_recovery_requests.verification_status IS 'Admin verification status';


--
-- Name: customers; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.customers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    access_code text,
    whatsapp_number character varying(20),
    registration_status text DEFAULT 'pending'::text NOT NULL,
    registration_notes text,
    approved_by uuid,
    approved_at timestamp with time zone,
    access_code_generated_at timestamp with time zone,
    last_login_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    name text,
    location1_name text,
    location1_url text,
    location2_name text,
    location2_url text,
    location3_name text,
    location3_url text,
    location1_lat double precision,
    location1_lng double precision,
    location2_lat double precision,
    location2_lng double precision,
    location3_lat double precision,
    location3_lng double precision,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    whatsapp_available boolean,
    erp_branch_id integer,
    CONSTRAINT customers_location1_name_len CHECK (((location1_name IS NULL) OR (length(location1_name) <= 120))),
    CONSTRAINT customers_location1_url_len CHECK (((location1_url IS NULL) OR (length(location1_url) <= 2048))),
    CONSTRAINT customers_location2_name_len CHECK (((location2_name IS NULL) OR (length(location2_name) <= 120))),
    CONSTRAINT customers_location2_url_len CHECK (((location2_url IS NULL) OR (length(location2_url) <= 2048))),
    CONSTRAINT customers_location3_name_len CHECK (((location3_name IS NULL) OR (length(location3_name) <= 120))),
    CONSTRAINT customers_location3_url_len CHECK (((location3_url IS NULL) OR (length(location3_url) <= 2048))),
    CONSTRAINT customers_registration_status_check CHECK ((registration_status = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text, 'suspended'::text, 'pre_registered'::text, 'deleted'::text]))),
    CONSTRAINT customers_whatsapp_format_check CHECK (((whatsapp_number)::text ~ '^\+?[1-9]\d{1,14}$'::text))
);



--
-- Name: TABLE customers; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.customers IS 'Customer information and access codes for customer login system';


--
-- Name: COLUMN customers.access_code; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.customers.access_code IS 'Unique 6-digit access code for customer login';


--
-- Name: COLUMN customers.whatsapp_number; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.customers.whatsapp_number IS 'Customer WhatsApp number for notifications';


--
-- Name: COLUMN customers.registration_status; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.customers.registration_status IS 'Customer registration approval status';


--
-- Name: COLUMN customers.is_deleted; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.customers.is_deleted IS 'Soft delete flag - set to true when customer deletes their account';


--
-- Name: COLUMN customers.deleted_at; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.customers.deleted_at IS 'Timestamp when customer deleted their account';


--
-- Name: COLUMN customers.erp_branch_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.customers.erp_branch_id IS 'ERP branch ID for queries';


--
-- Name: day_off; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.day_off (
    id text NOT NULL,
    employee_id text NOT NULL,
    day_off_date date NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    day_off_reason_id character varying(50),
    approval_status character varying(50) DEFAULT 'pending'::character varying,
    approval_requested_by uuid,
    approval_requested_at timestamp with time zone,
    approval_approved_by uuid,
    approval_approved_at timestamp with time zone,
    approval_notes text,
    document_url text,
    document_uploaded_at timestamp with time zone,
    is_deductible_on_salary boolean DEFAULT false,
    rejection_reason text,
    description text,
    CONSTRAINT day_off_approval_status_check CHECK (((approval_status)::text = ANY ((ARRAY['pending'::character varying, 'sent_for_approval'::character varying, 'approved'::character varying, 'rejected'::character varying])::text[])))
);



--
-- Name: COLUMN day_off.description; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.day_off.description IS 'Description or reason for the day off request';


--
-- Name: day_off_reasons; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.day_off_reasons (
    id character varying(50) NOT NULL,
    reason_en character varying(255) NOT NULL,
    reason_ar character varying(255) NOT NULL,
    is_deductible boolean DEFAULT false,
    is_document_mandatory boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);



--
-- Name: day_off_weekday; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.day_off_weekday (
    id text NOT NULL,
    employee_id text NOT NULL,
    weekday integer NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT day_off_weekday_weekday_check CHECK (((weekday >= 0) AND (weekday <= 6)))
);



--
-- Name: default_incident_users; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.default_incident_users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    incident_type_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    created_by uuid
);



--
-- Name: deleted_bundle_offers; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.deleted_bundle_offers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    original_offer_id integer NOT NULL,
    offer_data jsonb NOT NULL,
    bundles_data jsonb NOT NULL,
    deleted_at timestamp with time zone DEFAULT now(),
    deleted_by uuid,
    deletion_reason text
);



--
-- Name: TABLE deleted_bundle_offers; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.deleted_bundle_offers IS 'Archive table for deleted bundle offers - allows recovery and audit trail';


--
-- Name: COLUMN deleted_bundle_offers.original_offer_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.deleted_bundle_offers.original_offer_id IS 'The original offer ID from offers table (INTEGER)';


--
-- Name: COLUMN deleted_bundle_offers.offer_data; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.deleted_bundle_offers.offer_data IS 'Complete offer data as JSON';


--
-- Name: COLUMN deleted_bundle_offers.bundles_data; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.deleted_bundle_offers.bundles_data IS 'Array of bundle data as JSON';


--
-- Name: COLUMN deleted_bundle_offers.deleted_by; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.deleted_bundle_offers.deleted_by IS 'User who deleted the offer';


--
-- Name: COLUMN deleted_bundle_offers.deletion_reason; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.deleted_bundle_offers.deletion_reason IS 'Optional reason for deletion';


--
-- Name: delivery_fee_tiers; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.delivery_fee_tiers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    min_order_amount numeric(10,2) NOT NULL,
    max_order_amount numeric(10,2),
    delivery_fee numeric(10,2) NOT NULL,
    tier_order integer NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    description_en text,
    description_ar text,
    created_by uuid,
    updated_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    branch_id bigint,
    CONSTRAINT check_delivery_fee_positive CHECK ((delivery_fee >= (0)::numeric)),
    CONSTRAINT check_min_amount_positive CHECK ((min_order_amount >= (0)::numeric)),
    CONSTRAINT check_min_max_order CHECK (((max_order_amount IS NULL) OR (max_order_amount > min_order_amount)))
);



--
-- Name: TABLE delivery_fee_tiers; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.delivery_fee_tiers IS 'Multi-tier delivery fee system - Migration 20251107000000';


--
-- Name: COLUMN delivery_fee_tiers.min_order_amount; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.delivery_fee_tiers.min_order_amount IS 'Minimum order amount for this tier (SAR)';


--
-- Name: COLUMN delivery_fee_tiers.max_order_amount; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.delivery_fee_tiers.max_order_amount IS 'Maximum order amount for this tier, NULL for unlimited';


--
-- Name: COLUMN delivery_fee_tiers.delivery_fee; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.delivery_fee_tiers.delivery_fee IS 'Delivery fee charged for orders in this tier (SAR)';


--
-- Name: COLUMN delivery_fee_tiers.tier_order; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.delivery_fee_tiers.tier_order IS 'Display order for admin interface';


--
-- Name: COLUMN delivery_fee_tiers.branch_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.delivery_fee_tiers.branch_id IS 'When NULL, tier is global. When set, tier applies only to this branch.';


--
-- Name: delivery_service_settings; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.delivery_service_settings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    minimum_order_amount numeric(10,2) DEFAULT 15.00 NOT NULL,
    is_24_hours boolean DEFAULT true NOT NULL,
    operating_start_time time without time zone,
    operating_end_time time without time zone,
    is_active boolean DEFAULT true NOT NULL,
    display_message_ar text DEFAULT 'التوصيل متاح على مدار الساعة (24/7)'::text,
    display_message_en text DEFAULT 'Delivery available 24/7'::text,
    updated_by uuid,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    customer_login_mask_enabled boolean DEFAULT true NOT NULL,
    CONSTRAINT delivery_settings_singleton CHECK ((id = '00000000-0000-0000-0000-000000000001'::uuid))
);

ALTER TABLE ONLY public.delivery_service_settings REPLICA IDENTITY FULL;



--
-- Name: TABLE delivery_service_settings; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.delivery_service_settings IS 'Global delivery service configuration settings';


--
-- Name: COLUMN delivery_service_settings.minimum_order_amount; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.delivery_service_settings.minimum_order_amount IS 'Minimum order amount to place any order (SAR)';


--
-- Name: denomination_audit_log; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.denomination_audit_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    record_id uuid NOT NULL,
    branch_id integer NOT NULL,
    user_id uuid NOT NULL,
    action character varying(10) NOT NULL,
    record_type character varying(30) NOT NULL,
    box_number smallint,
    old_counts jsonb,
    new_counts jsonb,
    old_erp_balance numeric(15,2),
    new_erp_balance numeric(15,2),
    old_grand_total numeric(15,2),
    new_grand_total numeric(15,2),
    old_difference numeric(15,2),
    new_difference numeric(15,2),
    change_reason text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT denomination_audit_log_action_check CHECK (((action)::text = ANY ((ARRAY['INSERT'::character varying, 'UPDATE'::character varying, 'DELETE'::character varying])::text[])))
);



--
-- Name: TABLE denomination_audit_log; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.denomination_audit_log IS 'Automatic audit log for all denomination record changes (INSERT, UPDATE, DELETE)';


--
-- Name: denomination_records; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.denomination_records (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    branch_id integer NOT NULL,
    user_id uuid NOT NULL,
    record_type character varying(30) NOT NULL,
    box_number smallint,
    counts jsonb DEFAULT '{}'::jsonb NOT NULL,
    erp_balance numeric(15,2),
    grand_total numeric(15,2) DEFAULT 0 NOT NULL,
    difference numeric(15,2),
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    petty_cash_operation jsonb,
    CONSTRAINT denomination_records_box_number_check CHECK (((box_number IS NULL) OR ((box_number >= 1) AND (box_number <= 12)))),
    CONSTRAINT denomination_records_record_type_check CHECK (((record_type)::text = ANY (ARRAY['main'::text, 'advance_box'::text, 'collection_box'::text, 'paid'::text, 'received'::text, 'petty_cash_box'::text])))
);



--
-- Name: TABLE denomination_records; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.denomination_records IS 'Stores denomination count records for main, boxes, and other sections';


--
-- Name: COLUMN denomination_records.record_type; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.denomination_records.record_type IS 'Type of record: main, advance_box, collection_box, paid, received';


--
-- Name: COLUMN denomination_records.box_number; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.denomination_records.box_number IS 'Box or card number (1-12 for advance boxes, 1-6 for collection boxes, 1-6 for paid/received, null for main)';


--
-- Name: COLUMN denomination_records.counts; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.denomination_records.counts IS 'JSONB storing denomination counts: {"d500": 10, "d200": 5, ...}';


--
-- Name: COLUMN denomination_records.petty_cash_operation; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.denomination_records.petty_cash_operation IS 'JSONB column storing petty cash operation details: {transferred_from_box_number, transferred_from_user_id, closing_details}';


--
-- Name: CONSTRAINT denomination_records_record_type_check ON denomination_records; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON CONSTRAINT denomination_records_record_type_check ON public.denomination_records IS 'Allowed record types: main (main denomination), advance_box (advance manager boxes), collection_box (collection boxes), paid (paid records), received (received records), petty_cash_box (petty cash transfers)';


--
-- Name: denomination_transactions; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.denomination_transactions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    branch_id integer NOT NULL,
    section character varying(20) NOT NULL,
    transaction_type character varying(50) NOT NULL,
    amount numeric(15,2) NOT NULL,
    remarks text,
    apply_denomination boolean DEFAULT false,
    denomination_details jsonb DEFAULT '{}'::jsonb,
    entity_data jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid NOT NULL,
    CONSTRAINT denomination_transactions_section_check CHECK (((section)::text = ANY ((ARRAY['paid'::character varying, 'received'::character varying])::text[]))),
    CONSTRAINT denomination_transactions_transaction_type_check CHECK (((transaction_type)::text = ANY ((ARRAY['vendor'::character varying, 'expenses'::character varying, 'user'::character varying, 'other'::character varying])::text[])))
);



--
-- Name: denomination_types; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.denomination_types (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    value numeric(10,2) NOT NULL,
    label character varying(50) NOT NULL,
    label_ar character varying(50),
    is_active boolean DEFAULT true,
    sort_order integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);



--
-- Name: TABLE denomination_types; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.denomination_types IS 'Master table for denomination types (currency notes, coins, damage)';


--
-- Name: denomination_types_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.denomination_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: denomination_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.denomination_types_id_seq OWNED BY public.denomination_types.id;


--
-- Name: denomination_user_preferences; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.denomination_user_preferences (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    default_branch_id integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);



--
-- Name: TABLE denomination_user_preferences; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.denomination_user_preferences IS 'Stores user preferences for the Denomination feature';


--
-- Name: COLUMN denomination_user_preferences.user_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.denomination_user_preferences.user_id IS 'Reference to the user';


--
-- Name: COLUMN denomination_user_preferences.default_branch_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.denomination_user_preferences.default_branch_id IS 'Default branch selected by the user for denomination';


--
-- Name: desktop_themes; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.desktop_themes (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(255) DEFAULT ''::character varying,
    is_default boolean DEFAULT false,
    taskbar_bg character varying(100) DEFAULT 'rgba(0, 102, 178, 0.75)'::character varying,
    taskbar_border character varying(100) DEFAULT 'rgba(255, 255, 255, 0.2)'::character varying,
    taskbar_btn_active_bg character varying(100) DEFAULT 'linear-gradient(135deg, #4F46E5, #6366F1)'::character varying,
    taskbar_btn_active_text character varying(30) DEFAULT '#FFFFFF'::character varying,
    taskbar_btn_inactive_bg character varying(30) DEFAULT 'rgba(255, 255, 255, 0.95)'::character varying,
    taskbar_btn_inactive_text character varying(30) DEFAULT '#0B1220'::character varying,
    taskbar_btn_hover_border character varying(30) DEFAULT '#4F46E5'::character varying,
    taskbar_quick_access_bg character varying(100) DEFAULT 'rgba(255, 255, 255, 0.1)'::character varying,
    sidebar_bg character varying(30) DEFAULT '#374151'::character varying,
    sidebar_text character varying(30) DEFAULT '#e5e7eb'::character varying,
    sidebar_border character varying(30) DEFAULT '#1f2937'::character varying,
    sidebar_favorites_bg character varying(30) DEFAULT '#1d2c5e'::character varying,
    sidebar_favorites_text character varying(30) DEFAULT '#fcd34d'::character varying,
    section_btn_bg character varying(30) DEFAULT '#1DBC83'::character varying,
    section_btn_text character varying(30) DEFAULT '#FFFFFF'::character varying,
    section_btn_hover_bg character varying(30) DEFAULT '#3b82f6'::character varying,
    section_btn_hover_text character varying(30) DEFAULT '#FFFFFF'::character varying,
    subsection_btn_bg character varying(30) DEFAULT '#1DBC83'::character varying,
    subsection_btn_text character varying(30) DEFAULT '#FFFFFF'::character varying,
    subsection_btn_hover_bg character varying(30) DEFAULT '#3b82f6'::character varying,
    subsection_btn_hover_text character varying(30) DEFAULT '#FFFFFF'::character varying,
    submenu_item_bg character varying(30) DEFAULT '#FFFFFF'::character varying,
    submenu_item_text character varying(30) DEFAULT '#f97316'::character varying,
    submenu_item_hover_bg character varying(30) DEFAULT '#3b82f6'::character varying,
    submenu_item_hover_text character varying(30) DEFAULT '#FFFFFF'::character varying,
    logo_bar_bg character varying(100) DEFAULT 'linear-gradient(135deg, #15A34A 0%, #22C55E 100%)'::character varying,
    logo_bar_text character varying(30) DEFAULT '#FFFFFF'::character varying,
    logo_border character varying(30) DEFAULT '#F59E0B'::character varying,
    window_title_active_bg character varying(30) DEFAULT '#0066b2'::character varying,
    window_title_active_text character varying(30) DEFAULT '#FFFFFF'::character varying,
    window_title_inactive_bg character varying(100) DEFAULT 'linear-gradient(135deg, #F9FAFB, #E5E7EB)'::character varying,
    window_title_inactive_text character varying(30) DEFAULT '#374151'::character varying,
    window_border_active character varying(30) DEFAULT '#4F46E5'::character varying,
    desktop_bg character varying(30) DEFAULT '#F9FAFB'::character varying,
    desktop_pattern_opacity character varying(10) DEFAULT '0.4'::character varying,
    interface_switch_bg character varying(100) DEFAULT 'linear-gradient(145deg, #3b82f6, #2563eb)'::character varying,
    interface_switch_hover_bg character varying(100) DEFAULT 'linear-gradient(145deg, #2563eb, #1d4ed8)'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid
);



--
-- Name: desktop_themes_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.desktop_themes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: desktop_themes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.desktop_themes_id_seq OWNED BY public.desktop_themes.id;


--
-- Name: edge_functions_cache; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.edge_functions_cache (
    func_name text NOT NULL,
    func_size text,
    file_count integer DEFAULT 0,
    last_modified timestamp with time zone,
    has_index boolean DEFAULT false,
    func_code text DEFAULT ''::text,
    updated_at timestamp with time zone DEFAULT now()
);



--
-- Name: employee_checklist_assignments; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.employee_checklist_assignments (
    id bigint NOT NULL,
    employee_id text NOT NULL,
    assigned_to_user_id text,
    branch_id bigint,
    checklist_id text NOT NULL,
    frequency_type text NOT NULL,
    day_of_week text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    assigned_by text,
    updated_by text,
    CONSTRAINT employee_checklist_assignments_frequency_type_check CHECK ((frequency_type = ANY (ARRAY['daily'::text, 'weekly'::text])))
);



--
-- Name: employee_checklist_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.employee_checklist_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: employee_checklist_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.employee_checklist_assignments_id_seq OWNED BY public.employee_checklist_assignments.id;


--
-- Name: employee_fine_payments; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.employee_fine_payments (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    warning_id uuid,
    payment_method character varying(50),
    payment_amount numeric(10,2) NOT NULL,
    payment_currency character varying(3) DEFAULT 'USD'::character varying,
    payment_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    payment_reference character varying(100),
    payment_notes text,
    processed_by uuid,
    processed_by_username character varying(255),
    account_code character varying(50),
    transaction_id character varying(100),
    receipt_number character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);



--
-- Name: TABLE employee_fine_payments; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.employee_fine_payments IS 'Payment history for fines associated with warnings';


--
-- Name: employee_official_holidays; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.employee_official_holidays (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    employee_id text NOT NULL,
    official_holiday_id text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);



--
-- Name: erp_connections; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.erp_connections (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    branch_id bigint NOT NULL,
    branch_name text NOT NULL,
    server_ip text NOT NULL,
    server_name text,
    database_name text NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    device_id text,
    erp_branch_id integer,
    tunnel_url text
);



--
-- Name: COLUMN erp_connections.erp_branch_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.erp_connections.erp_branch_id IS 'Branch ID from ERP system (1, 2, 3, etc.)';


--
-- Name: COLUMN erp_connections.tunnel_url; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.erp_connections.tunnel_url IS 'Cloudflare Tunnel URL for the ERP bridge API on this branch server';


--
-- Name: erp_daily_sales; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.erp_daily_sales (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    branch_id bigint NOT NULL,
    sale_date date NOT NULL,
    total_bills integer DEFAULT 0,
    gross_amount numeric(18,2) DEFAULT 0,
    tax_amount numeric(18,2) DEFAULT 0,
    discount_amount numeric(18,2) DEFAULT 0,
    total_returns integer DEFAULT 0,
    return_amount numeric(18,2) DEFAULT 0,
    return_tax numeric(18,2) DEFAULT 0,
    net_bills integer DEFAULT 0,
    net_amount numeric(18,2) DEFAULT 0,
    net_tax numeric(18,2) DEFAULT 0,
    last_sync_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);



--
-- Name: erp_sync_logs; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.erp_sync_logs (
    id integer NOT NULL,
    sync_type text DEFAULT 'auto'::text NOT NULL,
    branches_total integer DEFAULT 0,
    branches_success integer DEFAULT 0,
    branches_failed integer DEFAULT 0,
    products_fetched integer DEFAULT 0,
    products_inserted integer DEFAULT 0,
    products_updated integer DEFAULT 0,
    duration_ms integer DEFAULT 0,
    details jsonb,
    triggered_by text DEFAULT 'pg_cron'::text,
    created_at timestamp with time zone DEFAULT now()
);



--
-- Name: erp_sync_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.erp_sync_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: erp_sync_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.erp_sync_logs_id_seq OWNED BY public.erp_sync_logs.id;


--
-- Name: erp_synced_products; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.erp_synced_products (
    id integer NOT NULL,
    barcode character varying(50) NOT NULL,
    auto_barcode character varying(50),
    parent_barcode character varying(50),
    product_name_en character varying(500),
    product_name_ar character varying(500),
    unit_name character varying(100),
    unit_qty numeric(18,6) DEFAULT 1,
    is_base_unit boolean DEFAULT false,
    synced_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    expiry_dates jsonb DEFAULT '[]'::jsonb,
    managed_by jsonb DEFAULT '[]'::jsonb,
    in_process jsonb DEFAULT '[]'::jsonb,
    expiry_hidden boolean DEFAULT false
);



--
-- Name: erp_synced_products_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.erp_synced_products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: erp_synced_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.erp_synced_products_id_seq OWNED BY public.erp_synced_products.id;


--
-- Name: expense_parent_categories; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.expense_parent_categories (
    id bigint NOT NULL,
    name_en text NOT NULL,
    name_ar text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    is_active boolean DEFAULT true
);



--
-- Name: TABLE expense_parent_categories; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.expense_parent_categories IS 'Parent expense categories with bilingual support (English and Arabic)';


--
-- Name: expense_parent_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.expense_parent_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: expense_parent_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.expense_parent_categories_id_seq OWNED BY public.expense_parent_categories.id;


--
-- Name: expense_requisitions; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.expense_requisitions (
    id bigint NOT NULL,
    requisition_number text NOT NULL,
    branch_id bigint NOT NULL,
    branch_name text NOT NULL,
    approver_id uuid,
    approver_name text,
    expense_category_id bigint,
    expense_category_name_en text,
    expense_category_name_ar text,
    requester_id text NOT NULL,
    requester_name text NOT NULL,
    requester_contact text NOT NULL,
    vat_applicable boolean DEFAULT false,
    amount numeric(15,2) NOT NULL,
    payment_category text NOT NULL,
    description text,
    status text DEFAULT 'pending'::text,
    image_url text,
    created_by uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    credit_period integer,
    bank_name text,
    iban text,
    used_amount numeric DEFAULT 0,
    remaining_balance numeric DEFAULT 0,
    requester_ref_id uuid,
    is_active boolean DEFAULT true NOT NULL,
    due_date date,
    internal_user_id uuid,
    request_type text DEFAULT 'external'::text,
    vendor_id integer,
    vendor_name text,
    CONSTRAINT expense_requisitions_request_type_check CHECK ((request_type = ANY (ARRAY['external'::text, 'internal'::text, 'vendor'::text])))
);



--
-- Name: TABLE expense_requisitions; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.expense_requisitions IS 'Expense requisitions with approval workflow and image storage';


--
-- Name: COLUMN expense_requisitions.requisition_number; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.expense_requisitions.requisition_number IS 'Unique requisition number in format REQ-YYYYMMDD-XXXX';


--
-- Name: COLUMN expense_requisitions.expense_category_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.expense_requisitions.expense_category_id IS 'Expense category - can be null initially and assigned when closing the request';


--
-- Name: COLUMN expense_requisitions.payment_category; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.expense_requisitions.payment_category IS 'Payment method: advance_cash, advance_bank, advance_cash_credit, advance_bank_credit, cash, bank, cash_credit, bank_credit, stock_purchase_advance_cash, stock_purchase_advance_bank, stock_purchase_cash, stock_purchase_bank';


--
-- Name: COLUMN expense_requisitions.status; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.expense_requisitions.status IS 'Requisition status: pending, approved, rejected, completed';


--
-- Name: COLUMN expense_requisitions.credit_period; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.expense_requisitions.credit_period IS 'Credit period in days (required for credit payment methods: advance_cash_credit, advance_bank_credit, cash_credit, bank_credit)';


--
-- Name: COLUMN expense_requisitions.bank_name; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.expense_requisitions.bank_name IS 'Bank name (optional for all bank payment methods)';


--
-- Name: COLUMN expense_requisitions.iban; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.expense_requisitions.iban IS 'IBAN number (optional for all bank payment methods)';


--
-- Name: COLUMN expense_requisitions.used_amount; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.expense_requisitions.used_amount IS 'Total amount used from this requisition across all scheduled bills';


--
-- Name: COLUMN expense_requisitions.remaining_balance; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.expense_requisitions.remaining_balance IS 'Remaining balance available for new bills (amount - used_amount)';


--
-- Name: COLUMN expense_requisitions.requester_ref_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.expense_requisitions.requester_ref_id IS 'Reference to the requesters table for normalized requester data';


--
-- Name: COLUMN expense_requisitions.is_active; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.expense_requisitions.is_active IS 'Indicates if the requisition is active. Deactivated requisitions are excluded from filters and scheduling.';


--
-- Name: COLUMN expense_requisitions.due_date; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.expense_requisitions.due_date IS 'Automatically calculated due date based on payment method and credit period';


--
-- Name: COLUMN expense_requisitions.vendor_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.expense_requisitions.vendor_id IS 'Vendor ERP ID when request type is vendor';


--
-- Name: COLUMN expense_requisitions.vendor_name; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.expense_requisitions.vendor_name IS 'Vendor name when request type is vendor';


--
-- Name: expense_requisitions_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.expense_requisitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: expense_requisitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.expense_requisitions_id_seq OWNED BY public.expense_requisitions.id;


--
-- Name: expense_scheduler; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.expense_scheduler (
    id bigint NOT NULL,
    branch_id bigint NOT NULL,
    branch_name text NOT NULL,
    expense_category_id bigint,
    expense_category_name_en text,
    expense_category_name_ar text,
    requisition_id bigint,
    requisition_number text,
    co_user_id uuid,
    co_user_name text,
    bill_type text NOT NULL,
    bill_number text,
    bill_date date,
    payment_method text,
    due_date date,
    credit_period integer,
    amount numeric NOT NULL,
    bill_file_url text,
    description text,
    notes text,
    is_paid boolean DEFAULT false,
    paid_date timestamp with time zone,
    status text DEFAULT 'pending'::text,
    created_by uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_by uuid,
    updated_at timestamp with time zone DEFAULT now(),
    bank_name text,
    iban text,
    payment_reference character varying(255),
    schedule_type text DEFAULT 'single_bill'::text,
    recurring_type text,
    recurring_metadata jsonb,
    approver_id uuid,
    approver_name text,
    vendor_id integer,
    vendor_name text,
    CONSTRAINT check_approver_for_recurring CHECK (((schedule_type <> 'recurring'::text) OR ((schedule_type = 'recurring'::text) AND (approver_id IS NOT NULL) AND (approver_name IS NOT NULL)))),
    CONSTRAINT check_co_user_for_non_recurring CHECK (((schedule_type = 'recurring'::text) OR (schedule_type = 'expense_requisition'::text) OR (schedule_type = 'closed_requisition_bill'::text) OR ((schedule_type = ANY (ARRAY['single_bill'::text, 'multiple_bill'::text])) AND (co_user_id IS NOT NULL) AND (co_user_name IS NOT NULL)))),
    CONSTRAINT check_recurring_type_values CHECK ((((schedule_type <> 'recurring'::text) AND (recurring_type IS NULL)) OR ((schedule_type = 'recurring'::text) AND (recurring_type = ANY (ARRAY['daily'::text, 'weekly'::text, 'monthly_date'::text, 'monthly_day'::text, 'yearly'::text, 'half_yearly'::text, 'quarterly'::text, 'custom'::text]))))),
    CONSTRAINT check_schedule_type_values CHECK ((schedule_type = ANY (ARRAY['single_bill'::text, 'multiple_bill'::text, 'recurring'::text, 'expense_requisition'::text, 'closed_requisition_bill'::text])))
);



--
-- Name: TABLE expense_scheduler; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.expense_scheduler IS 'Unified table for all scheduled expenses including bills from closed requisitions. 
Bills from closed requisitions have schedule_type = closed_requisition_bill and is_paid = true.';


--
-- Name: COLUMN expense_scheduler.expense_category_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.expense_scheduler.expense_category_id IS 'Can be NULL for requisitions created without categories - category will be assigned when closing the request with bills';


--
-- Name: COLUMN expense_scheduler.due_date; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.expense_scheduler.due_date IS 'Payment due date - calculated based on bill_date or created_at plus credit_period';


--
-- Name: COLUMN expense_scheduler.payment_reference; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.expense_scheduler.payment_reference IS 'Payment reference number or transaction ID for tracking purposes';


--
-- Name: COLUMN expense_scheduler.schedule_type; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.expense_scheduler.schedule_type IS 'Types: single_bill, multiple_bill, recurring, expense_requisition, closed_requisition_bill';


--
-- Name: COLUMN expense_scheduler.recurring_type; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.expense_scheduler.recurring_type IS 'Type of recurring schedule: daily, weekly, monthly_date, monthly_day, yearly, half_yearly, quarterly, custom. Only applies when schedule_type is recurring';


--
-- Name: COLUMN expense_scheduler.recurring_metadata; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.expense_scheduler.recurring_metadata IS 'JSON metadata for recurring schedule details (until_date, weekday, month_position, etc.)';


--
-- Name: COLUMN expense_scheduler.approver_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.expense_scheduler.approver_id IS 'User ID of the approver for recurring schedules. Required for recurring schedules.';


--
-- Name: COLUMN expense_scheduler.approver_name; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.expense_scheduler.approver_name IS 'Name of the approver for recurring schedules. Required for recurring schedules.';


--
-- Name: COLUMN expense_scheduler.vendor_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.expense_scheduler.vendor_id IS 'Vendor ERP ID when schedule is for a vendor expense';


--
-- Name: COLUMN expense_scheduler.vendor_name; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.expense_scheduler.vendor_name IS 'Vendor name when schedule is for a vendor expense';


--
-- Name: CONSTRAINT check_co_user_for_non_recurring ON expense_scheduler; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON CONSTRAINT check_co_user_for_non_recurring ON public.expense_scheduler IS 'Ensures CO user is required for single_bill and multiple_bill, but not for recurring, expense_requisition, or closed_requisition_bill schedule types';


--
-- Name: CONSTRAINT check_schedule_type_values ON expense_scheduler; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON CONSTRAINT check_schedule_type_values ON public.expense_scheduler IS 'Allowed schedule types: single_bill, multiple_bill, recurring, expense_requisition, closed_requisition_bill';


--
-- Name: expense_scheduler_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.expense_scheduler_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: expense_scheduler_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.expense_scheduler_id_seq OWNED BY public.expense_scheduler.id;


--
-- Name: expense_sub_categories; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.expense_sub_categories (
    id bigint NOT NULL,
    parent_category_id bigint NOT NULL,
    name_en text NOT NULL,
    name_ar text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    is_active boolean DEFAULT true
);



--
-- Name: TABLE expense_sub_categories; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.expense_sub_categories IS 'Sub expense categories linked to parent categories with bilingual support';


--
-- Name: expense_sub_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.expense_sub_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: expense_sub_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.expense_sub_categories_id_seq OWNED BY public.expense_sub_categories.id;


--
-- Name: flyer_offer_products; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.flyer_offer_products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    offer_id uuid NOT NULL,
    product_barcode text NOT NULL,
    cost numeric(10,2),
    sales_price numeric(10,2),
    offer_price numeric(10,2),
    profit_amount numeric(10,2),
    profit_percent numeric(10,2),
    profit_after_offer numeric(10,2),
    decrease_amount numeric(10,2),
    offer_qty integer DEFAULT 1 NOT NULL,
    limit_qty integer,
    free_qty integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    page_number integer DEFAULT 1,
    page_order integer DEFAULT 1,
    total_sales_price numeric DEFAULT 0,
    total_offer_price numeric DEFAULT 0,
    CONSTRAINT flyer_offer_products_free_qty_check CHECK ((free_qty >= 0)),
    CONSTRAINT flyer_offer_products_offer_qty_check CHECK ((offer_qty >= 0))
);



--
-- Name: TABLE flyer_offer_products; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.flyer_offer_products IS 'Junction table linking flyer offers to products with pricing details';


--
-- Name: COLUMN flyer_offer_products.offer_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.flyer_offer_products.offer_id IS 'Reference to the flyer offer';


--
-- Name: COLUMN flyer_offer_products.product_barcode; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.flyer_offer_products.product_barcode IS 'Reference to the product barcode';


--
-- Name: COLUMN flyer_offer_products.cost; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.flyer_offer_products.cost IS 'Product cost price';


--
-- Name: COLUMN flyer_offer_products.sales_price; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.flyer_offer_products.sales_price IS 'Regular sales price';


--
-- Name: COLUMN flyer_offer_products.offer_price; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.flyer_offer_products.offer_price IS 'Special offer price';


--
-- Name: COLUMN flyer_offer_products.profit_amount; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.flyer_offer_products.profit_amount IS 'Profit amount in currency';


--
-- Name: COLUMN flyer_offer_products.profit_percent; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.flyer_offer_products.profit_percent IS 'Profit as percentage';


--
-- Name: COLUMN flyer_offer_products.profit_after_offer; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.flyer_offer_products.profit_after_offer IS 'Profit after applying offer discount';


--
-- Name: COLUMN flyer_offer_products.decrease_amount; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.flyer_offer_products.decrease_amount IS 'Amount decreased from regular price';


--
-- Name: COLUMN flyer_offer_products.offer_qty; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.flyer_offer_products.offer_qty IS 'Quantity required to qualify for offer';


--
-- Name: COLUMN flyer_offer_products.limit_qty; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.flyer_offer_products.limit_qty IS 'Maximum quantity limit per customer (nullable)';


--
-- Name: COLUMN flyer_offer_products.free_qty; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.flyer_offer_products.free_qty IS 'Free quantity given with purchase';


--
-- Name: COLUMN flyer_offer_products.page_number; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.flyer_offer_products.page_number IS 'The page number where this product appears in the flyer';


--
-- Name: COLUMN flyer_offer_products.page_order; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.flyer_offer_products.page_order IS 'The order/position of this product on its page';


--
-- Name: flyer_offers; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.flyer_offers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    template_id text DEFAULT (gen_random_uuid())::text NOT NULL,
    template_name text NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    offer_name text,
    offer_name_id text,
    CONSTRAINT flyer_offers_dates_check CHECK ((end_date >= start_date))
);



--
-- Name: TABLE flyer_offers; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.flyer_offers IS 'Stores flyer offer campaigns and templates';


--
-- Name: COLUMN flyer_offers.template_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.flyer_offers.template_id IS 'Unique template identifier for the offer';


--
-- Name: COLUMN flyer_offers.template_name; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.flyer_offers.template_name IS 'Display name for the offer template';


--
-- Name: COLUMN flyer_offers.is_active; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.flyer_offers.is_active IS 'Whether this offer is currently active';


--
-- Name: COLUMN flyer_offers.offer_name; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.flyer_offers.offer_name IS 'Optional custom name for the offer, in addition to the template name';


--
-- Name: COLUMN flyer_offers.offer_name_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.flyer_offers.offer_name_id IS 'Reference to predefined offer name from offer_names table';


--
-- Name: CONSTRAINT flyer_offers_dates_check ON flyer_offers; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON CONSTRAINT flyer_offers_dates_check ON public.flyer_offers IS 'Ensures end date is not before start date';


--
-- Name: flyer_templates; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.flyer_templates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    first_page_image_url text NOT NULL,
    sub_page_image_urls text[] DEFAULT '{}'::text[] NOT NULL,
    first_page_configuration jsonb DEFAULT '[]'::jsonb NOT NULL,
    sub_page_configurations jsonb DEFAULT '[]'::jsonb NOT NULL,
    metadata jsonb DEFAULT '{"sub_page_width": 794, "sub_page_height": 1123, "first_page_width": 794, "first_page_height": 1123}'::jsonb,
    is_active boolean DEFAULT true,
    is_default boolean DEFAULT false,
    category character varying(100),
    tags text[] DEFAULT '{}'::text[],
    usage_count integer DEFAULT 0,
    last_used_at timestamp with time zone,
    created_by uuid,
    updated_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    CONSTRAINT flyer_templates_sub_page_images_match_configs CHECK (((array_length(sub_page_image_urls, 1) = jsonb_array_length(sub_page_configurations)) OR ((sub_page_image_urls = '{}'::text[]) AND (sub_page_configurations = '[]'::jsonb))))
);



--
-- Name: TABLE flyer_templates; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.flyer_templates IS 'Stores flyer template designs with product field configurations';


--
-- Name: COLUMN flyer_templates.first_page_image_url; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.flyer_templates.first_page_image_url IS 'Storage URL for the first page template image';


--
-- Name: COLUMN flyer_templates.sub_page_image_urls; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.flyer_templates.sub_page_image_urls IS 'Array of storage URLs for unlimited sub-page template images';


--
-- Name: COLUMN flyer_templates.first_page_configuration; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.flyer_templates.first_page_configuration IS 'JSONB array of product field configurations for first page';


--
-- Name: COLUMN flyer_templates.sub_page_configurations; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.flyer_templates.sub_page_configurations IS 'JSONB 2D array - each element contains field configurations for a sub-page';


--
-- Name: COLUMN flyer_templates.metadata; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.flyer_templates.metadata IS 'Template dimensions and additional metadata';


--
-- Name: frontend_builds; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.frontend_builds (
    id integer NOT NULL,
    version text NOT NULL,
    file_name text NOT NULL,
    file_size bigint DEFAULT 0 NOT NULL,
    storage_path text NOT NULL,
    notes text,
    uploaded_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);



--
-- Name: frontend_builds_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.frontend_builds_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: frontend_builds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.frontend_builds_id_seq OWNED BY public.frontend_builds.id;


--
-- Name: hr_analysed_attendance_data; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.hr_analysed_attendance_data (
    id bigint NOT NULL,
    employee_id text NOT NULL,
    shift_date date NOT NULL,
    status text DEFAULT 'Absent'::text NOT NULL,
    worked_minutes integer DEFAULT 0 NOT NULL,
    late_minutes integer DEFAULT 0 NOT NULL,
    under_minutes integer DEFAULT 0 NOT NULL,
    shift_start_time time without time zone,
    shift_end_time time without time zone,
    check_in_time time without time zone,
    check_out_time time without time zone,
    employee_name_en text,
    employee_name_ar text,
    branch_id text,
    nationality text,
    analyzed_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    overtime_minutes integer DEFAULT 0
);



--
-- Name: hr_analysed_attendance_data_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.hr_analysed_attendance_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: hr_analysed_attendance_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.hr_analysed_attendance_data_id_seq OWNED BY public.hr_analysed_attendance_data.id;


--
-- Name: hr_basic_salary; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.hr_basic_salary (
    employee_id character varying(50) NOT NULL,
    basic_salary numeric(10,2) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    payment_mode character varying(20) DEFAULT 'Bank'::character varying NOT NULL,
    other_allowance numeric(10,2),
    other_allowance_payment_mode character varying(20),
    accommodation_allowance numeric(10,2),
    accommodation_payment_mode character varying(20),
    travel_allowance numeric(10,2),
    travel_payment_mode character varying(20),
    gosi_deduction numeric(10,2),
    total_salary numeric(10,2),
    food_allowance numeric(10,2) DEFAULT 0,
    food_payment_mode text DEFAULT 'Bank'::text,
    CONSTRAINT hr_basic_salary_accommodation_payment_mode_check CHECK (((accommodation_payment_mode)::text = ANY ((ARRAY['Bank'::character varying, 'Cash'::character varying])::text[]))),
    CONSTRAINT hr_basic_salary_food_payment_mode_check CHECK ((food_payment_mode = ANY (ARRAY['Bank'::text, 'Cash'::text]))),
    CONSTRAINT hr_basic_salary_other_allowance_payment_mode_check CHECK (((other_allowance_payment_mode)::text = ANY ((ARRAY['Bank'::character varying, 'Cash'::character varying])::text[]))),
    CONSTRAINT hr_basic_salary_payment_mode_check CHECK (((payment_mode)::text = ANY ((ARRAY['Bank'::character varying, 'Cash'::character varying])::text[]))),
    CONSTRAINT hr_basic_salary_travel_payment_mode_check CHECK (((travel_payment_mode)::text = ANY ((ARRAY['Bank'::character varying, 'Cash'::character varying])::text[])))
);



--
-- Name: TABLE hr_basic_salary; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.hr_basic_salary IS 'Stores basic salary information for employees';


--
-- Name: COLUMN hr_basic_salary.employee_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.hr_basic_salary.employee_id IS 'References hr_employee_master.id';


--
-- Name: COLUMN hr_basic_salary.basic_salary; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.hr_basic_salary.basic_salary IS 'Employee basic salary amount';


--
-- Name: COLUMN hr_basic_salary.payment_mode; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.hr_basic_salary.payment_mode IS 'Payment mode: Bank or Cash';


--
-- Name: COLUMN hr_basic_salary.other_allowance; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.hr_basic_salary.other_allowance IS 'Other allowance amount';


--
-- Name: COLUMN hr_basic_salary.other_allowance_payment_mode; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.hr_basic_salary.other_allowance_payment_mode IS 'Payment mode for other allowance: Bank or Cash';


--
-- Name: COLUMN hr_basic_salary.accommodation_allowance; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.hr_basic_salary.accommodation_allowance IS 'Accommodation allowance amount';


--
-- Name: COLUMN hr_basic_salary.accommodation_payment_mode; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.hr_basic_salary.accommodation_payment_mode IS 'Payment mode for accommodation: Bank or Cash';


--
-- Name: COLUMN hr_basic_salary.travel_allowance; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.hr_basic_salary.travel_allowance IS 'Travel allowance amount';


--
-- Name: COLUMN hr_basic_salary.travel_payment_mode; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.hr_basic_salary.travel_payment_mode IS 'Payment mode for travel: Bank or Cash';


--
-- Name: COLUMN hr_basic_salary.gosi_deduction; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.hr_basic_salary.gosi_deduction IS 'GOSI deduction amount';


--
-- Name: COLUMN hr_basic_salary.total_salary; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.hr_basic_salary.total_salary IS 'Total salary after all allowances and deductions';


--
-- Name: COLUMN hr_basic_salary.food_allowance; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.hr_basic_salary.food_allowance IS 'Food allowance amount for the employee';


--
-- Name: COLUMN hr_basic_salary.food_payment_mode; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.hr_basic_salary.food_payment_mode IS 'Payment mode for food allowance: Bank or Cash';


--
-- Name: hr_checklist_operations_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.hr_checklist_operations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: hr_checklist_operations; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.hr_checklist_operations (
    id character varying(20) DEFAULT ('CLO'::text || nextval('public.hr_checklist_operations_id_seq'::regclass)) NOT NULL,
    user_id uuid NOT NULL,
    employee_id character varying(50),
    box_operation_id uuid,
    checklist_id character varying(20) NOT NULL,
    answers jsonb DEFAULT '[]'::jsonb NOT NULL,
    total_points integer DEFAULT 0 NOT NULL,
    branch_id bigint,
    operation_date date DEFAULT CURRENT_DATE NOT NULL,
    operation_time time without time zone DEFAULT CURRENT_TIME NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    box_number integer,
    max_points integer DEFAULT 0 NOT NULL,
    submission_type_en text,
    submission_type_ar text
);



--
-- Name: COLUMN hr_checklist_operations.answers; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.hr_checklist_operations.answers IS 'JSONB array: [{ question_id: "Q1", answer_key: "a1", answer_text: "Yes", points: 5, remarks: "...", other_value: "..." }, ...]';


--
-- Name: COLUMN hr_checklist_operations.max_points; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.hr_checklist_operations.max_points IS 'Total possible points from all questions in the checklist';


--
-- Name: COLUMN hr_checklist_operations.submission_type_en; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.hr_checklist_operations.submission_type_en IS 'Submission type in English: POS, Daily, Weekly';


--
-- Name: COLUMN hr_checklist_operations.submission_type_ar; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.hr_checklist_operations.submission_type_ar IS 'Submission type in Arabic: POS, يومي, أسبوعي';


--
-- Name: hr_checklist_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.hr_checklist_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: hr_checklist_questions; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.hr_checklist_questions (
    id character varying(20) DEFAULT ('Q'::text || nextval('public.hr_checklist_questions_id_seq'::regclass)) NOT NULL,
    question_en text,
    question_ar text,
    answer_1_en text,
    answer_1_ar text,
    answer_1_points integer DEFAULT 0,
    answer_2_en text,
    answer_2_ar text,
    answer_2_points integer DEFAULT 0,
    answer_3_en text,
    answer_3_ar text,
    answer_3_points integer DEFAULT 0,
    answer_4_en text,
    answer_4_ar text,
    answer_4_points integer DEFAULT 0,
    answer_5_en text,
    answer_5_ar text,
    answer_5_points integer DEFAULT 0,
    answer_6_en text,
    answer_6_ar text,
    answer_6_points integer DEFAULT 0,
    has_remarks boolean DEFAULT false,
    has_other boolean DEFAULT false,
    other_points integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);



--
-- Name: hr_checklists_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.hr_checklists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: hr_checklists; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.hr_checklists (
    id character varying(20) DEFAULT ('CL'::text || nextval('public.hr_checklists_id_seq'::regclass)) NOT NULL,
    checklist_name_en text,
    checklist_name_ar text,
    question_ids jsonb DEFAULT '[]'::jsonb,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);



--
-- Name: hr_departments; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.hr_departments (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    department_name_en character varying(100) NOT NULL,
    department_name_ar character varying(100) NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);



--
-- Name: TABLE hr_departments; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.hr_departments IS 'HR Departments - minimal schema for Create Department function';


--
-- Name: hr_employee_master; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.hr_employee_master (
    id text NOT NULL,
    user_id uuid NOT NULL,
    current_branch_id integer NOT NULL,
    current_position_id uuid,
    name_en character varying(255),
    name_ar character varying(255),
    employee_id_mapping jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    nationality_id character varying(10),
    id_expiry_date date,
    id_document_url character varying(500),
    health_card_expiry_date date,
    health_card_document_url character varying(500),
    driving_licence_expiry_date date,
    driving_licence_document_url character varying(500),
    id_number character varying(50),
    health_card_number character varying(50),
    driving_licence_number character varying(50),
    bank_name character varying(255),
    iban character varying(34),
    contract_expiry_date date,
    contract_document_url text,
    sponsorship_status boolean DEFAULT false,
    insurance_expiry_date date,
    insurance_company_id character varying(15),
    health_educational_renewal_date date,
    date_of_birth date,
    join_date date,
    work_permit_expiry_date date,
    probation_period_expiry_date date,
    employment_status text DEFAULT 'Resigned'::text,
    permitted_early_leave_hours numeric DEFAULT 0,
    employment_status_effective_date date,
    employment_status_reason text,
    whatsapp_number text,
    email text,
    privacy_policy_accepted boolean DEFAULT false NOT NULL,
    CONSTRAINT employment_status_values CHECK ((employment_status = ANY (ARRAY['Resigned'::text, 'Job (With Finger)'::text, 'Vacation'::text, 'Terminated'::text, 'Run Away'::text, 'Remote Job'::text, 'Job (No Finger)'::text])))
);



--
-- Name: COLUMN hr_employee_master.bank_name; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.hr_employee_master.bank_name IS 'Name of the bank where employee has account';


--
-- Name: COLUMN hr_employee_master.iban; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.hr_employee_master.iban IS 'International Bank Account Number';


--
-- Name: COLUMN hr_employee_master.contract_expiry_date; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.hr_employee_master.contract_expiry_date IS 'Employment contract expiry date';


--
-- Name: COLUMN hr_employee_master.contract_document_url; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.hr_employee_master.contract_document_url IS 'URL to the uploaded contract document';


--
-- Name: COLUMN hr_employee_master.sponsorship_status; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.hr_employee_master.sponsorship_status IS 'Employee sponsorship status - true if active, false if inactive';


--
-- Name: COLUMN hr_employee_master.employment_status_effective_date; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.hr_employee_master.employment_status_effective_date IS 'Effective date for employment status changes (Resigned, Terminated, Run Away)';


--
-- Name: COLUMN hr_employee_master.employment_status_reason; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.hr_employee_master.employment_status_reason IS 'Reason for employment status change';


--
-- Name: hr_employees; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.hr_employees (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    employee_id character varying(20) NOT NULL,
    branch_id bigint NOT NULL,
    hire_date date,
    status character varying(20) DEFAULT 'active'::character varying,
    created_at timestamp with time zone DEFAULT now(),
    name character varying(200) NOT NULL,
    updated_at timestamp with time zone DEFAULT now()
);



--
-- Name: TABLE hr_employees; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.hr_employees IS 'HR Employees - Upload function with Employee ID and Name only. Branch assigned from UI, Hire Date updated later.';


--
-- Name: hr_fingerprint_transactions; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.hr_fingerprint_transactions (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    employee_id character varying(20) NOT NULL,
    name character varying(200),
    branch_id bigint NOT NULL,
    date date NOT NULL,
    "time" time without time zone NOT NULL,
    status character varying(20) NOT NULL,
    device_id character varying(50),
    created_at timestamp with time zone DEFAULT now(),
    location text,
    processed boolean DEFAULT false,
    CONSTRAINT chk_hr_fingerprint_punch CHECK (((status)::text = ANY (ARRAY[('Check In'::character varying)::text, ('Check Out'::character varying)::text, ('Break In'::character varying)::text, ('Break Out'::character varying)::text, ('Overtime In'::character varying)::text, ('Overtime Out'::character varying)::text])))
);



--
-- Name: TABLE hr_fingerprint_transactions; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.hr_fingerprint_transactions IS 'HR Fingerprint Transactions - Excel upload with numeric employee_id and name matching hr_employees table';


--
-- Name: hr_insurance_companies; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.hr_insurance_companies (
    id character varying(15) NOT NULL,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);



--
-- Name: hr_insurance_company_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.hr_insurance_company_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: hr_levels; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.hr_levels (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    level_name_en character varying(100) NOT NULL,
    level_name_ar character varying(100) NOT NULL,
    level_order integer NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);



--
-- Name: TABLE hr_levels; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.hr_levels IS 'HR Levels - minimal schema for Create Level function';


--
-- Name: hr_position_assignments; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.hr_position_assignments (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    employee_id uuid NOT NULL,
    position_id uuid NOT NULL,
    department_id uuid NOT NULL,
    level_id uuid NOT NULL,
    branch_id bigint NOT NULL,
    effective_date date DEFAULT CURRENT_DATE NOT NULL,
    is_current boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);



--
-- Name: TABLE hr_position_assignments; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.hr_position_assignments IS 'HR Position Assignments - minimal schema for Assign Positions function';


--
-- Name: hr_position_reporting_template; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.hr_position_reporting_template (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    subordinate_position_id uuid NOT NULL,
    manager_position_1 uuid,
    manager_position_2 uuid,
    manager_position_3 uuid,
    manager_position_4 uuid,
    manager_position_5 uuid,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT chk_no_self_report_1 CHECK ((subordinate_position_id <> manager_position_1)),
    CONSTRAINT chk_no_self_report_2 CHECK ((subordinate_position_id <> manager_position_2)),
    CONSTRAINT chk_no_self_report_3 CHECK ((subordinate_position_id <> manager_position_3)),
    CONSTRAINT chk_no_self_report_4 CHECK ((subordinate_position_id <> manager_position_4)),
    CONSTRAINT chk_no_self_report_5 CHECK ((subordinate_position_id <> manager_position_5))
);



--
-- Name: TABLE hr_position_reporting_template; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.hr_position_reporting_template IS 'HR Position Reporting Template - Each position can report to up to 5 different manager positions (Slots 1-5)';


--
-- Name: hr_positions; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.hr_positions (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    position_title_en character varying(100) NOT NULL,
    position_title_ar character varying(100) NOT NULL,
    department_id uuid NOT NULL,
    level_id uuid NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);



--
-- Name: TABLE hr_positions; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.hr_positions IS 'HR Positions - minimal schema for Create Position function';


--
-- Name: incident_actions_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.incident_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: incident_actions; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.incident_actions (
    id text DEFAULT ('ACT'::text || nextval('public.incident_actions_id_seq'::regclass)) NOT NULL,
    action_type text NOT NULL,
    recourse_type text,
    action_report jsonb,
    has_fine boolean DEFAULT false,
    fine_amount numeric(10,2) DEFAULT 0,
    fine_threat_amount numeric(10,2) DEFAULT 0,
    is_paid boolean DEFAULT false,
    paid_at timestamp with time zone,
    paid_by text,
    employee_id text NOT NULL,
    incident_id text NOT NULL,
    incident_type_id text,
    created_by text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT incident_actions_action_type_check CHECK ((action_type = ANY (ARRAY['warning'::text, 'investigation'::text, 'termination'::text, 'other'::text]))),
    CONSTRAINT incident_actions_recourse_type_check CHECK ((recourse_type = ANY (ARRAY['warning'::text, 'warning_fine'::text, 'warning_fine_threat'::text, 'warning_fine_termination_threat'::text, 'termination'::text])))
);



--
-- Name: TABLE incident_actions; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.incident_actions IS 'Tracks all actions taken on incidents including warnings, fines, and their payment status';


--
-- Name: COLUMN incident_actions.id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.incident_actions.id IS 'Auto-generated ID in format ACT1, ACT2, etc.';


--
-- Name: COLUMN incident_actions.action_type; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.incident_actions.action_type IS 'Type of action: warning, investigation, termination, other';


--
-- Name: COLUMN incident_actions.recourse_type; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.incident_actions.recourse_type IS 'Type of recourse for warnings';


--
-- Name: COLUMN incident_actions.action_report; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.incident_actions.action_report IS 'Full action/warning report as JSONB';


--
-- Name: COLUMN incident_actions.has_fine; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.incident_actions.has_fine IS 'Whether this action includes a fine';


--
-- Name: COLUMN incident_actions.fine_amount; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.incident_actions.fine_amount IS 'Fine amount if applicable';


--
-- Name: COLUMN incident_actions.fine_threat_amount; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.incident_actions.fine_threat_amount IS 'Threatened fine amount for warning_fine_threat type';


--
-- Name: COLUMN incident_actions.is_paid; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.incident_actions.is_paid IS 'Whether the fine has been paid';


--
-- Name: COLUMN incident_actions.paid_at; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.incident_actions.paid_at IS 'When the fine was paid';


--
-- Name: COLUMN incident_actions.paid_by; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.incident_actions.paid_by IS 'User ID who marked the fine as paid';


--
-- Name: incident_types; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.incident_types (
    id text NOT NULL,
    incident_type_en text NOT NULL,
    incident_type_ar text NOT NULL,
    description_en text,
    description_ar text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);



--
-- Name: TABLE incident_types; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.incident_types IS 'Stores the types of incidents that can be reported in the system';


--
-- Name: COLUMN incident_types.id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.incident_types.id IS 'Unique identifier for incident type (IN1, IN2, etc.)';


--
-- Name: COLUMN incident_types.incident_type_en; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.incident_types.incident_type_en IS 'English name of the incident type';


--
-- Name: COLUMN incident_types.incident_type_ar; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.incident_types.incident_type_ar IS 'Arabic name of the incident type';


--
-- Name: incidents; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.incidents (
    id text NOT NULL,
    incident_type_id text NOT NULL,
    employee_id text,
    branch_id bigint NOT NULL,
    violation_id text,
    what_happened jsonb NOT NULL,
    witness_details jsonb,
    report_type text DEFAULT 'employee_related'::text NOT NULL,
    reports_to_user_ids uuid[] DEFAULT ARRAY[]::uuid[] NOT NULL,
    claims_status text,
    claimed_user_id uuid,
    resolution_status public.resolution_status DEFAULT 'reported'::public.resolution_status NOT NULL,
    user_statuses jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    attachments jsonb DEFAULT '[]'::jsonb,
    investigation_report jsonb,
    related_party jsonb,
    resolution_report jsonb
);



--
-- Name: TABLE incidents; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.incidents IS 'Stores incident reports submitted by employees and other incident types';


--
-- Name: COLUMN incidents.id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.incidents.id IS 'Unique identifier for incident (INS1, INS2, etc.)';


--
-- Name: COLUMN incidents.incident_type_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.incidents.incident_type_id IS 'Type of incident (references incident_types table)';


--
-- Name: COLUMN incidents.employee_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.incidents.employee_id IS 'Employee ID - NULL for non-employee incidents (Customer, Maintenance, Vendor, Vehicle, Government, Other)';


--
-- Name: COLUMN incidents.branch_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.incidents.branch_id IS 'Branch where incident occurred';


--
-- Name: COLUMN incidents.violation_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.incidents.violation_id IS 'Violation ID - NULL for non-employee incidents';


--
-- Name: COLUMN incidents.what_happened; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.incidents.what_happened IS 'JSONB: Detailed description of what happened';


--
-- Name: COLUMN incidents.witness_details; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.incidents.witness_details IS 'JSONB: Information about witnesses';


--
-- Name: COLUMN incidents.report_type; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.incidents.report_type IS 'Type of report (e.g., employee_related)';


--
-- Name: COLUMN incidents.reports_to_user_ids; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.incidents.reports_to_user_ids IS 'Array of user IDs who should receive this incident report';


--
-- Name: COLUMN incidents.claims_status; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.incidents.claims_status IS 'Status of claims related to the incident';


--
-- Name: COLUMN incidents.claimed_user_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.incidents.claimed_user_id IS 'User ID of person who claimed the incident';


--
-- Name: COLUMN incidents.resolution_status; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.incidents.resolution_status IS 'Status: reported, claimed, or resolved';


--
-- Name: COLUMN incidents.user_statuses; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.incidents.user_statuses IS 'JSONB: Individual status for each user in reports_to_user_ids';


--
-- Name: COLUMN incidents.attachments; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.incidents.attachments IS 'JSONB array of attachments: [{url, name, type, size, uploaded_at}, ...]';


--
-- Name: COLUMN incidents.investigation_report; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.incidents.investigation_report IS 'Stores investigation report details as JSON';


--
-- Name: COLUMN incidents.related_party; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.incidents.related_party IS 'Stores related party details as JSONB. For customer incidents: {name, contact_number}. For other incidents: {details}';


--
-- Name: COLUMN incidents.resolution_report; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.incidents.resolution_report IS 'Stores resolution report as JSONB with content, resolved_by, resolved_by_name, and resolved_at';


--
-- Name: interface_permissions; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.interface_permissions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    desktop_enabled boolean DEFAULT true NOT NULL,
    mobile_enabled boolean DEFAULT true NOT NULL,
    customer_enabled boolean DEFAULT false NOT NULL,
    updated_by uuid NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    cashier_enabled boolean DEFAULT false
);



--
-- Name: TABLE interface_permissions; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.interface_permissions IS 'User access permissions for different application interfaces';


--
-- Name: COLUMN interface_permissions.desktop_enabled; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.interface_permissions.desktop_enabled IS 'Whether user can access desktop interface';


--
-- Name: COLUMN interface_permissions.mobile_enabled; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.interface_permissions.mobile_enabled IS 'Whether user can access mobile interface';


--
-- Name: COLUMN interface_permissions.customer_enabled; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.interface_permissions.customer_enabled IS 'Whether user can access customer interface';


--
-- Name: COLUMN interface_permissions.cashier_enabled; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.interface_permissions.cashier_enabled IS 'Controls access to the cashier/POS application';


--
-- Name: lease_rent_lease_parties; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.lease_rent_lease_parties (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    property_id uuid NOT NULL,
    property_space_id uuid,
    party_name_en character varying(255) NOT NULL,
    party_name_ar character varying(255) NOT NULL,
    shop_name character varying(255),
    contract_start_date date,
    contract_end_date date,
    lease_amount_contract numeric(12,2) DEFAULT 0,
    lease_amount_outside_contract numeric(12,2) DEFAULT 0,
    utility_charges numeric(12,2) DEFAULT 0,
    security_charges numeric(12,2) DEFAULT 0,
    other_charges jsonb DEFAULT '[]'::jsonb,
    payment_mode character varying(20) DEFAULT 'cash'::character varying,
    collection_incharge_id text,
    payment_period character varying(30) DEFAULT 'monthly'::character varying,
    payment_specific_date integer,
    payment_end_of_month boolean DEFAULT false,
    created_by uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    is_open_contract boolean DEFAULT false,
    contact_number character varying(50),
    email character varying(255)
);



--
-- Name: lease_rent_payment_entries; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.lease_rent_payment_entries (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    party_type character varying(10) NOT NULL,
    party_id uuid NOT NULL,
    period_num integer NOT NULL,
    column_name character varying(20) NOT NULL,
    amount numeric(12,2) NOT NULL,
    paid_date date DEFAULT CURRENT_DATE NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    created_by uuid
);



--
-- Name: lease_rent_payments; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.lease_rent_payments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    party_type character varying(10) NOT NULL,
    party_id uuid NOT NULL,
    period_num integer NOT NULL,
    period_from date NOT NULL,
    period_to date NOT NULL,
    total_amount numeric(12,2) DEFAULT 0 NOT NULL,
    paid_amount numeric(12,2) DEFAULT 0 NOT NULL,
    is_fully_paid boolean DEFAULT false NOT NULL,
    paid_at timestamp with time zone DEFAULT now(),
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid,
    paid_contract numeric(12,2) DEFAULT 0,
    paid_outside numeric(12,2) DEFAULT 0,
    paid_utility numeric(12,2) DEFAULT 0,
    paid_security numeric(12,2) DEFAULT 0,
    paid_other numeric(12,2) DEFAULT 0,
    paid_date date,
    CONSTRAINT lease_rent_payments_party_type_check CHECK (((party_type)::text = ANY ((ARRAY['rent'::character varying, 'lease'::character varying])::text[])))
);



--
-- Name: lease_rent_properties; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.lease_rent_properties (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    location_en character varying(500),
    location_ar character varying(500),
    is_leased boolean DEFAULT false,
    is_rented boolean DEFAULT false,
    created_by uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);



--
-- Name: lease_rent_property_spaces; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.lease_rent_property_spaces (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    property_id uuid NOT NULL,
    space_number character varying(100) NOT NULL,
    created_by uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);



--
-- Name: lease_rent_rent_parties; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.lease_rent_rent_parties (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    property_id uuid NOT NULL,
    property_space_id uuid,
    party_name_en character varying(255) NOT NULL,
    party_name_ar character varying(255) NOT NULL,
    shop_name character varying(255),
    contract_start_date date,
    contract_end_date date,
    rent_amount_contract numeric(12,2) DEFAULT 0,
    rent_amount_outside_contract numeric(12,2) DEFAULT 0,
    utility_charges numeric(12,2) DEFAULT 0,
    security_charges numeric(12,2) DEFAULT 0,
    other_charges jsonb DEFAULT '[]'::jsonb,
    payment_mode character varying(20) DEFAULT 'cash'::character varying,
    collection_incharge_id text,
    payment_period character varying(30) DEFAULT 'monthly'::character varying,
    payment_specific_date integer,
    payment_end_of_month boolean DEFAULT false,
    created_by uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    is_open_contract boolean DEFAULT false,
    contact_number character varying(50),
    email character varying(255)
);



--
-- Name: lease_rent_special_changes; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.lease_rent_special_changes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    party_type character varying(10) NOT NULL,
    party_id uuid NOT NULL,
    field_name character varying(50) NOT NULL,
    old_value numeric(12,2) DEFAULT 0,
    new_value numeric(12,2) NOT NULL,
    effective_from date NOT NULL,
    effective_until date,
    till_end_of_contract boolean DEFAULT false,
    payment_period character varying(20) DEFAULT 'monthly'::character varying,
    reason text,
    created_at timestamp with time zone DEFAULT now(),
    created_by uuid,
    CONSTRAINT lease_rent_special_changes_party_type_check CHECK (((party_type)::text = ANY ((ARRAY['rent'::character varying, 'lease'::character varying])::text[])))
);



--
-- Name: mobile_themes; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.mobile_themes (
    id bigint NOT NULL,
    name text NOT NULL,
    description text,
    is_default boolean DEFAULT false,
    colors jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid
);



--
-- Name: mobile_themes_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.mobile_themes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: mobile_themes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.mobile_themes_id_seq OWNED BY public.mobile_themes.id;


--
-- Name: multi_shift_date_wise; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.multi_shift_date_wise (
    id integer NOT NULL,
    employee_id text NOT NULL,
    date_from date NOT NULL,
    date_to date NOT NULL,
    shift_start_time time without time zone DEFAULT '09:00:00'::time without time zone NOT NULL,
    shift_start_buffer numeric(4,2) DEFAULT 0 NOT NULL,
    shift_end_time time without time zone DEFAULT '17:00:00'::time without time zone NOT NULL,
    shift_end_buffer numeric(4,2) DEFAULT 0 NOT NULL,
    is_shift_overlapping_next_day boolean DEFAULT false NOT NULL,
    working_hours numeric(5,2) DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT multi_shift_date_wise_date_check CHECK ((date_from <= date_to))
);



--
-- Name: multi_shift_date_wise_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.multi_shift_date_wise_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: multi_shift_date_wise_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.multi_shift_date_wise_id_seq OWNED BY public.multi_shift_date_wise.id;


--
-- Name: multi_shift_regular; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.multi_shift_regular (
    id integer NOT NULL,
    employee_id text NOT NULL,
    shift_start_time time without time zone DEFAULT '09:00:00'::time without time zone NOT NULL,
    shift_start_buffer numeric(4,2) DEFAULT 0 NOT NULL,
    shift_end_time time without time zone DEFAULT '17:00:00'::time without time zone NOT NULL,
    shift_end_buffer numeric(4,2) DEFAULT 0 NOT NULL,
    is_shift_overlapping_next_day boolean DEFAULT false NOT NULL,
    working_hours numeric(5,2) DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);



--
-- Name: multi_shift_regular_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.multi_shift_regular_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: multi_shift_regular_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.multi_shift_regular_id_seq OWNED BY public.multi_shift_regular.id;


--
-- Name: multi_shift_weekday; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.multi_shift_weekday (
    id integer NOT NULL,
    employee_id text NOT NULL,
    weekday integer NOT NULL,
    shift_start_time time without time zone DEFAULT '09:00:00'::time without time zone NOT NULL,
    shift_start_buffer numeric(4,2) DEFAULT 0 NOT NULL,
    shift_end_time time without time zone DEFAULT '17:00:00'::time without time zone NOT NULL,
    shift_end_buffer numeric(4,2) DEFAULT 0 NOT NULL,
    is_shift_overlapping_next_day boolean DEFAULT false NOT NULL,
    working_hours numeric(5,2) DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT multi_shift_weekday_weekday_check CHECK (((weekday >= 0) AND (weekday <= 6)))
);



--
-- Name: multi_shift_weekday_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.multi_shift_weekday_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: multi_shift_weekday_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.multi_shift_weekday_id_seq OWNED BY public.multi_shift_weekday.id;


--
-- Name: mv_expiry_products; Type: MATERIALIZED VIEW; Schema: public; Owner: supabase_admin
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



--
-- Name: nationalities; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.nationalities (
    id character varying(10) NOT NULL,
    name_en character varying(100) NOT NULL,
    name_ar character varying(100) NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);



--
-- Name: near_expiry_reports; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.near_expiry_reports (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    reporter_user_id uuid NOT NULL,
    branch_id integer,
    target_user_id uuid,
    status text DEFAULT 'pending'::text NOT NULL,
    items jsonb DEFAULT '[]'::jsonb NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    title text,
    CONSTRAINT near_expiry_reports_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'reviewed'::text, 'resolved'::text, 'dismissed'::text])))
);



--
-- Name: non_approved_payment_scheduler; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.non_approved_payment_scheduler (
    id bigint NOT NULL,
    schedule_type text NOT NULL,
    branch_id bigint NOT NULL,
    branch_name text NOT NULL,
    expense_category_id bigint NOT NULL,
    expense_category_name_en text,
    expense_category_name_ar text,
    co_user_id uuid,
    co_user_name text,
    bill_type text,
    bill_number text,
    bill_date date,
    payment_method text,
    due_date date,
    credit_period integer,
    amount numeric NOT NULL,
    bill_file_url text,
    bank_name text,
    iban text,
    description text,
    notes text,
    recurring_type text,
    recurring_metadata jsonb,
    approver_id uuid NOT NULL,
    approver_name text NOT NULL,
    approval_status text DEFAULT 'pending'::text,
    approved_at timestamp with time zone,
    approved_by uuid,
    rejection_reason text,
    expense_scheduler_id bigint,
    created_by uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_by uuid,
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT check_non_approved_approval_status CHECK ((approval_status = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text]))),
    CONSTRAINT check_non_approved_co_user_for_non_recurring CHECK (((schedule_type = 'recurring'::text) OR ((schedule_type = ANY (ARRAY['single_bill'::text, 'multiple_bill'::text])) AND (co_user_id IS NOT NULL) AND (co_user_name IS NOT NULL)))),
    CONSTRAINT check_non_approved_recurring_type CHECK (((recurring_type IS NULL) OR (recurring_type = ANY (ARRAY['daily'::text, 'weekly'::text, 'monthly_date'::text, 'monthly_day'::text, 'yearly'::text, 'half_yearly'::text, 'quarterly'::text, 'custom'::text])))),
    CONSTRAINT check_non_approved_schedule_type CHECK ((schedule_type = ANY (ARRAY['single_bill'::text, 'multiple_bill'::text, 'recurring'::text])))
);



--
-- Name: TABLE non_approved_payment_scheduler; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.non_approved_payment_scheduler IS 'Stores payment schedules that require approval before being posted to expense_scheduler';


--
-- Name: COLUMN non_approved_payment_scheduler.schedule_type; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.non_approved_payment_scheduler.schedule_type IS 'Type of schedule: single_bill, multiple_bill, or recurring';


--
-- Name: COLUMN non_approved_payment_scheduler.approval_status; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.non_approved_payment_scheduler.approval_status IS 'Approval status: pending, approved, rejected';


--
-- Name: COLUMN non_approved_payment_scheduler.expense_scheduler_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.non_approved_payment_scheduler.expense_scheduler_id IS 'Links to expense_scheduler after approval';


--
-- Name: non_approved_payment_scheduler_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.non_approved_payment_scheduler_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: non_approved_payment_scheduler_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.non_approved_payment_scheduler_id_seq OWNED BY public.non_approved_payment_scheduler.id;


--
-- Name: notification_attachments; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.notification_attachments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    notification_id uuid NOT NULL,
    file_name character varying(255) NOT NULL,
    file_path text NOT NULL,
    file_size bigint NOT NULL,
    file_type character varying(100) NOT NULL,
    uploaded_by character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);



--
-- Name: notification_read_states; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.notification_read_states (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    notification_id uuid NOT NULL,
    user_id text NOT NULL,
    read_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    is_read boolean DEFAULT false NOT NULL
);



--
-- Name: COLUMN notification_read_states.is_read; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.notification_read_states.is_read IS 'Whether the notification has been read by the user';


--
-- Name: notification_recipients; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.notification_recipients (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    notification_id uuid NOT NULL,
    role character varying(100),
    branch_id character varying(255),
    is_read boolean DEFAULT false NOT NULL,
    read_at timestamp with time zone,
    is_dismissed boolean DEFAULT false NOT NULL,
    dismissed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    delivery_status character varying(20) DEFAULT 'pending'::character varying,
    delivery_attempted_at timestamp with time zone,
    error_message text,
    user_id uuid
);



--
-- Name: notifications; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.notifications (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title character varying(255) NOT NULL,
    message text NOT NULL,
    created_by character varying(255) DEFAULT 'system'::character varying NOT NULL,
    created_by_name character varying(100) DEFAULT 'System'::character varying NOT NULL,
    created_by_role character varying(50) DEFAULT 'Admin'::character varying NOT NULL,
    target_users jsonb,
    target_roles jsonb,
    target_branches jsonb,
    scheduled_for timestamp with time zone,
    sent_at timestamp with time zone DEFAULT now(),
    expires_at timestamp with time zone,
    has_attachments boolean DEFAULT false NOT NULL,
    read_count integer DEFAULT 0 NOT NULL,
    total_recipients integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    metadata jsonb,
    task_id uuid,
    task_assignment_id uuid,
    priority character varying(20) DEFAULT 'medium'::character varying NOT NULL,
    status character varying(20) DEFAULT 'published'::character varying NOT NULL,
    target_type character varying(50) DEFAULT 'all_users'::character varying NOT NULL,
    type character varying(50) DEFAULT 'info'::character varying NOT NULL
);



--
-- Name: TABLE notifications; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.notifications IS 'Cache refresh timestamp: 2025-10-04 11:00:23.237041+00';


--
-- Name: COLUMN notifications.task_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.notifications.task_id IS 'Reference to the task this notification is about';


--
-- Name: COLUMN notifications.task_assignment_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.notifications.task_assignment_id IS 'Reference to the task assignment this notification is about';


--
-- Name: offer_bundles; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.offer_bundles (
    id integer NOT NULL,
    offer_id integer NOT NULL,
    bundle_name_ar character varying(255) NOT NULL,
    bundle_name_en character varying(255) NOT NULL,
    required_products jsonb NOT NULL,
    discount_value numeric(10,2) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    discount_type character varying(20) DEFAULT 'amount'::character varying,
    CONSTRAINT offer_bundles_discount_amount_check CHECK ((discount_value > (0)::numeric)),
    CONSTRAINT offer_bundles_discount_type_check CHECK (((discount_type)::text = ANY (ARRAY[('percentage'::character varying)::text, ('amount'::character varying)::text]))),
    CONSTRAINT offer_bundles_discount_value_check CHECK ((discount_value > (0)::numeric))
);



--
-- Name: TABLE offer_bundles; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.offer_bundles IS 'Bundle offer configurations with multiple products';


--
-- Name: offer_bundles_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.offer_bundles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: offer_bundles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.offer_bundles_id_seq OWNED BY public.offer_bundles.id;


--
-- Name: offer_cart_tiers; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.offer_cart_tiers (
    id integer NOT NULL,
    offer_id integer NOT NULL,
    tier_number integer NOT NULL,
    min_amount numeric(10,2) NOT NULL,
    max_amount numeric(10,2),
    discount_type character varying(20) NOT NULL,
    discount_value numeric(10,2) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT offer_cart_tiers_check CHECK (((max_amount IS NULL) OR (max_amount > min_amount))),
    CONSTRAINT offer_cart_tiers_discount_type_check CHECK (((discount_type)::text = ANY (ARRAY[('percentage'::character varying)::text, ('fixed'::character varying)::text]))),
    CONSTRAINT offer_cart_tiers_discount_value_check CHECK ((discount_value >= (0)::numeric)),
    CONSTRAINT offer_cart_tiers_min_amount_check CHECK ((min_amount >= (0)::numeric)),
    CONSTRAINT offer_cart_tiers_tier_number_check CHECK (((tier_number >= 1) AND (tier_number <= 6)))
);



--
-- Name: offer_cart_tiers_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.offer_cart_tiers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: offer_cart_tiers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.offer_cart_tiers_id_seq OWNED BY public.offer_cart_tiers.id;


--
-- Name: offer_names; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.offer_names (
    id text NOT NULL,
    name_en text NOT NULL,
    name_ar text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);



--
-- Name: TABLE offer_names; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.offer_names IS 'Predefined offer name templates';


--
-- Name: offer_products; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.offer_products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    offer_id integer NOT NULL,
    product_id character varying(50) NOT NULL,
    offer_qty integer DEFAULT 1 NOT NULL,
    offer_percentage numeric(5,2),
    offer_price numeric(10,2),
    max_uses integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    is_part_of_variation_group boolean DEFAULT false NOT NULL,
    variation_group_id uuid,
    variation_parent_barcode text,
    added_by uuid,
    added_at timestamp with time zone DEFAULT now(),
    CONSTRAINT at_least_one_discount CHECK (((offer_percentage IS NOT NULL) OR (offer_price IS NOT NULL))),
    CONSTRAINT valid_offer_price CHECK (((offer_price IS NULL) OR (offer_price >= (0)::numeric))),
    CONSTRAINT valid_offer_qty CHECK ((offer_qty > 0)),
    CONSTRAINT valid_percentage CHECK (((offer_percentage IS NULL) OR ((offer_percentage >= (0)::numeric) AND (offer_percentage <= (100)::numeric))))
);



--
-- Name: TABLE offer_products; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.offer_products IS 'Stores individual products in product discount offers with percentage or special price';


--
-- Name: COLUMN offer_products.offer_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.offer_products.offer_id IS 'Reference to parent offer';


--
-- Name: COLUMN offer_products.product_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.offer_products.product_id IS 'Reference to product';


--
-- Name: COLUMN offer_products.offer_qty; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.offer_products.offer_qty IS 'Quantity required for offer (e.g., 2 for "2 pieces for 39.95")';


--
-- Name: COLUMN offer_products.offer_percentage; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.offer_products.offer_percentage IS 'Percentage discount (e.g., 20.00 for 20% off) - NULL for special price offers';


--
-- Name: COLUMN offer_products.offer_price; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.offer_products.offer_price IS 'Special price for offer quantity (e.g., 39.95 for 2 pieces) - NULL for percentage offers';


--
-- Name: COLUMN offer_products.max_uses; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.offer_products.max_uses IS 'Maximum uses per product (NULL = unlimited)';


--
-- Name: COLUMN offer_products.is_part_of_variation_group; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.offer_products.is_part_of_variation_group IS 'Flag indicating if this product belongs to a variation group within the offer';


--
-- Name: COLUMN offer_products.variation_group_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.offer_products.variation_group_id IS 'UUID linking all variations in the same group within an offer';


--
-- Name: COLUMN offer_products.variation_parent_barcode; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.offer_products.variation_parent_barcode IS 'Quick reference to the parent product barcode';


--
-- Name: COLUMN offer_products.added_by; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.offer_products.added_by IS 'User who added this variation to the offer';


--
-- Name: COLUMN offer_products.added_at; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.offer_products.added_at IS 'Timestamp when this variation was added to the offer';


--
-- Name: CONSTRAINT at_least_one_discount ON offer_products; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON CONSTRAINT at_least_one_discount ON public.offer_products IS 'Ensures at least one discount field is set. Both can be set for percentage offers (stores calculated price).';


--
-- Name: offer_usage_logs; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.offer_usage_logs (
    id integer NOT NULL,
    offer_id integer NOT NULL,
    customer_id uuid,
    order_id uuid,
    discount_applied numeric(10,2) NOT NULL,
    original_amount numeric(10,2) NOT NULL,
    final_amount numeric(10,2) NOT NULL,
    cart_items jsonb,
    used_at timestamp with time zone DEFAULT now(),
    session_id character varying(255) DEFAULT NULL::character varying,
    device_type character varying(50) DEFAULT NULL::character varying
);



--
-- Name: TABLE offer_usage_logs; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.offer_usage_logs IS 'Comprehensive logging of all offer applications';


--
-- Name: COLUMN offer_usage_logs.order_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.offer_usage_logs.order_id IS 'Links offer usage to the order where it was applied (NULL for non-order usage)';


--
-- Name: offer_usage_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.offer_usage_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: offer_usage_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.offer_usage_logs_id_seq OWNED BY public.offer_usage_logs.id;


--
-- Name: offers; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.offers (
    id integer NOT NULL,
    type character varying(20) NOT NULL,
    name_ar character varying(255) NOT NULL,
    name_en character varying(255) NOT NULL,
    description_ar text,
    description_en text,
    start_date timestamp with time zone DEFAULT now() NOT NULL,
    end_date timestamp with time zone NOT NULL,
    is_active boolean DEFAULT true,
    max_uses_per_customer integer,
    max_total_uses integer,
    current_total_uses integer DEFAULT 0,
    branch_id integer,
    service_type character varying(20) DEFAULT 'both'::character varying,
    show_on_product_page boolean DEFAULT true,
    show_in_carousel boolean DEFAULT false,
    send_push_notification boolean DEFAULT false,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT offers_service_type_check CHECK (((service_type)::text = ANY (ARRAY[('delivery'::character varying)::text, ('pickup'::character varying)::text, ('both'::character varying)::text]))),
    CONSTRAINT offers_type_check CHECK (((type)::text = ANY (ARRAY[('bundle'::character varying)::text, ('cart'::character varying)::text, ('product'::character varying)::text, ('bogo'::character varying)::text]))),
    CONSTRAINT valid_date_range CHECK ((end_date > start_date))
);



--
-- Name: TABLE offers; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.offers IS 'Main offers table with all offer configurations and rules';


--
-- Name: offers_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.offers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: offers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.offers_id_seq OWNED BY public.offers.id;


--
-- Name: official_holidays; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.official_holidays (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    holiday_date date NOT NULL,
    name_en text DEFAULT ''::text NOT NULL,
    name_ar text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);



--
-- Name: order_audit_logs; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.order_audit_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid NOT NULL,
    action_type character varying(50) NOT NULL,
    from_status character varying(50),
    to_status character varying(50),
    performed_by uuid,
    performed_by_name character varying(255),
    performed_by_role character varying(50),
    assigned_user_id uuid,
    assigned_user_name character varying(255),
    assignment_type character varying(50),
    field_name character varying(100),
    old_value text,
    new_value text,
    notes text,
    ip_address inet,
    user_agent text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);

ALTER TABLE ONLY public.order_audit_logs REPLICA IDENTITY FULL;



--
-- Name: TABLE order_audit_logs; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.order_audit_logs IS 'Audit trail for all order changes and actions';


--
-- Name: COLUMN order_audit_logs.action_type; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.order_audit_logs.action_type IS 'Type of action: created, status_changed, assigned_picker, assigned_delivery, cancelled, etc.';


--
-- Name: COLUMN order_audit_logs.from_status; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.order_audit_logs.from_status IS 'Previous order status (for status_changed actions)';


--
-- Name: COLUMN order_audit_logs.to_status; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.order_audit_logs.to_status IS 'New order status (for status_changed actions)';


--
-- Name: COLUMN order_audit_logs.performed_by; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.order_audit_logs.performed_by IS 'User who performed the action';


--
-- Name: COLUMN order_audit_logs.assigned_user_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.order_audit_logs.assigned_user_id IS 'User who was assigned (for assignment actions)';


--
-- Name: COLUMN order_audit_logs.assignment_type; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.order_audit_logs.assignment_type IS 'Type of assignment: picker or delivery';


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.order_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid NOT NULL,
    product_id character varying(50) NOT NULL,
    product_name_ar character varying(255) NOT NULL,
    product_name_en character varying(255) NOT NULL,
    product_sku character varying(100),
    unit_id character varying(50),
    unit_name_ar character varying(100),
    unit_name_en character varying(100),
    unit_size character varying(50),
    quantity integer NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    original_price numeric(10,2) NOT NULL,
    discount_amount numeric(10,2) DEFAULT 0 NOT NULL,
    final_price numeric(10,2) NOT NULL,
    line_total numeric(10,2) NOT NULL,
    has_offer boolean DEFAULT false NOT NULL,
    offer_id integer,
    offer_name_ar character varying(255),
    offer_name_en character varying(255),
    offer_type character varying(50),
    offer_discount_percentage numeric(5,2),
    offer_special_price numeric(10,2),
    item_type character varying(20) DEFAULT 'regular'::character varying NOT NULL,
    bundle_id uuid,
    bundle_name_ar character varying(255),
    bundle_name_en character varying(255),
    is_bundle_item boolean DEFAULT false NOT NULL,
    is_bogo_free boolean DEFAULT false NOT NULL,
    bogo_group_id uuid,
    tax_rate numeric(5,2) DEFAULT 0 NOT NULL,
    tax_amount numeric(10,2) DEFAULT 0 NOT NULL,
    item_notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);

ALTER TABLE ONLY public.order_items REPLICA IDENTITY FULL;



--
-- Name: TABLE order_items; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.order_items IS 'Individual line items within customer orders';


--
-- Name: COLUMN order_items.product_name_ar; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.order_items.product_name_ar IS 'Product name snapshot in Arabic at time of order';


--
-- Name: COLUMN order_items.product_name_en; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.order_items.product_name_en IS 'Product name snapshot in English at time of order';


--
-- Name: COLUMN order_items.unit_price; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.order_items.unit_price IS 'Price per unit at time of order';


--
-- Name: COLUMN order_items.final_price; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.order_items.final_price IS 'Price after applying discounts/offers';


--
-- Name: COLUMN order_items.line_total; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.order_items.line_total IS 'Total for this line (final_price * quantity)';


--
-- Name: COLUMN order_items.item_type; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.order_items.item_type IS 'Type of item: regular, bundle_item, bogo_free, bogo_discounted';


--
-- Name: COLUMN order_items.bundle_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.order_items.bundle_id IS 'Groups items that belong to the same bundle purchase';


--
-- Name: COLUMN order_items.bogo_group_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.order_items.bogo_group_id IS 'Groups items involved in the same BOGO offer';


--
-- Name: orders; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_number character varying(50) NOT NULL,
    customer_id uuid NOT NULL,
    customer_name character varying(255) NOT NULL,
    customer_phone character varying(20) NOT NULL,
    customer_whatsapp character varying(20),
    branch_id bigint NOT NULL,
    selected_location jsonb,
    order_status character varying(50) DEFAULT 'new'::character varying NOT NULL,
    fulfillment_method character varying(20) DEFAULT 'delivery'::character varying NOT NULL,
    subtotal_amount numeric(10,2) DEFAULT 0 NOT NULL,
    delivery_fee numeric(10,2) DEFAULT 0 NOT NULL,
    discount_amount numeric(10,2) DEFAULT 0 NOT NULL,
    tax_amount numeric(10,2) DEFAULT 0 NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    payment_method character varying(20) NOT NULL,
    payment_status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    payment_reference character varying(100),
    total_items integer DEFAULT 0 NOT NULL,
    total_quantity integer DEFAULT 0 NOT NULL,
    picker_id uuid,
    picker_assigned_at timestamp with time zone,
    delivery_person_id uuid,
    delivery_assigned_at timestamp with time zone,
    accepted_at timestamp with time zone,
    ready_at timestamp with time zone,
    delivered_at timestamp with time zone,
    cancelled_at timestamp with time zone,
    cancelled_by uuid,
    cancellation_reason text,
    customer_notes text,
    admin_notes text,
    estimated_pickup_time timestamp with time zone,
    estimated_delivery_time timestamp with time zone,
    actual_pickup_time timestamp with time zone,
    actual_delivery_time timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    picked_up_at timestamp with time zone
);

ALTER TABLE ONLY public.orders REPLICA IDENTITY FULL;



--
-- Name: TABLE orders; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.orders IS 'Customer orders from mobile app';


--
-- Name: COLUMN orders.order_number; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.orders.order_number IS 'Unique order number displayed to customer (e.g., ORD-20251120-0001)';


--
-- Name: COLUMN orders.selected_location; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.orders.selected_location IS 'Customer delivery location snapshot from their saved locations';


--
-- Name: COLUMN orders.order_status; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.orders.order_status IS 'Order workflow status: new, accepted, in_picking, ready, out_for_delivery, delivered, cancelled';


--
-- Name: COLUMN orders.fulfillment_method; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.orders.fulfillment_method IS 'How customer will receive order: delivery or pickup';


--
-- Name: COLUMN orders.payment_method; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.orders.payment_method IS 'Payment method: cash, card, online';


--
-- Name: COLUMN orders.payment_status; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.orders.payment_status IS 'Payment tracking: pending, paid, refunded';


--
-- Name: overtime_registrations; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.overtime_registrations (
    id text NOT NULL,
    employee_id text NOT NULL,
    overtime_date date NOT NULL,
    overtime_minutes integer DEFAULT 0 NOT NULL,
    worked_minutes integer DEFAULT 0,
    notes text,
    created_by text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);



--
-- Name: TABLE overtime_registrations; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.overtime_registrations IS 'Stores overtime registrations for employees who worked on holidays/day offs or worked beyond expected hours';


--
-- Name: pos_deduction_transfers; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.pos_deduction_transfers (
    id text NOT NULL,
    box_number integer NOT NULL,
    branch_id integer NOT NULL,
    cashier_user_id text NOT NULL,
    closed_by uuid,
    short_amount numeric(10,2) DEFAULT 0 NOT NULL,
    status public.pos_deduction_status DEFAULT 'Proposed'::public.pos_deduction_status NOT NULL,
    date_created_box timestamp with time zone NOT NULL,
    date_closed_box timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    completed_by_name character varying(255),
    box_operation_id uuid NOT NULL,
    applied boolean DEFAULT false
);



--
-- Name: TABLE pos_deduction_transfers; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.pos_deduction_transfers IS 'Stores POS deduction transfer records when cashier has shortage more than 5';


--
-- Name: privilege_cards_branch; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.privilege_cards_branch (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    privilege_card_id integer NOT NULL,
    card_number character varying(50) NOT NULL,
    branch_id integer NOT NULL,
    card_balance numeric(10,4) DEFAULT 0,
    card_holder_name character varying(255),
    total_redemptions numeric(10,4) DEFAULT 0,
    redemption_count integer DEFAULT 0,
    expiry_date date,
    mobile character varying(20),
    last_sync_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);



--
-- Name: privilege_cards_master; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.privilege_cards_master (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    card_number character varying(50) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);



--
-- Name: processed_fingerprint_transactions; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.processed_fingerprint_transactions (
    id text NOT NULL,
    center_id text NOT NULL,
    employee_id text NOT NULL,
    branch_id text NOT NULL,
    punch_date date NOT NULL,
    punch_time time without time zone NOT NULL,
    status text,
    processed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);



--
-- Name: processed_fingerprint_transactions_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.processed_fingerprint_transactions_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: product_categories; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.product_categories (
    id character varying(10) NOT NULL,
    name_en character varying(100) NOT NULL,
    name_ar character varying(100) NOT NULL,
    display_order integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    image_url text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid
);



--
-- Name: product_request_bt; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.product_request_bt (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    requester_user_id uuid NOT NULL,
    from_branch_id integer NOT NULL,
    to_branch_id integer NOT NULL,
    target_user_id uuid NOT NULL,
    status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    items jsonb DEFAULT '[]'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    document_url text
);



--
-- Name: product_request_po; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.product_request_po (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    requester_user_id uuid NOT NULL,
    from_branch_id integer NOT NULL,
    target_user_id uuid NOT NULL,
    status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    items jsonb DEFAULT '[]'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    document_url text
);



--
-- Name: product_request_st; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.product_request_st (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    requester_user_id uuid NOT NULL,
    branch_id integer NOT NULL,
    target_user_id uuid NOT NULL,
    status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    items jsonb DEFAULT '[]'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    document_url text
);



--
-- Name: product_units; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.product_units (
    id character varying(10) NOT NULL,
    name_en character varying(50) NOT NULL,
    name_ar character varying(50) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid
);



--
-- Name: products; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.products (
    id character varying(10) NOT NULL,
    barcode text NOT NULL,
    product_name_en text,
    product_name_ar text,
    image_url text,
    category_id character varying(10),
    unit_id character varying(10),
    unit_qty numeric DEFAULT 1 NOT NULL,
    sale_price numeric DEFAULT 0 NOT NULL,
    cost numeric DEFAULT 0 NOT NULL,
    profit numeric DEFAULT 0 NOT NULL,
    profit_percentage numeric DEFAULT 0 NOT NULL,
    current_stock integer DEFAULT 0 NOT NULL,
    minim_qty integer DEFAULT 0 NOT NULL,
    minimum_qty_alert integer DEFAULT 0 NOT NULL,
    maximum_qty integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true,
    is_customer_product boolean DEFAULT true,
    is_variation boolean DEFAULT false NOT NULL,
    parent_product_barcode text,
    variation_group_name_en text,
    variation_group_name_ar text,
    variation_order integer DEFAULT 0,
    variation_image_override text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid,
    modified_by uuid,
    modified_at timestamp with time zone
);



--
-- Name: purchase_voucher_issue_types; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.purchase_voucher_issue_types (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    type_name character varying NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);



--
-- Name: purchase_voucher_items; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.purchase_voucher_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    purchase_voucher_id character varying NOT NULL,
    serial_number integer NOT NULL,
    value numeric NOT NULL,
    status character varying DEFAULT 'stocked'::character varying,
    issued_date timestamp with time zone,
    closed_date timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    stock integer DEFAULT 1,
    issue_type character varying DEFAULT 'not issued'::character varying,
    stock_location bigint,
    stock_person uuid,
    issued_to uuid,
    issued_by uuid,
    receipt_url text,
    issue_remarks text,
    close_remarks text,
    close_bill_number character varying,
    approval_status character varying,
    approver_id uuid,
    pending_stock_location bigint,
    pending_stock_person uuid
);



--
-- Name: purchase_vouchers; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.purchase_vouchers (
    id character varying NOT NULL,
    book_number character varying NOT NULL,
    serial_start integer NOT NULL,
    serial_end integer NOT NULL,
    voucher_count integer NOT NULL,
    per_voucher_value numeric NOT NULL,
    total_value numeric NOT NULL,
    status character varying DEFAULT 'active'::character varying,
    created_by uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);



--
-- Name: purchase_vouchers_book_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.purchase_vouchers_book_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: push_subscriptions; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.push_subscriptions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    subscription jsonb NOT NULL,
    endpoint text NOT NULL,
    user_agent text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone,
    failed_deliveries integer DEFAULT 0,
    is_active boolean DEFAULT true,
    customer_id uuid,
    CONSTRAINT chk_push_sub_user_or_customer CHECK (((user_id IS NOT NULL) OR (customer_id IS NOT NULL)))
);



--
-- Name: TABLE push_subscriptions; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.push_subscriptions IS 'Stores web push notification subscriptions for users';


--
-- Name: COLUMN push_subscriptions.subscription; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.push_subscriptions.subscription IS 'Full PushSubscription object in JSON format';


--
-- Name: COLUMN push_subscriptions.endpoint; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.push_subscriptions.endpoint IS 'Push service endpoint URL for deduplication';


--
-- Name: COLUMN push_subscriptions.failed_deliveries; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.push_subscriptions.failed_deliveries IS 'Count of consecutive failed push attempts';


--
-- Name: COLUMN push_subscriptions.is_active; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.push_subscriptions.is_active IS 'Whether this subscription is active and should receive pushes';


--
-- Name: quick_task_assignments; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.quick_task_assignments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    quick_task_id uuid NOT NULL,
    assigned_to_user_id uuid NOT NULL,
    status character varying(50) DEFAULT 'pending'::character varying,
    accepted_at timestamp with time zone,
    started_at timestamp with time zone,
    completed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    require_task_finished boolean DEFAULT true,
    require_photo_upload boolean DEFAULT true,
    require_erp_reference boolean DEFAULT false,
    CONSTRAINT chk_require_task_finished_not_null CHECK ((require_task_finished IS NOT NULL))
);



--
-- Name: COLUMN quick_task_assignments.require_task_finished; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.quick_task_assignments.require_task_finished IS 'Whether task completion checkbox is required';


--
-- Name: COLUMN quick_task_assignments.require_photo_upload; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.quick_task_assignments.require_photo_upload IS 'Whether photo upload is required for task completion';


--
-- Name: COLUMN quick_task_assignments.require_erp_reference; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.quick_task_assignments.require_erp_reference IS 'Whether ERP reference number is required for task completion';


--
-- Name: quick_task_comments; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.quick_task_comments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    quick_task_id uuid NOT NULL,
    comment text NOT NULL,
    comment_type character varying(50) DEFAULT 'comment'::character varying,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now()
);



--
-- Name: quick_task_completions; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.quick_task_completions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    quick_task_id uuid NOT NULL,
    assignment_id uuid NOT NULL,
    completed_by_user_id uuid NOT NULL,
    completion_notes text,
    photo_path text,
    erp_reference character varying(255),
    completion_status character varying(50) DEFAULT 'submitted'::character varying NOT NULL,
    verified_by_user_id uuid,
    verified_at timestamp with time zone,
    verification_notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_completion_status_valid CHECK (((completion_status)::text = ANY (ARRAY[('submitted'::character varying)::text, ('verified'::character varying)::text, ('rejected'::character varying)::text, ('pending_review'::character varying)::text]))),
    CONSTRAINT chk_verified_at_when_verified CHECK (((((completion_status)::text <> 'verified'::text) AND (verified_at IS NULL)) OR (((completion_status)::text = 'verified'::text) AND (verified_at IS NOT NULL))))
);



--
-- Name: TABLE quick_task_completions; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.quick_task_completions IS 'Completion records for quick tasks with photos and verification';


--
-- Name: COLUMN quick_task_completions.id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.quick_task_completions.id IS 'Unique identifier for the completion record';


--
-- Name: COLUMN quick_task_completions.quick_task_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.quick_task_completions.quick_task_id IS 'Reference to the quick task that was completed';


--
-- Name: COLUMN quick_task_completions.assignment_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.quick_task_completions.assignment_id IS 'Reference to the specific assignment that was completed';


--
-- Name: COLUMN quick_task_completions.completed_by_user_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.quick_task_completions.completed_by_user_id IS 'User who completed the task';


--
-- Name: COLUMN quick_task_completions.completion_notes; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.quick_task_completions.completion_notes IS 'Notes provided by the user upon completion';


--
-- Name: COLUMN quick_task_completions.photo_path; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.quick_task_completions.photo_path IS 'Path to the completion photo in storage';


--
-- Name: COLUMN quick_task_completions.erp_reference; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.quick_task_completions.erp_reference IS 'ERP system reference number if required';


--
-- Name: COLUMN quick_task_completions.completion_status; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.quick_task_completions.completion_status IS 'Status of the completion record';


--
-- Name: COLUMN quick_task_completions.verified_by_user_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.quick_task_completions.verified_by_user_id IS 'User who verified the completion';


--
-- Name: COLUMN quick_task_completions.verified_at; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.quick_task_completions.verified_at IS 'When the completion was verified';


--
-- Name: COLUMN quick_task_completions.verification_notes; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.quick_task_completions.verification_notes IS 'Notes from the verifier';


--
-- Name: quick_tasks; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.quick_tasks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    price_tag character varying(50),
    issue_type character varying(100) NOT NULL,
    priority character varying(50) NOT NULL,
    assigned_by uuid NOT NULL,
    assigned_to_branch_id bigint,
    created_at timestamp with time zone DEFAULT now(),
    deadline_datetime timestamp with time zone DEFAULT (now() + '24:00:00'::interval),
    completed_at timestamp with time zone,
    status character varying(50) DEFAULT 'pending'::character varying,
    created_from character varying(50) DEFAULT 'quick_task'::character varying,
    updated_at timestamp with time zone DEFAULT now(),
    require_task_finished boolean DEFAULT true,
    require_photo_upload boolean DEFAULT false,
    require_erp_reference boolean DEFAULT false,
    incident_id text,
    product_request_id uuid,
    product_request_type character varying(5),
    order_id uuid,
    CONSTRAINT chk_require_task_finished_not_null CHECK ((require_task_finished IS NOT NULL))
);



--
-- Name: COLUMN quick_tasks.require_task_finished; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.quick_tasks.require_task_finished IS 'Default requirement for task completion (always required)';


--
-- Name: COLUMN quick_tasks.require_photo_upload; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.quick_tasks.require_photo_upload IS 'Default requirement for photo upload on task completion';


--
-- Name: COLUMN quick_tasks.require_erp_reference; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.quick_tasks.require_erp_reference IS 'Default requirement for ERP reference on task completion';


--
-- Name: COLUMN quick_tasks.incident_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.quick_tasks.incident_id IS 'Reference to the incident that triggered this quick task';


--
-- Name: COLUMN quick_tasks.product_request_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.quick_tasks.product_request_id IS 'Reference to the product request that triggered this quick task';


--
-- Name: COLUMN quick_tasks.product_request_type; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.quick_tasks.product_request_type IS 'Type of product request: PO, ST, or BT';


--
-- Name: users; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.users (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    username character varying(50) NOT NULL,
    password_hash character varying(255) NOT NULL,
    salt character varying(100) NOT NULL,
    quick_access_code character varying(255) NOT NULL,
    quick_access_salt character varying(100) NOT NULL,
    user_type public.user_type_enum DEFAULT 'branch_specific'::public.user_type_enum NOT NULL,
    employee_id uuid,
    branch_id bigint,
    position_id uuid,
    avatar text,
    avatar_small_url text,
    avatar_medium_url text,
    avatar_large_url text,
    is_first_login boolean DEFAULT true,
    failed_login_attempts integer DEFAULT 0,
    locked_at timestamp with time zone,
    locked_by uuid,
    last_login_at timestamp with time zone,
    password_expires_at timestamp with time zone,
    last_password_change timestamp with time zone DEFAULT now(),
    created_by bigint,
    updated_by bigint,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    status character varying(20) DEFAULT 'active'::character varying NOT NULL,
    ai_translation_enabled boolean DEFAULT false NOT NULL,
    is_master_admin boolean DEFAULT false,
    is_admin boolean DEFAULT false,
    CONSTRAINT users_employee_branch_check CHECK (((user_type = 'global'::public.user_type_enum) OR ((user_type = 'branch_specific'::public.user_type_enum) AND (branch_id IS NOT NULL))))
);



--
-- Name: COLUMN users.ai_translation_enabled; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.users.ai_translation_enabled IS 'Whether AI translation is enabled for this user - controls access to AI translation features in mobile interface';


--
-- Name: quick_task_completion_details; Type: VIEW; Schema: public; Owner: supabase_admin
--

DROP VIEW IF EXISTS public.quick_task_completion_details CASCADE;
CREATE VIEW public.quick_task_completion_details AS
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



--
-- Name: quick_task_files; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.quick_task_files (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    quick_task_id uuid NOT NULL,
    file_name character varying(255) NOT NULL,
    file_type character varying(100),
    file_size integer,
    mime_type character varying(100),
    storage_path text NOT NULL,
    storage_bucket character varying(100) DEFAULT 'quick-task-files'::character varying,
    uploaded_by uuid,
    uploaded_at timestamp with time zone DEFAULT now()
);



--
-- Name: quick_task_files_with_details; Type: VIEW; Schema: public; Owner: supabase_admin
--

DROP VIEW IF EXISTS public.quick_task_files_with_details CASCADE;
CREATE VIEW public.quick_task_files_with_details AS
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



--
-- Name: quick_task_user_preferences; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.quick_task_user_preferences (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    default_branch_id bigint,
    default_price_tag character varying(50),
    default_issue_type character varying(100),
    default_priority character varying(50),
    selected_user_ids uuid[],
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);



--
-- Name: quick_tasks_with_details; Type: VIEW; Schema: public; Owner: supabase_admin
--

DROP VIEW IF EXISTS public.quick_tasks_with_details CASCADE;
CREATE VIEW public.quick_tasks_with_details AS
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



--
-- Name: receiving_records; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.receiving_records (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    branch_id integer NOT NULL,
    vendor_id integer NOT NULL,
    bill_date date NOT NULL,
    bill_amount numeric(15,2) NOT NULL,
    bill_number character varying(100),
    payment_method character varying(100),
    credit_period integer,
    due_date date,
    bank_name character varying(200),
    iban character varying(50),
    vendor_vat_number character varying(50),
    bill_vat_number character varying(50),
    vat_numbers_match boolean,
    vat_mismatch_reason text,
    branch_manager_user_id uuid,
    shelf_stocker_user_ids uuid[] DEFAULT '{}'::uuid[],
    accountant_user_id uuid,
    purchasing_manager_user_id uuid,
    expired_return_amount numeric(12,2) DEFAULT 0,
    near_expiry_return_amount numeric(12,2) DEFAULT 0,
    over_stock_return_amount numeric(12,2) DEFAULT 0,
    damage_return_amount numeric(12,2) DEFAULT 0,
    total_return_amount numeric(12,2) DEFAULT 0,
    final_bill_amount numeric(12,2) DEFAULT 0,
    expired_erp_document_type character varying(10),
    expired_erp_document_number character varying(100),
    expired_vendor_document_number character varying(100),
    near_expiry_erp_document_type character varying(10),
    near_expiry_erp_document_number character varying(100),
    near_expiry_vendor_document_number character varying(100),
    over_stock_erp_document_type character varying(10),
    over_stock_erp_document_number character varying(100),
    over_stock_vendor_document_number character varying(100),
    damage_erp_document_type character varying(10),
    damage_erp_document_number character varying(100),
    damage_vendor_document_number character varying(100),
    has_expired_returns boolean DEFAULT false,
    has_near_expiry_returns boolean DEFAULT false,
    has_over_stock_returns boolean DEFAULT false,
    has_damage_returns boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    inventory_manager_user_id uuid,
    night_supervisor_user_ids uuid[] DEFAULT '{}'::uuid[],
    warehouse_handler_user_ids uuid[] DEFAULT '{}'::uuid[],
    certificate_url text,
    certificate_generated_at timestamp with time zone,
    certificate_file_name text,
    original_bill_url text,
    erp_purchase_invoice_reference character varying(255),
    updated_at timestamp with time zone DEFAULT now(),
    pr_excel_file_url text,
    erp_purchase_invoice_uploaded boolean DEFAULT false,
    pr_excel_file_uploaded boolean DEFAULT false,
    original_bill_uploaded boolean DEFAULT false,
    CONSTRAINT check_credit_period_positive CHECK (((credit_period IS NULL) OR (credit_period >= 0))),
    CONSTRAINT check_damage_return_amount CHECK ((damage_return_amount >= (0)::numeric)),
    CONSTRAINT check_due_date_after_bill_date CHECK (((due_date IS NULL) OR (bill_date IS NULL) OR (due_date >= bill_date))),
    CONSTRAINT check_expired_return_amount CHECK ((expired_return_amount >= (0)::numeric)),
    CONSTRAINT check_final_bill_amount CHECK ((final_bill_amount >= (0)::numeric)),
    CONSTRAINT check_near_expiry_return_amount CHECK ((near_expiry_return_amount >= (0)::numeric)),
    CONSTRAINT check_over_stock_return_amount CHECK ((over_stock_return_amount >= (0)::numeric)),
    CONSTRAINT check_return_not_exceed_bill CHECK ((total_return_amount <= bill_amount)),
    CONSTRAINT check_total_return_amount CHECK ((total_return_amount >= (0)::numeric)),
    CONSTRAINT check_vat_mismatch_reason CHECK (((vat_numbers_match IS NULL) OR (vat_numbers_match = true) OR ((vat_numbers_match = false) AND (vat_mismatch_reason IS NOT NULL) AND (length(TRIM(BOTH FROM vat_mismatch_reason)) > 0))))
);



--
-- Name: TABLE receiving_records; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.receiving_records IS 'Receiving records with bill information and return processing';


--
-- Name: COLUMN receiving_records.user_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.user_id IS 'User who performed the receiving';


--
-- Name: COLUMN receiving_records.branch_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.branch_id IS 'Branch where receiving was performed';


--
-- Name: COLUMN receiving_records.vendor_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.vendor_id IS 'Vendor from whom goods were received';


--
-- Name: COLUMN receiving_records.bill_date; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.bill_date IS 'Date entered from the physical bill';


--
-- Name: COLUMN receiving_records.bill_amount; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.bill_amount IS 'Total amount from the bill';


--
-- Name: COLUMN receiving_records.bill_number; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.bill_number IS 'Bill number from the physical bill';


--
-- Name: COLUMN receiving_records.payment_method; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.payment_method IS 'Payment method for this receiving (can differ from vendor default)';


--
-- Name: COLUMN receiving_records.credit_period; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.credit_period IS 'Credit period in days for this receiving (can differ from vendor default)';


--
-- Name: COLUMN receiving_records.due_date; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.due_date IS 'Calculated due date (bill date + credit period) for credit payment methods';


--
-- Name: COLUMN receiving_records.bank_name; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.bank_name IS 'Bank name for this receiving (can differ from vendor default)';


--
-- Name: COLUMN receiving_records.iban; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.iban IS 'IBAN for this receiving (can differ from vendor default)';


--
-- Name: COLUMN receiving_records.vendor_vat_number; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.vendor_vat_number IS 'VAT number from vendor record at time of receiving';


--
-- Name: COLUMN receiving_records.bill_vat_number; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.bill_vat_number IS 'VAT number entered from the physical bill';


--
-- Name: COLUMN receiving_records.vat_numbers_match; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.vat_numbers_match IS 'Whether vendor and bill VAT numbers match';


--
-- Name: COLUMN receiving_records.vat_mismatch_reason; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.vat_mismatch_reason IS 'Reason provided when VAT numbers do not match';


--
-- Name: COLUMN receiving_records.branch_manager_user_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.branch_manager_user_id IS 'Selected branch manager or responsible user for this receiving';


--
-- Name: COLUMN receiving_records.shelf_stocker_user_ids; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.shelf_stocker_user_ids IS 'Array of user IDs selected as shelf stockers for this receiving';


--
-- Name: COLUMN receiving_records.accountant_user_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.accountant_user_id IS 'Selected accountant or responsible user for accounting tasks';


--
-- Name: COLUMN receiving_records.purchasing_manager_user_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.purchasing_manager_user_id IS 'Selected purchasing manager or responsible user for purchasing oversight';


--
-- Name: COLUMN receiving_records.expired_return_amount; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.expired_return_amount IS 'Amount returned for expired items';


--
-- Name: COLUMN receiving_records.near_expiry_return_amount; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.near_expiry_return_amount IS 'Amount returned for near expiry items';


--
-- Name: COLUMN receiving_records.over_stock_return_amount; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.over_stock_return_amount IS 'Amount returned for over stock items';


--
-- Name: COLUMN receiving_records.damage_return_amount; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.damage_return_amount IS 'Amount returned for damaged items';


--
-- Name: COLUMN receiving_records.total_return_amount; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.total_return_amount IS 'Total amount of all returns (auto-calculated)';


--
-- Name: COLUMN receiving_records.final_bill_amount; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.final_bill_amount IS 'Final bill amount after deducting returns (auto-calculated)';


--
-- Name: COLUMN receiving_records.expired_erp_document_type; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.expired_erp_document_type IS 'ERP document type for expired returns (GRN, PR)';


--
-- Name: COLUMN receiving_records.expired_erp_document_number; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.expired_erp_document_number IS 'ERP document number for expired returns';


--
-- Name: COLUMN receiving_records.expired_vendor_document_number; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.expired_vendor_document_number IS 'Vendor document number for expired returns';


--
-- Name: COLUMN receiving_records.near_expiry_erp_document_type; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.near_expiry_erp_document_type IS 'ERP document type for near expiry returns (GRN, PR)';


--
-- Name: COLUMN receiving_records.near_expiry_erp_document_number; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.near_expiry_erp_document_number IS 'ERP document number for near expiry returns';


--
-- Name: COLUMN receiving_records.near_expiry_vendor_document_number; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.near_expiry_vendor_document_number IS 'Vendor document number for near expiry returns';


--
-- Name: COLUMN receiving_records.over_stock_erp_document_type; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.over_stock_erp_document_type IS 'ERP document type for over stock returns (GRN, PR)';


--
-- Name: COLUMN receiving_records.over_stock_erp_document_number; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.over_stock_erp_document_number IS 'ERP document number for over stock returns';


--
-- Name: COLUMN receiving_records.over_stock_vendor_document_number; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.over_stock_vendor_document_number IS 'Vendor document number for over stock returns';


--
-- Name: COLUMN receiving_records.damage_erp_document_type; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.damage_erp_document_type IS 'ERP document type for damage returns (GRN, PR)';


--
-- Name: COLUMN receiving_records.damage_erp_document_number; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.damage_erp_document_number IS 'ERP document number for damage returns';


--
-- Name: COLUMN receiving_records.damage_vendor_document_number; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.damage_vendor_document_number IS 'Vendor document number for damage returns';


--
-- Name: COLUMN receiving_records.has_expired_returns; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.has_expired_returns IS 'Whether expired returns were processed';


--
-- Name: COLUMN receiving_records.has_near_expiry_returns; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.has_near_expiry_returns IS 'Whether near expiry returns were processed';


--
-- Name: COLUMN receiving_records.has_over_stock_returns; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.has_over_stock_returns IS 'Whether over stock returns were processed';


--
-- Name: COLUMN receiving_records.has_damage_returns; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.has_damage_returns IS 'Whether damage returns were processed';


--
-- Name: COLUMN receiving_records.created_at; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.created_at IS 'When this receiving record was created in system';


--
-- Name: COLUMN receiving_records.inventory_manager_user_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.inventory_manager_user_id IS 'Single user responsible for inventory management for this receiving';


--
-- Name: COLUMN receiving_records.night_supervisor_user_ids; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.night_supervisor_user_ids IS 'Array of user IDs for night supervisors assigned to this receiving';


--
-- Name: COLUMN receiving_records.warehouse_handler_user_ids; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.warehouse_handler_user_ids IS 'Array of user IDs for warehouse and stock handlers assigned to this receiving';


--
-- Name: COLUMN receiving_records.certificate_url; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.certificate_url IS 'Public URL to the generated clearance certificate image';


--
-- Name: COLUMN receiving_records.certificate_generated_at; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.certificate_generated_at IS 'Timestamp when certificate was generated and saved';


--
-- Name: COLUMN receiving_records.certificate_file_name; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.certificate_file_name IS 'Original filename of the certificate in storage';


--
-- Name: COLUMN receiving_records.original_bill_url; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.original_bill_url IS 'URL to uploaded original bill document (PDF, image, etc.)';


--
-- Name: COLUMN receiving_records.erp_purchase_invoice_reference; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.erp_purchase_invoice_reference IS 'ERP purchase invoice reference number entered by inventory manager when completing receiving task';


--
-- Name: COLUMN receiving_records.updated_at; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.updated_at IS 'Timestamp when the record was last updated';


--
-- Name: COLUMN receiving_records.pr_excel_file_url; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.pr_excel_file_url IS 'URL link to uploaded PR Excel file stored in Supabase Storage';


--
-- Name: COLUMN receiving_records.erp_purchase_invoice_uploaded; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.erp_purchase_invoice_uploaded IS 'Boolean flag indicating if ERP purchase invoice reference has been entered by Inventory Manager';


--
-- Name: COLUMN receiving_records.pr_excel_file_uploaded; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.pr_excel_file_uploaded IS 'Boolean flag indicating if PR Excel file has been uploaded by Inventory Manager';


--
-- Name: COLUMN receiving_records.original_bill_uploaded; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_records.original_bill_uploaded IS 'Boolean flag indicating if original bill has been uploaded by Inventory Manager';


--
-- Name: vendors; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.vendors (
    erp_vendor_id integer NOT NULL,
    vendor_name text NOT NULL,
    salesman_name text,
    salesman_contact text,
    supervisor_name text,
    supervisor_contact text,
    vendor_contact_number text,
    payment_method text,
    credit_period integer,
    bank_name text,
    iban text,
    status text DEFAULT 'Active'::text,
    last_visit timestamp without time zone,
    categories text[],
    delivery_modes text[],
    place text,
    location_link text,
    return_expired_products text,
    return_expired_products_note text,
    return_near_expiry_products text,
    return_near_expiry_products_note text,
    return_over_stock text,
    return_over_stock_note text,
    return_damage_products text,
    return_damage_products_note text,
    no_return boolean DEFAULT false,
    no_return_note text,
    vat_applicable text DEFAULT 'VAT Applicable'::text,
    vat_number text,
    no_vat_note text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    branch_id bigint NOT NULL,
    payment_priority text DEFAULT 'Normal'::text,
    CONSTRAINT vendors_payment_priority_check CHECK ((payment_priority = ANY (ARRAY['Most'::text, 'Medium'::text, 'Normal'::text, 'Low'::text])))
);



--
-- Name: TABLE vendors; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.vendors IS 'Vendor management table with support for multiple payment methods, return policies, and VAT information';


--
-- Name: COLUMN vendors.payment_method; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendors.payment_method IS 'Comma-separated list of payment methods: Cash on Delivery, Bank on Delivery, Cash Credit, Bank Credit';


--
-- Name: COLUMN vendors.credit_period; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendors.credit_period IS 'Credit period in days for credit-based payment methods';


--
-- Name: COLUMN vendors.bank_name; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendors.bank_name IS 'Bank name for bank-related payment methods';


--
-- Name: COLUMN vendors.iban; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendors.iban IS 'International Bank Account Number for bank transfers';


--
-- Name: COLUMN vendors.no_return; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendors.no_return IS 'When TRUE, vendor does not accept any returns regardless of other return policy settings';


--
-- Name: COLUMN vendors.vat_applicable; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendors.vat_applicable IS 'VAT applicability status for the vendor';


--
-- Name: COLUMN vendors.vat_number; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendors.vat_number IS 'VAT registration number when VAT is applicable';


--
-- Name: COLUMN vendors.branch_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendors.branch_id IS 'Branch ID that this vendor belongs to - makes vendor management branch-wise';


--
-- Name: COLUMN vendors.payment_priority; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendors.payment_priority IS 'Payment priority level: Most, Medium, Normal (default), Low';


--
-- Name: receiving_records_pr_excel_status; Type: VIEW; Schema: public; Owner: supabase_admin
--

DROP VIEW IF EXISTS public.receiving_records_pr_excel_status CASCADE;
CREATE VIEW public.receiving_records_pr_excel_status AS
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



--
-- Name: VIEW receiving_records_pr_excel_status; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON VIEW public.receiving_records_pr_excel_status IS 'Simple view showing only PR Excel upload status for receiving records';


--
-- Name: receiving_task_templates; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.receiving_task_templates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    role_type character varying(50) NOT NULL,
    title_template text NOT NULL,
    description_template text NOT NULL,
    require_erp_reference boolean DEFAULT false NOT NULL,
    require_original_bill_upload boolean DEFAULT false NOT NULL,
    require_task_finished_mark boolean DEFAULT true NOT NULL,
    priority character varying(20) DEFAULT 'high'::character varying NOT NULL,
    deadline_hours integer DEFAULT 24 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    depends_on_role_types text[] DEFAULT '{}'::text[],
    require_photo_upload boolean DEFAULT false,
    CONSTRAINT receiving_task_templates_deadline_hours_check CHECK (((deadline_hours > 0) AND (deadline_hours <= 168))),
    CONSTRAINT receiving_task_templates_priority_check CHECK (((priority)::text = ANY (ARRAY[('low'::character varying)::text, ('medium'::character varying)::text, ('high'::character varying)::text, ('urgent'::character varying)::text]))),
    CONSTRAINT receiving_task_templates_role_type_check CHECK (((role_type)::text = ANY (ARRAY[('branch_manager'::character varying)::text, ('purchase_manager'::character varying)::text, ('inventory_manager'::character varying)::text, ('night_supervisor'::character varying)::text, ('warehouse_handler'::character varying)::text, ('shelf_stocker'::character varying)::text, ('accountant'::character varying)::text])))
);



--
-- Name: TABLE receiving_task_templates; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.receiving_task_templates IS 'Reusable task templates for receiving workflow. Each role has one template.';


--
-- Name: COLUMN receiving_task_templates.role_type; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_task_templates.role_type IS 'Role type: branch_manager, purchase_manager, inventory_manager, night_supervisor, warehouse_handler, shelf_stocker, accountant';


--
-- Name: COLUMN receiving_task_templates.title_template; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_task_templates.title_template IS 'Task title template. Use {placeholders} for dynamic content.';


--
-- Name: COLUMN receiving_task_templates.description_template; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_task_templates.description_template IS 'Task description template. Use {placeholders} for branch, vendor, bill details.';


--
-- Name: COLUMN receiving_task_templates.depends_on_role_types; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_task_templates.depends_on_role_types IS 'Array of role types that must complete their tasks before this role can complete theirs';


--
-- Name: COLUMN receiving_task_templates.require_photo_upload; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_task_templates.require_photo_upload IS 'Whether this role must upload a completion photo';


--
-- Name: receiving_tasks; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.receiving_tasks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    receiving_record_id uuid NOT NULL,
    role_type character varying(50) NOT NULL,
    assigned_user_id uuid,
    requires_erp_reference boolean DEFAULT false,
    requires_original_bill_upload boolean DEFAULT false,
    requires_reassignment boolean DEFAULT false,
    requires_task_finished_mark boolean DEFAULT true,
    erp_reference_number character varying(255),
    original_bill_uploaded boolean DEFAULT false,
    original_bill_file_path text,
    task_completed boolean DEFAULT false,
    completed_at timestamp with time zone,
    clearance_certificate_url text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    template_id uuid,
    task_status character varying(50) DEFAULT 'pending'::character varying NOT NULL,
    title text,
    description text,
    priority character varying(20) DEFAULT 'high'::character varying,
    due_date timestamp with time zone,
    completed_by_user_id uuid,
    completion_photo_url text,
    completion_notes text,
    rule_effective_date timestamp with time zone,
    CONSTRAINT receiving_tasks_role_type_check CHECK (((role_type)::text = ANY (ARRAY[('branch_manager'::character varying)::text, ('purchase_manager'::character varying)::text, ('inventory_manager'::character varying)::text, ('night_supervisor'::character varying)::text, ('warehouse_handler'::character varying)::text, ('shelf_stocker'::character varying)::text, ('accountant'::character varying)::text]))),
    CONSTRAINT receiving_tasks_task_status_check CHECK (((task_status)::text = ANY (ARRAY[('pending'::character varying)::text, ('in_progress'::character varying)::text, ('completed'::character varying)::text, ('cancelled'::character varying)::text])))
);



--
-- Name: TABLE receiving_tasks; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.receiving_tasks IS 'Receiving-specific tasks with full separation from general task system. Links templates with receiving records.';


--
-- Name: COLUMN receiving_tasks.role_type; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_tasks.role_type IS 'Role type for this task: branch_manager, purchase_manager, inventory_manager, night_supervisor, warehouse_handler, shelf_stocker, accountant';


--
-- Name: COLUMN receiving_tasks.template_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_tasks.template_id IS 'Foreign key to receiving_task_templates. Defines the task type and role.';


--
-- Name: COLUMN receiving_tasks.task_status; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_tasks.task_status IS 'Current status: pending, in_progress, completed, cancelled';


--
-- Name: COLUMN receiving_tasks.completion_photo_url; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.receiving_tasks.completion_photo_url IS 'URL of completion photo uploaded by user (required for shelf_stocker role)';


--
-- Name: receiving_user_defaults; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.receiving_user_defaults (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    default_branch_id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);



--
-- Name: recurring_assignment_schedules; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.recurring_assignment_schedules (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    assignment_id uuid NOT NULL,
    repeat_type text NOT NULL,
    repeat_interval integer DEFAULT 1 NOT NULL,
    repeat_on_days integer[],
    repeat_on_date integer,
    repeat_on_month integer,
    execute_time time without time zone DEFAULT '09:00:00'::time without time zone NOT NULL,
    timezone text DEFAULT 'UTC'::text,
    start_date date NOT NULL,
    end_date date,
    max_occurrences integer,
    is_active boolean DEFAULT true,
    last_executed_at timestamp with time zone,
    next_execution_at timestamp with time zone NOT NULL,
    executions_count integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by text NOT NULL,
    CONSTRAINT chk_max_occurrences_positive CHECK (((max_occurrences IS NULL) OR (max_occurrences > 0))),
    CONSTRAINT chk_next_execution_after_start CHECK (((next_execution_at)::date >= start_date)),
    CONSTRAINT chk_repeat_interval_positive CHECK ((repeat_interval > 0)),
    CONSTRAINT chk_schedule_bounds CHECK (((end_date IS NULL) OR (end_date >= start_date))),
    CONSTRAINT recurring_assignment_schedules_repeat_type_check CHECK ((repeat_type = ANY (ARRAY['daily'::text, 'weekly'::text, 'monthly'::text, 'yearly'::text, 'custom'::text])))
);



--
-- Name: TABLE recurring_assignment_schedules; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.recurring_assignment_schedules IS 'Configuration for recurring task assignments with flexible scheduling';


--
-- Name: recurring_schedule_check_log; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.recurring_schedule_check_log (
    id integer NOT NULL,
    check_date date DEFAULT CURRENT_DATE NOT NULL,
    schedules_checked integer DEFAULT 0,
    notifications_sent integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now()
);



--
-- Name: TABLE recurring_schedule_check_log; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.recurring_schedule_check_log IS 'Log table for recurring schedule checks. 

To manually run the check, execute:
SELECT * FROM check_and_notify_recurring_schedules_with_logging();

To set up automatic daily execution:
1. Enable pg_cron extension in Supabase (may require contacting support)
2. Create cron job: 
   SELECT cron.schedule(''check-recurring-schedules'', ''0 6 * * *'', 
   $$SELECT check_and_notify_recurring_schedules_with_logging();$$);

Alternatively, use external cron service (GitHub Actions, Vercel Cron, etc.) to call:
POST https://your-project.supabase.co/rest/v1/rpc/check_and_notify_recurring_schedules_with_logging
';


--
-- Name: recurring_schedule_check_log_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.recurring_schedule_check_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: recurring_schedule_check_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.recurring_schedule_check_log_id_seq OWNED BY public.recurring_schedule_check_log.id;


--
-- Name: regular_shift; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.regular_shift (
    id text NOT NULL,
    shift_start_time time without time zone DEFAULT '09:00:00'::time without time zone NOT NULL,
    shift_start_buffer numeric(4,2) DEFAULT 0 NOT NULL,
    shift_end_time time without time zone DEFAULT '17:00:00'::time without time zone NOT NULL,
    shift_end_buffer numeric(4,2) DEFAULT 0 NOT NULL,
    is_shift_overlapping_next_day boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    working_hours numeric(5,2) DEFAULT 0
);



--
-- Name: requesters; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.requesters (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    requester_id character varying(50) NOT NULL,
    requester_name character varying(255) NOT NULL,
    contact_number character varying(20),
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    created_by uuid,
    updated_by uuid
);



--
-- Name: TABLE requesters; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.requesters IS 'Table to store requester information for expense requisitions';


--
-- Name: COLUMN requesters.requester_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.requesters.requester_id IS 'Unique identifier for the requester (employee ID or custom ID)';


--
-- Name: COLUMN requesters.requester_name; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.requesters.requester_name IS 'Full name of the requester';


--
-- Name: COLUMN requesters.contact_number; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.requesters.contact_number IS 'Contact number of the requester';


--
-- Name: security_code_scroll_texts; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.security_code_scroll_texts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    text_content text NOT NULL,
    sort_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    created_by uuid
);



--
-- Name: shelf_paper_fonts_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.shelf_paper_fonts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: shelf_paper_fonts; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.shelf_paper_fonts (
    name character varying(255) NOT NULL,
    font_url text NOT NULL,
    file_name character varying(255),
    file_size integer,
    created_by uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    id character varying(20) DEFAULT ('F'::text || (nextval('public.shelf_paper_fonts_id_seq'::regclass))::text) NOT NULL,
    original_file_name character varying(500)
);



--
-- Name: shelf_paper_templates; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.shelf_paper_templates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    description text,
    template_image_url text NOT NULL,
    field_configuration jsonb DEFAULT '[]'::jsonb NOT NULL,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    metadata jsonb
);



--
-- Name: TABLE shelf_paper_templates; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.shelf_paper_templates IS 'Stores shelf paper template designs with field configurations';


--
-- Name: COLUMN shelf_paper_templates.metadata; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.shelf_paper_templates.metadata IS 'Stores template metadata like preview dimensions used for field positioning';


--
-- Name: sidebar_buttons; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.sidebar_buttons (
    id bigint NOT NULL,
    main_section_id bigint NOT NULL,
    subsection_id bigint NOT NULL,
    button_name_en character varying(255) NOT NULL,
    button_name_ar character varying(255) NOT NULL,
    button_code character varying(100) NOT NULL,
    icon character varying(50),
    display_order integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);



--
-- Name: sidebar_buttons_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.sidebar_buttons ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.sidebar_buttons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: social_links; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.social_links (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    branch_id bigint NOT NULL,
    facebook text,
    whatsapp text,
    instagram text,
    tiktok text,
    snapchat text,
    website text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    location_link text,
    facebook_clicks bigint DEFAULT 0,
    whatsapp_clicks bigint DEFAULT 0,
    instagram_clicks bigint DEFAULT 0,
    tiktok_clicks bigint DEFAULT 0,
    snapchat_clicks bigint DEFAULT 0,
    website_clicks bigint DEFAULT 0,
    location_link_clicks bigint DEFAULT 0
);



--
-- Name: special_shift_date_wise; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.special_shift_date_wise (
    id text NOT NULL,
    employee_id text NOT NULL,
    shift_date date NOT NULL,
    shift_start_time time without time zone DEFAULT '09:00:00'::time without time zone NOT NULL,
    shift_start_buffer numeric(4,2) DEFAULT 0,
    shift_end_time time without time zone DEFAULT '17:00:00'::time without time zone NOT NULL,
    shift_end_buffer numeric(4,2) DEFAULT 0,
    is_shift_overlapping_next_day boolean DEFAULT false,
    working_hours numeric(5,2) DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);



--
-- Name: special_shift_weekday; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.special_shift_weekday (
    id text NOT NULL,
    employee_id text NOT NULL,
    weekday integer NOT NULL,
    shift_start_time time without time zone DEFAULT '09:00:00'::time without time zone NOT NULL,
    shift_start_buffer numeric(4,2) DEFAULT 0 NOT NULL,
    shift_end_time time without time zone DEFAULT '17:00:00'::time without time zone NOT NULL,
    shift_end_buffer numeric(4,2) DEFAULT 0 NOT NULL,
    is_shift_overlapping_next_day boolean DEFAULT false NOT NULL,
    working_hours numeric(5,2) DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT special_shift_weekday_weekday_check CHECK (((weekday >= 0) AND (weekday <= 6)))
);



--
-- Name: system_api_keys; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.system_api_keys (
    id integer NOT NULL,
    service_name character varying(100) NOT NULL,
    api_key text DEFAULT ''::text NOT NULL,
    description text DEFAULT ''::text,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);



--
-- Name: system_api_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.system_api_keys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: system_api_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.system_api_keys_id_seq OWNED BY public.system_api_keys.id;


--
-- Name: task_assignments; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.task_assignments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    task_id uuid NOT NULL,
    assignment_type text NOT NULL,
    assigned_to_user_id uuid,
    assigned_to_branch_id bigint,
    assigned_by uuid NOT NULL,
    assigned_by_name text,
    assigned_at timestamp with time zone DEFAULT now(),
    status text DEFAULT 'assigned'::text,
    started_at timestamp with time zone,
    completed_at timestamp with time zone,
    schedule_date date,
    schedule_time time without time zone,
    deadline_date date,
    deadline_time time without time zone,
    deadline_datetime timestamp with time zone,
    is_reassignable boolean DEFAULT true,
    is_recurring boolean DEFAULT false,
    recurring_pattern jsonb,
    notes text,
    priority_override text,
    require_task_finished boolean DEFAULT true,
    require_photo_upload boolean DEFAULT false,
    require_erp_reference boolean DEFAULT false,
    reassigned_from uuid,
    reassignment_reason text,
    reassigned_at timestamp with time zone,
    CONSTRAINT chk_deadline_consistency CHECK ((((deadline_date IS NULL) AND (deadline_time IS NULL)) OR (deadline_date IS NOT NULL))),
    CONSTRAINT chk_priority_override_valid CHECK (((priority_override IS NULL) OR (priority_override = ANY (ARRAY['low'::text, 'medium'::text, 'high'::text, 'urgent'::text])))),
    CONSTRAINT chk_schedule_consistency CHECK ((((schedule_date IS NULL) AND (schedule_time IS NULL)) OR (schedule_date IS NOT NULL)))
);



--
-- Name: TABLE task_assignments; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.task_assignments IS 'Task assignments to users, branches, or all';


--
-- Name: COLUMN task_assignments.schedule_date; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.task_assignments.schedule_date IS 'The date when the task should be started/executed';


--
-- Name: COLUMN task_assignments.schedule_time; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.task_assignments.schedule_time IS 'The time when the task should be started/executed';


--
-- Name: COLUMN task_assignments.deadline_date; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.task_assignments.deadline_date IS 'The date when the task must be completed';


--
-- Name: COLUMN task_assignments.deadline_time; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.task_assignments.deadline_time IS 'The time when the task must be completed';


--
-- Name: COLUMN task_assignments.deadline_datetime; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.task_assignments.deadline_datetime IS 'Computed timestamp combining deadline_date and deadline_time';


--
-- Name: COLUMN task_assignments.is_reassignable; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.task_assignments.is_reassignable IS 'Whether this assignment can be reassigned to another user';


--
-- Name: COLUMN task_assignments.is_recurring; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.task_assignments.is_recurring IS 'Whether this is a recurring assignment';


--
-- Name: COLUMN task_assignments.recurring_pattern; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.task_assignments.recurring_pattern IS 'JSON configuration for recurring patterns';


--
-- Name: COLUMN task_assignments.notes; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.task_assignments.notes IS 'Additional instructions or notes for the assignee';


--
-- Name: COLUMN task_assignments.priority_override; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.task_assignments.priority_override IS 'Override the task priority for this specific assignment';


--
-- Name: COLUMN task_assignments.require_task_finished; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.task_assignments.require_task_finished IS 'Whether task completion confirmation is required';


--
-- Name: COLUMN task_assignments.require_photo_upload; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.task_assignments.require_photo_upload IS 'Whether photo upload is required for completion';


--
-- Name: COLUMN task_assignments.require_erp_reference; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.task_assignments.require_erp_reference IS 'Whether ERP reference is required for completion';


--
-- Name: COLUMN task_assignments.reassigned_from; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.task_assignments.reassigned_from IS 'Reference to the original assignment if this is a reassignment';


--
-- Name: COLUMN task_assignments.reassignment_reason; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.task_assignments.reassignment_reason IS 'Reason for reassignment';


--
-- Name: task_images; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.task_images (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    task_id uuid NOT NULL,
    file_name text NOT NULL,
    file_size bigint NOT NULL,
    file_type text NOT NULL,
    file_url text NOT NULL,
    image_type text NOT NULL,
    uploaded_by text NOT NULL,
    uploaded_by_name text,
    created_at timestamp with time zone DEFAULT now(),
    image_width integer,
    image_height integer,
    file_path text,
    attachment_type text DEFAULT 'task_creation'::text,
    CONSTRAINT task_images_attachment_type_check CHECK ((attachment_type = ANY (ARRAY['task_creation'::text, 'task_completion'::text])))
);



--
-- Name: TABLE task_images; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.task_images IS 'Task creation images and completion photos';


--
-- Name: task_attachments; Type: VIEW; Schema: public; Owner: supabase_admin
--

DROP VIEW IF EXISTS public.task_attachments CASCADE;
CREATE VIEW public.task_attachments AS
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



--
-- Name: task_completions; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.task_completions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    task_id uuid NOT NULL,
    assignment_id uuid NOT NULL,
    completed_by text NOT NULL,
    completed_by_name text,
    completed_by_branch_id uuid,
    task_finished_completed boolean DEFAULT false,
    photo_uploaded_completed boolean DEFAULT false,
    erp_reference_completed boolean DEFAULT false,
    erp_reference_number text,
    completion_notes text,
    verified_by text,
    verified_at timestamp with time zone,
    verification_notes text,
    completed_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    completion_photo_url text,
    CONSTRAINT chk_photo_url_consistency CHECK (((photo_uploaded_completed = false) OR (completion_photo_url IS NOT NULL)))
);



--
-- Name: TABLE task_completions; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.task_completions IS 'Individual user task completion records';


--
-- Name: COLUMN task_completions.completion_photo_url; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.task_completions.completion_photo_url IS 'URL of the uploaded completion photo stored in completion-photos bucket';


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.tasks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    description text,
    require_task_finished boolean DEFAULT false,
    require_photo_upload boolean DEFAULT false,
    require_erp_reference boolean DEFAULT false,
    can_escalate boolean DEFAULT false,
    can_reassign boolean DEFAULT false,
    created_by text NOT NULL,
    created_by_name text,
    created_by_role text,
    status text DEFAULT 'draft'::text,
    priority text DEFAULT 'medium'::text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    due_date date,
    due_time time without time zone,
    due_datetime timestamp with time zone,
    search_vector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, ((title || ' '::text) || COALESCE(description, ''::text)))) STORED,
    metadata jsonb,
    CONSTRAINT tasks_priority_check CHECK ((priority = ANY (ARRAY['low'::text, 'medium'::text, 'high'::text])))
);



--
-- Name: TABLE tasks; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.tasks IS 'Main task information and metadata';


--
-- Name: COLUMN tasks.metadata; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.tasks.metadata IS 'JSONB field to store task-specific metadata like payment_schedule_id, payment_type, etc.';


--
-- Name: task_completion_summary; Type: VIEW; Schema: public; Owner: supabase_admin
--

DROP VIEW IF EXISTS public.task_completion_summary CASCADE;
CREATE VIEW public.task_completion_summary AS
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



--
-- Name: task_reminder_logs; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.task_reminder_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    task_assignment_id uuid,
    quick_task_assignment_id uuid,
    task_title text NOT NULL,
    assigned_to_user_id uuid,
    deadline timestamp with time zone NOT NULL,
    hours_overdue numeric,
    reminder_sent_at timestamp with time zone DEFAULT now(),
    notification_id uuid,
    status text DEFAULT 'sent'::text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT check_single_assignment CHECK ((((task_assignment_id IS NOT NULL) AND (quick_task_assignment_id IS NULL)) OR ((task_assignment_id IS NULL) AND (quick_task_assignment_id IS NOT NULL))))
);



--
-- Name: TABLE task_reminder_logs; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.task_reminder_logs IS 'Logs all automatic and manual task reminders sent to users';


--
-- Name: user_audit_logs; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.user_audit_logs (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid,
    target_user_id uuid,
    action character varying(100) NOT NULL,
    table_name character varying(100),
    record_id uuid,
    old_values jsonb,
    new_values jsonb,
    ip_address inet,
    user_agent text,
    performed_by uuid,
    created_at timestamp with time zone DEFAULT now()
);



--
-- Name: user_device_sessions; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.user_device_sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    device_id character varying(100) NOT NULL,
    session_token character varying(255) NOT NULL,
    device_type character varying(20) NOT NULL,
    browser_name character varying(50),
    user_agent text,
    ip_address inet,
    is_active boolean DEFAULT true,
    login_at timestamp with time zone DEFAULT now(),
    last_activity timestamp with time zone DEFAULT now(),
    expires_at timestamp with time zone DEFAULT (now() + '24:00:00'::interval),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT user_device_sessions_device_type_check CHECK (((device_type)::text = ANY (ARRAY[('mobile'::character varying)::text, ('desktop'::character varying)::text])))
);



--
-- Name: user_favorite_buttons; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.user_favorite_buttons (
    id text NOT NULL,
    employee_id text,
    user_id uuid NOT NULL,
    favorite_config jsonb DEFAULT '[]'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);



--
-- Name: user_management_view; Type: VIEW; Schema: public; Owner: supabase_admin
--

DROP VIEW IF EXISTS public.user_management_view CASCADE;
CREATE VIEW public.user_management_view AS
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



--
-- Name: user_mobile_theme_assignments; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.user_mobile_theme_assignments (
    id bigint NOT NULL,
    user_id uuid NOT NULL,
    theme_id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    color_overrides jsonb
);



--
-- Name: COLUMN user_mobile_theme_assignments.color_overrides; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.user_mobile_theme_assignments.color_overrides IS 'User-specific color overrides. Merge with theme colors at runtime. Stores only properties that differ from base theme.';


--
-- Name: user_mobile_theme_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.user_mobile_theme_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: user_mobile_theme_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.user_mobile_theme_assignments_id_seq OWNED BY public.user_mobile_theme_assignments.id;


--
-- Name: user_password_history; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.user_password_history (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    password_hash character varying(255) NOT NULL,
    salt character varying(100) NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);



--
-- Name: user_permissions_view; Type: VIEW; Schema: public; Owner: supabase_admin
--

DROP VIEW IF EXISTS public.user_permissions_view CASCADE;
CREATE VIEW public.user_permissions_view AS
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



--
-- Name: user_sessions; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.user_sessions (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    session_token character varying(255) NOT NULL,
    login_method character varying(20) NOT NULL,
    ip_address inet,
    user_agent text,
    is_active boolean DEFAULT true,
    expires_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    ended_at timestamp with time zone,
    CONSTRAINT user_sessions_login_method_check CHECK (((login_method)::text = ANY (ARRAY[('quick_access'::character varying)::text, ('username_password'::character varying)::text])))
);



--
-- Name: user_theme_assignments; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.user_theme_assignments (
    id integer NOT NULL,
    user_id uuid NOT NULL,
    theme_id integer NOT NULL,
    assigned_by uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);



--
-- Name: user_theme_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.user_theme_assignments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: user_theme_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public.user_theme_assignments_id_seq OWNED BY public.user_theme_assignments.id;


--
-- Name: user_voice_preferences; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.user_voice_preferences (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    locale text NOT NULL,
    voice_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT user_voice_preferences_locale_check CHECK ((locale = ANY (ARRAY['en'::text, 'ar'::text])))
);



--
-- Name: variation_audit_log; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.variation_audit_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    action_type text NOT NULL,
    variation_group_id uuid,
    affected_barcodes text[],
    parent_barcode text,
    group_name_en text,
    group_name_ar text,
    user_id uuid,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL,
    details jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT variation_audit_log_action_type_check CHECK ((action_type = ANY (ARRAY['create_group'::text, 'edit_group'::text, 'delete_group'::text, 'add_variation'::text, 'remove_variation'::text, 'reorder_variations'::text, 'change_parent'::text, 'update_image_override'::text])))
);



--
-- Name: TABLE variation_audit_log; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.variation_audit_log IS 'Audit trail for all variation group operations';


--
-- Name: COLUMN variation_audit_log.action_type; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.variation_audit_log.action_type IS 'Type of action performed on variation group';


--
-- Name: COLUMN variation_audit_log.variation_group_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.variation_audit_log.variation_group_id IS 'UUID of the variation group affected';


--
-- Name: COLUMN variation_audit_log.affected_barcodes; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.variation_audit_log.affected_barcodes IS 'Array of product barcodes affected by this action';


--
-- Name: COLUMN variation_audit_log.parent_barcode; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.variation_audit_log.parent_barcode IS 'Parent product barcode for reference';


--
-- Name: COLUMN variation_audit_log.group_name_en; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.variation_audit_log.group_name_en IS 'English name of the group at time of action';


--
-- Name: COLUMN variation_audit_log.group_name_ar; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.variation_audit_log.group_name_ar IS 'Arabic name of the group at time of action';


--
-- Name: COLUMN variation_audit_log.user_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.variation_audit_log.user_id IS 'User who performed the action';


--
-- Name: COLUMN variation_audit_log.details; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.variation_audit_log.details IS 'Additional details stored as JSON (before/after state, etc.)';


--
-- Name: vendor_payment_schedule; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.vendor_payment_schedule (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    receiving_record_id uuid,
    bill_number character varying(255),
    vendor_id character varying(255),
    vendor_name character varying(255),
    branch_id integer,
    branch_name character varying(255),
    bill_date date,
    bill_amount numeric(15,2),
    final_bill_amount numeric(15,2),
    payment_method character varying(100),
    bank_name character varying(255),
    iban character varying(255),
    due_date date,
    credit_period integer,
    vat_number character varying(100),
    scheduled_date timestamp without time zone DEFAULT now(),
    paid_date timestamp without time zone,
    notes text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    original_due_date date,
    original_bill_amount numeric(15,2),
    original_final_amount numeric(15,2),
    is_paid boolean DEFAULT false,
    payment_reference character varying(255),
    task_id uuid,
    task_assignment_id uuid,
    receiver_user_id uuid,
    accountant_user_id uuid,
    verification_status text DEFAULT 'pending'::text,
    verified_by uuid,
    verified_date timestamp with time zone,
    transaction_date timestamp with time zone,
    original_bill_url text,
    created_by uuid,
    pr_excel_verified boolean DEFAULT false,
    pr_excel_verified_by uuid,
    pr_excel_verified_date timestamp with time zone,
    discount_amount numeric(15,2) DEFAULT 0,
    discount_notes text,
    grr_amount numeric(15,2) DEFAULT 0,
    grr_reference_number text,
    grr_notes text,
    pri_amount numeric(15,2) DEFAULT 0,
    pri_reference_number text,
    pri_notes text,
    last_adjustment_date timestamp with time zone,
    last_adjusted_by uuid,
    adjustment_history jsonb DEFAULT '[]'::jsonb,
    approval_status text DEFAULT 'pending'::text NOT NULL,
    approval_requested_by uuid,
    approval_requested_at timestamp with time zone,
    approved_by uuid,
    approved_at timestamp with time zone,
    approval_notes text,
    assigned_approver_id uuid,
    CONSTRAINT check_discount_amount_positive CHECK ((discount_amount >= (0)::numeric)),
    CONSTRAINT check_grr_amount_positive CHECK ((grr_amount >= (0)::numeric)),
    CONSTRAINT check_pri_amount_positive CHECK ((pri_amount >= (0)::numeric)),
    CONSTRAINT check_total_deductions_valid CHECK ((((COALESCE(discount_amount, (0)::numeric) + COALESCE(grr_amount, (0)::numeric)) + COALESCE(pri_amount, (0)::numeric)) <= COALESCE(original_final_amount, final_bill_amount, bill_amount))),
    CONSTRAINT vendor_payment_approval_status_check CHECK ((approval_status = ANY (ARRAY['pending'::text, 'sent_for_approval'::text, 'approved'::text, 'rejected'::text])))
);



--
-- Name: TABLE vendor_payment_schedule; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.vendor_payment_schedule IS 'Schedule and track vendor payments';


--
-- Name: COLUMN vendor_payment_schedule.due_date; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.due_date IS 'Current due date (can be rescheduled)';


--
-- Name: COLUMN vendor_payment_schedule.scheduled_date; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.scheduled_date IS 'When the payment was scheduled';


--
-- Name: COLUMN vendor_payment_schedule.paid_date; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.paid_date IS 'Timestamp when payment was marked as paid';


--
-- Name: COLUMN vendor_payment_schedule.original_due_date; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.original_due_date IS 'Original due date when first scheduled (never changes)';


--
-- Name: COLUMN vendor_payment_schedule.original_bill_amount; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.original_bill_amount IS 'Original bill amount when first scheduled (never changes)';


--
-- Name: COLUMN vendor_payment_schedule.original_final_amount; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.original_final_amount IS 'Original final amount when first scheduled (never changes)';


--
-- Name: COLUMN vendor_payment_schedule.is_paid; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.is_paid IS 'Boolean flag: true=paid, false=not paid';


--
-- Name: COLUMN vendor_payment_schedule.payment_reference; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.payment_reference IS 'Payment reference number (migrated from payment_transactions). Format: CP#XXXX or AUTO-COD-XXXXX';


--
-- Name: COLUMN vendor_payment_schedule.task_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.task_id IS 'Task created for accountant when payment is marked as paid';


--
-- Name: COLUMN vendor_payment_schedule.task_assignment_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.task_assignment_id IS 'Task assignment for the accountant';


--
-- Name: COLUMN vendor_payment_schedule.receiver_user_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.receiver_user_id IS 'User who received the goods (from receiving_records)';


--
-- Name: COLUMN vendor_payment_schedule.accountant_user_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.accountant_user_id IS 'Accountant assigned to process this payment';


--
-- Name: COLUMN vendor_payment_schedule.verification_status; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.verification_status IS 'Payment verification status: pending, verified, rejected';


--
-- Name: COLUMN vendor_payment_schedule.verified_by; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.verified_by IS 'User who verified the payment';


--
-- Name: COLUMN vendor_payment_schedule.verified_date; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.verified_date IS 'Date when payment was verified';


--
-- Name: COLUMN vendor_payment_schedule.transaction_date; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.transaction_date IS 'Actual transaction/payment date';


--
-- Name: COLUMN vendor_payment_schedule.original_bill_url; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.original_bill_url IS 'URL to the original bill/invoice document';


--
-- Name: COLUMN vendor_payment_schedule.discount_amount; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.discount_amount IS 'Discount amount deducted from bill';


--
-- Name: COLUMN vendor_payment_schedule.discount_notes; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.discount_notes IS 'Notes explaining the discount';


--
-- Name: COLUMN vendor_payment_schedule.grr_amount; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.grr_amount IS 'Goods Receipt Return amount deducted from bill';


--
-- Name: COLUMN vendor_payment_schedule.grr_reference_number; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.grr_reference_number IS 'Reference number for GRR document';


--
-- Name: COLUMN vendor_payment_schedule.grr_notes; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.grr_notes IS 'Notes for GRR adjustment';


--
-- Name: COLUMN vendor_payment_schedule.pri_amount; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.pri_amount IS 'Purchase Return Invoice amount deducted from bill';


--
-- Name: COLUMN vendor_payment_schedule.pri_reference_number; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.pri_reference_number IS 'Reference number for PRI document';


--
-- Name: COLUMN vendor_payment_schedule.pri_notes; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.pri_notes IS 'Notes for PRI adjustment';


--
-- Name: COLUMN vendor_payment_schedule.last_adjustment_date; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.last_adjustment_date IS 'Date of last adjustment';


--
-- Name: COLUMN vendor_payment_schedule.last_adjusted_by; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.last_adjusted_by IS 'User ID who made the last adjustment (stores auth.users.id without FK constraint)';


--
-- Name: COLUMN vendor_payment_schedule.adjustment_history; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.adjustment_history IS 'JSON array of all adjustment history';


--
-- Name: COLUMN vendor_payment_schedule.approval_status; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.approval_status IS 'Approval workflow status: pending, sent_for_approval, approved, rejected';


--
-- Name: COLUMN vendor_payment_schedule.approval_requested_by; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.approval_requested_by IS 'User who requested approval';


--
-- Name: COLUMN vendor_payment_schedule.approval_requested_at; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.approval_requested_at IS 'Timestamp when approval was requested';


--
-- Name: COLUMN vendor_payment_schedule.approved_by; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.approved_by IS 'User who approved the payment';


--
-- Name: COLUMN vendor_payment_schedule.approved_at; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.approved_at IS 'Timestamp when payment was approved';


--
-- Name: COLUMN vendor_payment_schedule.approval_notes; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.approval_notes IS 'Optional notes about the approval decision';


--
-- Name: COLUMN vendor_payment_schedule.assigned_approver_id; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.vendor_payment_schedule.assigned_approver_id IS 'The specific user assigned to approve this vendor payment';


--
-- Name: view_offer; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.view_offer (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    offer_name character varying(255) NOT NULL,
    branch_id bigint NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    file_url text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    start_time time without time zone DEFAULT '00:00:00'::time without time zone,
    end_time time without time zone DEFAULT '23:59:00'::time without time zone,
    thumbnail_url text,
    view_button_count integer DEFAULT 0,
    page_visit_count integer DEFAULT 0
);



--
-- Name: wa_accounts; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.wa_accounts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    phone_number character varying(20) NOT NULL,
    display_name text,
    waba_id text,
    phone_number_id text,
    access_token text,
    quality_rating character varying(10) DEFAULT 'GREEN'::character varying,
    status character varying(20) DEFAULT 'connected'::character varying,
    is_default boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    is_active boolean DEFAULT true,
    branch_id uuid,
    payment_pending numeric(12,2) DEFAULT 0,
    payment_currency text DEFAULT 'USD'::text,
    last_payment_date timestamp without time zone,
    meta_business_account_id text,
    meta_access_token text
);



--
-- Name: wa_ai_bot_config; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.wa_ai_bot_config (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    is_enabled boolean DEFAULT false,
    tone character varying(20) DEFAULT 'friendly'::character varying,
    default_language character varying(10) DEFAULT 'auto'::character varying,
    max_replies_per_conversation integer DEFAULT 10,
    handoff_keywords text[] DEFAULT '{}'::text[],
    training_data jsonb DEFAULT '[]'::jsonb,
    custom_instructions text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    token_limit integer DEFAULT 500000,
    tokens_used integer DEFAULT 0,
    prompt_tokens_used integer DEFAULT 0,
    completion_tokens_used integer DEFAULT 0,
    total_requests integer DEFAULT 0,
    training_qa jsonb DEFAULT '[]'::jsonb,
    bot_rules text DEFAULT ''::text,
    human_support_enabled boolean DEFAULT false,
    human_support_start_time time without time zone DEFAULT '12:00:00'::time without time zone,
    human_support_end_time time without time zone DEFAULT '20:00:00'::time without time zone
);



--
-- Name: wa_auto_reply_triggers; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.wa_auto_reply_triggers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    wa_account_id uuid,
    name text,
    trigger_words_en text[] DEFAULT '{}'::text[],
    trigger_words_ar text[] DEFAULT '{}'::text[],
    match_type character varying(20) DEFAULT 'contains'::character varying,
    reply_type character varying(20) DEFAULT 'text'::character varying,
    reply_text text,
    reply_media_url text,
    reply_template_id uuid,
    reply_buttons jsonb DEFAULT '[]'::jsonb,
    follow_up_trigger_id uuid,
    sort_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    trigger_words text[] DEFAULT ARRAY[]::text[],
    response_type character varying(20) DEFAULT 'text'::character varying,
    response_content text,
    response_media_url text,
    response_template_name text,
    response_buttons jsonb DEFAULT '[]'::jsonb,
    follow_up_delay_seconds integer DEFAULT 0,
    follow_up_content text,
    priority integer DEFAULT 0
);



--
-- Name: wa_bot_flows; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.wa_bot_flows (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    wa_account_id uuid,
    name text NOT NULL,
    trigger_words_en text[] DEFAULT ARRAY[]::text[],
    trigger_words_ar text[] DEFAULT ARRAY[]::text[],
    match_type character varying(20) DEFAULT 'contains'::character varying,
    nodes jsonb DEFAULT '[]'::jsonb,
    edges jsonb DEFAULT '[]'::jsonb,
    is_active boolean DEFAULT true,
    priority integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);



--
-- Name: wa_broadcast_recipients; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.wa_broadcast_recipients (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    broadcast_id uuid,
    customer_id uuid,
    phone_number character varying(20) NOT NULL,
    customer_name text,
    whatsapp_message_id text,
    status character varying(20) DEFAULT 'pending'::character varying,
    error_details text,
    sent_at timestamp with time zone
);

ALTER TABLE ONLY public.wa_broadcast_recipients REPLICA IDENTITY FULL;



--
-- Name: wa_broadcasts; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.wa_broadcasts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    wa_account_id uuid,
    name text,
    template_id uuid,
    recipient_filter character varying(20) DEFAULT 'all'::character varying,
    recipient_group_id uuid,
    total_recipients integer DEFAULT 0,
    sent_count integer DEFAULT 0,
    delivered_count integer DEFAULT 0,
    read_count integer DEFAULT 0,
    failed_count integer DEFAULT 0,
    status character varying(20) DEFAULT 'draft'::character varying,
    scheduled_at timestamp with time zone,
    completed_at timestamp with time zone,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now()
);

ALTER TABLE ONLY public.wa_broadcasts REPLICA IDENTITY FULL;



--
-- Name: wa_catalog_orders; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.wa_catalog_orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    wa_account_id uuid NOT NULL,
    catalog_id uuid,
    customer_phone text NOT NULL,
    customer_name text,
    order_status text DEFAULT 'pending'::text,
    items jsonb DEFAULT '[]'::jsonb,
    subtotal numeric(12,2) DEFAULT 0,
    tax numeric(12,2) DEFAULT 0,
    shipping numeric(12,2) DEFAULT 0,
    total numeric(12,2) DEFAULT 0,
    currency text DEFAULT 'SAR'::text,
    notes text,
    meta_order_id text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);



--
-- Name: wa_catalog_products; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.wa_catalog_products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    catalog_id uuid NOT NULL,
    wa_account_id uuid NOT NULL,
    meta_product_id text,
    retailer_id text,
    name text NOT NULL,
    description text,
    price numeric(12,2) DEFAULT 0,
    currency text DEFAULT 'SAR'::text,
    sale_price numeric(12,2),
    image_url text,
    additional_images text[] DEFAULT '{}'::text[],
    url text,
    category text,
    availability text DEFAULT 'in stock'::text,
    condition text DEFAULT 'new'::text,
    brand text,
    sku text,
    quantity integer DEFAULT 0,
    is_hidden boolean DEFAULT false,
    status text DEFAULT 'active'::text,
    synced_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);



--
-- Name: wa_catalogs; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.wa_catalogs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    wa_account_id uuid NOT NULL,
    meta_catalog_id text,
    name text NOT NULL,
    description text,
    status text DEFAULT 'active'::text,
    product_count integer DEFAULT 0,
    synced_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);



--
-- Name: wa_contact_group_members; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.wa_contact_group_members (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    group_id uuid,
    customer_id uuid,
    added_at timestamp with time zone DEFAULT now()
);



--
-- Name: wa_contact_groups; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.wa_contact_groups (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    description text,
    customer_count integer DEFAULT 0,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now()
);



--
-- Name: wa_conversations; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.wa_conversations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    wa_account_id uuid,
    customer_id uuid,
    customer_phone character varying(20) NOT NULL,
    customer_name text,
    last_message_at timestamp with time zone,
    last_message_preview text,
    unread_count integer DEFAULT 0,
    is_bot_handling boolean DEFAULT false,
    bot_type character varying(20),
    status character varying(20) DEFAULT 'active'::character varying,
    created_at timestamp with time zone DEFAULT now(),
    branch_id uuid,
    handled_by character varying(20) DEFAULT 'bot'::character varying,
    window_expires_at timestamp with time zone,
    needs_human boolean DEFAULT false,
    is_sos boolean DEFAULT false
);



--
-- Name: wa_messages; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.wa_messages (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    conversation_id uuid,
    wa_account_id uuid,
    whatsapp_message_id text,
    direction character varying(10) DEFAULT 'outbound'::character varying NOT NULL,
    message_type character varying(20) DEFAULT 'text'::character varying,
    content text,
    media_url text,
    media_mime_type character varying(50),
    template_name character varying(100),
    template_language character varying(10),
    status character varying(20) DEFAULT 'sent'::character varying,
    sent_by character varying(20) DEFAULT 'user'::character varying,
    sent_by_user_id uuid,
    error_details text,
    created_at timestamp with time zone DEFAULT now(),
    delivered_at timestamp with time zone,
    read_at timestamp with time zone,
    metadata jsonb
);



--
-- Name: wa_settings; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.wa_settings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    wa_account_id uuid,
    business_name text,
    business_description text,
    business_address text,
    business_email text,
    business_website text,
    business_category text,
    profile_picture_url text,
    about_text text,
    webhook_url text,
    webhook_verify_token text,
    webhook_active boolean DEFAULT false,
    business_hours jsonb DEFAULT '{}'::jsonb,
    outside_hours_message text,
    default_language character varying(10) DEFAULT 'en'::character varying,
    notify_new_message boolean DEFAULT true,
    notify_bot_escalation boolean DEFAULT true,
    notify_broadcast_complete boolean DEFAULT true,
    notify_template_status boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    auto_reply_enabled boolean DEFAULT false
);



--
-- Name: wa_templates; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.wa_templates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    wa_account_id uuid,
    meta_template_id text,
    name character varying(100) NOT NULL,
    category character varying(20) DEFAULT 'UTILITY'::character varying,
    language character varying(10) DEFAULT 'en'::character varying,
    status character varying(20) DEFAULT 'PENDING'::character varying,
    header_type character varying(20) DEFAULT 'none'::character varying,
    header_content text,
    body_text text,
    footer_text text,
    buttons jsonb DEFAULT '[]'::jsonb,
    meta_data jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);



--
-- Name: warning_main_category; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.warning_main_category (
    id character varying(10) NOT NULL,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);



--
-- Name: warning_ref_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE IF NOT EXISTS public.warning_ref_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: warning_sub_category; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.warning_sub_category (
    id character varying(10) NOT NULL,
    main_category_id character varying(10) NOT NULL,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);



--
-- Name: warning_violation; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.warning_violation (
    id character varying(10) NOT NULL,
    sub_category_id character varying(10) NOT NULL,
    main_category_id character varying(10) NOT NULL,
    name_en character varying(255) NOT NULL,
    name_ar character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);



--
-- Name: whatsapp_message_log; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE IF NOT EXISTS public.whatsapp_message_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    phone_number character varying(20) NOT NULL,
    message_type character varying(50) DEFAULT 'access_code'::character varying NOT NULL,
    template_name character varying(100),
    template_language character varying(10),
    whatsapp_message_id text,
    status character varying(20) DEFAULT 'sent'::character varying,
    customer_name text,
    error_details text,
    created_at timestamp with time zone DEFAULT now()
);



--
-- Name: ai_chat_guide id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.ai_chat_guide ALTER COLUMN id SET DEFAULT nextval('public.ai_chat_guide_id_seq'::regclass);


--
-- Name: approval_permissions id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.approval_permissions ALTER COLUMN id SET DEFAULT nextval('public.approval_permissions_id_seq'::regclass);


--
-- Name: approver_branch_access id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.approver_branch_access ALTER COLUMN id SET DEFAULT nextval('public.approver_branch_access_id_seq'::regclass);


--
-- Name: approver_visibility_config id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.approver_visibility_config ALTER COLUMN id SET DEFAULT nextval('public.approver_visibility_config_id_seq'::regclass);


--
-- Name: asset_main_categories id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.asset_main_categories ALTER COLUMN id SET DEFAULT nextval('public.asset_main_categories_id_seq'::regclass);


--
-- Name: asset_sub_categories id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.asset_sub_categories ALTER COLUMN id SET DEFAULT nextval('public.asset_sub_categories_id_seq'::regclass);


--
-- Name: assets id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.assets ALTER COLUMN id SET DEFAULT nextval('public.assets_id_seq'::regclass);


--
-- Name: bank_reconciliations id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.bank_reconciliations ALTER COLUMN id SET DEFAULT nextval('public.bank_reconciliations_id_seq'::regclass);


--
-- Name: bogo_offer_rules id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.bogo_offer_rules ALTER COLUMN id SET DEFAULT nextval('public.bogo_offer_rules_id_seq'::regclass);


--
-- Name: branches id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.branches ALTER COLUMN id SET DEFAULT nextval('public.branches_id_seq'::regclass);


--
-- Name: break_reasons id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.break_reasons ALTER COLUMN id SET DEFAULT nextval('public.break_reasons_id_seq'::regclass);


--
-- Name: denomination_types id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.denomination_types ALTER COLUMN id SET DEFAULT nextval('public.denomination_types_id_seq'::regclass);


--
-- Name: desktop_themes id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.desktop_themes ALTER COLUMN id SET DEFAULT nextval('public.desktop_themes_id_seq'::regclass);


--
-- Name: employee_checklist_assignments id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.employee_checklist_assignments ALTER COLUMN id SET DEFAULT nextval('public.employee_checklist_assignments_id_seq'::regclass);


--
-- Name: erp_sync_logs id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.erp_sync_logs ALTER COLUMN id SET DEFAULT nextval('public.erp_sync_logs_id_seq'::regclass);


--
-- Name: erp_synced_products id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.erp_synced_products ALTER COLUMN id SET DEFAULT nextval('public.erp_synced_products_id_seq'::regclass);


--
-- Name: expense_parent_categories id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.expense_parent_categories ALTER COLUMN id SET DEFAULT nextval('public.expense_parent_categories_id_seq'::regclass);


--
-- Name: expense_requisitions id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.expense_requisitions ALTER COLUMN id SET DEFAULT nextval('public.expense_requisitions_id_seq'::regclass);


--
-- Name: expense_scheduler id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.expense_scheduler ALTER COLUMN id SET DEFAULT nextval('public.expense_scheduler_id_seq'::regclass);


--
-- Name: expense_sub_categories id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.expense_sub_categories ALTER COLUMN id SET DEFAULT nextval('public.expense_sub_categories_id_seq'::regclass);


--
-- Name: frontend_builds id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.frontend_builds ALTER COLUMN id SET DEFAULT nextval('public.frontend_builds_id_seq'::regclass);


--
-- Name: hr_analysed_attendance_data id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.hr_analysed_attendance_data ALTER COLUMN id SET DEFAULT nextval('public.hr_analysed_attendance_data_id_seq'::regclass);


--
-- Name: mobile_themes id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.mobile_themes ALTER COLUMN id SET DEFAULT nextval('public.mobile_themes_id_seq'::regclass);


--
-- Name: multi_shift_date_wise id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.multi_shift_date_wise ALTER COLUMN id SET DEFAULT nextval('public.multi_shift_date_wise_id_seq'::regclass);


--
-- Name: multi_shift_regular id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.multi_shift_regular ALTER COLUMN id SET DEFAULT nextval('public.multi_shift_regular_id_seq'::regclass);


--
-- Name: multi_shift_weekday id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.multi_shift_weekday ALTER COLUMN id SET DEFAULT nextval('public.multi_shift_weekday_id_seq'::regclass);


--
-- Name: non_approved_payment_scheduler id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.non_approved_payment_scheduler ALTER COLUMN id SET DEFAULT nextval('public.non_approved_payment_scheduler_id_seq'::regclass);


--
-- Name: offer_bundles id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.offer_bundles ALTER COLUMN id SET DEFAULT nextval('public.offer_bundles_id_seq'::regclass);


--
-- Name: offer_cart_tiers id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.offer_cart_tiers ALTER COLUMN id SET DEFAULT nextval('public.offer_cart_tiers_id_seq'::regclass);


--
-- Name: offer_usage_logs id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.offer_usage_logs ALTER COLUMN id SET DEFAULT nextval('public.offer_usage_logs_id_seq'::regclass);


--
-- Name: offers id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.offers ALTER COLUMN id SET DEFAULT nextval('public.offers_id_seq'::regclass);


--
-- Name: recurring_schedule_check_log id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.recurring_schedule_check_log ALTER COLUMN id SET DEFAULT nextval('public.recurring_schedule_check_log_id_seq'::regclass);


--
-- Name: system_api_keys id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.system_api_keys ALTER COLUMN id SET DEFAULT nextval('public.system_api_keys_id_seq'::regclass);


--
-- Name: user_mobile_theme_assignments id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.user_mobile_theme_assignments ALTER COLUMN id SET DEFAULT nextval('public.user_mobile_theme_assignments_id_seq'::regclass);


--
-- Name: user_theme_assignments id; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.user_theme_assignments ALTER COLUMN id SET DEFAULT nextval('public.user_theme_assignments_id_seq'::regclass);


--
-- Name: access_code_otp access_code_otp_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.access_code_otp
    ADD CONSTRAINT access_code_otp_pkey PRIMARY KEY (id);


--
-- Name: ai_chat_guide ai_chat_guide_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.ai_chat_guide
    ADD CONSTRAINT ai_chat_guide_pkey PRIMARY KEY (id);


--
-- Name: app_icons app_icons_icon_key_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.app_icons
    ADD CONSTRAINT app_icons_icon_key_key UNIQUE (icon_key);


--
-- Name: app_icons app_icons_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.app_icons
    ADD CONSTRAINT app_icons_pkey PRIMARY KEY (id);


--
-- Name: approval_permissions approval_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.approval_permissions
    ADD CONSTRAINT approval_permissions_pkey PRIMARY KEY (id);


--
-- Name: approval_permissions approval_permissions_user_id_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.approval_permissions
    ADD CONSTRAINT approval_permissions_user_id_key UNIQUE (user_id);


--
-- Name: approver_branch_access approver_branch_access_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.approver_branch_access
    ADD CONSTRAINT approver_branch_access_pkey PRIMARY KEY (id);


--
-- Name: approver_branch_access approver_branch_access_user_id_branch_id_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.approver_branch_access
    ADD CONSTRAINT approver_branch_access_user_id_branch_id_key UNIQUE (user_id, branch_id);


--
-- Name: approver_visibility_config approver_visibility_config_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.approver_visibility_config
    ADD CONSTRAINT approver_visibility_config_pkey PRIMARY KEY (id);


--
-- Name: approver_visibility_config approver_visibility_config_user_id_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.approver_visibility_config
    ADD CONSTRAINT approver_visibility_config_user_id_key UNIQUE (user_id);


--
-- Name: asset_sub_categories asset_items_group_code_name_en_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
