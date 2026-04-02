CREATE FUNCTION public.update_receiving_records_pr_excel_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF OLD.pr_excel_file_url IS DISTINCT FROM NEW.pr_excel_file_url THEN
        NEW.updated_at = now();
    END IF;
    RETURN NEW;
END;
$$;


--
-- Name: update_receiving_records_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

