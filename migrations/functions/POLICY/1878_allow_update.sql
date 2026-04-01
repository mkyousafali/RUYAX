CREATE POLICY allow_update ON public.notification_recipients FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: notifications allow_update; Type: POLICY; Schema: public; Owner: -
--

