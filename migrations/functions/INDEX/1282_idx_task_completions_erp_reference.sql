CREATE INDEX idx_task_completions_erp_reference ON public.task_completions USING btree (erp_reference_completed);


--
-- Name: idx_task_completions_photo_uploaded; Type: INDEX; Schema: public; Owner: -
--

