CREATE POLICY authenticated_view_active_products ON public.coupon_products FOR SELECT TO authenticated USING (((is_active = true) AND (deleted_at IS NULL)));


--
-- Name: bank_reconciliations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.bank_reconciliations ENABLE ROW LEVEL SECURITY;

--
-- Name: biometric_connections; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.biometric_connections ENABLE ROW LEVEL SECURITY;

--
-- Name: bogo_offer_rules; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.bogo_offer_rules ENABLE ROW LEVEL SECURITY;

--
-- Name: box_operations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.box_operations ENABLE ROW LEVEL SECURITY;

--
-- Name: box_operations box_operations_delete; Type: POLICY; Schema: public; Owner: -
--

