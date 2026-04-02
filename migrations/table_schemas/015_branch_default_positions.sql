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
-- Name: branch_default_positions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.branch_default_positions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    branch_id integer NOT NULL,
    branch_manager_user_id uuid,
    purchasing_manager_user_id uuid,
    inventory_manager_user_id uuid,
    accountant_user_id uuid,
    night_supervisor_user_ids uuid[] DEFAULT '{}'::uuid[],
    warehouse_handler_user_id uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: branch_default_positions branch_default_positions_branch_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branch_default_positions
    ADD CONSTRAINT branch_default_positions_branch_id_key UNIQUE (branch_id);


--
-- Name: branch_default_positions branch_default_positions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branch_default_positions
    ADD CONSTRAINT branch_default_positions_pkey PRIMARY KEY (id);


--
-- Name: idx_branch_default_positions_branch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_branch_default_positions_branch_id ON public.branch_default_positions USING btree (branch_id);


--
-- Name: branch_default_positions branch_default_positions_timestamp_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER branch_default_positions_timestamp_update BEFORE UPDATE ON public.branch_default_positions FOR EACH ROW EXECUTE FUNCTION public.update_branch_default_positions_timestamp();


--
-- Name: branch_default_positions branch_default_positions_accountant_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branch_default_positions
    ADD CONSTRAINT branch_default_positions_accountant_user_id_fkey FOREIGN KEY (accountant_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: branch_default_positions branch_default_positions_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branch_default_positions
    ADD CONSTRAINT branch_default_positions_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;


--
-- Name: branch_default_positions branch_default_positions_branch_manager_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branch_default_positions
    ADD CONSTRAINT branch_default_positions_branch_manager_user_id_fkey FOREIGN KEY (branch_manager_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: branch_default_positions branch_default_positions_inventory_manager_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branch_default_positions
    ADD CONSTRAINT branch_default_positions_inventory_manager_user_id_fkey FOREIGN KEY (inventory_manager_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: branch_default_positions branch_default_positions_purchasing_manager_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branch_default_positions
    ADD CONSTRAINT branch_default_positions_purchasing_manager_user_id_fkey FOREIGN KEY (purchasing_manager_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: branch_default_positions branch_default_positions_warehouse_handler_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branch_default_positions
    ADD CONSTRAINT branch_default_positions_warehouse_handler_user_id_fkey FOREIGN KEY (warehouse_handler_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: branch_default_positions Allow all access to branch_default_positions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to branch_default_positions" ON public.branch_default_positions USING (true) WITH CHECK (true);


--
-- Name: branch_default_positions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.branch_default_positions ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE branch_default_positions; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.branch_default_positions TO anon;
GRANT ALL ON TABLE public.branch_default_positions TO authenticated;
GRANT ALL ON TABLE public.branch_default_positions TO service_role;
GRANT SELECT ON TABLE public.branch_default_positions TO replication_user;


--
-- PostgreSQL database dump complete
--

