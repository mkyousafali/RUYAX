CREATE INDEX idx_offers_date_range ON public.offers USING btree (start_date, end_date);


--
-- Name: idx_offers_is_active; Type: INDEX; Schema: public; Owner: -
--

