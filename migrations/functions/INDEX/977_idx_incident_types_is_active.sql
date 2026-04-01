CREATE INDEX idx_incident_types_is_active ON public.incident_types USING btree (is_active) WHERE (is_active = true);


--
-- Name: idx_incidents_attachments; Type: INDEX; Schema: public; Owner: -
--

