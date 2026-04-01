CREATE INDEX idx_expense_sub_categories_parent ON public.expense_sub_categories USING btree (parent_category_id);


--
-- Name: idx_fine_payments_payment_date; Type: INDEX; Schema: public; Owner: -
--

