CREATE POLICY authenticated_full_access ON public.offer_cart_tiers USING ((auth.uid() IS NOT NULL));


--
-- Name: offer_products authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

