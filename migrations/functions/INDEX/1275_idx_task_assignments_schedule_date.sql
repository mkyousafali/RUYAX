CREATE INDEX idx_task_assignments_schedule_date ON public.task_assignments USING btree (schedule_date) WHERE (schedule_date IS NOT NULL);


--
-- Name: idx_task_assignments_status; Type: INDEX; Schema: public; Owner: -
--

