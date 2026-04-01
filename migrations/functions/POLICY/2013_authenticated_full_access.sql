CREATE POLICY authenticated_full_access ON public.flyer_offer_products USING ((auth.uid() IS NOT NULL));


--
-- Name: flyer_offers authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

