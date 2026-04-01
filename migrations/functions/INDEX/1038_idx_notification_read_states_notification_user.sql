CREATE INDEX idx_notification_read_states_notification_user ON public.notification_read_states USING btree (notification_id, user_id);


--
-- Name: idx_notification_read_states_user_id; Type: INDEX; Schema: public; Owner: -
--

