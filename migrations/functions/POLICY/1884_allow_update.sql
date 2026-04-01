CREATE POLICY allow_update ON public.order_audit_logs FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: order_items allow_update; Type: POLICY; Schema: public; Owner: -
--

