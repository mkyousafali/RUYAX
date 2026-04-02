CREATE POLICY delivery_update_assigned_orders ON public.orders FOR UPDATE USING (((delivery_person_id = auth.uid()) OR public.is_delivery_staff(auth.uid()))) WITH CHECK ((((delivery_person_id = auth.uid()) OR public.is_delivery_staff(auth.uid())) AND ((order_status)::text = ANY (ARRAY[('out_for_delivery'::character varying)::text, ('delivered'::character varying)::text]))));


--
-- Name: orders delivery_view_assigned_orders; Type: POLICY; Schema: public; Owner: -
--

