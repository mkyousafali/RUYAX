CREATE INDEX idx_receiving_tasks_record_role ON public.receiving_tasks USING btree (receiving_record_id, role_type);


--
-- Name: idx_receiving_tasks_role_type; Type: INDEX; Schema: public; Owner: -
--

