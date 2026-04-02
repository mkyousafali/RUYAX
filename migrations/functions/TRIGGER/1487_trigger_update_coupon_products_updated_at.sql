CREATE TRIGGER trigger_update_coupon_products_updated_at BEFORE UPDATE ON public.coupon_products FOR EACH ROW EXECUTE FUNCTION public.update_coupon_products_updated_at();


--
-- Name: customer_recovery_requests trigger_update_customer_recovery_requests_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

