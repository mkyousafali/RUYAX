CREATE POLICY anon_full_access ON public.delivery_fee_tiers USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: delivery_service_settings anon_full_access; Type: POLICY; Schema: public; Owner: -
--

