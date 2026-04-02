CREATE INDEX idx_task_completions_completed_by ON public.task_completions USING btree (completed_by);


--
-- Name: idx_task_completions_completed_by_branch_id; Type: INDEX; Schema: public; Owner: -
--

