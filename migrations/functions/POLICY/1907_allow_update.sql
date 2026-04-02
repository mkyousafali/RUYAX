CREATE POLICY allow_update ON public.tasks FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: user_audit_logs allow_update; Type: POLICY; Schema: public; Owner: -
--

