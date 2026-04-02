CREATE INDEX idx_customers_whatsapp ON public.customers USING btree (whatsapp_number) WHERE (whatsapp_number IS NOT NULL);


--
-- Name: idx_day_off_approval_requested_by; Type: INDEX; Schema: public; Owner: -
--

