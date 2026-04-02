CREATE FUNCTION public.get_bt_assigned_ims(p_request_ids uuid[]) RETURNS TABLE(product_request_id uuid, assigned_to_user_id uuid)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT
        qt.product_request_id,
        qta.assigned_to_user_id
    FROM quick_tasks qt
    INNER JOIN quick_task_assignments qta ON qta.quick_task_id = qt.id
    WHERE qt.product_request_type = 'BT'
    AND qt.product_request_id = ANY(p_request_ids);
END;
$$;


--
-- Name: get_bt_requests_with_details(); Type: FUNCTION; Schema: public; Owner: -
--

