CREATE TRIGGER cleanup_task_notifications_trigger AFTER DELETE ON public.tasks FOR EACH ROW EXECUTE FUNCTION public.trigger_cleanup_task_notifications();


--
-- Name: day_off_reasons day_off_reasons_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

