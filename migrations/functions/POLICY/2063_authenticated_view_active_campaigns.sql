CREATE POLICY authenticated_view_active_campaigns ON public.coupon_campaigns FOR SELECT TO authenticated USING (((is_active = true) AND (deleted_at IS NULL)));


--
-- Name: coupon_products authenticated_view_active_products; Type: POLICY; Schema: public; Owner: -
--

