CREATE POLICY allow_update ON public.notification_read_states FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: notification_recipients allow_update; Type: POLICY; Schema: public; Owner: -
--

