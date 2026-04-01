CREATE POLICY customer_recovery_requests_update_policy ON public.customer_recovery_requests FOR UPDATE USING (true);


--
-- Name: customers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;

--
-- Name: orders customers_create_orders; Type: POLICY; Schema: public; Owner: -
--

