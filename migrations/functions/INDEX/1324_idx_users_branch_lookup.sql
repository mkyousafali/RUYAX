CREATE INDEX idx_users_branch_lookup ON public.users USING btree (branch_id) WHERE (branch_id IS NOT NULL);


--
-- Name: idx_users_created_at; Type: INDEX; Schema: public; Owner: -
--

