CREATE POLICY allow_update ON public.order_items FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: orders allow_update; Type: POLICY; Schema: public; Owner: -
--

