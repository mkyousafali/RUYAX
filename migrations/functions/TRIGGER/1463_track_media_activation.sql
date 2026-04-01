CREATE TRIGGER track_media_activation BEFORE UPDATE ON public.customer_app_media FOR EACH ROW EXECUTE FUNCTION public.track_media_activation();


--
-- Name: app_icons trg_app_icons_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

