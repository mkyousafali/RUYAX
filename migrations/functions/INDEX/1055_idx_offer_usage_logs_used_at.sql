CREATE INDEX idx_offer_usage_logs_used_at ON public.offer_usage_logs USING btree (used_at DESC);


--
-- Name: idx_offers_branch_id; Type: INDEX; Schema: public; Owner: -
--

