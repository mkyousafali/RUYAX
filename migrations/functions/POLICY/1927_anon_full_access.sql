CREATE POLICY anon_full_access ON public.customer_recovery_requests USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: customers anon_full_access; Type: POLICY; Schema: public; Owner: -
--

