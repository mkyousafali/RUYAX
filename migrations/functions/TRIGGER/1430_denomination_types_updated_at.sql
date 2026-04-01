CREATE TRIGGER denomination_types_updated_at BEFORE UPDATE ON public.denomination_types FOR EACH ROW EXECUTE FUNCTION public.update_denomination_updated_at();


--
-- Name: desktop_themes desktop_themes_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

