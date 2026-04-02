CREATE INDEX idx_expense_scheduler_due_date_paid ON public.expense_scheduler USING btree (due_date, is_paid);


--
-- Name: idx_expense_scheduler_is_paid; Type: INDEX; Schema: public; Owner: -
--

