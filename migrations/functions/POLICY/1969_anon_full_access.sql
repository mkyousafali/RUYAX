CREATE POLICY anon_full_access ON public.quick_task_user_preferences USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: quick_tasks anon_full_access; Type: POLICY; Schema: public; Owner: -
--

