CREATE POLICY authenticated_full_access ON public.hr_positions USING ((auth.uid() IS NOT NULL));


--
-- Name: interface_permissions authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

