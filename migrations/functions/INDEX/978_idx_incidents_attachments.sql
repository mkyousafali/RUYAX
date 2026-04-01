CREATE INDEX idx_incidents_attachments ON public.incidents USING gin (attachments);


--
-- Name: idx_incidents_branch_id; Type: INDEX; Schema: public; Owner: -
--

