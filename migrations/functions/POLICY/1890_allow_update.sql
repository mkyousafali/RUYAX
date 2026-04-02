CREATE POLICY allow_update ON public.quick_task_comments FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: quick_task_completions allow_update; Type: POLICY; Schema: public; Owner: -
--

