CREATE POLICY management_view_all_audit_logs ON public.order_audit_logs FOR SELECT USING (public.has_order_management_access(auth.uid()));


--
-- Name: orders management_view_all_orders; Type: POLICY; Schema: public; Owner: -
--

