CREATE POLICY anon_full_access ON public.quick_task_comments USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: quick_task_completions anon_full_access; Type: POLICY; Schema: public; Owner: -
--

