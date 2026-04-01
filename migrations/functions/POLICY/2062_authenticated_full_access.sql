CREATE POLICY authenticated_full_access ON public.view_offer USING ((auth.uid() IS NOT NULL));


--
-- Name: coupon_campaigns authenticated_view_active_campaigns; Type: POLICY; Schema: public; Owner: -
--

