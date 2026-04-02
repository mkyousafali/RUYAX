CREATE INDEX idx_tasks_search_vector ON public.tasks USING gin (search_vector);


--
-- Name: idx_tasks_status; Type: INDEX; Schema: public; Owner: -
--

