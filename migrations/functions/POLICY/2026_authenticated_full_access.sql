CREATE POLICY authenticated_full_access ON public.notification_attachments USING ((auth.uid() IS NOT NULL));


--
-- Name: notification_read_states authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

