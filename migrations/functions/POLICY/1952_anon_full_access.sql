CREATE POLICY anon_full_access ON public.notification_attachments USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: notification_read_states anon_full_access; Type: POLICY; Schema: public; Owner: -
--

