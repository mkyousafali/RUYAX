CREATE POLICY anon_full_access ON public.customers USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: deleted_bundle_offers anon_full_access; Type: POLICY; Schema: public; Owner: -
--

