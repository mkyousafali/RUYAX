CREATE UNIQUE INDEX idx_users_quick_access ON public.users USING btree (quick_access_code);


--
-- Name: idx_users_username; Type: INDEX; Schema: public; Owner: -
--

