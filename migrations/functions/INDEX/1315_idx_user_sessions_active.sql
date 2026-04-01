CREATE INDEX idx_user_sessions_active ON public.user_sessions USING btree (is_active);


--
-- Name: idx_user_sessions_token; Type: INDEX; Schema: public; Owner: -
--

