CREATE INDEX idx_expense_scheduler_recurring_type ON public.expense_scheduler USING btree (recurring_type) WHERE (recurring_type IS NOT NULL);


--
-- Name: idx_expense_scheduler_requisition_id; Type: INDEX; Schema: public; Owner: -
--

