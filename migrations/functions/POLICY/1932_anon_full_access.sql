CREATE POLICY anon_full_access ON public.employee_fine_payments USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: erp_connections anon_full_access; Type: POLICY; Schema: public; Owner: -
--

