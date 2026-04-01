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
            'Finish Picking #' || v_order.order_number || '|||╪Ñ┘å┘ç╪º╪í ╪¬╪¡╪╢┘è╪▒ #' || v_order.order_number,
            'Finish picking products for order #' || v_order.order_number || E'\nCustomer: ' || v_order.customer_name || '|||╪ú┘å┘ç┘É ╪¬╪¡╪╢┘è╪▒ ╪º┘ä┘à┘å╪¬╪¼╪º╪¬ ┘ä┘ä╪╖┘ä╪¿ #' || v_order.order_number || E'\n╪º┘ä╪╣┘à┘è┘ä: ' || v_order.customer_name,
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
        v_notif_title := 'Finish Picking: Order #' || v_order.order_number || '|||╪Ñ┘å┘ç╪º╪í ╪º┘ä╪¬╪¡╪╢┘è╪▒: ╪╖┘ä╪¿ #' || v_order.order_number;
        v_notif_message := 'Start picking completed. Please finish picking order #' || v_order.order_number || '|||╪¬┘à ╪¿╪»╪í ╪º┘ä╪¬╪¡╪╢┘è╪▒. ┘è╪▒╪¼┘ë ╪Ñ┘å┘ç╪º╪í ╪¬╪¡╪╢┘è╪▒ ╪º┘ä╪╖┘ä╪¿ #' || v_order.order_number;

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
        -- Picker completed ΓåÆ Order is ready
        UPDATE orders SET 
            order_status = 'ready',
            ready_at = NOW(),
            updated_at = NOW()
        WHERE id = v_order.id AND order_status IN ('in_picking', 'accepted');

        -- Create bilingual notification: Order Ready
        v_notif_title := 'Order #' || v_order.order_number || ' Ready|||╪╖┘ä╪¿ #' || v_order.order_number || ' ╪¼╪º┘ç╪▓';
        
        IF v_order.fulfillment_method = 'pickup' THEN
            v_notif_message := 'Order #' || v_order.order_number || ' is ready for pickup. Customer: ' || v_order.customer_name || '|||╪º┘ä╪╖┘ä╪¿ #' || v_order.order_number || ' ╪¼╪º┘ç╪▓ ┘ä┘ä╪º╪│╪¬┘ä╪º┘à. ╪º┘ä╪╣┘à┘è┘ä: ' || v_order.customer_name;
        ELSE
            v_notif_message := 'Order #' || v_order.order_number || ' is ready. Please assign a delivery person. Customer: ' || v_order.customer_name || '|||╪º┘ä╪╖┘ä╪¿ #' || v_order.order_number || ' ╪¼╪º┘ç╪▓. ┘è╪▒╪¼┘ë ╪¬╪╣┘è┘è┘å ┘à┘å╪»┘ê╪¿ ╪¬┘ê╪╡┘è┘ä. ╪º┘ä╪╣┘à┘è┘ä: ' || v_order.customer_name;
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
        -- Delivery completed ΓåÆ Order is delivered
        UPDATE orders SET 
            order_status = 'delivered',
            delivered_at = NOW(),
            actual_delivery_time = NOW(),
            updated_at = NOW()
        WHERE id = v_order.id AND order_status = 'out_for_delivery';

        -- Create bilingual notification: Order Delivered
        v_notif_title := 'Order #' || v_order.order_number || ' Delivered|||╪╖┘ä╪¿ #' || v_order.order_number || ' ╪¬┘à ╪º┘ä╪¬┘ê╪╡┘è┘ä';
        v_notif_message := 'Order #' || v_order.order_number || ' has been delivered to ' || v_order.customer_name || '|||╪¬┘à ╪¬┘ê╪╡┘è┘ä ╪º┘ä╪╖┘ä╪¿ #' || v_order.order_number || ' ╪Ñ┘ä┘ë ' || v_order.customer_name;

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
-- Name: has_order_management_access(uuid); Type: FUNCTION; Schema: public; Owner: -
--

