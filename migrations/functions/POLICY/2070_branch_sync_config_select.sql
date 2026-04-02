CREATE POLICY branch_sync_config_select ON public.branch_sync_config FOR SELECT TO authenticated USING (true);


--
-- Name: branches; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.branches ENABLE ROW LEVEL SECURITY;

--
-- Name: break_reasons; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.break_reasons ENABLE ROW LEVEL SECURITY;

--
-- Name: break_register; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.break_register ENABLE ROW LEVEL SECURITY;

--
-- Name: break_security_seed; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.break_security_seed ENABLE ROW LEVEL SECURITY;

--
-- Name: button_main_sections; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.button_main_sections ENABLE ROW LEVEL SECURITY;

--
-- Name: button_permissions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.button_permissions ENABLE ROW LEVEL SECURITY;

--
-- Name: button_sub_sections; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.button_sub_sections ENABLE ROW LEVEL SECURITY;

--
-- Name: coupon_campaigns; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.coupon_campaigns ENABLE ROW LEVEL SECURITY;

--
-- Name: coupon_claims; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.coupon_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: coupon_eligible_customers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.coupon_eligible_customers ENABLE ROW LEVEL SECURITY;

--
-- Name: coupon_products; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.coupon_products ENABLE ROW LEVEL SECURITY;

--
-- Name: customer_access_code_history; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.customer_access_code_history ENABLE ROW LEVEL SECURITY;

--
-- Name: customer_access_code_history customer_access_code_history_insert_policy; Type: POLICY; Schema: public; Owner: -
--

