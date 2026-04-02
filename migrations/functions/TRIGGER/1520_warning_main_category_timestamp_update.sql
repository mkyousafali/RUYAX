CREATE TRIGGER warning_main_category_timestamp_update BEFORE UPDATE ON public.warning_main_category FOR EACH ROW EXECUTE FUNCTION public.update_warning_main_category_timestamp();


--
-- Name: warning_sub_category warning_sub_category_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

