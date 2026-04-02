CREATE TABLE public.recurring_assignment_schedules (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    assignment_id uuid NOT NULL,
    repeat_type text NOT NULL,
    repeat_interval integer DEFAULT 1 NOT NULL,
    repeat_on_days integer[],
    repeat_on_date integer,
    repeat_on_month integer,
    execute_time time without time zone DEFAULT '09:00:00'::time without time zone NOT NULL,
    timezone text DEFAULT 'UTC'::text,
    start_date date NOT NULL,
    end_date date,
    max_occurrences integer,
    is_active boolean DEFAULT true,
    last_executed_at timestamp with time zone,
    next_execution_at timestamp with time zone NOT NULL,
    executions_count integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by text NOT NULL,
    CONSTRAINT chk_max_occurrences_positive CHECK (((max_occurrences IS NULL) OR (max_occurrences > 0))),
    CONSTRAINT chk_next_execution_after_start CHECK (((next_execution_at)::date >= start_date)),
    CONSTRAINT chk_repeat_interval_positive CHECK ((repeat_interval > 0)),
    CONSTRAINT chk_schedule_bounds CHECK (((end_date IS NULL) OR (end_date >= start_date))),
    CONSTRAINT recurring_assignment_schedules_repeat_type_check CHECK ((repeat_type = ANY (ARRAY['daily'::text, 'weekly'::text, 'monthly'::text, 'yearly'::text, 'custom'::text])))
);


--
-- Name: TABLE recurring_assignment_schedules; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.recurring_assignment_schedules IS 'Configuration for recurring task assignments with flexible scheduling';


--
-- Name: recurring_schedule_check_log; Type: TABLE; Schema: public; Owner: -
--

