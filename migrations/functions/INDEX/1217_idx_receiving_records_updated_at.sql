CREATE INDEX idx_receiving_records_updated_at ON public.receiving_records USING btree (updated_at DESC);


--
-- Name: idx_receiving_records_user_id; Type: INDEX; Schema: public; Owner: -
--

