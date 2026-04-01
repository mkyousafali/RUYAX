CREATE POLICY allow_update ON public.offer_usage_logs FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: order_audit_logs allow_update; Type: POLICY; Schema: public; Owner: -
--

