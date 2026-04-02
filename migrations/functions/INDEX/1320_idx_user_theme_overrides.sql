CREATE INDEX idx_user_theme_overrides ON public.user_mobile_theme_assignments USING btree (user_id) WHERE (color_overrides IS NOT NULL);


--
-- Name: idx_user_voice_preferences_user_id; Type: INDEX; Schema: public; Owner: -
--

