CREATE INDEX idx_quick_task_assignments_user ON public.quick_task_assignments USING btree (assigned_to_user_id);


--
-- Name: idx_quick_task_comments_created_by; Type: INDEX; Schema: public; Owner: -
--

