CREATE POLICY anon_full_access ON public.quick_task_files USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: quick_task_user_preferences anon_full_access; Type: POLICY; Schema: public; Owner: -
--

