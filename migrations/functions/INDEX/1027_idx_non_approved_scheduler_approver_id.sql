CREATE INDEX idx_non_approved_scheduler_approver_id ON public.non_approved_payment_scheduler USING btree (approver_id);


--
-- Name: idx_non_approved_scheduler_branch_id; Type: INDEX; Schema: public; Owner: -
--

