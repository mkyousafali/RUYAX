CREATE POLICY anon_full_access ON public.hr_positions USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: interface_permissions anon_full_access; Type: POLICY; Schema: public; Owner: -
--

