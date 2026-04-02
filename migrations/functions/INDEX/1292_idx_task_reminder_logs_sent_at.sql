CREATE INDEX idx_task_reminder_logs_sent_at ON public.task_reminder_logs USING btree (reminder_sent_at);


--
-- Name: idx_task_reminder_logs_status; Type: INDEX; Schema: public; Owner: -
--

