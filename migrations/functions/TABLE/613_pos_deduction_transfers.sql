CREATE TABLE public.pos_deduction_transfers (
    id text NOT NULL,
    box_number integer NOT NULL,
    branch_id integer NOT NULL,
    cashier_user_id text NOT NULL,
    closed_by uuid,
    short_amount numeric(10,2) DEFAULT 0 NOT NULL,
    status public.pos_deduction_status DEFAULT 'Proposed'::public.pos_deduction_status NOT NULL,
    date_created_box timestamp with time zone NOT NULL,
    date_closed_box timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    completed_by_name character varying(255),
    box_operation_id uuid NOT NULL,
    applied boolean DEFAULT false
);


--
-- Name: TABLE pos_deduction_transfers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.pos_deduction_transfers IS 'Stores POS deduction transfer records when cashier has shortage more than 5';


--
-- Name: privilege_cards_branch; Type: TABLE; Schema: public; Owner: -
--

