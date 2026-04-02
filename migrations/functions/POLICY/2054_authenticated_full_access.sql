CREATE POLICY authenticated_full_access ON public.task_reminder_logs USING ((auth.uid() IS NOT NULL));


--
-- Name: tasks authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

