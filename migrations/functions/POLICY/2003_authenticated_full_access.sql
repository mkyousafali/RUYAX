CREATE POLICY authenticated_full_access ON public.deleted_bundle_offers USING ((auth.uid() IS NOT NULL));


--
-- Name: delivery_fee_tiers authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

