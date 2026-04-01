CREATE INDEX idx_coupon_claims_customer_campaign ON public.coupon_claims USING btree (campaign_id, customer_mobile);


--
-- Name: idx_coupon_claims_date; Type: INDEX; Schema: public; Owner: -
--

