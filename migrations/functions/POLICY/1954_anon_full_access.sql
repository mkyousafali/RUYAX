CREATE POLICY anon_full_access ON public.notification_recipients USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: notifications anon_full_access; Type: POLICY; Schema: public; Owner: -
--

