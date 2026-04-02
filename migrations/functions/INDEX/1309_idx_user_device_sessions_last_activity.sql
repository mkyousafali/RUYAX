CREATE INDEX idx_user_device_sessions_last_activity ON public.user_device_sessions USING btree (last_activity);


--
-- Name: idx_user_device_sessions_user_id; Type: INDEX; Schema: public; Owner: -
--

