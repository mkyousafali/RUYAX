CREATE POLICY authenticated_full_access ON public.requesters USING ((auth.uid() IS NOT NULL));


--
-- Name: shelf_paper_templates authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

