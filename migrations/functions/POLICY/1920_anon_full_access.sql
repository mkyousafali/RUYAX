CREATE POLICY anon_full_access ON public.bogo_offer_rules USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: coupon_campaigns anon_full_access; Type: POLICY; Schema: public; Owner: -
--

