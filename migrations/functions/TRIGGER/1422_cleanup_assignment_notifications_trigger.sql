CREATE TRIGGER cleanup_assignment_notifications_trigger AFTER DELETE ON public.task_assignments FOR EACH ROW EXECUTE FUNCTION public.trigger_cleanup_assignment_notifications();


--
-- Name: tasks cleanup_task_notifications_trigger; Type: TRIGGER; Schema: public; Owner: -
--

