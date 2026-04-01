CREATE FUNCTION public.cleanup_expired_sessions() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Clean up expired device sessions
    UPDATE user_device_sessions
    SET is_active = false
    WHERE expires_at < NOW()
    AND is_active = true;
    
    -- Mark old push subscriptions as inactive
    UPDATE push_subscriptions
    SET is_active = false
    WHERE last_seen < NOW() - INTERVAL '30 days'
    AND is_active = true;
    
    -- Clean up old notification queue entries
    DELETE FROM notification_queue
    WHERE created_at < NOW() - INTERVAL '7 days'
    AND status IN ('sent', 'delivered', 'failed');
    
    -- Clean up old audit logs (keep last 90 days)
    DELETE FROM user_audit_logs
    WHERE created_at < NOW() - INTERVAL '90 days';
END;
$$;


--
-- Name: clear_analytics_logs(); Type: FUNCTION; Schema: public; Owner: -
--

