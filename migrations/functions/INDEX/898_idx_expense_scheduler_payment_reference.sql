CREATE INDEX idx_expense_scheduler_payment_reference ON public.expense_scheduler USING btree (payment_reference) WHERE (payment_reference IS NOT NULL);


--
-- Name: idx_expense_scheduler_recurring_type; Type: INDEX; Schema: public; Owner: -
--

