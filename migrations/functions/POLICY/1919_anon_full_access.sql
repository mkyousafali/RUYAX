CREATE POLICY anon_full_access ON public.biometric_connections USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: bogo_offer_rules anon_full_access; Type: POLICY; Schema: public; Owner: -
--

