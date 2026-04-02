CREATE POLICY authenticated_full_access ON public.flyer_templates USING ((auth.uid() IS NOT NULL));


--
-- Name: hr_departments authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

