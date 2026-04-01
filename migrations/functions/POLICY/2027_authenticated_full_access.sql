CREATE POLICY authenticated_full_access ON public.notification_read_states USING ((auth.uid() IS NOT NULL));


--
-- Name: notification_recipients authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

