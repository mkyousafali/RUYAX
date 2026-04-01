CREATE POLICY authenticated_full_access ON public.delivery_service_settings USING ((auth.uid() IS NOT NULL));


--
-- Name: employee_fine_payments authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

