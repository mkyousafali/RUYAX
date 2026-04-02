CREATE POLICY anon_full_access ON public.quick_task_assignments USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: quick_task_comments anon_full_access; Type: POLICY; Schema: public; Owner: -
--

