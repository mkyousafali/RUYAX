CREATE POLICY authenticated_full_access ON public.customers USING ((auth.uid() IS NOT NULL));


--
-- Name: deleted_bundle_offers authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

