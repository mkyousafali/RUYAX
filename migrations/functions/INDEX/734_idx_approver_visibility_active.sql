CREATE INDEX idx_approver_visibility_active ON public.approver_visibility_config USING btree (is_active) WHERE (is_active = true);


--
-- Name: idx_approver_visibility_type; Type: INDEX; Schema: public; Owner: -
--

