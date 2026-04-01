CREATE POLICY anon_full_access ON public.erp_connections USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: erp_daily_sales anon_full_access; Type: POLICY; Schema: public; Owner: -
--

