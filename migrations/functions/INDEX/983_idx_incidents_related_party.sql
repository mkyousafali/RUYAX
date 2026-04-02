CREATE INDEX idx_incidents_related_party ON public.incidents USING gin (related_party) WHERE (related_party IS NOT NULL);


--
-- Name: idx_incidents_reports_to_user_ids; Type: INDEX; Schema: public; Owner: -
--

