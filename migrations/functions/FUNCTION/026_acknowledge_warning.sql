CREATE FUNCTION public.acknowledge_warning(warning_id_param uuid, acknowledged_by_param uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    UPDATE employee_warnings 
    SET 
        warning_status = 'acknowledged',
        acknowledged_at = CURRENT_TIMESTAMP,
        acknowledged_by = acknowledged_by_param,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = warning_id_param
    AND warning_status = 'active';
    
    RETURN FOUND;
END;
$$;


--
-- Name: adjust_product_stock_on_order_insert(); Type: FUNCTION; Schema: public; Owner: -
--

