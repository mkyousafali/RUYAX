CREATE TRIGGER trigger_update_bogo_offer_rules_updated_at BEFORE UPDATE ON public.bogo_offer_rules FOR EACH ROW EXECUTE FUNCTION public.update_bogo_offer_rules_updated_at();


--
-- Name: branches trigger_update_branches_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

