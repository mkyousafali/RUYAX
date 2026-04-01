CREATE INDEX idx_receiving_tasks_completion_photo_url ON public.receiving_tasks USING btree (completion_photo_url) WHERE (completion_photo_url IS NOT NULL);


--
-- Name: idx_receiving_tasks_created_at; Type: INDEX; Schema: public; Owner: -
--

