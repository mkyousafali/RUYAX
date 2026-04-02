CREATE INDEX idx_denomination_types_active ON public.denomination_types USING btree (is_active, sort_order);


--
-- Name: idx_denomination_user_preferences_user_id; Type: INDEX; Schema: public; Owner: -
--

