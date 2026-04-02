CREATE INDEX idx_denomination_records_petty_cash_operation ON public.denomination_records USING gin (petty_cash_operation);


--
-- Name: idx_denomination_records_type; Type: INDEX; Schema: public; Owner: -
--

