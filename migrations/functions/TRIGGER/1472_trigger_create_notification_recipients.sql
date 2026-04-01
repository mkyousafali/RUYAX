CREATE TRIGGER trigger_create_notification_recipients AFTER INSERT ON public.notifications FOR EACH ROW WHEN (((new.status)::text = 'published'::text)) EXECUTE FUNCTION public.create_notification_recipients();


--
-- Name: quick_task_assignments trigger_create_quick_task_notification; Type: TRIGGER; Schema: public; Owner: -
--

