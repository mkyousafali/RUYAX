CREATE POLICY users_view_order_audit_logs ON public.order_audit_logs FOR SELECT USING ((order_id IN ( SELECT orders.id
   FROM public.orders
  WHERE ((orders.customer_id = auth.uid()) OR (orders.picker_id = auth.uid()) OR (orders.delivery_person_id = auth.uid()) OR public.has_order_management_access(auth.uid()) OR public.is_delivery_staff(auth.uid())))));


--
-- Name: POLICY users_view_order_audit_logs ON order_audit_logs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY users_view_order_audit_logs ON public.order_audit_logs IS 'Users can view audit logs for their orders';


--
-- Name: order_items users_view_order_items; Type: POLICY; Schema: public; Owner: -
--

