CREATE POLICY authenticated_full_access ON public.recurring_schedule_check_log USING ((auth.uid() IS NOT NULL));


--
-- Name: requesters authenticated_full_access; Type: POLICY; Schema: public; Owner: -
--

