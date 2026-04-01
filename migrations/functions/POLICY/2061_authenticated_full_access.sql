CREATE POLICY authenticated_full_access ON public.variation_audit_log USING ((auth.uid() IS NOT NULL));


--
-- Name: view_offer authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

