CREATE MATERIALIZED VIEW public.mv_expiry_products AS
 SELECT ((entry.value ->> 'branch_id'::text))::integer AS branch_id,
    p.barcode,
    p.product_name_en,
    p.product_name_ar,
    ((entry.value ->> 'expiry_date'::text))::date AS expiry_date,
    (((entry.value ->> 'expiry_date'::text))::date - CURRENT_DATE) AS days_left,
    p.managed_by,
    p.expiry_hidden
   FROM public.erp_synced_products p,
    LATERAL jsonb_array_elements(p.expiry_dates) entry(value)
  WHERE ((jsonb_array_length(p.expiry_dates) > 0) AND ((entry.value ->> 'expiry_date'::text) IS NOT NULL) AND ((entry.value ->> 'branch_id'::text) IS NOT NULL))
  WITH NO DATA;


--
-- Name: nationalities; Type: TABLE; Schema: public; Owner: -
--

