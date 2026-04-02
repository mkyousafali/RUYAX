CREATE POLICY anon_full_access ON public.coupon_products USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: customer_access_code_history anon_full_access; Type: POLICY; Schema: public; Owner: -
--

