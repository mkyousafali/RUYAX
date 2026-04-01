CREATE INDEX idx_mv_expiry_days ON public.mv_expiry_products USING btree (days_left);


--
-- Name: idx_mv_expiry_hidden; Type: INDEX; Schema: public; Owner: -
--

