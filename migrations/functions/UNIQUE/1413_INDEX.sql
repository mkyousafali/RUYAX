CREATE UNIQUE INDEX ux_delivery_tiers_scope_order ON public.delivery_fee_tiers USING btree (COALESCE(branch_id, ('-1'::integer)::bigint), tier_order);


--
-- Name: ai_chat_guide ai_chat_guide_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

