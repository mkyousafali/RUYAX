CREATE TRIGGER multi_shift_date_wise_timestamp_update BEFORE UPDATE ON public.multi_shift_date_wise FOR EACH ROW EXECUTE FUNCTION public.update_multi_shift_date_wise_timestamp();


--
-- Name: multi_shift_regular multi_shift_regular_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

