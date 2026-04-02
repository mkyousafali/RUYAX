CREATE TRIGGER official_holidays_timestamp_trigger BEFORE UPDATE ON public.official_holidays FOR EACH ROW EXECUTE FUNCTION public.update_official_holidays_timestamp();


--
-- Name: product_request_bt product_request_bt_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

