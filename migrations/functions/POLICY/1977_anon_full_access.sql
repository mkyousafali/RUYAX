CREATE POLICY anon_full_access ON public.task_assignments USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: task_completions anon_full_access; Type: POLICY; Schema: public; Owner: -
--

