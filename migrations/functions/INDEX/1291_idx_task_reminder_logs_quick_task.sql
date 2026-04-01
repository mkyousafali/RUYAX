CREATE INDEX idx_task_reminder_logs_quick_task ON public.task_reminder_logs USING btree (quick_task_assignment_id) WHERE (quick_task_assignment_id IS NOT NULL);


--
-- Name: idx_task_reminder_logs_sent_at; Type: INDEX; Schema: public; Owner: -
--

