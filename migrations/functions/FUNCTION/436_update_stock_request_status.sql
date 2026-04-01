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
        v_status_label := 'Accepted Γ£à';
        v_status_label_ar := '┘à┘é╪¿┘ê┘ä Γ£à';
        v_notif_type := 'success';
        v_message := 'Your Stock Request has been approved.' || E'\n---\n' || '╪╖┘ä╪¿ ╪º┘ä┘à╪«╪▓┘ê┘å ╪º┘ä╪«╪º╪╡ ╪¿┘â ╪¬┘à ┘é╪¿┘ê┘ä┘ç.';
    ELSE
        v_status_label := 'Rejected Γ¥î';
        v_status_label_ar := '┘à╪▒┘ü┘ê╪╢ Γ¥î';
        v_notif_type := 'error';
        v_message := 'Your Stock Request has been rejected.' || E'\n---\n' || '╪╖┘ä╪¿ ╪º┘ä┘à╪«╪▓┘ê┘å ╪º┘ä╪«╪º╪╡ ╪¿┘â ╪¬┘à ╪▒┘ü╪╢┘ç.';
    END IF;

    v_title := 'ST Request ' || v_status_label || ' | ╪╖┘ä╪¿ ST ' || v_status_label_ar;

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
-- Name: update_system_api_keys_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

