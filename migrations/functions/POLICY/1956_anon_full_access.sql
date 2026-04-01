CREATE POLICY anon_full_access ON public.offer_bundles USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: offer_cart_tiers anon_full_access; Type: POLICY; Schema: public; Owner: -
--

