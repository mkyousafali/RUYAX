CREATE FUNCTION public.notify_branches_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM pg_notify(
        'branches_changed',
        json_build_object(
            'operation', TG_OP,
            'id', COALESCE(NEW.id, OLD.id),
            'timestamp', NOW()
        )::text
    );
    RETURN COALESCE(NEW, OLD);
END;
$$;


--
-- Name: notify_customer_order_status_change(); Type: FUNCTION; Schema: public; Owner: -
--

