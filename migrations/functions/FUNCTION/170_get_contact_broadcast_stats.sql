CREATE FUNCTION public.get_contact_broadcast_stats(phone_number text) RETURNS TABLE(sent integer, delivered integer, read integer, failed integer, total integer)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $_$
  SELECT
    COALESCE(COUNT(*) FILTER (WHERE status = 'sent'), 0) as sent,
    COALESCE(COUNT(*) FILTER (WHERE status = 'delivered'), 0) as delivered,
    COALESCE(COUNT(*) FILTER (WHERE status = 'read'), 0) as read,
    COALESCE(COUNT(*) FILTER (WHERE status = 'failed'), 0) as failed,
    COUNT(*) as total
  FROM wa_broadcast_recipients
  WHERE phone_number = $1;
$_$;


--
-- Name: get_current_user_id(); Type: FUNCTION; Schema: public; Owner: -
--

