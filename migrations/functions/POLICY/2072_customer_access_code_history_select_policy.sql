CREATE POLICY customer_access_code_history_select_policy ON public.customer_access_code_history FOR SELECT USING (true);


--
-- Name: customer_app_media; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.customer_app_media ENABLE ROW LEVEL SECURITY;

--
-- Name: customer_product_requests; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.customer_product_requests ENABLE ROW LEVEL SECURITY;

--
-- Name: customer_recovery_requests; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.customer_recovery_requests ENABLE ROW LEVEL SECURITY;

--
-- Name: customer_recovery_requests customer_recovery_requests_delete_policy; Type: POLICY; Schema: public; Owner: -
--

