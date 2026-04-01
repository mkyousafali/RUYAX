CREATE INDEX idx_users_position_lookup ON public.users USING btree (position_id) WHERE (position_id IS NOT NULL);


--
-- Name: idx_users_quick_access; Type: INDEX; Schema: public; Owner: -
--

