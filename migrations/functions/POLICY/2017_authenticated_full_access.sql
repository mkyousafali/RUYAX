CREATE POLICY authenticated_full_access ON public.hr_employee_master FOR SELECT USING ((auth.uid() IS NOT NULL));


--
-- Name: hr_employees authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

