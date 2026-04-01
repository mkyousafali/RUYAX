CREATE POLICY authenticated_full_access ON public.hr_levels USING ((auth.uid() IS NOT NULL));


--
-- Name: hr_position_assignments authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

