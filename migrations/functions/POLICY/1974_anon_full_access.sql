CREATE POLICY anon_full_access ON public.recurring_schedule_check_log USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: requesters anon_full_access; Type: POLICY; Schema: public; Owner: -
--

