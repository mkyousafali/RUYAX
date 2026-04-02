CREATE TRIGGER trigger_update_offers_updated_at BEFORE UPDATE ON public.offers FOR EACH ROW EXECUTE FUNCTION public.update_offers_updated_at();


--
-- Name: pos_deduction_transfers trigger_update_pos_deduction_transfers_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

