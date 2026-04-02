CREATE POLICY authenticated_full_access ON public.coupon_claims USING ((auth.uid() IS NOT NULL));


--
-- Name: coupon_eligible_customers authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

