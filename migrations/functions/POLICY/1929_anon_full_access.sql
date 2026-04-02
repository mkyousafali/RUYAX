CREATE POLICY anon_full_access ON public.deleted_bundle_offers USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: delivery_fee_tiers anon_full_access; Type: POLICY; Schema: public; Owner: -
--

