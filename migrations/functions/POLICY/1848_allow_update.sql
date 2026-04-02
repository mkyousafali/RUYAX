CREATE POLICY allow_update ON public.coupon_eligible_customers FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: coupon_products allow_update; Type: POLICY; Schema: public; Owner: -
--

