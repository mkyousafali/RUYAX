CREATE TRIGGER product_request_bt_timestamp_update BEFORE UPDATE ON public.product_request_bt FOR EACH ROW EXECUTE FUNCTION public.update_product_request_bt_timestamp();


--
-- Name: product_request_po product_request_po_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

