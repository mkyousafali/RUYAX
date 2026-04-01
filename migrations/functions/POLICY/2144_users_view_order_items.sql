CREATE POLICY users_view_order_items ON public.order_items FOR SELECT USING ((order_id IN ( SELECT orders.id
   FROM public.orders
  WHERE ((orders.customer_id = auth.uid()) OR (orders.picker_id = auth.uid()) OR (orders.delivery_person_id = auth.uid()) OR public.has_order_management_access(auth.uid()) OR public.is_delivery_staff(auth.uid())))));


--
-- Name: POLICY users_view_order_items ON order_items; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY users_view_order_items ON public.order_items IS 'Users can view items for orders they have access to';


--
-- Name: variation_audit_log; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.variation_audit_log ENABLE ROW LEVEL SECURITY;

--
-- Name: vendor_payment_schedule; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.vendor_payment_schedule ENABLE ROW LEVEL SECURITY;

--
-- Name: vendor_payment_schedule vendor_payment_schedule_delete; Type: POLICY; Schema: public; Owner: -
--

