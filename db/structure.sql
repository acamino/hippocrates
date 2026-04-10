SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: btree_gin; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gin WITH SCHEMA public;


--
-- Name: EXTENSION btree_gin; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION btree_gin IS 'support for indexing common datatypes in GIN';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


--
-- Name: immutable_unaccent(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.immutable_unaccent(text) RETURNS text
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $_$
  SELECT public.unaccent('public.unaccent', $1);
$_$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activities (
    id integer NOT NULL,
    trackable_type character varying,
    trackable_id integer,
    owner_type character varying,
    owner_id integer,
    key character varying,
    parameters text,
    recipient_type character varying,
    recipient_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.activities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.activities_id_seq OWNED BY public.activities.id;


--
-- Name: anamneses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.anamneses (
    id integer NOT NULL,
    patient_id integer,
    medical_history character varying,
    surgical_history character varying,
    allergies character varying,
    observations character varying,
    habits character varying,
    family_history character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    hearing_aids boolean DEFAULT false NOT NULL,
    discarded_at timestamp without time zone
);


--
-- Name: anamneses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.anamneses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: anamneses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.anamneses_id_seq OWNED BY public.anamneses.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.attachments (
    id bigint NOT NULL,
    document_id bigint,
    content_data jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.attachments_id_seq OWNED BY public.attachments.id;


--
-- Name: branch_offices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.branch_offices (
    id bigint NOT NULL,
    name text NOT NULL,
    main boolean DEFAULT false NOT NULL,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    address text,
    phone_numbers text,
    city text
);


--
-- Name: branch_offices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.branch_offices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: branch_offices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.branch_offices_id_seq OWNED BY public.branch_offices.id;


--
-- Name: consultations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.consultations (
    id integer NOT NULL,
    patient_id integer,
    reason character varying DEFAULT ''::character varying,
    ongoing_issue character varying DEFAULT ''::character varying,
    organs_examination character varying DEFAULT ''::character varying,
    temperature numeric DEFAULT 0.0,
    heart_rate integer DEFAULT 0,
    blood_pressure character varying DEFAULT ''::character varying,
    respiratory_rate integer DEFAULT 0,
    weight numeric DEFAULT 0.0,
    height numeric DEFAULT 0.0,
    physical_examination character varying DEFAULT ''::character varying,
    right_ear character varying DEFAULT ''::character varying,
    left_ear character varying DEFAULT ''::character varying,
    right_nostril character varying DEFAULT ''::character varying,
    left_nostril character varying DEFAULT ''::character varying,
    nasopharynx character varying DEFAULT ''::character varying,
    nose_others character varying DEFAULT ''::character varying,
    oral_cavity character varying DEFAULT ''::character varying,
    oropharynx character varying DEFAULT ''::character varying,
    hypopharynx character varying DEFAULT ''::character varying,
    larynx character varying DEFAULT ''::character varying,
    neck character varying DEFAULT ''::character varying,
    others character varying DEFAULT ''::character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    miscellaneous character varying,
    diagnostic_plan character varying,
    treatment_plan character varying,
    warning_signs character varying,
    next_appointment timestamp without time zone,
    special_patient boolean DEFAULT false NOT NULL,
    hearing_aids character varying DEFAULT ''::character varying,
    oxygen_saturation integer DEFAULT 0,
    recommendations text,
    user_id bigint,
    serial character varying,
    branch_office_id bigint,
    payment numeric DEFAULT 0.0 NOT NULL,
    discarded_at timestamp without time zone,
    priced boolean DEFAULT false NOT NULL,
    pending_payment numeric DEFAULT 0.0 NOT NULL
);


--
-- Name: consultations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.consultations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: consultations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.consultations_id_seq OWNED BY public.consultations.id;


--
-- Name: diagnoses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.diagnoses (
    id integer NOT NULL,
    consultation_id integer,
    disease_code character varying,
    description character varying NOT NULL,
    type integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: diagnoses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.diagnoses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: diagnoses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.diagnoses_id_seq OWNED BY public.diagnoses.id;


--
-- Name: diseases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.diseases (
    code character varying NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    id bigint NOT NULL
);


--
-- Name: diseases_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.diseases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: diseases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.diseases_id_seq OWNED BY public.diseases.id;


--
-- Name: documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.documents (
    id bigint NOT NULL,
    consultation_id bigint,
    description text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.documents_id_seq OWNED BY public.documents.id;


--
-- Name: medicines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.medicines (
    id integer NOT NULL,
    name character varying NOT NULL,
    instructions character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: medicines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.medicines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: medicines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.medicines_id_seq OWNED BY public.medicines.id;


--
-- Name: patients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.patients (
    id integer NOT NULL,
    medical_history integer NOT NULL,
    last_name character varying NOT NULL,
    first_name character varying NOT NULL,
    identity_card_number character varying NOT NULL,
    birthdate date NOT NULL,
    gender integer DEFAULT 0 NOT NULL,
    civil_status integer DEFAULT 0 NOT NULL,
    address character varying,
    profession character varying,
    phone_number character varying,
    email character varying,
    source integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    special boolean DEFAULT false NOT NULL,
    health_insurance text,
    branch_office_id bigint,
    discarded_at timestamp without time zone,
    data_management_consent boolean DEFAULT false NOT NULL,
    search_vector tsvector GENERATED ALWAYS AS (to_tsvector('simple'::regconfig, public.immutable_unaccent((((((COALESCE(first_name, ''::character varying))::text || ' '::text) || (COALESCE(last_name, ''::character varying))::text) || ' '::text) || (COALESCE(identity_card_number, ''::character varying))::text)))) STORED
);


--
-- Name: patients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.patients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.patients_id_seq OWNED BY public.patients.id;


--
-- Name: payment_changes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_changes (
    id bigint NOT NULL,
    consultation_id bigint NOT NULL,
    user_id bigint NOT NULL,
    previous_payment numeric DEFAULT 0.0 NOT NULL,
    updated_payment numeric DEFAULT 0.0 NOT NULL,
    reason text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    type integer DEFAULT 0 NOT NULL
);


--
-- Name: payment_changes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payment_changes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payment_changes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payment_changes_id_seq OWNED BY public.payment_changes.id;


--
-- Name: prescriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.prescriptions (
    id integer NOT NULL,
    consultation_id integer,
    inscription character varying NOT NULL,
    subscription character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    "position" integer DEFAULT 0 NOT NULL
);


--
-- Name: prescriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.prescriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prescriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.prescriptions_id_seq OWNED BY public.prescriptions.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.settings (
    id integer NOT NULL,
    name character varying NOT NULL,
    value character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.settings_id_seq OWNED BY public.settings.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    admin boolean DEFAULT false NOT NULL,
    super_admin boolean DEFAULT false NOT NULL,
    active boolean DEFAULT true NOT NULL,
    first_name character varying,
    last_name character varying,
    pretty_name character varying,
    phone_number character varying,
    registration_acess character varying,
    speciality character varying,
    serial integer DEFAULT 0 NOT NULL,
    doctor boolean DEFAULT true NOT NULL,
    editor boolean DEFAULT false NOT NULL,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone,
    can_delete_patients boolean DEFAULT false NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: activities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities ALTER COLUMN id SET DEFAULT nextval('public.activities_id_seq'::regclass);


--
-- Name: anamneses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.anamneses ALTER COLUMN id SET DEFAULT nextval('public.anamneses_id_seq'::regclass);


--
-- Name: attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attachments ALTER COLUMN id SET DEFAULT nextval('public.attachments_id_seq'::regclass);


--
-- Name: branch_offices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branch_offices ALTER COLUMN id SET DEFAULT nextval('public.branch_offices_id_seq'::regclass);


--
-- Name: consultations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.consultations ALTER COLUMN id SET DEFAULT nextval('public.consultations_id_seq'::regclass);


--
-- Name: diagnoses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagnoses ALTER COLUMN id SET DEFAULT nextval('public.diagnoses_id_seq'::regclass);


--
-- Name: diseases id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diseases ALTER COLUMN id SET DEFAULT nextval('public.diseases_id_seq'::regclass);


--
-- Name: documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents ALTER COLUMN id SET DEFAULT nextval('public.documents_id_seq'::regclass);


--
-- Name: medicines id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.medicines ALTER COLUMN id SET DEFAULT nextval('public.medicines_id_seq'::regclass);


--
-- Name: patients id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patients ALTER COLUMN id SET DEFAULT nextval('public.patients_id_seq'::regclass);


--
-- Name: payment_changes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_changes ALTER COLUMN id SET DEFAULT nextval('public.payment_changes_id_seq'::regclass);


--
-- Name: prescriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prescriptions ALTER COLUMN id SET DEFAULT nextval('public.prescriptions_id_seq'::regclass);


--
-- Name: settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings ALTER COLUMN id SET DEFAULT nextval('public.settings_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: activities activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: anamneses anamneses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.anamneses
    ADD CONSTRAINT anamneses_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: attachments attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attachments
    ADD CONSTRAINT attachments_pkey PRIMARY KEY (id);


--
-- Name: branch_offices branch_offices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branch_offices
    ADD CONSTRAINT branch_offices_pkey PRIMARY KEY (id);


--
-- Name: consultations consultations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.consultations
    ADD CONSTRAINT consultations_pkey PRIMARY KEY (id);


--
-- Name: diagnoses diagnoses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagnoses
    ADD CONSTRAINT diagnoses_pkey PRIMARY KEY (id);


--
-- Name: diseases diseases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diseases
    ADD CONSTRAINT diseases_pkey PRIMARY KEY (id);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: medicines medicines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.medicines
    ADD CONSTRAINT medicines_pkey PRIMARY KEY (id);


--
-- Name: patients patients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (id);


--
-- Name: payment_changes payment_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_changes
    ADD CONSTRAINT payment_changes_pkey PRIMARY KEY (id);


--
-- Name: prescriptions prescriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prescriptions
    ADD CONSTRAINT prescriptions_pkey PRIMARY KEY (id);


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_consultations_patient_created_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_consultations_patient_created_id ON public.consultations USING btree (patient_id, created_at DESC, id DESC);


--
-- Name: idx_consultations_user_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_consultations_user_created ON public.consultations USING btree (user_id, created_at DESC);


--
-- Name: idx_patients_search; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_patients_search ON public.patients USING gin (search_vector);


--
-- Name: index_activities_on_owner_type_and_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_owner_type_and_owner_id ON public.activities USING btree (owner_type, owner_id);


--
-- Name: index_activities_on_recipient_type_and_recipient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_recipient_type_and_recipient_id ON public.activities USING btree (recipient_type, recipient_id);


--
-- Name: index_activities_on_trackable_type_and_trackable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_trackable_type_and_trackable_id ON public.activities USING btree (trackable_type, trackable_id);


--
-- Name: index_anamneses_on_discarded_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_anamneses_on_discarded_at ON public.anamneses USING btree (discarded_at);


--
-- Name: index_anamneses_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_anamneses_on_patient_id ON public.anamneses USING btree (patient_id);


--
-- Name: index_attachments_on_document_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_attachments_on_document_id ON public.attachments USING btree (document_id);


--
-- Name: index_branch_offices_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_branch_offices_on_name ON public.branch_offices USING btree (name);


--
-- Name: index_consultations_on_branch_office_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_consultations_on_branch_office_id ON public.consultations USING btree (branch_office_id);


--
-- Name: index_consultations_on_discarded_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_consultations_on_discarded_at ON public.consultations USING btree (discarded_at);


--
-- Name: index_consultations_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_consultations_on_patient_id ON public.consultations USING btree (patient_id);


--
-- Name: index_consultations_on_special_patient; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_consultations_on_special_patient ON public.consultations USING btree (special_patient);


--
-- Name: index_consultations_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_consultations_on_user_id ON public.consultations USING btree (user_id);


--
-- Name: index_diagnoses_on_consultation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_diagnoses_on_consultation_id ON public.diagnoses USING btree (consultation_id);


--
-- Name: index_diseases_on_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_diseases_on_code ON public.diseases USING btree (code);


--
-- Name: index_documents_on_consultation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_documents_on_consultation_id ON public.documents USING btree (consultation_id);


--
-- Name: index_medicines_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_medicines_on_name ON public.medicines USING btree (name);


--
-- Name: index_patients_on_branch_office_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_patients_on_branch_office_id ON public.patients USING btree (branch_office_id);


--
-- Name: index_patients_on_civil_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_patients_on_civil_status ON public.patients USING btree (civil_status);


--
-- Name: index_patients_on_discarded_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_patients_on_discarded_at ON public.patients USING btree (discarded_at);


--
-- Name: index_patients_on_first_name_and_last_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_patients_on_first_name_and_last_name ON public.patients USING gin (first_name, last_name);


--
-- Name: index_patients_on_gender; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_patients_on_gender ON public.patients USING btree (gender);


--
-- Name: index_patients_on_identity_card_number; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_patients_on_identity_card_number ON public.patients USING btree (identity_card_number);


--
-- Name: index_patients_on_medical_history; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_patients_on_medical_history ON public.patients USING btree (medical_history);


--
-- Name: index_patients_on_source; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_patients_on_source ON public.patients USING btree (source);


--
-- Name: index_patients_on_special; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_patients_on_special ON public.patients USING btree (special);


--
-- Name: index_payment_changes_on_consultation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payment_changes_on_consultation_id ON public.payment_changes USING btree (consultation_id);


--
-- Name: index_payment_changes_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payment_changes_on_user_id ON public.payment_changes USING btree (user_id);


--
-- Name: index_prescriptions_on_consultation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_prescriptions_on_consultation_id ON public.prescriptions USING btree (consultation_id);


--
-- Name: index_settings_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_settings_on_name ON public.settings USING btree (name);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_registration_acess; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_registration_acess ON public.users USING btree (registration_acess);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_unlock_token ON public.users USING btree (unlock_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON public.schema_migrations USING btree (version);


--
-- Name: patients fk_rails_042dda1ba7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT fk_rails_042dda1ba7 FOREIGN KEY (branch_office_id) REFERENCES public.branch_offices(id) ON DELETE SET NULL;


--
-- Name: prescriptions fk_rails_280b58d894; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prescriptions
    ADD CONSTRAINT fk_rails_280b58d894 FOREIGN KEY (consultation_id) REFERENCES public.consultations(id);


--
-- Name: diagnoses fk_rails_301f94eca3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagnoses
    ADD CONSTRAINT fk_rails_301f94eca3 FOREIGN KEY (consultation_id) REFERENCES public.consultations(id);


--
-- Name: anamneses fk_rails_3029ce5589; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.anamneses
    ADD CONSTRAINT fk_rails_3029ce5589 FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- Name: consultations fk_rails_33c52f1c05; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.consultations
    ADD CONSTRAINT fk_rails_33c52f1c05 FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- Name: payment_changes fk_rails_671f6d278b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_changes
    ADD CONSTRAINT fk_rails_671f6d278b FOREIGN KEY (consultation_id) REFERENCES public.consultations(id) ON DELETE CASCADE;


--
-- Name: documents fk_rails_68e2e560df; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT fk_rails_68e2e560df FOREIGN KEY (consultation_id) REFERENCES public.consultations(id) ON DELETE CASCADE;


--
-- Name: attachments fk_rails_bbbfd7ede9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attachments
    ADD CONSTRAINT fk_rails_bbbfd7ede9 FOREIGN KEY (document_id) REFERENCES public.documents(id) ON DELETE CASCADE;


--
-- Name: consultations fk_rails_e46097f376; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.consultations
    ADD CONSTRAINT fk_rails_e46097f376 FOREIGN KEY (branch_office_id) REFERENCES public.branch_offices(id) ON DELETE SET NULL;


--
-- Name: payment_changes fk_rails_e583c08c5d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_changes
    ADD CONSTRAINT fk_rails_e583c08c5d FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: consultations fk_rails_eb9663633d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.consultations
    ADD CONSTRAINT fk_rails_eb9663633d FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20260410120000'),
('20260330120822'),
('20260330120112'),
('20260322130907'),
('20260322125424'),
('20260213031414'),
('20260212200259'),
('20260212180747'),
('20250528022721'),
('20221006185934'),
('20221006002444'),
('20221006002133'),
('20221005232237'),
('20221005231929'),
('20221005231503'),
('20221004033327'),
('20221003001013'),
('20221002231601'),
('20220929011246'),
('20220929011245'),
('20220928043339'),
('20220928035247'),
('20220928034147'),
('20220927144600'),
('20220927020509'),
('20220926014213'),
('20220926013538'),
('20220925233530'),
('20220925033527'),
('20220925020205'),
('20220910124828'),
('20210925215048'),
('20210925123002'),
('20210918221257'),
('20210915111954'),
('20210915100831'),
('20210915035914'),
('20210120160222'),
('20201118021643'),
('20201115015125'),
('20201030111015'),
('20201015110708'),
('20200926042150'),
('20200924135244'),
('20200924134603'),
('20171204105641'),
('20170729030745'),
('20170729021432'),
('20160713023856'),
('20160712104217'),
('20160708100128'),
('20160625123535'),
('20160620121251'),
('20160620114213'),
('20160608040711'),
('20160608020453'),
('20160608015350'),
('20160608004701'),
('20160608001926'),
('20160608000925'),
('20160529053743'),
('20160529052342'),
('20160524111217'),
('20160524025343'),
('20160510120038'),
('20160506215923'),
('20160504020359'),
('20160407115842'),
('20160325031902');

