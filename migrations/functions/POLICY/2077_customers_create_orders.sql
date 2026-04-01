CREATE POLICY customers_create_orders ON public.orders FOR INSERT WITH CHECK ((auth.uid() = customer_id));


--
-- Name: customers customers_delete_policy; Type: POLICY; Schema: public; Owner: -
--

