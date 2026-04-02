CREATE POLICY authenticated_full_access ON public.offer_usage_logs USING ((auth.uid() IS NOT NULL));


--
-- Name: order_audit_logs authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

