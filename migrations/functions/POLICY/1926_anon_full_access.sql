CREATE POLICY anon_full_access ON public.customer_app_media USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: customer_recovery_requests anon_full_access; Type: POLICY; Schema: public; Owner: -
--

