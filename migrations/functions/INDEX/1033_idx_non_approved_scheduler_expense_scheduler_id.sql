CREATE INDEX idx_non_approved_scheduler_expense_scheduler_id ON public.non_approved_payment_scheduler USING btree (expense_scheduler_id) WHERE (expense_scheduler_id IS NOT NULL);


--
-- Name: idx_non_approved_scheduler_schedule_type; Type: INDEX; Schema: public; Owner: -
--

