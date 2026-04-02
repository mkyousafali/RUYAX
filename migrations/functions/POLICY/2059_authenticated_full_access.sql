CREATE POLICY authenticated_full_access ON public.user_sessions USING ((auth.uid() IS NOT NULL));


--
-- Name: users authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

