CREATE TRIGGER trigger_update_near_expiry_reports_updated_at BEFORE UPDATE ON public.near_expiry_reports FOR EACH ROW EXECUTE FUNCTION public.update_near_expiry_reports_updated_at();


--
-- Name: offer_bundles trigger_update_offer_bundles_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

