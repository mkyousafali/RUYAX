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
-- Name: create_notification_simple(text, text, text, text, uuid, uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

