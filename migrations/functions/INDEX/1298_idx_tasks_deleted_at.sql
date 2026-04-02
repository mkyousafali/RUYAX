CREATE INDEX idx_tasks_deleted_at ON public.tasks USING btree (deleted_at);


--
-- Name: idx_tasks_due_date; Type: INDEX; Schema: public; Owner: -
--

