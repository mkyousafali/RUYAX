CREATE POLICY anon_full_access ON public.hr_position_reporting_template USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: hr_positions anon_full_access; Type: POLICY; Schema: public; Owner: -
--

