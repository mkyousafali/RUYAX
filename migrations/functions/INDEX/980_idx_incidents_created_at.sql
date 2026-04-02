CREATE INDEX idx_incidents_created_at ON public.incidents USING btree (created_at DESC);


--
-- Name: idx_incidents_employee_id; Type: INDEX; Schema: public; Owner: -
--

