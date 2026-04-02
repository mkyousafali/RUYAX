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
-- Name: set_user_context(uuid, boolean, boolean); Type: FUNCTION; Schema: public; Owner: -
--

