CREATE TRIGGER multi_shift_weekday_timestamp_update BEFORE UPDATE ON public.multi_shift_weekday FOR EACH ROW EXECUTE FUNCTION public.update_multi_shift_weekday_timestamp();


--
-- Name: non_approved_payment_scheduler non_approved_scheduler_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

