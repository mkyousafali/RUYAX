CREATE FUNCTION public.notify_erp_daily_sales_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM pg_notify(
        'erp_daily_sales_changed',
        json_build_object(
            'operation', TG_OP,
            'id', COALESCE(NEW.id, OLD.id),
            'sale_date', COALESCE(NEW.sale_date, OLD.sale_date),
            'timestamp', extract(epoch from now())
        )::text
    );
    RETURN COALESCE(NEW, OLD);
END;
$$;


--
-- Name: process_clearance_certificate_generation(uuid, text, uuid, text, text); Type: FUNCTION; Schema: public; Owner: -
--

