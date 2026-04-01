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
-- Name: FUNCTION trigger_log_order_offer_usage(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.trigger_log_order_offer_usage() IS 'Links offer usage logs to orders for tracking';


--
-- Name: trigger_notify_new_order(); Type: FUNCTION; Schema: public; Owner: -
--

