CREATE INDEX idx_customer_app_media_expiry ON public.customer_app_media USING btree (expiry_date) WHERE (expiry_date IS NOT NULL);


--
-- Name: idx_customer_app_media_type; Type: INDEX; Schema: public; Owner: -
--

