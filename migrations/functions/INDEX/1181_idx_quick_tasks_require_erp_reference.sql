CREATE INDEX idx_quick_tasks_require_erp_reference ON public.quick_tasks USING btree (require_erp_reference) WHERE (require_erp_reference = true);


--
-- Name: idx_quick_tasks_require_photo_upload; Type: INDEX; Schema: public; Owner: -
--

