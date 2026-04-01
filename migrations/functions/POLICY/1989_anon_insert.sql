CREATE POLICY anon_insert ON public.access_code_otp FOR INSERT TO anon WITH CHECK (true);


--
-- Name: app_icons; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.app_icons ENABLE ROW LEVEL SECURITY;

--
-- Name: approval_permissions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.approval_permissions ENABLE ROW LEVEL SECURITY;

--
-- Name: approver_branch_access; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.approver_branch_access ENABLE ROW LEVEL SECURITY;

--
-- Name: approver_visibility_config; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.approver_visibility_config ENABLE ROW LEVEL SECURITY;

--
-- Name: asset_main_categories; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.asset_main_categories ENABLE ROW LEVEL SECURITY;

--
-- Name: asset_sub_categories; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.asset_sub_categories ENABLE ROW LEVEL SECURITY;

--
-- Name: assets; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.assets ENABLE ROW LEVEL SECURITY;

--
-- Name: coupon_eligible_customers authenticated_check_eligibility; Type: POLICY; Schema: public; Owner: -
--

