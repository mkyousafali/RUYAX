CREATE TRIGGER calculate_receiving_amounts_trigger BEFORE INSERT OR UPDATE ON public.receiving_records FOR EACH ROW EXECUTE FUNCTION public.calculate_receiving_amounts();


--
-- Name: regular_shift calculate_working_hours_trigger; Type: TRIGGER; Schema: public; Owner: -
--

