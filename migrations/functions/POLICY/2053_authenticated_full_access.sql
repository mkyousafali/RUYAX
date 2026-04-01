CREATE POLICY authenticated_full_access ON public.task_images USING ((auth.uid() IS NOT NULL));


--
-- Name: task_reminder_logs authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

