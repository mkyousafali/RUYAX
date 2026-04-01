CREATE TRIGGER update_erp_connections_updated_at BEFORE UPDATE ON public.erp_connections FOR EACH ROW EXECUTE FUNCTION public.update_erp_connections_updated_at();


--
-- Name: erp_daily_sales update_erp_daily_sales_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

