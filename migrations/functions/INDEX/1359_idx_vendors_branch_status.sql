CREATE INDEX idx_vendors_branch_status ON public.vendors USING btree (branch_id, status) WHERE (branch_id IS NOT NULL);


--
-- Name: idx_vendors_created_at; Type: INDEX; Schema: public; Owner: -
--

