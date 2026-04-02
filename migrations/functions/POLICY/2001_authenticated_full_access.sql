CREATE POLICY authenticated_full_access ON public.customer_recovery_requests USING ((auth.uid() IS NOT NULL));


--
-- Name: customers authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

