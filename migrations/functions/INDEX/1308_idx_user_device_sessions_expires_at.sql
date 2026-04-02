CREATE INDEX idx_user_device_sessions_expires_at ON public.user_device_sessions USING btree (expires_at);


--
-- Name: idx_user_device_sessions_last_activity; Type: INDEX; Schema: public; Owner: -
--

