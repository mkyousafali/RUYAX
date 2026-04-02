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
            v_title := '╪¬┘à ┘é╪¿┘ê┘ä ╪╖┘ä╪¿┘â Γ£à';
            v_body := '╪¬┘à ┘é╪¿┘ê┘ä ╪╖┘ä╪¿┘â ╪▒┘é┘à #' || v_order.order_number || ' ┘ê╪¼╪º╪▒┘è ╪¬╪¼┘ç┘è╪▓┘ç.' || chr(10) || 'Your order #' || v_order.order_number || ' has been accepted.';
            v_type := 'order_accepted';
        WHEN 'in_picking' THEN
            v_title := '╪¼╪º╪▒┘è ╪¬╪¡╪╢┘è╪▒ ╪╖┘ä╪¿┘â ≡ƒôª';
            v_body := '╪╖┘ä╪¿┘â ╪▒┘é┘à #' || v_order.order_number || ' ┘é┘è╪» ╪º┘ä╪¬╪¡╪╢┘è╪▒ ╪º┘ä╪ó┘å.' || chr(10) || 'Your order #' || v_order.order_number || ' is being prepared.';
            v_type := 'order_picking';
        WHEN 'ready' THEN
            IF v_order.fulfillment_method = 'pickup' THEN
                v_title := '╪╖┘ä╪¿┘â ╪¼╪º┘ç╪▓ ┘ä┘ä╪º╪│╪¬┘ä╪º┘à ≡ƒÄë';
                v_body := '╪╖┘ä╪¿┘â ╪▒┘é┘à #' || v_order.order_number || ' ╪¼╪º┘ç╪▓! ╪¬╪╣╪º┘ä ┘ê╪º╪│╪¬┘ä┘à┘ç.' || chr(10) || 'Your order #' || v_order.order_number || ' is ready for pickup!';
            ELSE
                v_title := '╪╖┘ä╪¿┘â ╪¼╪º┘ç╪▓ ≡ƒÄë';
                v_body := '╪╖┘ä╪¿┘â ╪▒┘é┘à #' || v_order.order_number || ' ╪¼╪º┘ç╪▓ ┘ê╪¿╪º┘å╪¬╪╕╪º╪▒ ╪º┘ä╪¬┘ê╪╡┘è┘ä.' || chr(10) || 'Your order #' || v_order.order_number || ' is ready for delivery.';
            END IF;
            v_type := 'order_ready';
        WHEN 'out_for_delivery' THEN
            v_title := '╪╖┘ä╪¿┘â ┘ü┘è ╪º┘ä╪╖╪▒┘è┘é ≡ƒÜù';
            v_body := '╪╖┘ä╪¿┘â ╪▒┘é┘à #' || v_order.order_number || ' ┘ü┘è ╪╖╪▒┘è┘é┘ç ╪Ñ┘ä┘è┘â!' || chr(10) || 'Your order #' || v_order.order_number || ' is on its way!';
            v_type := 'order_out_for_delivery';
        WHEN 'delivered' THEN
            v_title := '╪¬┘à ╪¬┘ê╪╡┘è┘ä ╪╖┘ä╪¿┘â Γ£à';
            v_body := '╪¬┘à ╪¬┘ê╪╡┘è┘ä ╪╖┘ä╪¿┘â ╪▒┘é┘à #' || v_order.order_number || ' ╪¿┘å╪¼╪º╪¡. ╪¿╪º┘ä╪╣╪º┘ü┘è╪⌐!' || chr(10) || 'Your order #' || v_order.order_number || ' has been delivered. Enjoy!';
            v_type := 'order_delivered';
        WHEN 'picked_up' THEN
            v_title := '╪¬┘à ╪º╪│╪¬┘ä╪º┘à ╪╖┘ä╪¿┘â Γ£à';
            v_body := '╪¬┘à ╪¬╪ú┘â┘è╪» ╪º╪│╪¬┘ä╪º┘à ╪╖┘ä╪¿┘â ╪▒┘é┘à #' || v_order.order_number || '. ╪┤┘â╪▒╪º┘ï ┘ä┘â!' || chr(10) || 'Your order #' || v_order.order_number || ' pickup confirmed. Thank you!';
            v_type := 'order_picked_up';
        WHEN 'cancelled' THEN
            v_title := '╪¬┘à ╪Ñ┘ä╪║╪º╪í ╪╖┘ä╪¿┘â Γ¥î';
            v_body := '╪¬┘à ╪Ñ┘ä╪║╪º╪í ╪╖┘ä╪¿┘â ╪▒┘é┘à #' || v_order.order_number || '.' || chr(10) || 'Your order #' || v_order.order_number || ' has been cancelled.';
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
-- Name: notify_erp_daily_sales_change(); Type: FUNCTION; Schema: public; Owner: -
--

