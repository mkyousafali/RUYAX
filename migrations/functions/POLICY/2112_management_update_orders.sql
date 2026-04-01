CREATE POLICY management_update_orders ON public.orders FOR UPDATE USING (public.has_order_management_access(auth.uid()));


--
-- Name: order_audit_logs management_view_all_audit_logs; Type: POLICY; Schema: public; Owner: -
--

