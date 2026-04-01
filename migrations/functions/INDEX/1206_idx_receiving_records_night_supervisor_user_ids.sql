CREATE INDEX idx_receiving_records_night_supervisor_user_ids ON public.receiving_records USING gin (night_supervisor_user_ids);


--
-- Name: idx_receiving_records_original_bill_uploaded; Type: INDEX; Schema: public; Owner: -
--

