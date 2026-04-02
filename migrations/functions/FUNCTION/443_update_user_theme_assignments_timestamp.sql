CREATE FUNCTION public.update_user_theme_assignments_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;


--
-- Name: update_vendor_payment_with_exact_calculation(uuid, numeric, numeric, numeric, text, text, text, text, text, jsonb); Type: FUNCTION; Schema: public; Owner: -
--

