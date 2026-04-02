CREATE INDEX idx_expense_requisitions_requester_ref ON public.expense_requisitions USING btree (requester_ref_id);


--
-- Name: idx_expense_requisitions_status_active; Type: INDEX; Schema: public; Owner: -
--

