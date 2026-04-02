CREATE POLICY allow_update ON public.deleted_bundle_offers FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: delivery_fee_tiers allow_update; Type: POLICY; Schema: public; Owner: -
--

