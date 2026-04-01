CREATE TRIGGER day_off_weekday_updated_at_trigger BEFORE UPDATE ON public.day_off_weekday FOR EACH ROW EXECUTE FUNCTION public.update_day_off_weekday_updated_at();


--
-- Name: denomination_records denomination_records_audit; Type: TRIGGER; Schema: public; Owner: -
--

