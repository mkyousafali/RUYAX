CREATE POLICY anon_full_access ON public.receiving_task_templates USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: receiving_tasks anon_full_access; Type: POLICY; Schema: public; Owner: -
--

