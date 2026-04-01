CREATE POLICY authenticated_full_access ON public.hr_position_assignments USING ((auth.uid() IS NOT NULL));


--
-- Name: hr_position_reporting_template authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

