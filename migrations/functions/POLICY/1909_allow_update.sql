CREATE POLICY allow_update ON public.user_device_sessions FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: user_password_history allow_update; Type: POLICY; Schema: public; Owner: -
--

