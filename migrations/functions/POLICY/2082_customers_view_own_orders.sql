CREATE POLICY customers_view_own_orders ON public.orders FOR SELECT USING (((auth.uid() = customer_id) OR public.has_order_management_access(auth.uid()) OR public.is_delivery_staff(auth.uid())));


--
-- Name: POLICY customers_view_own_orders ON orders; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY customers_view_own_orders ON public.orders IS 'Customers can view their own orders, management and delivery staff can view all';


--
-- Name: day_off; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.day_off ENABLE ROW LEVEL SECURITY;

--
-- Name: day_off_reasons; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.day_off_reasons ENABLE ROW LEVEL SECURITY;

--
-- Name: day_off_weekday; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.day_off_weekday ENABLE ROW LEVEL SECURITY;

--
-- Name: default_incident_users; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.default_incident_users ENABLE ROW LEVEL SECURITY;

--
-- Name: deleted_bundle_offers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.deleted_bundle_offers ENABLE ROW LEVEL SECURITY;

--
-- Name: delivery_fee_tiers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.delivery_fee_tiers ENABLE ROW LEVEL SECURITY;

--
-- Name: delivery_service_settings; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.delivery_service_settings ENABLE ROW LEVEL SECURITY;

--
-- Name: delivery_service_settings delivery_settings_allow_read; Type: POLICY; Schema: public; Owner: -
--

