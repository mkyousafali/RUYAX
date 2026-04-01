CREATE POLICY authenticated_full_access ON public.delivery_fee_tiers USING ((auth.uid() IS NOT NULL));


--
-- Name: delivery_service_settings authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

