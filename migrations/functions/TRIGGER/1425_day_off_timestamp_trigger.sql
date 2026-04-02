CREATE TRIGGER day_off_timestamp_trigger BEFORE UPDATE ON public.day_off FOR EACH ROW EXECUTE FUNCTION public.update_day_off_timestamp();


--
-- Name: day_off_weekday day_off_weekday_updated_at_trigger; Type: TRIGGER; Schema: public; Owner: -
--

