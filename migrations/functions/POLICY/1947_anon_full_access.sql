CREATE POLICY anon_full_access ON public.hr_position_assignments USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: hr_position_reporting_template anon_full_access; Type: POLICY; Schema: public; Owner: -
--

