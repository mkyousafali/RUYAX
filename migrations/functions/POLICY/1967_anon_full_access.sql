CREATE POLICY anon_full_access ON public.quick_task_completions USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: quick_task_files anon_full_access; Type: POLICY; Schema: public; Owner: -
--

