CREATE INDEX idx_flyer_offers_dates ON public.flyer_offers USING btree (start_date, end_date);


--
-- Name: idx_flyer_offers_is_active; Type: INDEX; Schema: public; Owner: -
--

