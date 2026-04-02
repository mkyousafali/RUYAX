CREATE INDEX idx_quick_task_completions_completed_by ON public.quick_task_completions USING btree (completed_by_user_id);


--
-- Name: idx_quick_task_completions_created_at; Type: INDEX; Schema: public; Owner: -
--

