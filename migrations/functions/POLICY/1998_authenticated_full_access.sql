CREATE POLICY authenticated_full_access ON public.coupon_products USING ((auth.uid() IS NOT NULL));


--
-- Name: customer_access_code_history authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

