CREATE POLICY anon_full_access ON public.user_sessions USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: users anon_full_access; Type: POLICY; Schema: public; Owner: -
--

