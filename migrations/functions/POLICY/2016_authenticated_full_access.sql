CREATE POLICY authenticated_full_access ON public.hr_departments USING ((auth.uid() IS NOT NULL));


--
-- Name: hr_employee_master authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

