CREATE TRIGGER warning_sub_category_timestamp_update BEFORE UPDATE ON public.warning_sub_category FOR EACH ROW EXECUTE FUNCTION public.update_warning_sub_category_timestamp();


--
-- Name: warning_violation warning_violation_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

