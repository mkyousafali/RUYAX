CREATE TABLE public.multi_shift_weekday (
    id integer NOT NULL,
    employee_id text NOT NULL,
    weekday integer NOT NULL,
    shift_start_time time without time zone DEFAULT '09:00:00'::time without time zone NOT NULL,
    shift_start_buffer numeric(4,2) DEFAULT 0 NOT NULL,
    shift_end_time time without time zone DEFAULT '17:00:00'::time without time zone NOT NULL,
    shift_end_buffer numeric(4,2) DEFAULT 0 NOT NULL,
    is_shift_overlapping_next_day boolean DEFAULT false NOT NULL,
    working_hours numeric(5,2) DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT multi_shift_weekday_weekday_check CHECK (((weekday >= 0) AND (weekday <= 6)))
);


--
-- Name: multi_shift_weekday_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

