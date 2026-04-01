CREATE POLICY anon_full_access ON public.task_images USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: task_reminder_logs anon_full_access; Type: POLICY; Schema: public; Owner: -
--

