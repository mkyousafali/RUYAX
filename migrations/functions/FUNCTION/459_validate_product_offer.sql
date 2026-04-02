CREATE FUNCTION public.validate_product_offer(p_offer_id integer, p_product_id uuid, p_quantity integer) RETURNS boolean
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
  v_offer_qty INTEGER;
  v_is_active BOOLEAN;
  v_start_date TIMESTAMPTZ;
  v_end_date TIMESTAMPTZ;
BEGIN
  SELECT 
    op.offer_qty,
    o.is_active,
    o.start_date,
    o.end_date
  INTO 
    v_offer_qty,
    v_is_active,
    v_start_date,
    v_end_date
  FROM offer_products op
  INNER JOIN offers o ON op.offer_id = o.id
  WHERE op.offer_id = p_offer_id 
    AND op.product_id = p_product_id;
  
  IF NOT FOUND THEN
    RETURN FALSE;
  END IF;
  
  IF NOT v_is_active THEN
    RETURN FALSE;
  END IF;
  
  IF NOW() < v_start_date OR NOW() > v_end_date THEN
    RETURN FALSE;
  END IF;
  
  IF p_quantity < v_offer_qty THEN
    RETURN FALSE;
  END IF;
  
  RETURN TRUE;
END;
$$;


--
-- Name: FUNCTION validate_product_offer(p_offer_id integer, p_product_id uuid, p_quantity integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.validate_product_offer(p_offer_id integer, p_product_id uuid, p_quantity integer) IS 'Validate if product offer can be applied';


--
-- Name: validate_task_completion_requirements(uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

