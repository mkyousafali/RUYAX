CREATE INDEX idx_erp_daily_sales_branch_date ON public.erp_daily_sales USING btree (branch_id, sale_date);


--
-- Name: idx_erp_daily_sales_branch_id; Type: INDEX; Schema: public; Owner: -
--

