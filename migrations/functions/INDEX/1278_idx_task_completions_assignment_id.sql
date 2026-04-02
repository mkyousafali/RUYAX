CREATE INDEX idx_task_completions_assignment_id ON public.task_completions USING btree (assignment_id);


--
-- Name: idx_task_completions_completed_at; Type: INDEX; Schema: public; Owner: -
--

