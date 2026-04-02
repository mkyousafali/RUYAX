CREATE TRIGGER product_request_po_timestamp_update BEFORE UPDATE ON public.product_request_po FOR EACH ROW EXECUTE FUNCTION public.update_product_request_po_timestamp();


--
-- Name: product_request_st product_request_st_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

