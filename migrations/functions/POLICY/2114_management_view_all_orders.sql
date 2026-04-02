CREATE POLICY management_view_all_orders ON public.orders FOR SELECT USING ((public.has_order_management_access(auth.uid()) OR (picker_id = auth.uid()) OR (delivery_person_id = auth.uid())));


--
-- Name: POLICY management_view_all_orders ON orders; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY management_view_all_orders ON public.orders IS 'Management, pickers, and delivery staff can view orders';


--
-- Name: mobile_themes; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.mobile_themes ENABLE ROW LEVEL SECURITY;

--
-- Name: multi_shift_date_wise; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.multi_shift_date_wise ENABLE ROW LEVEL SECURITY;

--
-- Name: multi_shift_regular; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.multi_shift_regular ENABLE ROW LEVEL SECURITY;

--
-- Name: multi_shift_weekday; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.multi_shift_weekday ENABLE ROW LEVEL SECURITY;

--
-- Name: nationalities; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.nationalities ENABLE ROW LEVEL SECURITY;

--
-- Name: near_expiry_reports; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.near_expiry_reports ENABLE ROW LEVEL SECURITY;

--
-- Name: non_approved_payment_scheduler; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.non_approved_payment_scheduler ENABLE ROW LEVEL SECURITY;

--
-- Name: notification_attachments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.notification_attachments ENABLE ROW LEVEL SECURITY;

--
-- Name: notification_read_states; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.notification_read_states ENABLE ROW LEVEL SECURITY;

--
-- Name: notification_recipients; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.notification_recipients ENABLE ROW LEVEL SECURITY;

--
-- Name: notifications; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

--
-- Name: offer_bundles; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.offer_bundles ENABLE ROW LEVEL SECURITY;

--
-- Name: offer_cart_tiers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.offer_cart_tiers ENABLE ROW LEVEL SECURITY;

--
-- Name: offer_names; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.offer_names ENABLE ROW LEVEL SECURITY;

--
-- Name: offer_products; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.offer_products ENABLE ROW LEVEL SECURITY;

--
-- Name: offer_usage_logs; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.offer_usage_logs ENABLE ROW LEVEL SECURITY;

--
-- Name: offers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.offers ENABLE ROW LEVEL SECURITY;

--
-- Name: official_holidays; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.official_holidays ENABLE ROW LEVEL SECURITY;

--
-- Name: order_audit_logs; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.order_audit_logs ENABLE ROW LEVEL SECURITY;

--
-- Name: order_items; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.order_items ENABLE ROW LEVEL SECURITY;

--
-- Name: orders; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;

--
-- Name: overtime_registrations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.overtime_registrations ENABLE ROW LEVEL SECURITY;

--
-- Name: overtime_registrations overtime_registrations_all; Type: POLICY; Schema: public; Owner: -
--

