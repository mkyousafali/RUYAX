CREATE INDEX idx_quick_task_assignments_require_photo_upload ON public.quick_task_assignments USING btree (require_photo_upload) WHERE (require_photo_upload = true);


--
-- Name: idx_quick_task_assignments_require_task_finished; Type: INDEX; Schema: public; Owner: -
--

