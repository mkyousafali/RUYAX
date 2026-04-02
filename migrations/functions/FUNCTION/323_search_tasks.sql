CREATE FUNCTION public.search_tasks(search_query text, user_id_param text DEFAULT NULL::text, limit_param integer DEFAULT 50, offset_param integer DEFAULT 0) RETURNS TABLE(id uuid, title text, description text, require_task_finished boolean, require_photo_upload boolean, require_erp_reference boolean, can_escalate boolean, can_reassign boolean, created_by text, created_by_name text, status text, priority text, created_at timestamp with time zone, updated_at timestamp with time zone, due_date date, due_time time without time zone, rank real)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        t.id, t.title, t.description, t.require_task_finished, t.require_photo_upload, t.require_erp_reference,
        t.can_escalate, t.can_reassign, t.created_by, t.created_by_name, t.status, t.priority,
        t.created_at, t.updated_at, t.due_date, t.due_time,
        ts_rank(t.search_vector, plainto_tsquery('english', search_query)) as rank
    FROM public.tasks t
    WHERE t.deleted_at IS NULL
    AND (
        search_query IS NULL 
        OR search_query = '' 
        OR t.search_vector @@ plainto_tsquery('english', search_query)
        OR t.title ILIKE '%' || search_query || '%'
        OR t.description ILIKE '%' || search_query || '%'
    )
    ORDER BY 
        CASE WHEN search_query IS NOT NULL AND search_query != '' 
        THEN ts_rank(t.search_vector, plainto_tsquery('english', search_query)) 
        ELSE 0 END DESC,
        t.created_at DESC
    LIMIT limit_param OFFSET offset_param;
END;
$$;


--
-- Name: search_tasks(text, text, uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

