CREATE INDEX idx_expense_requisitions_is_active ON public.expense_requisitions USING btree (is_active) WHERE (is_active = true);


--
-- Name: idx_expense_requisitions_remaining_balance; Type: INDEX; Schema: public; Owner: -
--

