CREATE POLICY authenticated_check_eligibility ON public.coupon_eligible_customers FOR SELECT TO authenticated USING (true);


--
-- Name: coupon_claims authenticated_create_claims; Type: POLICY; Schema: public; Owner: -
--

