CREATE TRIGGER trigger_update_delivery_tiers_timestamp BEFORE UPDATE ON public.delivery_fee_tiers FOR EACH ROW EXECUTE FUNCTION public.update_delivery_tiers_timestamp();


--
-- Name: flyer_templates trigger_update_flyer_templates_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

