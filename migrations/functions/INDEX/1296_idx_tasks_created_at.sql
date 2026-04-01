CREATE INDEX idx_tasks_created_at ON public.tasks USING btree (created_at DESC);


--
-- Name: idx_tasks_created_by; Type: INDEX; Schema: public; Owner: -
--

