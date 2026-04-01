CREATE INDEX idx_vendors_branch_id ON public.vendors USING btree (branch_id) WHERE (branch_id IS NOT NULL);


--
-- Name: idx_vendors_branch_status; Type: INDEX; Schema: public; Owner: -
--

