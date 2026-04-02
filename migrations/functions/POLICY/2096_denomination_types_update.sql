CREATE POLICY denomination_types_update ON public.denomination_types FOR UPDATE USING (true);


--
-- Name: desktop_themes; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.desktop_themes ENABLE ROW LEVEL SECURITY;

--
-- Name: employee_checklist_assignments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.employee_checklist_assignments ENABLE ROW LEVEL SECURITY;

--
-- Name: employee_fine_payments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.employee_fine_payments ENABLE ROW LEVEL SECURITY;

--
-- Name: employee_official_holidays; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.employee_official_holidays ENABLE ROW LEVEL SECURITY;

--
-- Name: erp_connections; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.erp_connections ENABLE ROW LEVEL SECURITY;

--
-- Name: erp_daily_sales; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.erp_daily_sales ENABLE ROW LEVEL SECURITY;

--
-- Name: erp_sync_logs; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.erp_sync_logs ENABLE ROW LEVEL SECURITY;

--
-- Name: erp_synced_products; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.erp_synced_products ENABLE ROW LEVEL SECURITY;

--
-- Name: expense_parent_categories; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.expense_parent_categories ENABLE ROW LEVEL SECURITY;

--
-- Name: expense_requisitions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.expense_requisitions ENABLE ROW LEVEL SECURITY;

--
-- Name: expense_scheduler; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.expense_scheduler ENABLE ROW LEVEL SECURITY;

--
-- Name: expense_sub_categories; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.expense_sub_categories ENABLE ROW LEVEL SECURITY;

--
-- Name: flyer_offer_products; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.flyer_offer_products ENABLE ROW LEVEL SECURITY;

--
-- Name: flyer_offer_products flyer_offer_products_delete_policy; Type: POLICY; Schema: public; Owner: -
--

