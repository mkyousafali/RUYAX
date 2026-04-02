CREATE INDEX idx_task_assignments_assigned_to_branch_id ON public.task_assignments USING btree (assigned_to_branch_id);


--
-- Name: idx_task_assignments_assigned_to_user_id; Type: INDEX; Schema: public; Owner: -
--

