CREATE TRIGGER receiving_user_defaults_timestamp_update BEFORE UPDATE ON public.receiving_user_defaults FOR EACH ROW EXECUTE FUNCTION public.update_receiving_user_defaults_timestamp();


--
-- Name: regular_shift regular_shift_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

