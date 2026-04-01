CREATE TRIGGER special_shift_date_wise_timestamp_trigger BEFORE UPDATE ON public.special_shift_date_wise FOR EACH ROW EXECUTE FUNCTION public.update_special_shift_date_wise_timestamp();


--
-- Name: special_shift_weekday special_shift_weekday_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

