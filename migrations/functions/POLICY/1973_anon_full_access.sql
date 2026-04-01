CREATE POLICY anon_full_access ON public.recurring_assignment_schedules USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: recurring_schedule_check_log anon_full_access; Type: POLICY; Schema: public; Owner: -
--

