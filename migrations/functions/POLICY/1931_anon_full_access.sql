CREATE POLICY anon_full_access ON public.delivery_service_settings USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: employee_fine_payments anon_full_access; Type: POLICY; Schema: public; Owner: -
--

