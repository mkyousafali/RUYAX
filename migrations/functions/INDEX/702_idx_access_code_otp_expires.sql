CREATE INDEX idx_access_code_otp_expires ON public.access_code_otp USING btree (expires_at);


--
-- Name: idx_access_code_otp_user; Type: INDEX; Schema: public; Owner: -
--

