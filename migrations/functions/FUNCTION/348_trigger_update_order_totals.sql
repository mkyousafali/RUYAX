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
-- Name: FUNCTION trigger_update_order_totals(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.trigger_update_order_totals() IS 'Recalculates order item counts when order_items change';


--
-- Name: update_ai_chat_guide_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

