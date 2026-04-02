CREATE INDEX idx_quick_task_completions_created_at ON public.quick_task_completions USING btree (created_at DESC);


--
-- Name: idx_quick_task_completions_status; Type: INDEX; Schema: public; Owner: -
--

