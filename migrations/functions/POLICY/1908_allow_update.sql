CREATE POLICY allow_update ON public.user_audit_logs FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: user_device_sessions allow_update; Type: POLICY; Schema: public; Owner: -
--

