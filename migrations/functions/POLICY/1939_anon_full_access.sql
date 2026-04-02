CREATE POLICY anon_full_access ON public.flyer_offer_products USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: flyer_offers anon_full_access; Type: POLICY; Schema: public; Owner: -
--

