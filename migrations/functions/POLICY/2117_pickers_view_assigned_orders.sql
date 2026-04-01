CREATE POLICY pickers_view_assigned_orders ON public.orders FOR SELECT USING (((picker_id = auth.uid()) OR public.has_order_management_access(auth.uid())));


--
-- Name: POLICY pickers_view_assigned_orders ON orders; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY pickers_view_assigned_orders ON public.orders IS 'Pickers can view orders assigned to them';


--
-- Name: pos_deduction_transfers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.pos_deduction_transfers ENABLE ROW LEVEL SECURITY;

--
-- Name: privilege_cards_branch; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.privilege_cards_branch ENABLE ROW LEVEL SECURITY;

--
-- Name: privilege_cards_master; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.privilege_cards_master ENABLE ROW LEVEL SECURITY;

--
-- Name: processed_fingerprint_transactions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.processed_fingerprint_transactions ENABLE ROW LEVEL SECURITY;

--
-- Name: product_categories; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.product_categories ENABLE ROW LEVEL SECURITY;

--
-- Name: product_request_bt; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.product_request_bt ENABLE ROW LEVEL SECURITY;

--
-- Name: product_request_po; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.product_request_po ENABLE ROW LEVEL SECURITY;

--
-- Name: product_request_st; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.product_request_st ENABLE ROW LEVEL SECURITY;

--
-- Name: product_units; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.product_units ENABLE ROW LEVEL SECURITY;

--
-- Name: products; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

--
-- Name: purchase_voucher_issue_types; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.purchase_voucher_issue_types ENABLE ROW LEVEL SECURITY;

--
-- Name: purchase_voucher_items; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.purchase_voucher_items ENABLE ROW LEVEL SECURITY;

--
-- Name: purchase_vouchers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.purchase_vouchers ENABLE ROW LEVEL SECURITY;

--
-- Name: push_subscriptions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.push_subscriptions ENABLE ROW LEVEL SECURITY;

--
-- Name: purchase_vouchers pv_authenticated_all; Type: POLICY; Schema: public; Owner: -
--

