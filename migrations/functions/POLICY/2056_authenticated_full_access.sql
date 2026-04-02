CREATE POLICY authenticated_full_access ON public.user_audit_logs USING ((auth.uid() IS NOT NULL));


--
-- Name: user_device_sessions authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

