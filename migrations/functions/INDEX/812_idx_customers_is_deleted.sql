CREATE INDEX idx_customers_is_deleted ON public.customers USING btree (is_deleted) WHERE (is_deleted = true);


--
-- Name: idx_customers_registration_status; Type: INDEX; Schema: public; Owner: -
--

