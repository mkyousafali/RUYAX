CREATE INDEX idx_non_approved_scheduler_approval_status ON public.non_approved_payment_scheduler USING btree (approval_status);


--
-- Name: idx_non_approved_scheduler_approver_id; Type: INDEX; Schema: public; Owner: -
--

