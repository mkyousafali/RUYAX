CREATE INDEX idx_task_assignments_reassignable ON public.task_assignments USING btree (is_reassignable, status) WHERE (is_reassignable = true);


--
-- Name: idx_task_assignments_recurring; Type: INDEX; Schema: public; Owner: -
--

