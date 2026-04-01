CREATE TRIGGER day_off_reasons_timestamp_update BEFORE UPDATE ON public.day_off_reasons FOR EACH ROW EXECUTE FUNCTION public.update_day_off_reasons_timestamp();


--
-- Name: day_off day_off_timestamp_trigger; Type: TRIGGER; Schema: public; Owner: -
--

