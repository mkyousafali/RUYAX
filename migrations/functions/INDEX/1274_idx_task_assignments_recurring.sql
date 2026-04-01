CREATE INDEX idx_task_assignments_recurring ON public.task_assignments USING btree (is_recurring, status) WHERE (is_recurring = true);


--
-- Name: idx_task_assignments_schedule_date; Type: INDEX; Schema: public; Owner: -
--

