CREATE POLICY allow_update ON public.user_sessions FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: users allow_update; Type: POLICY; Schema: public; Owner: -
--

