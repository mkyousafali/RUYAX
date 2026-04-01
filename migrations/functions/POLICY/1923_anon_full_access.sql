CREATE POLICY anon_full_access ON public.coupon_eligible_customers USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: coupon_products anon_full_access; Type: POLICY; Schema: public; Owner: -
--

