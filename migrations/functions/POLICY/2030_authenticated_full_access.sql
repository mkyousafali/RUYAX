CREATE POLICY authenticated_full_access ON public.offer_bundles USING ((auth.uid() IS NOT NULL));


--
-- Name: offer_cart_tiers authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

