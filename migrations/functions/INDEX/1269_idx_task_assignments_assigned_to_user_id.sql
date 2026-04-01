CREATE INDEX idx_task_assignments_assigned_to_user_id ON public.task_assignments USING btree (assigned_to_user_id);


--
-- Name: idx_task_assignments_assignment_type; Type: INDEX; Schema: public; Owner: -
--

