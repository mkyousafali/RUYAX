CREATE POLICY realtime_access_code_history_select ON public.customer_access_code_history FOR SELECT TO authenticated, anon USING (true);


--
-- Name: customers realtime_customers_select; Type: POLICY; Schema: public; Owner: -
--

