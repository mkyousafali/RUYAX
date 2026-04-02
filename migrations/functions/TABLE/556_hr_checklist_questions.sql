CREATE TABLE public.hr_checklist_questions (
    id character varying(20) DEFAULT ('Q'::text || nextval('public.hr_checklist_questions_id_seq'::regclass)) NOT NULL,
    question_en text,
    question_ar text,
    answer_1_en text,
    answer_1_ar text,
    answer_1_points integer DEFAULT 0,
    answer_2_en text,
    answer_2_ar text,
    answer_2_points integer DEFAULT 0,
    answer_3_en text,
    answer_3_ar text,
    answer_3_points integer DEFAULT 0,
    answer_4_en text,
    answer_4_ar text,
    answer_4_points integer DEFAULT 0,
    answer_5_en text,
    answer_5_ar text,
    answer_5_points integer DEFAULT 0,
    answer_6_en text,
    answer_6_ar text,
    answer_6_points integer DEFAULT 0,
    has_remarks boolean DEFAULT false,
    has_other boolean DEFAULT false,
    other_points integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: hr_checklists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

