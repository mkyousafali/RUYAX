CREATE INDEX idx_task_completions_completed_at ON public.task_completions USING btree (completed_at DESC);


--
-- Name: idx_task_completions_completed_by; Type: INDEX; Schema: public; Owner: -
--

