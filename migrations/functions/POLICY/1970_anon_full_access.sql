CREATE POLICY anon_full_access ON public.quick_tasks USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: receiving_task_templates anon_full_access; Type: POLICY; Schema: public; Owner: -
--

