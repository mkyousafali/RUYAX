CREATE INDEX idx_notification_attachments_notification_id ON public.notification_attachments USING btree (notification_id);


--
-- Name: idx_notification_attachments_uploaded_by; Type: INDEX; Schema: public; Owner: -
--

