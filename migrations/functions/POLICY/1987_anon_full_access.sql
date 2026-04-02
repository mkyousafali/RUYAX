CREATE POLICY anon_full_access ON public.variation_audit_log USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: view_offer anon_full_access; Type: POLICY; Schema: public; Owner: -
--

