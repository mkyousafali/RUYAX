CREATE TRIGGER trigger_update_customer_recovery_requests_updated_at BEFORE UPDATE ON public.customer_recovery_requests FOR EACH ROW EXECUTE FUNCTION public.update_customer_recovery_requests_updated_at();


--
-- Name: customers trigger_update_customers_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

