CREATE TRIGGER trigger_update_offer_bundles_updated_at BEFORE UPDATE ON public.offer_bundles FOR EACH ROW EXECUTE FUNCTION public.update_offers_updated_at();


--
-- Name: offers trigger_update_offers_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

