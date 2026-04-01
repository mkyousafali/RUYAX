CREATE INDEX idx_deleted_bundle_offers_deleted_at ON public.deleted_bundle_offers USING btree (deleted_at DESC);


--
-- Name: idx_deleted_bundle_offers_deleted_by; Type: INDEX; Schema: public; Owner: -
--

