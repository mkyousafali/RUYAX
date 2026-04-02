CREATE POLICY anon_full_access ON public.requesters USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: shelf_paper_templates anon_full_access; Type: POLICY; Schema: public; Owner: -
--

