CREATE POLICY allow_update ON public.user_password_history FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: user_sessions allow_update; Type: POLICY; Schema: public; Owner: -
--

