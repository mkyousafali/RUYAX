CREATE POLICY authenticated_full_access ON public.bogo_offer_rules USING ((auth.uid() IS NOT NULL));


--
-- Name: coupon_campaigns authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

