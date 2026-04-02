CREATE POLICY anon_full_access ON public.coupon_campaigns USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: coupon_claims anon_full_access; Type: POLICY; Schema: public; Owner: -
--

