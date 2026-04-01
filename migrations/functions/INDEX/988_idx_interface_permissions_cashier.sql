CREATE INDEX idx_interface_permissions_cashier ON public.interface_permissions USING btree (cashier_enabled) WHERE (cashier_enabled = true);


--
-- Name: idx_interface_permissions_customer; Type: INDEX; Schema: public; Owner: -
--

