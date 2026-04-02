CREATE POLICY realtime_customers_select ON public.customers FOR SELECT TO authenticated, anon USING (true);


--
-- Name: wa_messages realtime_wa_messages_select; Type: POLICY; Schema: public; Owner: -
--

