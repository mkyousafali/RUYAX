CREATE POLICY anon_full_access ON public.hr_employee_master FOR SELECT USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: hr_employees anon_full_access; Type: POLICY; Schema: public; Owner: -
--

