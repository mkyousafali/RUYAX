CREATE POLICY allow_update ON public.recurring_schedule_check_log FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: requesters allow_update; Type: POLICY; Schema: public; Owner: -
--

