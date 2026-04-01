CREATE INDEX idx_user_device_sessions_device_id ON public.user_device_sessions USING btree (device_id);


--
-- Name: idx_user_device_sessions_expires_at; Type: INDEX; Schema: public; Owner: -
--

