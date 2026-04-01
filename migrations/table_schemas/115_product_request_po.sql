--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 15.8

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: product_request_po; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_request_po (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    requester_user_id uuid NOT NULL,
    from_branch_id integer NOT NULL,
    target_user_id uuid NOT NULL,
    status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    items jsonb DEFAULT '[]'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    document_url text
);


--
-- Name: product_request_po product_request_po_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_request_po
    ADD CONSTRAINT product_request_po_pkey PRIMARY KEY (id);


--
-- Name: idx_product_request_po_branch; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_request_po_branch ON public.product_request_po USING btree (from_branch_id);


--
-- Name: idx_product_request_po_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_request_po_created ON public.product_request_po USING btree (created_at);


--
-- Name: idx_product_request_po_requester; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_request_po_requester ON public.product_request_po USING btree (requester_user_id);


--
-- Name: idx_product_request_po_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_request_po_status ON public.product_request_po USING btree (status);


--
-- Name: idx_product_request_po_target; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_request_po_target ON public.product_request_po USING btree (target_user_id);


--
-- Name: product_request_po product_request_po_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER product_request_po_timestamp_update BEFORE UPDATE ON public.product_request_po FOR EACH ROW EXECUTE FUNCTION public.update_product_request_po_timestamp();


--
-- Name: product_request_po product_request_po_from_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_request_po
    ADD CONSTRAINT product_request_po_from_branch_id_fkey FOREIGN KEY (from_branch_id) REFERENCES public.branches(id) ON DELETE RESTRICT;


--
-- Name: product_request_po product_request_po_requester_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_request_po
    ADD CONSTRAINT product_request_po_requester_user_id_fkey FOREIGN KEY (requester_user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: product_request_po product_request_po_target_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_request_po
    ADD CONSTRAINT product_request_po_target_user_id_fkey FOREIGN KEY (target_user_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: product_request_po Allow all access to product_request_po; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to product_request_po" ON public.product_request_po USING (true) WITH CHECK (true);


--
-- Name: product_request_po; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.product_request_po ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE product_request_po; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.product_request_po TO anon;
GRANT ALL ON TABLE public.product_request_po TO authenticated;
GRANT ALL ON TABLE public.product_request_po TO service_role;
GRANT SELECT ON TABLE public.product_request_po TO replication_user;


--
-- PostgreSQL database dump complete
--

