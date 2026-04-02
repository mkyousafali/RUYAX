CREATE POLICY anon_full_access ON public.approval_permissions USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: biometric_connections anon_full_access; Type: POLICY; Schema: public; Owner: -
--

