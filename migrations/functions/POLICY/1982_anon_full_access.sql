CREATE POLICY anon_full_access ON public.user_audit_logs USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: user_device_sessions anon_full_access; Type: POLICY; Schema: public; Owner: -
--

