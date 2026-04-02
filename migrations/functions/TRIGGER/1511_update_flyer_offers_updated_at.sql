CREATE TRIGGER update_flyer_offers_updated_at BEFORE UPDATE ON public.flyer_offers FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: offer_cart_tiers update_offer_cart_tiers_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

