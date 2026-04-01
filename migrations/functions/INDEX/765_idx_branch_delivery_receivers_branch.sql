CREATE INDEX idx_branch_delivery_receivers_branch ON public.branch_default_delivery_receivers USING btree (branch_id) WHERE (is_active = true);


--
-- Name: idx_branch_delivery_receivers_user; Type: INDEX; Schema: public; Owner: -
--

