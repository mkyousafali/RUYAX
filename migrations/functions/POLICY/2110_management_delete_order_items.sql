CREATE POLICY management_delete_order_items ON public.order_items FOR DELETE USING (public.has_order_management_access(auth.uid()));


--
-- Name: order_items management_update_order_items; Type: POLICY; Schema: public; Owner: -
--

