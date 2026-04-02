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
-- Name: queue_quick_task_push_notifications(); Type: FUNCTION; Schema: public; Owner: -
--

