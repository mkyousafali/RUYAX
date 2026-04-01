CREATE POLICY authenticated_full_access ON public.order_audit_logs USING ((auth.uid() IS NOT NULL));


--
-- Name: order_items authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

