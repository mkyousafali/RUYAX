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
-- Name: FUNCTION trigger_notify_new_order(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.trigger_notify_new_order() IS 'Notifies all Admin and Master Admin users when a new order is placed';


--
-- Name: trigger_order_status_audit(); Type: FUNCTION; Schema: public; Owner: -
--

