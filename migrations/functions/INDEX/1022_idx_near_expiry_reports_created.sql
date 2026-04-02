CREATE INDEX idx_near_expiry_reports_created ON public.near_expiry_reports USING btree (created_at DESC);


--
-- Name: idx_near_expiry_reports_reporter; Type: INDEX; Schema: public; Owner: -
--

