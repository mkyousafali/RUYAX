CREATE POLICY authenticated_full_access ON public.offer_products USING ((auth.uid() IS NOT NULL));


--
-- Name: offer_usage_logs authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

