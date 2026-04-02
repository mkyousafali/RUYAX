CREATE POLICY authenticated_full_access ON public.customer_app_media USING ((auth.uid() IS NOT NULL));


--
-- Name: customer_recovery_requests authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

