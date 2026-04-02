CREATE FUNCTION public.update_hr_employee_master_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;


--
-- Name: update_interface_permissions_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

