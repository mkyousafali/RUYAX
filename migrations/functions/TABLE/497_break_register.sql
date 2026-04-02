CREATE TABLE public.break_register (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    employee_id character varying(50) NOT NULL,
    employee_name_en character varying(200),
    employee_name_ar character varying(200),
    branch_id integer,
    reason_id integer NOT NULL,
    reason_note text,
    start_time timestamp with time zone DEFAULT now() NOT NULL,
    end_time timestamp with time zone,
    duration_seconds integer,
    status character varying(20) DEFAULT 'open'::character varying,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT break_register_status_check CHECK (((status)::text = ANY ((ARRAY['open'::character varying, 'closed'::character varying])::text[])))
);

ALTER TABLE ONLY public.break_register REPLICA IDENTITY FULL;


--
-- Name: break_security_seed; Type: TABLE; Schema: public; Owner: -
--

