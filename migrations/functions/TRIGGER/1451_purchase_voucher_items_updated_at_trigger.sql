CREATE TRIGGER purchase_voucher_items_updated_at_trigger BEFORE UPDATE ON public.purchase_voucher_items FOR EACH ROW EXECUTE FUNCTION public.update_purchase_voucher_items_updated_at();


--
-- Name: purchase_vouchers purchase_vouchers_updated_at_trigger; Type: TRIGGER; Schema: public; Owner: -
--

