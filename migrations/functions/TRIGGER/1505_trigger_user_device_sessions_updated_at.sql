CREATE TRIGGER trigger_user_device_sessions_updated_at BEFORE UPDATE ON public.user_device_sessions FOR EACH ROW EXECUTE FUNCTION public.update_user_device_sessions_updated_at();


--
-- Name: offer_bundles trigger_validate_bundle_offer_type; Type: TRIGGER; Schema: public; Owner: -
--

