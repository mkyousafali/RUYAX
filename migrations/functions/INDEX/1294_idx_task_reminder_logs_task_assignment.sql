CREATE INDEX idx_task_reminder_logs_task_assignment ON public.task_reminder_logs USING btree (task_assignment_id) WHERE (task_assignment_id IS NOT NULL);


--
-- Name: idx_task_reminder_logs_user; Type: INDEX; Schema: public; Owner: -
--

