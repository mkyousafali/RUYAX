CREATE TABLE public.hr_analysed_attendance_data (
    id bigint NOT NULL,
    employee_id text NOT NULL,
    shift_date date NOT NULL,
    status text DEFAULT 'Absent'::text NOT NULL,
    worked_minutes integer DEFAULT 0 NOT NULL,
    late_minutes integer DEFAULT 0 NOT NULL,
    under_minutes integer DEFAULT 0 NOT NULL,
    shift_start_time time without time zone,
    shift_end_time time without time zone,
    check_in_time time without time zone,
    check_out_time time without time zone,
    employee_name_en text,
    employee_name_ar text,
    branch_id text,
    nationality text,
    analyzed_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    overtime_minutes integer DEFAULT 0
);


--
-- Name: hr_analysed_attendance_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

