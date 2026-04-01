CREATE INDEX idx_expense_requisitions_status_active ON public.expense_requisitions USING btree (status, is_active);


--
-- Name: idx_expense_scheduler_approver_id; Type: INDEX; Schema: public; Owner: -
--

