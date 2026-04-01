CREATE TRIGGER update_customer_app_media_timestamp BEFORE UPDATE ON public.customer_app_media FOR EACH ROW EXECUTE FUNCTION public.update_customer_app_media_timestamp();


--
-- Name: erp_connections update_erp_connections_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

