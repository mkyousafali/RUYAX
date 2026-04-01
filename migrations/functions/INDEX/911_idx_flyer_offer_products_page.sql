CREATE INDEX idx_flyer_offer_products_page ON public.flyer_offer_products USING btree (offer_id, page_number, page_order);


--
-- Name: idx_flyer_offers_dates; Type: INDEX; Schema: public; Owner: -
--

