CREATE POLICY anon_full_access ON public.tasks USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: user_audit_logs anon_full_access; Type: POLICY; Schema: public; Owner: -
--

