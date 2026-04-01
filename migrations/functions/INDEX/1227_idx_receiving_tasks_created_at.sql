CREATE INDEX idx_receiving_tasks_created_at ON public.receiving_tasks USING btree (created_at DESC);


--
-- Name: idx_receiving_tasks_receiving_record_id; Type: INDEX; Schema: public; Owner: -
--

