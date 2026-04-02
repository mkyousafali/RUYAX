CREATE POLICY anon_full_access ON public.offer_usage_logs USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: order_audit_logs anon_full_access; Type: POLICY; Schema: public; Owner: -
--

