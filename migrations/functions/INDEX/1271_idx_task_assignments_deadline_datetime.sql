CREATE INDEX idx_task_assignments_deadline_datetime ON public.task_assignments USING btree (deadline_datetime) WHERE (deadline_datetime IS NOT NULL);


--
-- Name: idx_task_assignments_overdue; Type: INDEX; Schema: public; Owner: -
--

