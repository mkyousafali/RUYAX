CREATE INDEX idx_quick_task_assignments_assignment_id_status ON public.quick_task_assignments USING btree (quick_task_id, status);


--
-- Name: idx_quick_task_assignments_created_at; Type: INDEX; Schema: public; Owner: -
--

