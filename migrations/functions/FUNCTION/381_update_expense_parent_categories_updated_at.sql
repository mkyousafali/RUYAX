CREATE FUNCTION public.update_expense_parent_categories_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: update_expense_scheduler_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

