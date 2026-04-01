CREATE INDEX idx_pos_deduction_transfers_date_closed ON public.pos_deduction_transfers USING btree (date_closed_box);


--
-- Name: idx_privilege_cards_branch_branch_id; Type: INDEX; Schema: public; Owner: -
--

