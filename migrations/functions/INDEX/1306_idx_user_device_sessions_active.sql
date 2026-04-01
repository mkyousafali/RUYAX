CREATE INDEX idx_user_device_sessions_active ON public.user_device_sessions USING btree (is_active);


--
-- Name: idx_user_device_sessions_device_id; Type: INDEX; Schema: public; Owner: -
--

