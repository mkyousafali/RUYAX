CREATE TRIGGER trigger_update_coupon_campaigns_updated_at BEFORE UPDATE ON public.coupon_campaigns FOR EACH ROW EXECUTE FUNCTION public.update_coupon_campaigns_updated_at();


--
-- Name: coupon_products trigger_update_coupon_products_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

