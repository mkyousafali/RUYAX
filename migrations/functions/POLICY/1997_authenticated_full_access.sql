CREATE POLICY authenticated_full_access ON public.coupon_eligible_customers USING ((auth.uid() IS NOT NULL));


--
-- Name: coupon_products authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

