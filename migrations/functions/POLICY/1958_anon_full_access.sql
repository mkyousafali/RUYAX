CREATE POLICY anon_full_access ON public.offer_products USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: offer_usage_logs anon_full_access; Type: POLICY; Schema: public; Owner: -
--

