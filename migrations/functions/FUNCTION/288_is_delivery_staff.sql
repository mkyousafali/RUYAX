CREATE FUNCTION public.is_delivery_staff(user_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM users u
        LEFT JOIN user_roles ur ON u.position_id::text = ur.role_code
        WHERE u.id = user_id
        AND ur.role_code IN ('DELIVERY_STAFF', 'DRIVER')
    );
END;
$$;


--
-- Name: FUNCTION is_delivery_staff(user_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.is_delivery_staff(user_id uuid) IS 'Check if user is delivery staff (Delivery Staff, Driver)';


--
-- Name: is_overnight_shift(time without time zone, time without time zone); Type: FUNCTION; Schema: public; Owner: -
--

