CREATE INDEX idx_task_assignments_task_id ON public.task_assignments USING btree (task_id);


--
-- Name: idx_task_completions_assignment_id; Type: INDEX; Schema: public; Owner: -
--

