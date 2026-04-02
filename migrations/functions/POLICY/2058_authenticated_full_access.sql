CREATE POLICY authenticated_full_access ON public.user_password_history USING ((auth.uid() IS NOT NULL));


--
-- Name: user_sessions authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

