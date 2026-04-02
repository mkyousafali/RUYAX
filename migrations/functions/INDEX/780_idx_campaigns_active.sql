CREATE INDEX idx_campaigns_active ON public.coupon_campaigns USING btree (is_active) WHERE (deleted_at IS NULL);


--
-- Name: idx_campaigns_code; Type: INDEX; Schema: public; Owner: -
--

