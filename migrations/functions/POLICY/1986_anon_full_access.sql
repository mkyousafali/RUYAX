CREATE POLICY anon_full_access ON public.users USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: variation_audit_log anon_full_access; Type: POLICY; Schema: public; Owner: -
--

