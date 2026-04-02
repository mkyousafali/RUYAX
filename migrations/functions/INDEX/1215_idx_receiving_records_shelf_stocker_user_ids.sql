CREATE INDEX idx_receiving_records_shelf_stocker_user_ids ON public.receiving_records USING gin (shelf_stocker_user_ids);


--
-- Name: idx_receiving_records_total_return_amount; Type: INDEX; Schema: public; Owner: -
--

