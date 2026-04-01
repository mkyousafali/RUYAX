CREATE POLICY allow_update ON public.task_assignments FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: task_completions allow_update; Type: POLICY; Schema: public; Owner: -
--

