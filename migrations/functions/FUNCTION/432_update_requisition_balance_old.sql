CREATE FUNCTION public.update_requisition_balance_old() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Handle the old requisition_id if it exists and is different
  IF OLD.requisition_id IS NOT NULL AND (TG_OP = 'DELETE' OR OLD.requisition_id != NEW.requisition_id) THEN
    UPDATE public.expense_requisitions
    SET 
      used_amount = (
        SELECT COALESCE(SUM(amount), 0)
        FROM public.expense_scheduler
        WHERE requisition_id = OLD.requisition_id
          AND status != 'cancelled'
      ),
      remaining_balance = amount - (
        SELECT COALESCE(SUM(amount), 0)
        FROM public.expense_scheduler
        WHERE requisition_id = OLD.requisition_id
          AND status != 'cancelled'
      ),
      updated_at = now()
    WHERE id = OLD.requisition_id;
  END IF;
  
  RETURN COALESCE(NEW, OLD);
END;
$$;


--
-- Name: update_social_links_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

