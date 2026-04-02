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
-- Name: hr_basic_salary; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hr_basic_salary (
    employee_id character varying(50) NOT NULL,
    basic_salary numeric(10,2) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    payment_mode character varying(20) DEFAULT 'Bank'::character varying NOT NULL,
    other_allowance numeric(10,2),
    other_allowance_payment_mode character varying(20),
    accommodation_allowance numeric(10,2),
    accommodation_payment_mode character varying(20),
    travel_allowance numeric(10,2),
    travel_payment_mode character varying(20),
    gosi_deduction numeric(10,2),
    total_salary numeric(10,2),
    food_allowance numeric(10,2) DEFAULT 0,
    food_payment_mode text DEFAULT 'Bank'::text,
    CONSTRAINT hr_basic_salary_accommodation_payment_mode_check CHECK (((accommodation_payment_mode)::text = ANY ((ARRAY['Bank'::character varying, 'Cash'::character varying])::text[]))),
    CONSTRAINT hr_basic_salary_food_payment_mode_check CHECK ((food_payment_mode = ANY (ARRAY['Bank'::text, 'Cash'::text]))),
    CONSTRAINT hr_basic_salary_other_allowance_payment_mode_check CHECK (((other_allowance_payment_mode)::text = ANY ((ARRAY['Bank'::character varying, 'Cash'::character varying])::text[]))),
    CONSTRAINT hr_basic_salary_payment_mode_check CHECK (((payment_mode)::text = ANY ((ARRAY['Bank'::character varying, 'Cash'::character varying])::text[]))),
    CONSTRAINT hr_basic_salary_travel_payment_mode_check CHECK (((travel_payment_mode)::text = ANY ((ARRAY['Bank'::character varying, 'Cash'::character varying])::text[])))
);


--
-- Name: TABLE hr_basic_salary; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.hr_basic_salary IS 'Stores basic salary information for employees';


--
-- Name: COLUMN hr_basic_salary.employee_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_basic_salary.employee_id IS 'References hr_employee_master.id';


--
-- Name: COLUMN hr_basic_salary.basic_salary; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_basic_salary.basic_salary IS 'Employee basic salary amount';


--
-- Name: COLUMN hr_basic_salary.payment_mode; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_basic_salary.payment_mode IS 'Payment mode: Bank or Cash';


--
-- Name: COLUMN hr_basic_salary.other_allowance; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_basic_salary.other_allowance IS 'Other allowance amount';


--
-- Name: COLUMN hr_basic_salary.other_allowance_payment_mode; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_basic_salary.other_allowance_payment_mode IS 'Payment mode for other allowance: Bank or Cash';


--
-- Name: COLUMN hr_basic_salary.accommodation_allowance; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_basic_salary.accommodation_allowance IS 'Accommodation allowance amount';


--
-- Name: COLUMN hr_basic_salary.accommodation_payment_mode; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_basic_salary.accommodation_payment_mode IS 'Payment mode for accommodation: Bank or Cash';


--
-- Name: COLUMN hr_basic_salary.travel_allowance; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_basic_salary.travel_allowance IS 'Travel allowance amount';


--
-- Name: COLUMN hr_basic_salary.travel_payment_mode; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_basic_salary.travel_payment_mode IS 'Payment mode for travel: Bank or Cash';


--
-- Name: COLUMN hr_basic_salary.gosi_deduction; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_basic_salary.gosi_deduction IS 'GOSI deduction amount';


--
-- Name: COLUMN hr_basic_salary.total_salary; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_basic_salary.total_salary IS 'Total salary after all allowances and deductions';


--
-- Name: COLUMN hr_basic_salary.food_allowance; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_basic_salary.food_allowance IS 'Food allowance amount for the employee';


--
-- Name: COLUMN hr_basic_salary.food_payment_mode; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_basic_salary.food_payment_mode IS 'Payment mode for food allowance: Bank or Cash';


--
-- Name: hr_basic_salary hr_basic_salary_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_basic_salary
    ADD CONSTRAINT hr_basic_salary_pkey PRIMARY KEY (employee_id);


--
-- Name: idx_hr_basic_salary_employee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_basic_salary_employee_id ON public.hr_basic_salary USING btree (employee_id);


--
-- Name: hr_basic_salary hr_basic_salary_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_basic_salary
    ADD CONSTRAINT hr_basic_salary_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.hr_employee_master(id) ON DELETE CASCADE;


--
-- Name: hr_basic_salary Allow all access to hr_basic_salary; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all access to hr_basic_salary" ON public.hr_basic_salary USING (true) WITH CHECK (true);


--
-- Name: hr_basic_salary; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hr_basic_salary ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE hr_basic_salary; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.hr_basic_salary TO anon;
GRANT ALL ON TABLE public.hr_basic_salary TO authenticated;
GRANT ALL ON TABLE public.hr_basic_salary TO service_role;
GRANT SELECT ON TABLE public.hr_basic_salary TO replication_user;


--
-- PostgreSQL database dump complete
--

