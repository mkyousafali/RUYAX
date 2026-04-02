CREATE INDEX idx_branch_delivery_receivers_user ON public.branch_default_delivery_receivers USING btree (user_id) WHERE (is_active = true);


--
-- Name: idx_branches_active; Type: INDEX; Schema: public; Owner: -
--

