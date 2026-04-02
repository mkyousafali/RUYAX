CREATE POLICY anon_full_access ON public.user_device_sessions USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: user_password_history anon_full_access; Type: POLICY; Schema: public; Owner: -
--

