CREATE INDEX idx_tasks_metadata ON public.tasks USING gin (metadata);


--
-- Name: idx_tasks_search_vector; Type: INDEX; Schema: public; Owner: -
--

