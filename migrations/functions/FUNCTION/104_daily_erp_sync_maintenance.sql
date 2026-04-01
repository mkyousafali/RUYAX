CREATE FUNCTION public.daily_erp_sync_maintenance() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    sync_result RECORD;
    result_text TEXT;
BEGIN
    -- Run the sync function
    SELECT * INTO sync_result FROM sync_all_missing_erp_references();
    
    result_text := format('Daily ERP sync maintenance completed: %s records synced', 
                         sync_result.synced_count);
    
    IF sync_result.synced_count > 0 THEN
        result_text := result_text || format('. Details: %s', sync_result.details);
    END IF;
    
    RETURN result_text;
END;
$$;


--
-- Name: deactivate_expired_media(); Type: FUNCTION; Schema: public; Owner: -
--

