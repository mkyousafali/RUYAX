CREATE INDEX idx_tasks_created_by ON public.tasks USING btree (created_by);


--
-- Name: idx_tasks_deleted_at; Type: INDEX; Schema: public; Owner: -
--

