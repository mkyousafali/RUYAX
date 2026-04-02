CREATE INDEX idx_coupon_products_stock ON public.coupon_products USING btree (stock_remaining) WHERE (is_active = true);


--
-- Name: idx_customer_access_code_history_created_at; Type: INDEX; Schema: public; Owner: -
--

