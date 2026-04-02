CREATE INDEX idx_incidents_resolution_report ON public.incidents USING gin (resolution_report) WHERE (resolution_report IS NOT NULL);


--
-- Name: idx_incidents_resolution_status; Type: INDEX; Schema: public; Owner: -
--

