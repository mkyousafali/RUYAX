CREATE POLICY allow_update ON public.notification_attachments FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: notification_read_states allow_update; Type: POLICY; Schema: public; Owner: -
--

