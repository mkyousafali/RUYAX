CREATE POLICY anon_full_access ON public.hr_departments USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: hr_employee_master anon_full_access; Type: POLICY; Schema: public; Owner: -
--

