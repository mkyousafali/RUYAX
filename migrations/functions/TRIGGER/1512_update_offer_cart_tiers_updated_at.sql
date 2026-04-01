CREATE TRIGGER update_offer_cart_tiers_updated_at BEFORE UPDATE ON public.offer_cart_tiers FOR EACH ROW EXECUTE FUNCTION public.update_offer_cart_tiers_updated_at();


--
-- Name: offer_products update_offer_products_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

