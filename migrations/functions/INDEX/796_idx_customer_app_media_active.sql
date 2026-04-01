CREATE INDEX idx_customer_app_media_active ON public.customer_app_media USING btree (is_active) WHERE (is_active = true);


--
-- Name: idx_customer_app_media_display_order; Type: INDEX; Schema: public; Owner: -
--

