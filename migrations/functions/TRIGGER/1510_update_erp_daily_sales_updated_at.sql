CREATE TRIGGER update_erp_daily_sales_updated_at BEFORE UPDATE ON public.erp_daily_sales FOR EACH ROW EXECUTE FUNCTION public.update_erp_daily_sales_updated_at();


--
-- Name: flyer_offers update_flyer_offers_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

