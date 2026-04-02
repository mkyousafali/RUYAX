CREATE POLICY authenticated_full_access ON public.employee_fine_payments USING ((auth.uid() IS NOT NULL));


--
-- Name: erp_connections authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

