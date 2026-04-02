CREATE POLICY authenticated_full_access ON public.notification_recipients USING ((auth.uid() IS NOT NULL));


--
-- Name: notifications authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

