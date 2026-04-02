CREATE TRIGGER calculate_working_hours_trigger BEFORE INSERT OR UPDATE ON public.regular_shift FOR EACH ROW EXECUTE FUNCTION public.calculate_working_hours();


--
-- Name: task_assignments cleanup_assignment_notifications_trigger; Type: TRIGGER; Schema: public; Owner: -
--

