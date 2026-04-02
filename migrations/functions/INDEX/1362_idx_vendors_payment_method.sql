CREATE INDEX idx_vendors_payment_method ON public.vendors USING gin (to_tsvector('english'::regconfig, payment_method));


--
-- Name: idx_vendors_payment_priority; Type: INDEX; Schema: public; Owner: -
--

