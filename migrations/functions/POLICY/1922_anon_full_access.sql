CREATE POLICY anon_full_access ON public.coupon_claims USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: coupon_eligible_customers anon_full_access; Type: POLICY; Schema: public; Owner: -
--

