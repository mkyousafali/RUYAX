CREATE FUNCTION public.update_expense_scheduler_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


--
-- Name: update_final_bill_amount_on_adjustment(); Type: FUNCTION; Schema: public; Owner: -
--

