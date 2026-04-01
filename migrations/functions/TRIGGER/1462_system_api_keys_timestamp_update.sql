CREATE TRIGGER system_api_keys_timestamp_update BEFORE UPDATE ON public.system_api_keys FOR EACH ROW EXECUTE FUNCTION public.update_system_api_keys_timestamp();


--
-- Name: customer_app_media track_media_activation; Type: TRIGGER; Schema: public; Owner: -
--

