CREATE INDEX idx_product_request_po_requester ON public.product_request_po USING btree (requester_user_id);


--
-- Name: idx_product_request_po_status; Type: INDEX; Schema: public; Owner: -
--

