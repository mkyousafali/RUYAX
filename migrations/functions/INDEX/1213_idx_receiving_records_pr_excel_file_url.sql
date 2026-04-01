CREATE INDEX idx_receiving_records_pr_excel_file_url ON public.receiving_records USING btree (pr_excel_file_url) WHERE (pr_excel_file_url IS NOT NULL);


--
-- Name: idx_receiving_records_purchasing_manager_user_id; Type: INDEX; Schema: public; Owner: -
--

