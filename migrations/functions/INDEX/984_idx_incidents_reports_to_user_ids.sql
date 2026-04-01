CREATE INDEX idx_incidents_reports_to_user_ids ON public.incidents USING gin (reports_to_user_ids);


--
-- Name: idx_incidents_resolution_report; Type: INDEX; Schema: public; Owner: -
--

