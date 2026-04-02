CREATE TRIGGER trg_update_final_bill_amount BEFORE INSERT OR UPDATE OF discount_amount, grr_amount, pri_amount, bill_amount ON public.vendor_payment_schedule FOR EACH ROW EXECUTE FUNCTION public.update_final_bill_amount_on_adjustment();


--
-- Name: order_items trigger_adjust_product_stock; Type: TRIGGER; Schema: public; Owner: -
--

