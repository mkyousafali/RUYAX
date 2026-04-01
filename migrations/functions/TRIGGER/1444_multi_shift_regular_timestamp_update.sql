CREATE TRIGGER multi_shift_regular_timestamp_update BEFORE UPDATE ON public.multi_shift_regular FOR EACH ROW EXECUTE FUNCTION public.update_multi_shift_regular_timestamp();


--
-- Name: multi_shift_weekday multi_shift_weekday_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

