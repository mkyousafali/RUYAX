CREATE FUNCTION public.generate_insurance_company_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  max_id INTEGER;
  new_id VARCHAR(15);
BEGIN
  -- Extract the numeric part from the last ID and increment it
  SELECT COALESCE(MAX(CAST(SUBSTRING(id, 4) AS INTEGER)), 0) + 1
  INTO max_id
  FROM hr_insurance_companies
  WHERE id LIKE 'INC%';
  
  -- Format as INC001, INC002, etc.
  new_id := 'INC' || LPAD(max_id::TEXT, 3, '0');
  NEW.id := new_id;
  
  RETURN NEW;
END;
$$;


--
-- Name: generate_new_customer_access_code(uuid, uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

