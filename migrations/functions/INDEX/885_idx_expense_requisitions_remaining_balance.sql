CREATE INDEX idx_expense_requisitions_remaining_balance ON public.expense_requisitions USING btree (remaining_balance);


--
-- Name: idx_expense_requisitions_requester_ref; Type: INDEX; Schema: public; Owner: -
--

