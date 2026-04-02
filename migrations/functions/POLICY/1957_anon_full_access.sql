CREATE POLICY anon_full_access ON public.offer_cart_tiers USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: offer_products anon_full_access; Type: POLICY; Schema: public; Owner: -
--

