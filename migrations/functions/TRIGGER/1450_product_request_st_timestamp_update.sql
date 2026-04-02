CREATE TRIGGER product_request_st_timestamp_update BEFORE UPDATE ON public.product_request_st FOR EACH ROW EXECUTE FUNCTION public.update_product_request_st_timestamp();


--
-- Name: purchase_voucher_items purchase_voucher_items_updated_at_trigger; Type: TRIGGER; Schema: public; Owner: -
--

