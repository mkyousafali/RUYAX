CREATE POLICY allow_update ON public.task_completions FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: task_images allow_update; Type: POLICY; Schema: public; Owner: -
--

