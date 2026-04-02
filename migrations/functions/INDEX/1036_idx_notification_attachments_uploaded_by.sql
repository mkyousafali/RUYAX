CREATE INDEX idx_notification_attachments_uploaded_by ON public.notification_attachments USING btree (uploaded_by);


--
-- Name: idx_notification_read_states_notification_id; Type: INDEX; Schema: public; Owner: -
--

