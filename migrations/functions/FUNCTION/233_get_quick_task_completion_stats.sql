CREATE FUNCTION public.get_quick_task_completion_stats() RETURNS TABLE(total_completions bigint, submitted_count bigint, verified_count bigint, rejected_count bigint, pending_review_count bigint, completions_with_photos bigint, completions_with_erp bigint, avg_verification_time interval)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*) as total_completions,
        COUNT(*) FILTER (WHERE completion_status = 'submitted') as submitted_count,
        COUNT(*) FILTER (WHERE completion_status = 'verified') as verified_count,
        COUNT(*) FILTER (WHERE completion_status = 'rejected') as rejected_count,
        COUNT(*) FILTER (WHERE completion_status = 'pending_review') as pending_review_count,
        COUNT(*) FILTER (WHERE photo_path IS NOT NULL) as completions_with_photos,
        COUNT(*) FILTER (WHERE erp_reference IS NOT NULL) as completions_with_erp,
        AVG(verified_at - created_at) FILTER (WHERE verified_at IS NOT NULL) as avg_verification_time
    FROM quick_task_completions;
END;
$$;


--
-- Name: get_receiving_records_with_details(integer, integer, text, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

