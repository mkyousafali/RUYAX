CREATE INDEX idx_non_approved_scheduler_created_by ON public.non_approved_payment_scheduler USING btree (created_by);


--
-- Name: idx_non_approved_scheduler_expense_scheduler_id; Type: INDEX; Schema: public; Owner: -
--

