CREATE INDEX idx_password_history_user_created ON public.user_password_history USING btree (user_id, created_at DESC);


--
-- Name: idx_payment_entries_party; Type: INDEX; Schema: public; Owner: -
--

