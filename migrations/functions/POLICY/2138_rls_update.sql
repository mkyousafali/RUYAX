CREATE POLICY rls_update ON public.vendors FOR UPDATE WITH CHECK (true);


--
-- Name: security_code_scroll_texts; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.security_code_scroll_texts ENABLE ROW LEVEL SECURITY;

--
-- Name: access_code_otp service_role_all; Type: POLICY; Schema: public; Owner: -
--

