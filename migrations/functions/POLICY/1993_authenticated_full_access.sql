CREATE POLICY authenticated_full_access ON public.biometric_connections USING ((auth.uid() IS NOT NULL));


--
-- Name: bogo_offer_rules authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

