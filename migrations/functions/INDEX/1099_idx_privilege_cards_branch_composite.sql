CREATE INDEX idx_privilege_cards_branch_composite ON public.privilege_cards_branch USING btree (branch_id, card_number);


--
-- Name: idx_privilege_cards_master_card_number; Type: INDEX; Schema: public; Owner: -
--

