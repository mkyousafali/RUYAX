CREATE INDEX idx_receiving_tasks_user_status ON public.receiving_tasks USING btree (assigned_user_id, task_status);


--
-- Name: idx_receiving_user_defaults_branch_id; Type: INDEX; Schema: public; Owner: -
--

