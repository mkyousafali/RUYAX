CREATE TRIGGER non_approved_scheduler_updated_at BEFORE UPDATE ON public.non_approved_payment_scheduler FOR EACH ROW EXECUTE FUNCTION public.update_non_approved_scheduler_updated_at();


--
-- Name: official_holidays official_holidays_timestamp_trigger; Type: TRIGGER; Schema: public; Owner: -
--

