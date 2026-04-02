CREATE POLICY anon_full_access ON public.task_completions USING (((auth.jwt() ->> 'role'::text) = 'anon'::text));


--
-- Name: task_images anon_full_access; Type: POLICY; Schema: public; Owner: -
--

