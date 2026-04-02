CREATE TABLE public.hr_checklist_operations (
    id character varying(20) DEFAULT ('CLO'::text || nextval('public.hr_checklist_operations_id_seq'::regclass)) NOT NULL,
    user_id uuid NOT NULL,
    employee_id character varying(50),
    box_operation_id uuid,
    checklist_id character varying(20) NOT NULL,
    answers jsonb DEFAULT '[]'::jsonb NOT NULL,
    total_points integer DEFAULT 0 NOT NULL,
    branch_id bigint,
    operation_date date DEFAULT CURRENT_DATE NOT NULL,
    operation_time time without time zone DEFAULT CURRENT_TIME NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    box_number integer,
    max_points integer DEFAULT 0 NOT NULL,
    submission_type_en text,
    submission_type_ar text
);


--
-- Name: COLUMN hr_checklist_operations.answers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_checklist_operations.answers IS 'JSONB array: [{ question_id: "Q1", answer_key: "a1", answer_text: "Yes", points: 5, remarks: "...", other_value: "..." }, ...]';


--
-- Name: COLUMN hr_checklist_operations.max_points; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_checklist_operations.max_points IS 'Total possible points from all questions in the checklist';


--
-- Name: COLUMN hr_checklist_operations.submission_type_en; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_checklist_operations.submission_type_en IS 'Submission type in English: POS, Daily, Weekly';


--
-- Name: COLUMN hr_checklist_operations.submission_type_ar; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_checklist_operations.submission_type_ar IS 'Submission type in Arabic: POS, ┘è┘ê┘à┘è, ╪ú╪│╪¿┘ê╪╣┘è';


--
-- Name: hr_checklist_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

