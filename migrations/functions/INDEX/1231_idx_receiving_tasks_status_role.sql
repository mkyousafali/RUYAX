CREATE INDEX idx_receiving_tasks_status_role ON public.receiving_tasks USING btree (task_status, role_type);


--
-- Name: idx_receiving_tasks_task_completed; Type: INDEX; Schema: public; Owner: -
--

