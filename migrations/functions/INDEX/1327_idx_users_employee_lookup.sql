CREATE INDEX idx_users_employee_lookup ON public.users USING btree (employee_id) WHERE (employee_id IS NOT NULL);


--
-- Name: idx_users_is_admin; Type: INDEX; Schema: public; Owner: -
--

