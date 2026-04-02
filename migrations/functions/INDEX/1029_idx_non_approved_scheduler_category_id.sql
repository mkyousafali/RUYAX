CREATE INDEX idx_non_approved_scheduler_category_id ON public.non_approved_payment_scheduler USING btree (expense_category_id);


--
-- Name: idx_non_approved_scheduler_co_user_id; Type: INDEX; Schema: public; Owner: -
--

