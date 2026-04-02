CREATE INDEX idx_quick_task_completions_verified_by ON public.quick_task_completions USING btree (verified_by_user_id) WHERE (verified_by_user_id IS NOT NULL);


--
-- Name: idx_quick_task_files_task; Type: INDEX; Schema: public; Owner: -
--

