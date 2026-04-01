CREATE UNIQUE INDEX idx_mv_expiry_unique ON public.mv_expiry_products USING btree (barcode, branch_id, expiry_date);


--
-- Name: idx_near_expiry_reports_branch; Type: INDEX; Schema: public; Owner: -
--

