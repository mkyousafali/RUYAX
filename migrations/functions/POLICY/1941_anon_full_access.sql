CREATE POLICY anon_full_access ON public.flyer_templates USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: hr_departments anon_full_access; Type: POLICY; Schema: public; Owner: -
--

