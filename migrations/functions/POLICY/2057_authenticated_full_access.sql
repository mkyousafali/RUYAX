CREATE POLICY authenticated_full_access ON public.user_device_sessions USING ((auth.uid() IS NOT NULL));


--
-- Name: user_password_history authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

