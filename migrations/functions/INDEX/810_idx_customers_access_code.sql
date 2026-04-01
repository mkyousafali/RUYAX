CREATE INDEX idx_customers_access_code ON public.customers USING btree (access_code) WHERE (access_code IS NOT NULL);


--
-- Name: idx_customers_approved_by; Type: INDEX; Schema: public; Owner: -
--

