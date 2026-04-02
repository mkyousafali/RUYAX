CREATE POLICY authenticated_full_access ON public.customer_access_code_history USING ((auth.uid() IS NOT NULL));


--
-- Name: customer_app_media authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

