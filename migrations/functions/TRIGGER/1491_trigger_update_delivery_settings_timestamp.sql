CREATE TRIGGER trigger_update_delivery_settings_timestamp BEFORE UPDATE ON public.delivery_service_settings FOR EACH ROW EXECUTE FUNCTION public.update_delivery_tiers_timestamp();


--
-- Name: delivery_fee_tiers trigger_update_delivery_tiers_timestamp; Type: TRIGGER; Schema: public; Owner: -
--

