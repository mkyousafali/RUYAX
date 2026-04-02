CREATE INDEX idx_task_completions_completed_by_branch_id ON public.task_completions USING btree (completed_by_branch_id);


--
-- Name: idx_task_completions_erp_reference; Type: INDEX; Schema: public; Owner: -
--

