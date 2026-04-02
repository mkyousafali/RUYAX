CREATE POLICY anon_full_access ON public.task_reminder_logs USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: tasks anon_full_access; Type: POLICY; Schema: public; Owner: -
--

