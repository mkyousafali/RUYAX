CREATE INDEX idx_expense_scheduler_approver_id ON public.expense_scheduler USING btree (approver_id) WHERE (approver_id IS NOT NULL);


--
-- Name: idx_expense_scheduler_branch_id; Type: INDEX; Schema: public; Owner: -
--

