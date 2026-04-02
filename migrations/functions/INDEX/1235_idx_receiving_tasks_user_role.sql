CREATE INDEX idx_receiving_tasks_user_role ON public.receiving_tasks USING btree (assigned_user_id, role_type);


--
-- Name: idx_receiving_tasks_user_status; Type: INDEX; Schema: public; Owner: -
--

