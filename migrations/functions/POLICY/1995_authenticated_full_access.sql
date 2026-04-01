CREATE POLICY authenticated_full_access ON public.coupon_campaigns USING ((auth.uid() IS NOT NULL));


--
-- Name: coupon_claims authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

