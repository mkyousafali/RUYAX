CREATE POLICY anon_full_access ON public.receiving_tasks USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: recurring_assignment_schedules anon_full_access; Type: POLICY; Schema: public; Owner: -
--

