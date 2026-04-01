CREATE POLICY authenticated_full_access ON public.hr_position_reporting_template USING ((auth.uid() IS NOT NULL));


--
-- Name: hr_positions authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

