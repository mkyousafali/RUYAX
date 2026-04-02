CREATE FUNCTION public.update_requisition_balance() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Only update if requisition_id is not null
  IF NEW.requisition_id IS NOT NULL THEN
    -- Update the expense_requisitions table
    UPDATE public.expense_requisitions
    SET 
      used_amount = (
        SELECT COALESCE(SUM(amount), 0)
        FROM public.expense_scheduler
        WHERE requisition_id = NEW.requisition_id
          AND status != 'cancelled'
      ),
      remaining_balance = amount - (
        SELECT COALESCE(SUM(amount), 0)
        FROM public.expense_scheduler
        WHERE requisition_id = NEW.requisition_id
          AND status != 'cancelled'
      ),
      updated_at = now()
    WHERE id = NEW.requisition_id;
  END IF;
  
  RETURN NEW;
END;
$$;


--
-- Name: update_requisition_balance_old(); Type: FUNCTION; Schema: public; Owner: -
--

