CREATE POLICY management_update_order_items ON public.order_items FOR UPDATE USING (public.has_order_management_access(auth.uid()));


--
-- Name: orders management_update_orders; Type: POLICY; Schema: public; Owner: -
--

