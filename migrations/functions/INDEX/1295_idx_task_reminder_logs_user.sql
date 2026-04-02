CREATE INDEX idx_task_reminder_logs_user ON public.task_reminder_logs USING btree (assigned_to_user_id);


--
-- Name: idx_tasks_created_at; Type: INDEX; Schema: public; Owner: -
--

