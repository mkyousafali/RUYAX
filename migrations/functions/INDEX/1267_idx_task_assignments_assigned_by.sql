CREATE INDEX idx_task_assignments_assigned_by ON public.task_assignments USING btree (assigned_by);


--
-- Name: idx_task_assignments_assigned_to_branch_id; Type: INDEX; Schema: public; Owner: -
--

