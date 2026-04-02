CREATE INDEX idx_product_request_bt_requester ON public.product_request_bt USING btree (requester_user_id);


--
-- Name: idx_product_request_bt_status; Type: INDEX; Schema: public; Owner: -
--

