CREATE INDEX idx_quick_tasks_require_photo_upload ON public.quick_tasks USING btree (require_photo_upload) WHERE (require_photo_upload = true);


--
-- Name: idx_quick_tasks_status; Type: INDEX; Schema: public; Owner: -
--

