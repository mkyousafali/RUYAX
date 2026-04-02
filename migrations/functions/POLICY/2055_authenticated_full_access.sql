CREATE POLICY authenticated_full_access ON public.tasks USING ((auth.uid() IS NOT NULL));


--
-- Name: user_audit_logs authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

