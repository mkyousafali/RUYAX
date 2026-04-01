CREATE POLICY authenticated_full_access ON public.notifications USING ((auth.uid() IS NOT NULL));


--
-- Name: offer_bundles authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

