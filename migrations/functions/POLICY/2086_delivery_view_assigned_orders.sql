CREATE POLICY delivery_view_assigned_orders ON public.orders FOR SELECT USING (((delivery_person_id = auth.uid()) OR public.is_delivery_staff(auth.uid()) OR public.has_order_management_access(auth.uid())));


--
-- Name: POLICY delivery_view_assigned_orders ON orders; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY delivery_view_assigned_orders ON public.orders IS 'Delivery personnel can view their assigned orders';


--
-- Name: denomination_audit_log; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.denomination_audit_log ENABLE ROW LEVEL SECURITY;

--
-- Name: denomination_audit_log denomination_audit_log_insert; Type: POLICY; Schema: public; Owner: -
--

