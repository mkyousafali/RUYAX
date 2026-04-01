CREATE POLICY anon_full_access ON public.notification_read_states USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: notification_recipients anon_full_access; Type: POLICY; Schema: public; Owner: -
--

