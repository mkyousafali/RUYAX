CREATE INDEX idx_task_completions_task_finished ON public.task_completions USING btree (task_finished_completed);


--
-- Name: idx_task_completions_task_id; Type: INDEX; Schema: public; Owner: -
--

