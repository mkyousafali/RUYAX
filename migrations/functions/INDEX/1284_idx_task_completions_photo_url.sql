CREATE INDEX idx_task_completions_photo_url ON public.task_completions USING btree (completion_photo_url) WHERE (completion_photo_url IS NOT NULL);


--
-- Name: idx_task_completions_task_finished; Type: INDEX; Schema: public; Owner: -
--

