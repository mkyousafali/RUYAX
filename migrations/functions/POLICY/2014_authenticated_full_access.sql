CREATE POLICY authenticated_full_access ON public.flyer_offers USING ((auth.uid() IS NOT NULL));


--
-- Name: flyer_templates authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

