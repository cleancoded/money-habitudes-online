--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE moneyhabitudes;
ALTER ROLE moneyhabitudes WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md56d93bbffcc6ff4da7e0d364ec921b700';
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;






\connect template1

--
-- PostgreSQL database dump
--

-- Dumped from database version 11.2 (Debian 11.2-1.pgdg90+1)
-- Dumped by pg_dump version 11.2 (Debian 11.2-1.pgdg90+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 11.2 (Debian 11.2-1.pgdg90+1)
-- Dumped by pg_dump version 11.2 (Debian 11.2-1.pgdg90+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: moneyhabitudes; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE moneyhabitudes WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';


ALTER DATABASE moneyhabitudes OWNER TO postgres;

\connect moneyhabitudes

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounts_account; Type: TABLE; Schema: public; Owner: moneyhabitudes
--

CREATE TABLE public.accounts_account (
    id uuid NOT NULL,
    created_date timestamp with time zone NOT NULL,
    modified_date timestamp with time zone NOT NULL,
    name character varying(64) NOT NULL,
    email character varying(255) NOT NULL,
    email_confirmed boolean NOT NULL,
    anonymous boolean NOT NULL,
    stripe_customer_id character varying(64) NOT NULL,
    enforce_limits boolean NOT NULL,
    group_code_override boolean NOT NULL,
    admin_report_override boolean NOT NULL,
    report_branding boolean NOT NULL,
    site_branding boolean NOT NULL,
    player_pays boolean NOT NULL,
    anonymous_games boolean NOT NULL,
    show_next_steps boolean NOT NULL,
    report_end character varying(100) NOT NULL,
    hide_player_reports boolean NOT NULL,
    player_report_alt_message text NOT NULL,
    admin boolean NOT NULL,
    language character varying(5) NOT NULL,
    extra_languages boolean NOT NULL,
    user_id integer
);


ALTER TABLE public.accounts_account OWNER TO moneyhabitudes;

--
-- Name: accounts_availablegames; Type: TABLE; Schema: public; Owner: moneyhabitudes
--

CREATE TABLE public.accounts_availablegames (
    id uuid NOT NULL,
    created_date timestamp with time zone NOT NULL,
    modified_date timestamp with time zone NOT NULL,
    count integer NOT NULL,
    account_id uuid NOT NULL,
    subscription_id uuid,
    CONSTRAINT accounts_availablegames_count_check CHECK ((count >= 0))
);


ALTER TABLE public.accounts_availablegames OWNER TO moneyhabitudes;

--
-- Name: accounts_branding; Type: TABLE; Schema: public; Owner: moneyhabitudes
--

CREATE TABLE public.accounts_branding (
    id uuid NOT NULL,
    created_date timestamp with time zone NOT NULL,
    modified_date timestamp with time zone NOT NULL,
    cover_text text NOT NULL,
    cover_image character varying(100) NOT NULL,
    account_id uuid NOT NULL
);


ALTER TABLE public.accounts_branding OWNER TO moneyhabitudes;

--
-- Name: accounts_share; Type: TABLE; Schema: public; Owner: moneyhabitudes
--

CREATE TABLE public.accounts_share (
    id uuid NOT NULL,
    created_date timestamp with time zone NOT NULL,
    modified_date timestamp with time zone NOT NULL,
    cardset character varying(16) NOT NULL,
    code character varying(16) NOT NULL,
    name character varying(64) NOT NULL,
    total integer NOT NULL,
    used integer NOT NULL,
    anonymous boolean NOT NULL,
    enforce_referrer boolean NOT NULL,
    referrer_urls text NOT NULL,
    individual boolean NOT NULL,
    owner_id uuid NOT NULL,
    CONSTRAINT accounts_share_total_check CHECK ((total >= 0)),
    CONSTRAINT accounts_share_used_check CHECK ((used >= 0))
);


ALTER TABLE public.accounts_share OWNER TO moneyhabitudes;

--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: moneyhabitudes
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO moneyhabitudes;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: moneyhabitudes
--

CREATE SEQUENCE public.auth_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO moneyhabitudes;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: moneyhabitudes
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: moneyhabitudes
--

CREATE TABLE public.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO moneyhabitudes;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: moneyhabitudes
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO moneyhabitudes;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: moneyhabitudes
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: moneyhabitudes
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO moneyhabitudes;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: moneyhabitudes
--

CREATE SEQUENCE public.auth_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO moneyhabitudes;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: moneyhabitudes
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: moneyhabitudes
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO moneyhabitudes;

--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: moneyhabitudes
--

CREATE TABLE public.auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO moneyhabitudes;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: moneyhabitudes
--

CREATE SEQUENCE public.auth_user_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_groups_id_seq OWNER TO moneyhabitudes;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: moneyhabitudes
--

ALTER SEQUENCE public.auth_user_groups_id_seq OWNED BY public.auth_user_groups.id;


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: moneyhabitudes
--

CREATE SEQUENCE public.auth_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_id_seq OWNER TO moneyhabitudes;

--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: moneyhabitudes
--

ALTER SEQUENCE public.auth_user_id_seq OWNED BY public.auth_user.id;


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: moneyhabitudes
--

CREATE TABLE public.auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO moneyhabitudes;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: moneyhabitudes
--

CREATE SEQUENCE public.auth_user_user_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_user_permissions_id_seq OWNER TO moneyhabitudes;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: moneyhabitudes
--

ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNED BY public.auth_user_user_permissions.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: moneyhabitudes
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO moneyhabitudes;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: moneyhabitudes
--

CREATE SEQUENCE public.django_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO moneyhabitudes;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: moneyhabitudes
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: moneyhabitudes
--

CREATE TABLE public.django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO moneyhabitudes;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: moneyhabitudes
--

CREATE SEQUENCE public.django_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_migrations_id_seq OWNER TO moneyhabitudes;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: moneyhabitudes
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: moneyhabitudes
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO moneyhabitudes;

--
-- Name: games_game; Type: TABLE; Schema: public; Owner: moneyhabitudes
--

CREATE TABLE public.games_game (
    id uuid NOT NULL,
    created_date timestamp with time zone NOT NULL,
    modified_date timestamp with time zone NOT NULL,
    cardset character varying(16) NOT NULL,
    data jsonb NOT NULL,
    player_name character varying(64) NOT NULL,
    player_email character varying(255) NOT NULL,
    share_name character varying(64) NOT NULL,
    last_activity_date timestamp with time zone NOT NULL,
    completed boolean NOT NULL,
    owner_id uuid NOT NULL,
    player_id uuid NOT NULL,
    share_id uuid NOT NULL
);


ALTER TABLE public.games_game OWNER TO moneyhabitudes;

--
-- Name: orders_order; Type: TABLE; Schema: public; Owner: moneyhabitudes
--

CREATE TABLE public.orders_order (
    id uuid NOT NULL,
    created_date timestamp with time zone NOT NULL,
    modified_date timestamp with time zone NOT NULL,
    active boolean NOT NULL,
    active_until timestamp with time zone NOT NULL,
    stripe_product_id character varying(255) NOT NULL,
    stripe_product_name character varying(255) NOT NULL,
    account_id uuid NOT NULL
);


ALTER TABLE public.orders_order OWNER TO moneyhabitudes;

--
-- Name: orders_subscription; Type: TABLE; Schema: public; Owner: moneyhabitudes
--

CREATE TABLE public.orders_subscription (
    id uuid NOT NULL,
    created_date timestamp with time zone NOT NULL,
    modified_date timestamp with time zone NOT NULL,
    active boolean NOT NULL,
    active_until timestamp with time zone NOT NULL,
    stripe_subscription_id character varying(64) NOT NULL,
    stripe_plan_id character varying(255) NOT NULL,
    stripe_plan_name character varying(255) NOT NULL,
    group_codes boolean NOT NULL,
    admin_reports boolean NOT NULL,
    manual_override boolean NOT NULL,
    "interval" character varying(255) NOT NULL,
    games integer NOT NULL,
    account_id uuid NOT NULL
);


ALTER TABLE public.orders_subscription OWNER TO moneyhabitudes;

--
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: auth_user id; Type: DEFAULT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.auth_user ALTER COLUMN id SET DEFAULT nextval('public.auth_user_id_seq'::regclass);


--
-- Name: auth_user_groups id; Type: DEFAULT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.auth_user_groups ALTER COLUMN id SET DEFAULT nextval('public.auth_user_groups_id_seq'::regclass);


--
-- Name: auth_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_user_user_permissions_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- Data for Name: accounts_account; Type: TABLE DATA; Schema: public; Owner: moneyhabitudes
--

COPY public.accounts_account (id, created_date, modified_date, name, email, email_confirmed, anonymous, stripe_customer_id, enforce_limits, group_code_override, admin_report_override, report_branding, site_branding, player_pays, anonymous_games, show_next_steps, report_end, hide_player_reports, player_report_alt_message, admin, language, extra_languages, user_id) FROM stdin;
971350a6-5e84-4ad5-b6b0-768fb945dad3	2020-07-28 17:53:13.253655+00	2020-07-28 17:53:13.255604+00	Heida Carter	admin@example.com	f	f		t	f	f	f	f	f	f	t		f		t		f	1
a8abca7d-03d8-45e4-a222-230d51e2e2c4	2020-07-28 17:53:13.386241+00	2020-07-28 17:53:13.386257+00	Brit Quiram	brit.quiram@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	2
e44e6f6b-03f8-4ac3-a77a-5ed4531f840c	2020-07-28 17:53:13.50575+00	2020-07-28 17:53:13.50577+00	Fancie Bucklin	fancie.bucklin@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	3
fed7c6b6-ee58-4df3-84a3-e06aac58d3dd	2020-07-28 17:53:13.627518+00	2020-07-28 17:53:13.627533+00	Elvira Mcclimens	elvira.mcclimens@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	4
9e85258d-ef9c-4d50-84c0-d13213245134	2020-07-28 17:53:13.748158+00	2020-07-28 17:53:13.748173+00	Rebe Turybury	rebe.turybury@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	5
2e0da655-8db5-40a7-a9fa-5979e078c44e	2020-07-28 17:53:13.869798+00	2020-07-28 17:53:13.869814+00	Naoma Janice	naoma.janice@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	6
fa066412-fb74-44c9-9108-e935a5feef56	2020-07-28 17:53:13.989021+00	2020-07-28 17:53:13.989036+00	Grayce Avers	grayce.avers@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	7
70e1bf8e-ff43-4278-a407-81d18bf60913	2020-07-28 17:53:14.110808+00	2020-07-28 17:53:14.110824+00	Bianka Mamoran	bianka.mamoran@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	8
e5a2dea4-d182-46ed-9822-0051cd22ceb9	2020-07-28 17:53:14.230033+00	2020-07-28 17:53:14.230048+00	Gerek Brasure	gerek.brasure@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	9
ea5f3631-f4e7-43e2-a7bc-9684afe934d6	2020-07-28 17:53:14.351997+00	2020-07-28 17:53:14.352012+00	Marleah Finlay	marleah.finlay@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	10
962b8507-cfc7-4ebc-b1b1-b3690fe0eb7a	2020-07-28 17:53:14.471434+00	2020-07-28 17:53:14.471449+00	Leann Feagan	leann.feagan@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	11
5f6eaec4-7b21-4fda-9a63-6ee0513f5042	2020-07-28 17:53:14.5932+00	2020-07-28 17:53:14.593216+00	Angelico Feigh	angelico.feigh@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	12
76fe6377-38a9-4a55-bcba-d56f751805ec	2020-07-28 17:53:14.712425+00	2020-07-28 17:53:14.712439+00	Maud Snelgrove	maud.snelgrove@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	13
e20cd9b8-44d0-4cfc-951a-ad99598ec9c0	2020-07-28 17:53:14.834231+00	2020-07-28 17:53:14.834247+00	Imogen Claassen	imogen.claassen@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	14
88d06026-07be-4284-927e-6c62261e1858	2020-07-28 17:53:14.953697+00	2020-07-28 17:53:14.953712+00	Brynna Keogan	brynna.keogan@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	15
777083f6-97bb-4858-bb90-68900faeb668	2020-07-28 17:53:15.075353+00	2020-07-28 17:53:15.075369+00	Ashil Bann	ashil.bann@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	16
641f26f7-3773-4d5f-b60c-ae3878f207fd	2020-07-28 17:53:15.194665+00	2020-07-28 17:53:15.19468+00	Frayda Selking	frayda.selking@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	17
222b20fa-fed5-4328-8cfa-f17be4278ad3	2020-07-28 17:53:15.31644+00	2020-07-28 17:53:15.316455+00	Allene Hanekamp	allene.hanekamp@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	18
9f2f500a-1808-4967-a8b1-5e04b25d31fe	2020-07-28 17:53:15.435613+00	2020-07-28 17:53:15.435629+00	Zuzana Ulrich	zuzana.ulrich@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	19
fb841f41-12be-4894-982a-c046106ec4c8	2020-07-28 17:53:15.557628+00	2020-07-28 17:53:15.557643+00	Artus Deats	artus.deats@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	20
5d92e412-ef8b-4332-bda1-ffa533e8e193	2020-07-28 17:53:15.676688+00	2020-07-28 17:53:15.676703+00	Ninette Broden	ninette.broden@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	21
ed91301e-be59-4c6d-bd06-908028ba0405	2020-07-28 17:53:15.800066+00	2020-07-28 17:53:15.800082+00	Sophia Manning	sophia.manning@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	22
d98585d0-1c47-4a97-b2ff-1da3c622780f	2020-07-28 17:53:15.923084+00	2020-07-28 17:53:15.923099+00	Marlow Semrad	marlow.semrad@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	23
fae4677e-adc1-4d14-b5df-b83314b7aff7	2020-07-28 17:53:16.048591+00	2020-07-28 17:53:16.048606+00	Wes Belch	wes.belch@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	24
7d2064b4-3730-4fde-ba98-f5ad131edfda	2020-07-28 17:53:16.171699+00	2020-07-28 17:53:16.171715+00	Hasheem Strausser	hasheem.strausser@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	25
5688de6b-3d53-43c4-bce4-a953cf475a80	2020-07-28 17:53:16.296987+00	2020-07-28 17:53:16.297002+00	Thorsten Mekonis	thorsten.mekonis@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	26
763a4942-e851-4f76-ad15-39cf961cb427	2020-07-28 17:53:16.419703+00	2020-07-28 17:53:16.419718+00	Page Bovey	page.bovey@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	27
74fef58b-4ed9-4b6b-8819-428d46f6e0ac	2020-07-28 17:53:16.545144+00	2020-07-28 17:53:16.545159+00	Jerry Mentz	jerry.mentz@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	28
529db385-09fa-4aeb-97b1-db5c8ebff88d	2020-07-28 17:53:16.668089+00	2020-07-28 17:53:16.668104+00	Georgetta Beu	georgetta.beu@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	29
8ecd3a61-e4bd-4acf-8a54-3f5d09431abf	2020-07-28 17:53:16.793133+00	2020-07-28 17:53:16.793149+00	Shane Boruvka	shane.boruvka@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	30
e17188db-e7ca-4472-9fb4-bcd183e6a391	2020-07-28 17:53:16.916071+00	2020-07-28 17:53:16.916086+00	Marylynne Mezza	marylynne.mezza@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	31
5b900dea-6cf0-48a6-a1d7-c599528b45a2	2020-07-28 17:53:17.041486+00	2020-07-28 17:53:17.041501+00	Ban Lardieri	ban.lardieri@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	32
338d1a98-ec6d-4150-9918-f1f89d0cb71a	2020-07-28 17:53:17.16432+00	2020-07-28 17:53:17.164335+00	Trixie Madaris	trixie.madaris@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	33
1a24b2c5-8796-4489-a787-989f3e2a5bdc	2020-07-28 17:53:17.289932+00	2020-07-28 17:53:17.289948+00	Idell Cubie	idell.cubie@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	34
476c84ef-54b9-40d3-9b25-15ea2cae7a7e	2020-07-28 17:53:17.41266+00	2020-07-28 17:53:17.412675+00	Euphemia Lethco	euphemia.lethco@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	35
a66a5efc-455c-4995-8828-ce2ff9e21a59	2020-07-28 17:53:17.536093+00	2020-07-28 17:53:17.536108+00	Erv Chrisler	erv.chrisler@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	36
1fe86b02-546d-462d-931e-1328d90fd57e	2020-07-28 17:53:17.655221+00	2020-07-28 17:53:17.655237+00	Brook Human	brook.human@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	37
710a38db-b0c2-45b1-a3d1-6c74412a4158	2020-07-28 17:53:17.776775+00	2020-07-28 17:53:17.776791+00	Karl Nero	karl.nero@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	38
6bb1eb30-4557-4cd7-bc2d-f08befa532a2	2020-07-28 17:53:17.896235+00	2020-07-28 17:53:17.89625+00	Mandel Strayham	mandel.strayham@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	39
ba87511e-db93-4ab4-8b0a-df374871228c	2020-07-28 17:53:18.017714+00	2020-07-28 17:53:18.017729+00	Brita Dew	brita.dew@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	40
2b3dc560-0c02-4f3a-8c0b-d1227628c548	2020-07-28 17:53:18.137303+00	2020-07-28 17:53:18.137319+00	Tod Dukelow	tod.dukelow@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	41
9dd1730a-fb0e-4eed-bf36-ecc4131a1cf4	2020-07-28 17:53:18.259414+00	2020-07-28 17:53:18.259429+00	Adam Lopey	adam.lopey@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	42
26792fca-33b7-496d-9b73-706b6776c1f6	2020-07-28 17:53:18.379187+00	2020-07-28 17:53:18.379204+00	Bram Tousignant	bram.tousignant@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	43
ce6a7f31-172f-41b4-8832-0331e867638b	2020-07-28 17:53:18.499315+00	2020-07-28 17:53:18.499335+00	Kristoforo Difebbo	kristoforo.difebbo@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	44
09d872f3-51f9-4110-a5b0-b74b0cefa4ba	2020-07-28 17:53:18.621206+00	2020-07-28 17:53:18.621221+00	Rey Komarek	rey.komarek@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	45
837494a9-e175-4a4d-b59c-0c94b1ca2b8d	2020-07-28 17:53:18.740628+00	2020-07-28 17:53:18.740643+00	Abbe Haubner	abbe.haubner@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	46
49bcc538-e051-49b8-a21c-cebb4cab28ac	2020-07-28 17:53:18.862071+00	2020-07-28 17:53:18.862086+00	Jeremy Niskanen	jeremy.niskanen@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	47
bb1a1552-bb4f-4228-8d0c-dce369577184	2020-07-28 17:53:18.981368+00	2020-07-28 17:53:18.981383+00	Kahaleel Cunnick	kahaleel.cunnick@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	48
8c60b3ea-180c-4f4b-89fe-0747efb244f7	2020-07-28 17:53:19.103616+00	2020-07-28 17:53:19.103631+00	Katrina Seta	katrina.seta@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	49
664a0d34-fbda-4762-b16b-2457d3c0eab6	2020-07-28 17:53:19.222556+00	2020-07-28 17:53:19.222571+00	Clari Effinger	clari.effinger@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	50
39d3c465-4f61-4647-a11a-f19b1cc874c4	2020-07-28 17:53:19.344479+00	2020-07-28 17:53:19.344494+00	Julee Vandervort	julee.vandervort@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	51
c3055999-0f9d-45ff-9e52-5808d193d711	2020-07-28 17:53:19.463408+00	2020-07-28 17:53:19.463423+00	Rozanne Ozburn	rozanne.ozburn@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	52
3c80e01e-a293-486b-b020-7ba69c09d0a8	2020-07-28 17:53:19.585463+00	2020-07-28 17:53:19.585478+00	Dexter Kittles	dexter.kittles@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	53
0540f68c-2de5-49c5-9af5-a86da7a37ac8	2020-07-28 17:53:19.70511+00	2020-07-28 17:53:19.705125+00	Belia Costilla	belia.costilla@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	54
5f1a67df-53ec-4605-9ed4-fb2323f1e8d0	2020-07-28 17:53:19.826514+00	2020-07-28 17:53:19.826529+00	Chiquita Fragozo	chiquita.fragozo@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	55
15d7ca22-86a4-43d4-aae5-4564cb5cb960	2020-07-28 17:53:19.946025+00	2020-07-28 17:53:19.946041+00	Heall Neske	heall.neske@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	56
ca45c75d-6b37-4b0e-a2a8-ffd71d3e680d	2020-07-28 17:53:20.067524+00	2020-07-28 17:53:20.067539+00	Eldredge Muriel	eldredge.muriel@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	57
2d5428bd-1fa2-4429-912b-0787c426d284	2020-07-28 17:53:20.187038+00	2020-07-28 17:53:20.187054+00	Nichole Haugh	nichole.haugh@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	58
17b205fa-a02f-4017-afc1-134240e6019a	2020-07-28 17:53:20.309314+00	2020-07-28 17:53:20.309329+00	Rodina Hausen	rodina.hausen@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	59
3a2c012c-4080-4b6d-8097-725b6748c313	2020-07-28 17:53:20.428715+00	2020-07-28 17:53:20.42873+00	Jaquenetta Osvaldo	jaquenetta.osvaldo@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	60
af7943a0-c4c7-49c6-b687-83b67d1ad2d0	2020-07-28 17:53:20.549023+00	2020-07-28 17:53:20.549039+00	Evered Rollison	evered.rollison@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	61
ee107120-a482-47d4-99f0-749c6a699472	2020-07-28 17:53:20.670579+00	2020-07-28 17:53:20.670594+00	Ardisj Streetman	ardisj.streetman@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	62
1919989e-2fac-436b-bec9-9a427f019cc0	2020-07-28 17:53:20.794126+00	2020-07-28 17:53:20.794141+00	Hortensia Michaelson	hortensia.michaelson@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	63
2782cae8-3af6-4bab-84b8-572762581feb	2020-07-28 17:53:20.917425+00	2020-07-28 17:53:20.917441+00	Grover Brojakowski	grover.brojakowski@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	64
341a7941-d97c-475d-ba8e-675e5d09721f	2020-07-28 17:53:21.040229+00	2020-07-28 17:53:21.040244+00	Dillie Senich	dillie.senich@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	65
85c746a1-c4b6-4074-accc-c5ce30958e15	2020-07-28 17:53:21.163786+00	2020-07-28 17:53:21.163802+00	Jacquelyn Belliston	jacquelyn.belliston@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	66
6163d720-3ab5-4c63-bbd2-349385c477f6	2020-07-28 17:53:21.288547+00	2020-07-28 17:53:21.288562+00	Friedrick Breisch	friedrick.breisch@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	67
feed2ce7-1804-406e-ad5c-4974c098ece1	2020-07-28 17:53:21.41161+00	2020-07-28 17:53:21.411625+00	Auroora Sachar	auroora.sachar@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	68
db23a4b7-56fb-4831-9b8e-c38666dfb328	2020-07-28 17:53:21.537312+00	2020-07-28 17:53:21.537327+00	Britta Schermer	britta.schermer@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	69
5b329ea1-7052-46a2-9894-4a3caacb4696	2020-07-28 17:53:21.659413+00	2020-07-28 17:53:21.659428+00	Mariska Pellam	mariska.pellam@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	70
bdf8a21a-efa8-422e-bbd8-73e0795f6868	2020-07-28 17:53:21.784537+00	2020-07-28 17:53:21.784552+00	Arthur Reisner	arthur.reisner@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	71
8f9d11be-4271-4432-b939-d6d44f5833a1	2020-07-28 17:53:21.907068+00	2020-07-28 17:53:21.907083+00	William Proudfoot	william.proudfoot@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	72
a85de258-69cf-4455-aac7-a7fe96160895	2020-07-28 17:53:22.032061+00	2020-07-28 17:53:22.032077+00	Laurianne Albury	laurianne.albury@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	73
b17a5b14-1456-4933-8f1f-237ebdf27cda	2020-07-28 17:53:22.154524+00	2020-07-28 17:53:22.154539+00	Lucias Briar	lucias.briar@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	74
63715a3f-f503-46c5-8b2c-9335e68b4693	2020-07-28 17:53:22.279294+00	2020-07-28 17:53:22.27931+00	Xena Wion	xena.wion@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	75
e74655ac-86cf-4baf-9ff1-489df7e798c7	2020-07-28 17:53:22.402324+00	2020-07-28 17:53:22.40234+00	Shawn Risien	shawn.risien@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	76
da19874c-ea5e-48ff-ae3c-f9d8a14eaf36	2020-07-28 17:53:22.5258+00	2020-07-28 17:53:22.525815+00	Lothario Lanzillotti	lothario.lanzillotti@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	77
223151de-c49c-43a6-be39-f8d6f3d75980	2020-07-28 17:53:22.650884+00	2020-07-28 17:53:22.650899+00	Addy Detz	addy.detz@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	78
d1944ddb-6689-4d71-8cdc-194e15dbf01e	2020-07-28 17:53:22.774172+00	2020-07-28 17:53:22.774187+00	Marius Eskra	marius.eskra@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	79
179fd8a2-3b08-4a0b-a539-62d43d924664	2020-07-28 17:53:22.899841+00	2020-07-28 17:53:22.899856+00	Andie Nowosielski	andie.nowosielski@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	80
d8f2fccf-6ee7-4f63-84ea-f24266776a98	2020-07-28 17:53:23.02479+00	2020-07-28 17:53:23.024817+00	Sarene Holsworth	sarene.holsworth@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	81
61a9b975-f980-4a93-a15d-4d6ac6e7c946	2020-07-28 17:53:23.151258+00	2020-07-28 17:53:23.151273+00	Brandie Rotruck	brandie.rotruck@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	82
41339314-7b6c-4a87-9ef2-2d7f664730c7	2020-07-28 17:53:23.27601+00	2020-07-28 17:53:23.276025+00	Estrella Gosden	estrella.gosden@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	83
c57ef02d-8bd9-46f4-9085-1f1d57cb0194	2020-07-28 17:53:23.401909+00	2020-07-28 17:53:23.401925+00	Merrili Gustine	merrili.gustine@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	84
fdc8c2e0-d9f0-48df-90ae-9c5f83add885	2020-07-28 17:53:23.525388+00	2020-07-28 17:53:23.525403+00	Eddy Angevine	eddy.angevine@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	85
9786beb4-8a4d-4568-a47c-305c7a010af1	2020-07-28 17:53:23.651536+00	2020-07-28 17:53:23.651551+00	Pren Siddoway	pren.siddoway@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	86
65638264-60fb-453a-a4b5-96c2185e1c64	2020-07-28 17:53:23.776237+00	2020-07-28 17:53:23.776253+00	Susann Rightnour	susann.rightnour@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	87
8a820dca-bd6e-4f6e-a3a7-8d3d4e1f1d0b	2020-07-28 17:53:23.901664+00	2020-07-28 17:53:23.90168+00	Katha Spayd	katha.spayd@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	88
fc1d97ae-33dd-41d7-bb2e-691378dd0ad2	2020-07-28 17:53:24.024545+00	2020-07-28 17:53:24.02456+00	Pier Vensel	pier.vensel@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	89
c4bd2578-506e-4f55-9ad4-726f99100c15	2020-07-28 17:53:24.150647+00	2020-07-28 17:53:24.150663+00	Marianne Lisi	marianne.lisi@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	90
f6115c05-14df-4beb-a7df-3f2410cf96a2	2020-07-28 17:53:24.273533+00	2020-07-28 17:53:24.273549+00	Dennie Skinkle	dennie.skinkle@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	91
64c51e8e-a340-4eaa-ac23-6178d7d5a9a2	2020-07-28 17:53:24.399843+00	2020-07-28 17:53:24.399858+00	Nikita Contratto	nikita.contratto@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	92
ffec3b14-19f1-447b-add9-32216bf65726	2020-07-28 17:53:24.521236+00	2020-07-28 17:53:24.521252+00	Tremain Mchone	tremain.mchone@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	93
e5daee69-c821-4eb8-8e56-820752cf4aea	2020-07-28 17:53:24.642902+00	2020-07-28 17:53:24.642918+00	Caz Bruton	caz.bruton@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	94
bbb3b9e8-c374-4b3d-87ce-3b9e37b0fce3	2020-07-28 17:53:24.763038+00	2020-07-28 17:53:24.763054+00	Isidora Lipner	isidora.lipner@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	95
f402cd46-4a05-4d68-93b4-9da85d4802db	2020-07-28 17:53:24.884799+00	2020-07-28 17:53:24.884814+00	Margarete Salach	margarete.salach@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	96
49a6c204-8074-4ab5-966c-8db7ea863d20	2020-07-28 17:53:25.004563+00	2020-07-28 17:53:25.004579+00	Bart Vangoff	bart.vangoff@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	97
2f135876-64ff-4444-85f9-5f4709987037	2020-07-28 17:53:25.126695+00	2020-07-28 17:53:25.126711+00	Lionel Smolski	lionel.smolski@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	98
f82cb44c-391d-4389-b743-690ec29742a7	2020-07-28 17:53:25.246073+00	2020-07-28 17:53:25.246088+00	Tierney Zeltner	tierney.zeltner@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	99
a926dba0-9cef-4cfa-a783-bb60364fbea7	2020-07-28 17:53:25.368261+00	2020-07-28 17:53:25.368281+00	Con Jacque	con.jacque@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	100
bdff9a62-3dc2-491a-a24b-53926037bd0a	2020-07-28 17:53:25.487858+00	2020-07-28 17:53:25.487874+00	Alicia Fusco	alicia.fusco@example.com	f	f		t	f	f	f	f	f	f	t		f		f		f	101
\.


--
-- Data for Name: accounts_availablegames; Type: TABLE DATA; Schema: public; Owner: moneyhabitudes
--

COPY public.accounts_availablegames (id, created_date, modified_date, count, account_id, subscription_id) FROM stdin;
\.


--
-- Data for Name: accounts_branding; Type: TABLE DATA; Schema: public; Owner: moneyhabitudes
--

COPY public.accounts_branding (id, created_date, modified_date, cover_text, cover_image, account_id) FROM stdin;
\.


--
-- Data for Name: accounts_share; Type: TABLE DATA; Schema: public; Owner: moneyhabitudes
--

COPY public.accounts_share (id, created_date, modified_date, cardset, code, name, total, used, anonymous, enforce_referrer, referrer_urls, individual, owner_id) FROM stdin;
2b62a800-cde9-4357-a1bf-a47a3fff8c8e	2020-07-28 17:53:39.439424+00	2020-07-28 17:53:39.447439+00	adult	KV32C2GR	brit.quiram@example.com	1	1	f	f	[]	t	971350a6-5e84-4ad5-b6b0-768fb945dad3
acc534e8-10ba-41f4-929b-ce687e8a9bf6	2020-07-28 17:53:30.787629+00	2020-07-28 17:53:32.893471+00	adult	8W9HR69F	Romulus Conference	16	16	f	f	[]	t	971350a6-5e84-4ad5-b6b0-768fb945dad3
ada2b23a-e5cf-4b55-a6e8-f04f41eb355d	2020-07-28 17:53:25.491928+00	2020-07-28 17:53:27.628792+00	adult	TDWC57H6	Fitchburg Conference	16	16	f	f	[]	t	971350a6-5e84-4ad5-b6b0-768fb945dad3
e4dcca50-ed32-4150-9560-6e6827a6c99f	2020-07-28 17:53:33.015769+00	2020-07-28 17:53:35.386661+00	adult	2EDLCDLS	Somerville Meeting	18	18	f	f	[]	t	971350a6-5e84-4ad5-b6b0-768fb945dad3
28144124-3a15-494a-b3b0-a2b9b92dd64d	2020-07-28 17:53:27.718278+00	2020-07-28 17:53:28.617576+00	adult	N89SK856	Tustin Conference	7	7	f	f	[]	t	971350a6-5e84-4ad5-b6b0-768fb945dad3
2374e192-153a-47ea-9f55-6e1d3cce8f2c	2020-07-28 17:53:28.737559+00	2020-07-28 17:53:29.306268+00	adult	Q84LZ5UF	Forest Hills Conference	5	5	f	f	[]	t	971350a6-5e84-4ad5-b6b0-768fb945dad3
73701371-d652-4b01-819c-fc7667184c95	2020-07-28 17:53:35.472521+00	2020-07-28 17:53:35.944499+00	adult	QGR78Y2D	San Dimas Demo	4	4	f	f	[]	t	971350a6-5e84-4ad5-b6b0-768fb945dad3
e4554c18-1dc3-40bb-90c6-a18d63bc86f4	2020-07-28 17:53:29.492818+00	2020-07-28 17:53:30.606066+00	adult	SQUB48ZY	Cumberland Meeting	9	9	f	f	[]	t	971350a6-5e84-4ad5-b6b0-768fb945dad3
9fc0f165-eea9-4ff0-8ac1-08da55423ed9	2020-07-28 17:53:36.059545+00	2020-07-28 17:53:38.472299+00	adult	JXWYXGW2	Huntley Meeting	18	18	f	f	[]	t	971350a6-5e84-4ad5-b6b0-768fb945dad3
568c5006-bd75-4cdc-934c-fbb54bdabb8c	2020-07-28 17:53:38.560823+00	2020-07-28 17:53:39.303461+00	adult	LGCFH8TR	Lawrence Conference	6	6	f	f	[]	t	971350a6-5e84-4ad5-b6b0-768fb945dad3
\.


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: moneyhabitudes
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: moneyhabitudes
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: moneyhabitudes
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add permission	1	add_permission
2	Can change permission	1	change_permission
3	Can delete permission	1	delete_permission
4	Can view permission	1	view_permission
5	Can add group	2	add_group
6	Can change group	2	change_group
7	Can delete group	2	delete_group
8	Can view group	2	view_group
9	Can add user	3	add_user
10	Can change user	3	change_user
11	Can delete user	3	delete_user
12	Can view user	3	view_user
13	Can add content type	4	add_contenttype
14	Can change content type	4	change_contenttype
15	Can delete content type	4	delete_contenttype
16	Can view content type	4	view_contenttype
17	Can add session	5	add_session
18	Can change session	5	change_session
19	Can delete session	5	delete_session
20	Can view session	5	view_session
21	Can add account	6	add_account
22	Can change account	6	change_account
23	Can delete account	6	delete_account
24	Can view account	6	view_account
25	Can add share	7	add_share
26	Can change share	7	change_share
27	Can delete share	7	delete_share
28	Can view share	7	view_share
29	Can add branding	8	add_branding
30	Can change branding	8	change_branding
31	Can delete branding	8	delete_branding
32	Can view branding	8	view_branding
33	Can add available games	9	add_availablegames
34	Can change available games	9	change_availablegames
35	Can delete available games	9	delete_availablegames
36	Can view available games	9	view_availablegames
37	Can add game	10	add_game
38	Can change game	10	change_game
39	Can delete game	10	delete_game
40	Can view game	10	view_game
41	Can add subscription	11	add_subscription
42	Can change subscription	11	change_subscription
43	Can delete subscription	11	delete_subscription
44	Can view subscription	11	view_subscription
45	Can add order	12	add_order
46	Can change order	12	change_order
47	Can delete order	12	delete_order
48	Can view order	12	view_order
\.


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: moneyhabitudes
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
2	pbkdf2_sha256$180000$sI6fS69sr7ZU$uZMHvfrS0QbuRDFhFD3cNni+6ymnh4RA4q/3FwUdNhs=	\N	f	brit.quiram@example.com			brit.quiram@example.com	f	t	2020-07-28 17:53:13.265673+00
3	pbkdf2_sha256$180000$cf0dTGZempDh$X2N1AnpoRNzq+c+CfY1wf6S4ZyArOphn5tWY4pJEH/c=	\N	f	fancie.bucklin@example.com			fancie.bucklin@example.com	f	t	2020-07-28 17:53:13.388417+00
4	pbkdf2_sha256$180000$y41mJjAwwYfN$zYTIFzXYrCL3Z/IbriSy5GxUEhj3JOWTid7lh7U2olI=	\N	f	elvira.mcclimens@example.com			elvira.mcclimens@example.com	f	t	2020-07-28 17:53:13.507854+00
5	pbkdf2_sha256$180000$8QERl12cp4nw$gq7UqjiGuv6rr/zz2bh+vCgzDUZyMfE65dYRLQVTTMc=	\N	f	rebe.turybury@example.com			rebe.turybury@example.com	f	t	2020-07-28 17:53:13.629699+00
6	pbkdf2_sha256$180000$bw0PvMOTt6c9$ifVv1DE/UrJRc/g/yXaQUjAenLufwrkQMPiowXFWhoE=	\N	f	naoma.janice@example.com			naoma.janice@example.com	f	t	2020-07-28 17:53:13.750244+00
7	pbkdf2_sha256$180000$akUAHaohazZm$EOQYu39XzCXur/8eT8A2nYkWlWoFdkQrfHNZvaGBwFM=	\N	f	grayce.avers@example.com			grayce.avers@example.com	f	t	2020-07-28 17:53:13.871912+00
8	pbkdf2_sha256$180000$pIWc51eGYkVK$hsBE6jHVOPXlnFI70kTUWpCxBQJYFt8XYvOdn7nUIys=	\N	f	bianka.mamoran@example.com			bianka.mamoran@example.com	f	t	2020-07-28 17:53:13.991062+00
9	pbkdf2_sha256$180000$xL4vSX3s4ws4$e0WLDwNrp100GvMjg7rSUCdB18MRB0In4R0p/ccbsOE=	\N	f	gerek.brasure@example.com			gerek.brasure@example.com	f	t	2020-07-28 17:53:14.112888+00
10	pbkdf2_sha256$180000$JkXdr1YEQPxY$ZTyhkLl2spyrUAYQtrdnMjSPHHsT/qRMlp+1hHOcb4Q=	\N	f	marleah.finlay@example.com			marleah.finlay@example.com	f	t	2020-07-28 17:53:14.232153+00
11	pbkdf2_sha256$180000$L5xfZpSeMcod$SflwG4shiu8AqpJpYzm9pwskYf430DTGLjGLhg0l/Os=	\N	f	leann.feagan@example.com			leann.feagan@example.com	f	t	2020-07-28 17:53:14.354077+00
12	pbkdf2_sha256$180000$M8L2Qm6gRHuf$cC/qN41Y0LCv3wAIsl8t6k4uU/1G3XRJ/Ph6HeZVgVM=	\N	f	angelico.feigh@example.com			angelico.feigh@example.com	f	t	2020-07-28 17:53:14.473495+00
13	pbkdf2_sha256$180000$Dv5G1qHprFy7$4TkH43VXe8cWE+ZujzvnTBsG36aelHCgDThzMpRgPyk=	\N	f	maud.snelgrove@example.com			maud.snelgrove@example.com	f	t	2020-07-28 17:53:14.595275+00
14	pbkdf2_sha256$180000$FruZwuIdDNiD$G7WeU8bfy0zmA7QW2aKpNGDeZoQtTdZ00DY2jgFPzEc=	\N	f	imogen.claassen@example.com			imogen.claassen@example.com	f	t	2020-07-28 17:53:14.714535+00
15	pbkdf2_sha256$180000$IKqypl7CNcQe$oOSHqoyMbXGo6LaLphzl9zLZPoZsLbNnOqYJKMlPv2k=	\N	f	brynna.keogan@example.com			brynna.keogan@example.com	f	t	2020-07-28 17:53:14.836385+00
16	pbkdf2_sha256$180000$c1ckV3VOTG3r$HHToKxMkwkkIt1TSEIjFK7azfQSeoSh0nHKlkBCf1Xc=	\N	f	ashil.bann@example.com			ashil.bann@example.com	f	t	2020-07-28 17:53:14.95577+00
17	pbkdf2_sha256$180000$4hPQ9wzeaQnp$LTkodin8vJ+YqBIQiSSCvPuloflLkePpULPB3kAeJyo=	\N	f	frayda.selking@example.com			frayda.selking@example.com	f	t	2020-07-28 17:53:15.077493+00
18	pbkdf2_sha256$180000$BoIO73tuwxL2$xXz2/kYKv7kwHb4WZGaAqi7nJY2w4Y2qFZP8wx6uDwU=	\N	f	allene.hanekamp@example.com			allene.hanekamp@example.com	f	t	2020-07-28 17:53:15.196734+00
19	pbkdf2_sha256$180000$bAhwAFKN6KAu$mlWtydsKMGKDGg3TZpaAsWgoS1QZ4A8plcdv48vKBOs=	\N	f	zuzana.ulrich@example.com			zuzana.ulrich@example.com	f	t	2020-07-28 17:53:15.318554+00
20	pbkdf2_sha256$180000$2zSxRe7CUA9O$shWxjvd0SOik57N7yurNdqtDgw/avQXEZ7gIHZWWYK0=	\N	f	artus.deats@example.com			artus.deats@example.com	f	t	2020-07-28 17:53:15.4377+00
21	pbkdf2_sha256$180000$YE0YCQGitIu4$p5pRi105ostWWx1ak2GLwQIb9mPzeqrG6C0jcFbeKmk=	\N	f	ninette.broden@example.com			ninette.broden@example.com	f	t	2020-07-28 17:53:15.559706+00
22	pbkdf2_sha256$180000$nSOzDNUyydnI$JQshIlPu5Kc0HZMzOXesGcdsNdBWWKCgIR9qv6lTGFI=	\N	f	sophia.manning@example.com			sophia.manning@example.com	f	t	2020-07-28 17:53:15.678779+00
23	pbkdf2_sha256$180000$E4qAXv1YgppK$m9dAgZflXqQ5fvYRXkX+nw7VOu0ZlC6k7+yoVqPNU48=	\N	f	marlow.semrad@example.com			marlow.semrad@example.com	f	t	2020-07-28 17:53:15.803812+00
24	pbkdf2_sha256$180000$f2NMkj5ZUken$udDNTpWhAeYREZ1ZdvCM7wH68mCg9QemfVMVYGSRaNs=	\N	f	wes.belch@example.com			wes.belch@example.com	f	t	2020-07-28 17:53:15.927058+00
25	pbkdf2_sha256$180000$iF26BxXBVuaS$sDfuknujjYlxlpPbkrpIvn4WZre2Yo4WS8nBkBD1OWk=	\N	f	hasheem.strausser@example.com			hasheem.strausser@example.com	f	t	2020-07-28 17:53:16.052582+00
26	pbkdf2_sha256$180000$hzEL7flbv7e7$fDBR8yfmYrGtYg/nPuosfvO1JdGb64Ah3gIIlSYIJCg=	\N	f	thorsten.mekonis@example.com			thorsten.mekonis@example.com	f	t	2020-07-28 17:53:16.175519+00
27	pbkdf2_sha256$180000$HdzwC6N5PZPX$nzf8AFnZByXqwApTZ4MHc/Veie4nS2LVwCMGFAAkkpI=	\N	f	page.bovey@example.com			page.bovey@example.com	f	t	2020-07-28 17:53:16.300915+00
28	pbkdf2_sha256$180000$q51f1bFoVPyR$+Hk0K2Tr+2I2vpVbuZQwUZQNcbFKG/VqBWixS/8Th4w=	\N	f	jerry.mentz@example.com			jerry.mentz@example.com	f	t	2020-07-28 17:53:16.423651+00
29	pbkdf2_sha256$180000$a9WcbMhGHPvW$eeYe/3PszebBoH3gMCWgqy2l9iehDH4wTAcsjjW9xS8=	\N	f	georgetta.beu@example.com			georgetta.beu@example.com	f	t	2020-07-28 17:53:16.549054+00
30	pbkdf2_sha256$180000$w9JKb2q2tzRI$Q2ej6dnUtttG9nvrJzmHxvnwKoJSGRoUyqKFfGAfCY4=	\N	f	shane.boruvka@example.com			shane.boruvka@example.com	f	t	2020-07-28 17:53:16.671859+00
31	pbkdf2_sha256$180000$GshPZRNsEUrP$B5N/j+TwT1Wia1sLaanx3/aV0NoqyEy3hL1o/49rASA=	\N	f	marylynne.mezza@example.com			marylynne.mezza@example.com	f	t	2020-07-28 17:53:16.797057+00
32	pbkdf2_sha256$180000$UZehSKptuaHm$S8DcVLGzm+zE1Bgvy7yJ62Abui11WkpvHPzL8U5KAXA=	\N	f	ban.lardieri@example.com			ban.lardieri@example.com	f	t	2020-07-28 17:53:16.919899+00
33	pbkdf2_sha256$180000$IEN5KK2ZvAvp$cokuuYUxvsKcE63e74/HZKDsnwc2yWaM0vQaRn9xIAc=	\N	f	trixie.madaris@example.com			trixie.madaris@example.com	f	t	2020-07-28 17:53:17.045424+00
34	pbkdf2_sha256$180000$4H69HwHsoeZi$xulUgMZvfUnr9B3/2SUaAJ3N+Scd2PIN81TMqE/obMU=	\N	f	idell.cubie@example.com			idell.cubie@example.com	f	t	2020-07-28 17:53:17.168229+00
35	pbkdf2_sha256$180000$y1DEWYr0o6Bk$Mb4nP7NQ4UY1KmaefyksQ3JDMPkdczAUMCPoefOotlU=	\N	f	euphemia.lethco@example.com			euphemia.lethco@example.com	f	t	2020-07-28 17:53:17.293892+00
36	pbkdf2_sha256$180000$a8rw1nuvVtFV$8tgHupeJ5MM/0U3QvI1KJGd5P/pjFxBQMfe6mB8nywU=	\N	f	erv.chrisler@example.com			erv.chrisler@example.com	f	t	2020-07-28 17:53:17.416515+00
37	pbkdf2_sha256$180000$psXar2SKeo8F$gtvhBGhu+D/uKGHW6Tk1QMPe4AGwizvsFj46GjkNSgw=	\N	f	brook.human@example.com			brook.human@example.com	f	t	2020-07-28 17:53:17.538174+00
38	pbkdf2_sha256$180000$kCqHrU0WC8KA$GLq1EJr84EcLFbtwcqc7b8MtOeHc0g+GYYFMg3n5Fzc=	\N	f	karl.nero@example.com			karl.nero@example.com	f	t	2020-07-28 17:53:17.657299+00
39	pbkdf2_sha256$180000$2PWE4GkpXPMv$ub221dJQ5V2fKB2e5ABflAa4zHWqpUpHHlPfgr98EU4=	\N	f	mandel.strayham@example.com			mandel.strayham@example.com	f	t	2020-07-28 17:53:17.778884+00
40	pbkdf2_sha256$180000$QZs3rFqxptS2$40SRIFMZEU2upB02nmbbNAOR8Aof82aKsaeHy2FzN3o=	\N	f	brita.dew@example.com			brita.dew@example.com	f	t	2020-07-28 17:53:17.898302+00
41	pbkdf2_sha256$180000$YknaNPh1ETDr$yHLGzBZhI9a9F2AsQeZOvsZy29e9XudGRuLBjYxPwr0=	\N	f	tod.dukelow@example.com			tod.dukelow@example.com	f	t	2020-07-28 17:53:18.019831+00
42	pbkdf2_sha256$180000$sjsuAvvwu24f$pah4uFMfiFJtUuHFM9Ex7tYKWAqaDRgj8edlPUVq2Y4=	\N	f	adam.lopey@example.com			adam.lopey@example.com	f	t	2020-07-28 17:53:18.139693+00
43	pbkdf2_sha256$180000$9NdtUhmzLN78$nnpEDSfKzd150TzY9wvpnlMwkjh2oWDgWSmNXbcbYUM=	\N	f	bram.tousignant@example.com			bram.tousignant@example.com	f	t	2020-07-28 17:53:18.261568+00
44	pbkdf2_sha256$180000$b5nmCRm6b0U3$r3GVETCn1ckCAQfGTYb7CHp5eqHr3dfrjPlNW1jZ3A0=	\N	f	kristoforo.difebbo@example.com			kristoforo.difebbo@example.com	f	t	2020-07-28 17:53:18.381351+00
45	pbkdf2_sha256$180000$PjyVcGZvFGgS$JrjlLrU7dckS16Nhh8l4LZFWcjQXJUrsny4beLvG42M=	\N	f	rey.komarek@example.com			rey.komarek@example.com	f	t	2020-07-28 17:53:18.501393+00
46	pbkdf2_sha256$180000$2fXd48Hq2lCV$xNPEMINb9fm3BYnTzrL7lttwQD+fKjT69wJiNOj/AS8=	\N	f	abbe.haubner@example.com			abbe.haubner@example.com	f	t	2020-07-28 17:53:18.623251+00
47	pbkdf2_sha256$180000$PdYvxrA4MRPC$DNGc8kDV+hyldbqcc7rGCvBE9iCT5qzQkwyDte1oVUc=	\N	f	jeremy.niskanen@example.com			jeremy.niskanen@example.com	f	t	2020-07-28 17:53:18.742717+00
48	pbkdf2_sha256$180000$6559xGjXXeEP$luM+XYoC96hi7M4iDj7ZbiA3ML8PE/S/iyjCeTA//Ek=	\N	f	kahaleel.cunnick@example.com			kahaleel.cunnick@example.com	f	t	2020-07-28 17:53:18.864126+00
49	pbkdf2_sha256$180000$Yzp4berSq1WW$CfS3lyMqLkJq76PkLPf2g/OvVpkg6tG2Fd9sLDQ5vYo=	\N	f	katrina.seta@example.com			katrina.seta@example.com	f	t	2020-07-28 17:53:18.983528+00
50	pbkdf2_sha256$180000$gNe9E0klmDyP$qF1xZGzMr65rmAQmFEruYjwBJd44evtExDNPDvQUG60=	\N	f	clari.effinger@example.com			clari.effinger@example.com	f	t	2020-07-28 17:53:19.105692+00
51	pbkdf2_sha256$180000$b7qr9KtM7IRd$yXkq7dYtjzxmYsEseHhxaXZDgf5H0EadOIFjsMyZ8ew=	\N	f	julee.vandervort@example.com			julee.vandervort@example.com	f	t	2020-07-28 17:53:19.224684+00
52	pbkdf2_sha256$180000$bWuKCZRjBkIq$JtZDGe357xoLPHrNo/xi8C7gEVPmfkdadzCHVGxpfAo=	\N	f	rozanne.ozburn@example.com			rozanne.ozburn@example.com	f	t	2020-07-28 17:53:19.346538+00
53	pbkdf2_sha256$180000$itf4KpmBJEdO$V2v7LpIBMCWbm1t/658MoGCAOpuBmh9XjBPRxSpG0EE=	\N	f	dexter.kittles@example.com			dexter.kittles@example.com	f	t	2020-07-28 17:53:19.465499+00
54	pbkdf2_sha256$180000$zWuCvqSQfUpW$2MqVmx4xW4vCH1636TRpJDR+qBs3dFACtnFhcyOj5Wk=	\N	f	belia.costilla@example.com			belia.costilla@example.com	f	t	2020-07-28 17:53:19.587502+00
55	pbkdf2_sha256$180000$oy4HHUpB8nJv$KefwT2AsPNNSNscXwDxt5Ta/Fq1LP3al22NNf5sOV8A=	\N	f	chiquita.fragozo@example.com			chiquita.fragozo@example.com	f	t	2020-07-28 17:53:19.707193+00
56	pbkdf2_sha256$180000$ELPh3rkns865$3YCZjcD8ux6p2DAJQ79d2+gw55FbcV9La0OlXeIAcBE=	\N	f	heall.neske@example.com			heall.neske@example.com	f	t	2020-07-28 17:53:19.828592+00
57	pbkdf2_sha256$180000$hYm7LHVzg48N$puc8NWi1kVti+02NBFDmpu9puu1ojVKVp/y9H8JCxAg=	\N	f	eldredge.muriel@example.com			eldredge.muriel@example.com	f	t	2020-07-28 17:53:19.94809+00
58	pbkdf2_sha256$180000$Sr4tjpRJRryn$nQzXqZfXKWe9sfEoEvyW/N7LLGun553LzX5LwJJ7pGo=	\N	f	nichole.haugh@example.com			nichole.haugh@example.com	f	t	2020-07-28 17:53:20.069573+00
59	pbkdf2_sha256$180000$DjL02cZ0ft6R$ysKmDT7YCFwC40+Oa4LO1nVyyuGECC6VtlJFj+UUKyA=	\N	f	rodina.hausen@example.com			rodina.hausen@example.com	f	t	2020-07-28 17:53:20.189126+00
60	pbkdf2_sha256$180000$VhvWlgdU1csG$R4DdhGo7+UhHw/YwcAYSIwCLGaJgS9U0r9zpXjJTCdA=	\N	f	jaquenetta.osvaldo@example.com			jaquenetta.osvaldo@example.com	f	t	2020-07-28 17:53:20.311392+00
61	pbkdf2_sha256$180000$YskJ28A6Z2JR$TYn5Egy4ekV1nRCELelZ0PaRNxWjJvgYx/6RKhBsFgU=	\N	f	evered.rollison@example.com			evered.rollison@example.com	f	t	2020-07-28 17:53:20.430812+00
62	pbkdf2_sha256$180000$i2Yfq0YmdvQj$+o6FAQFOdKEtGMMJjIYY92ZAuk5TJNig1UQibBZZBp0=	\N	f	ardisj.streetman@example.com			ardisj.streetman@example.com	f	t	2020-07-28 17:53:20.551068+00
63	pbkdf2_sha256$180000$Hoziw3slLidX$lJBFnEWCmDevwq7V3PAlAdZPwqVIwNr/nZKBhYbmVqw=	\N	f	hortensia.michaelson@example.com			hortensia.michaelson@example.com	f	t	2020-07-28 17:53:20.674389+00
64	pbkdf2_sha256$180000$yDlNLNFYUo3L$RQqkSkTI6fL6ZCSQE9WvSl4Xq40GJFfmsRnZcccN8P4=	\N	f	grover.brojakowski@example.com			grover.brojakowski@example.com	f	t	2020-07-28 17:53:20.797898+00
65	pbkdf2_sha256$180000$lmziY0yK57GU$kiJLkoCeOpYSJnb3Cm2lxvpr8iSWH3eZGyXHM5YEgdE=	\N	f	dillie.senich@example.com			dillie.senich@example.com	f	t	2020-07-28 17:53:20.921234+00
66	pbkdf2_sha256$180000$uMHngNK0KcoF$1TYg6nFMnSBpuiBbYCnZT13ftiKMlAjjh7e8WySiU8I=	\N	f	jacquelyn.belliston@example.com			jacquelyn.belliston@example.com	f	t	2020-07-28 17:53:21.044059+00
67	pbkdf2_sha256$180000$v8GYy3VZ2Jj4$/5fereUacRt+F/BgP/H34huUs0YsIC/zIbmNhgy+iF4=	\N	f	friedrick.breisch@example.com			friedrick.breisch@example.com	f	t	2020-07-28 17:53:21.167556+00
68	pbkdf2_sha256$180000$5XHc7p5d9m8E$gjgygIq2WObRzuMJ8fNOLGzFQ64tSbl6E7Spi6tnzNw=	\N	f	auroora.sachar@example.com			auroora.sachar@example.com	f	t	2020-07-28 17:53:21.292423+00
69	pbkdf2_sha256$180000$GZ4cQA7ESRI2$jaUdxeknxRtctlj2He+NRBT9aw34FjLYWjD5FJmRHEs=	\N	f	britta.schermer@example.com			britta.schermer@example.com	f	t	2020-07-28 17:53:21.415377+00
70	pbkdf2_sha256$180000$xhY10qJjxMNg$XPoVFU4fqq5lKz0oBh5vXXziSa+IwBbXAbSbCoYIZqc=	\N	f	mariska.pellam@example.com			mariska.pellam@example.com	f	t	2020-07-28 17:53:21.541062+00
71	pbkdf2_sha256$180000$ljOjGczwaeS6$OZt1UPEcHthfPl9CXlk5HrKr0gGy7xIZ1yYG/GvlJe4=	\N	f	arthur.reisner@example.com			arthur.reisner@example.com	f	t	2020-07-28 17:53:21.6633+00
72	pbkdf2_sha256$180000$A2IDyOHr6vSZ$k0bumUN0U/CPtM/huUg6BePGzhjoT+5jIoS8kYaWJgA=	\N	f	william.proudfoot@example.com			william.proudfoot@example.com	f	t	2020-07-28 17:53:21.788368+00
73	pbkdf2_sha256$180000$cq82klupRvyO$859dEnIYMCwe0+GyeNzN+eP/0TZpW2Ma6+l183eEyLo=	\N	f	laurianne.albury@example.com			laurianne.albury@example.com	f	t	2020-07-28 17:53:21.910934+00
74	pbkdf2_sha256$180000$EUECSpRKkiZy$forFbPJh+/Ue74rbxSSi9Ia8pdGfxJ0WXCfpu9yb3pI=	\N	f	lucias.briar@example.com			lucias.briar@example.com	f	t	2020-07-28 17:53:22.035848+00
75	pbkdf2_sha256$180000$hLr9HMMHu2sy$fNbjkYnJFn+l50WwzMpw74V5jjTNumlDk0ctHgAud2c=	\N	f	xena.wion@example.com			xena.wion@example.com	f	t	2020-07-28 17:53:22.158393+00
76	pbkdf2_sha256$180000$GgqNhfwbtyJ4$rRQswQlXZzGLIERMBdZc4WkyLiC+dSU7njk0cxxUNfY=	\N	f	shawn.risien@example.com			shawn.risien@example.com	f	t	2020-07-28 17:53:22.283171+00
77	pbkdf2_sha256$180000$srqfWoIyDo0H$fllSyIMxWzu4BT+9wh8C1dfHbscWrFqRpNlnJPgzUZA=	\N	f	lothario.lanzillotti@example.com			lothario.lanzillotti@example.com	f	t	2020-07-28 17:53:22.406182+00
78	pbkdf2_sha256$180000$82F4dn8kZdV6$RN6ktxUZTTiVZZk5MbNaiJ9OLxW47ztOkWJxT0ikOMQ=	\N	f	addy.detz@example.com			addy.detz@example.com	f	t	2020-07-28 17:53:22.529558+00
79	pbkdf2_sha256$180000$zZydmCx5PWcu$9kaiaxigpT+T8NkJj9ie3Egwk1VjajyPxLplI2KVGPw=	\N	f	marius.eskra@example.com			marius.eskra@example.com	f	t	2020-07-28 17:53:22.654753+00
80	pbkdf2_sha256$180000$YDCahuGqWDX0$mQ0wRd3M0ZCI7xFseDwRaCNhlNR/aHw6oG+oHVdD8LI=	\N	f	andie.nowosielski@example.com			andie.nowosielski@example.com	f	t	2020-07-28 17:53:22.777897+00
81	pbkdf2_sha256$180000$QdS4tCap6oqU$s5x/e489zwuopIO+DIF4HzwdEhdi5vnrXUsyxebJMGM=	\N	f	sarene.holsworth@example.com			sarene.holsworth@example.com	f	t	2020-07-28 17:53:22.903623+00
82	pbkdf2_sha256$180000$daJdbXSUasN2$llANTvLT66Bhs9Iv7/UZDQgis7dOBVu1qp3W757DqSM=	\N	f	brandie.rotruck@example.com			brandie.rotruck@example.com	f	t	2020-07-28 17:53:23.028541+00
83	pbkdf2_sha256$180000$aGBZlv210zaa$XZ3of3TmFfBmTl7JpeUuNFgkvxa5HUs1U4iDywGOYjA=	\N	f	estrella.gosden@example.com			estrella.gosden@example.com	f	t	2020-07-28 17:53:23.156831+00
84	pbkdf2_sha256$180000$DTyNGKNX5IvS$gpQlmkSGbNztiTMRnL+tQWj1Jzwg6HaR0U83iAToFH8=	\N	f	merrili.gustine@example.com			merrili.gustine@example.com	f	t	2020-07-28 17:53:23.279791+00
85	pbkdf2_sha256$180000$mBZgNzKVmrLj$1VEdAqwzODXQVqwQoWsR8y92pTlixIOC0vOVFHA3qoY=	\N	f	eddy.angevine@example.com			eddy.angevine@example.com	f	t	2020-07-28 17:53:23.405816+00
86	pbkdf2_sha256$180000$g6hHwwElzvxt$d50gSUgN4VYTlzAgeoIrStcB6s3hlV/7QF05pngrIiM=	\N	f	pren.siddoway@example.com			pren.siddoway@example.com	f	t	2020-07-28 17:53:23.529263+00
87	pbkdf2_sha256$180000$GvE8cq91AcAr$AzFEB1Lc9Zo+xVB9krYac6fb1I6exn8uTJ1CYIdTMgc=	\N	f	susann.rightnour@example.com			susann.rightnour@example.com	f	t	2020-07-28 17:53:23.6554+00
88	pbkdf2_sha256$180000$sc2iy2uRxj23$mIbcFrOnRMF+7hgHLOyjyuYpg/IEOQPo3UT6o0geqRk=	\N	f	katha.spayd@example.com			katha.spayd@example.com	f	t	2020-07-28 17:53:23.780105+00
89	pbkdf2_sha256$180000$W1Rpmtuk1Qt9$6L9WCV6hA/0ZPioeUxPP5X63LlCcgBhszoBEwlZRzAU=	\N	f	pier.vensel@example.com			pier.vensel@example.com	f	t	2020-07-28 17:53:23.905515+00
90	pbkdf2_sha256$180000$7hipFGPdVTAT$84tu5Z1llD5ew81v1+NaSlwGU54p9L6LpeAvqEhSpRQ=	\N	f	marianne.lisi@example.com			marianne.lisi@example.com	f	t	2020-07-28 17:53:24.028389+00
91	pbkdf2_sha256$180000$kRNfJDLAoAW4$2QZqWtXBnHeHiQ4PzNzLquj1A5NRQvpvTpOdpYBcSlQ=	\N	f	dennie.skinkle@example.com			dennie.skinkle@example.com	f	t	2020-07-28 17:53:24.154461+00
92	pbkdf2_sha256$180000$Jll27WftfjQa$juS0fJja2zoe4Xbw4+Z5vLEhVVTYE8v3UdV3JWeu2wo=	\N	f	nikita.contratto@example.com			nikita.contratto@example.com	f	t	2020-07-28 17:53:24.277406+00
93	pbkdf2_sha256$180000$IufBr4pLGjnG$7O6/16plJtkziHeQhX6KDwUT1AchKfFgsO6umTKqHJ8=	\N	f	tremain.mchone@example.com			tremain.mchone@example.com	f	t	2020-07-28 17:53:24.403624+00
94	pbkdf2_sha256$180000$6yAavrcYBja3$jUieGCeL1b+HuTSwKKHiGV1zaiLpPFna3oeS8gJxBk0=	\N	f	caz.bruton@example.com			caz.bruton@example.com	f	t	2020-07-28 17:53:24.523314+00
95	pbkdf2_sha256$180000$OupxEmBV73h1$FtASYaZz4w67CJJzOWLIsGIrzX6vi+KvSXlkr+szRiY=	\N	f	isidora.lipner@example.com			isidora.lipner@example.com	f	t	2020-07-28 17:53:24.645064+00
96	pbkdf2_sha256$180000$6pRvXb7hB2QQ$mrjjbmWLZzkBVBnuqC/BX2kx7RGiqU1z+nqAiOT2OI4=	\N	f	margarete.salach@example.com			margarete.salach@example.com	f	t	2020-07-28 17:53:24.765083+00
97	pbkdf2_sha256$180000$SC0yQcXNpGhM$ZVwdKI7elgCCaKdLebPj8UZFUt4iqJbMBJGwyUchoJE=	\N	f	bart.vangoff@example.com			bart.vangoff@example.com	f	t	2020-07-28 17:53:24.886895+00
98	pbkdf2_sha256$180000$xt8QPwHgqfZK$uVjza++3Rd5gCJC6fV5LLCJ2DlEjmNZuX4SlGZJdVOQ=	\N	f	lionel.smolski@example.com			lionel.smolski@example.com	f	t	2020-07-28 17:53:25.006622+00
99	pbkdf2_sha256$180000$5tU182tjtMnL$boqKUNL1n+/W+dhjnuSeqRqWvTFKO0QPw39GuCUiPNw=	\N	f	tierney.zeltner@example.com			tierney.zeltner@example.com	f	t	2020-07-28 17:53:25.128812+00
100	pbkdf2_sha256$180000$X89vSmUbNXqy$DGr5vRA/Z1764Ku7sWJW7y3+wzKfSWtxss0uvqKkh40=	\N	f	con.jacque@example.com			con.jacque@example.com	f	t	2020-07-28 17:53:25.248158+00
101	pbkdf2_sha256$180000$pg9CCQhGZMum$ln2ZE61DkfrNTwZaA8DOxzAsHnmz2E3U/gZ5nW04KDk=	\N	f	alicia.fusco@example.com			alicia.fusco@example.com	f	t	2020-07-28 17:53:25.370496+00
1	pbkdf2_sha256$180000$aZYSzMmFWB6y$LssIFFifm8PRf9lW3D0RtbH0PccorOQCRAXgFnu2GMM=	2020-07-28 17:56:30.73839+00	f	admin@example.com			admin@example.com	t	t	2020-07-28 17:53:13.116103+00
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: moneyhabitudes
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: moneyhabitudes
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: moneyhabitudes
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	auth	permission
2	auth	group
3	auth	user
4	contenttypes	contenttype
5	sessions	session
6	accounts	account
7	accounts	share
8	accounts	branding
9	accounts	availablegames
10	games	game
11	orders	subscription
12	orders	order
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: moneyhabitudes
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	accounts	0001_initial	2020-07-28 17:52:32.654195+00
2	orders	0001_initial	2020-07-28 17:52:32.689012+00
3	contenttypes	0001_initial	2020-07-28 17:52:32.707879+00
4	auth	0001_initial	2020-07-28 17:52:32.771672+00
5	accounts	0002_auto_20200508_1103	2020-07-28 17:52:32.851978+00
6	contenttypes	0002_remove_content_type_name	2020-07-28 17:52:32.875392+00
7	auth	0002_alter_permission_name_max_length	2020-07-28 17:52:32.880122+00
8	auth	0003_alter_user_email_max_length	2020-07-28 17:52:32.88945+00
9	auth	0004_alter_user_username_opts	2020-07-28 17:52:32.898461+00
10	auth	0005_alter_user_last_login_null	2020-07-28 17:52:32.907938+00
11	auth	0006_require_contenttypes_0002	2020-07-28 17:52:32.910323+00
12	auth	0007_alter_validators_add_error_messages	2020-07-28 17:52:32.91943+00
13	auth	0008_alter_user_username_max_length	2020-07-28 17:52:32.932123+00
14	auth	0009_alter_user_last_name_max_length	2020-07-28 17:52:32.944396+00
15	auth	0010_alter_group_name_max_length	2020-07-28 17:52:32.954902+00
16	auth	0011_update_proxy_permissions	2020-07-28 17:52:32.969373+00
17	games	0001_initial	2020-07-28 17:52:32.99732+00
18	sessions	0001_initial	2020-07-28 17:52:33.033818+00
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: moneyhabitudes
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
\.


--
-- Data for Name: games_game; Type: TABLE DATA; Schema: public; Owner: moneyhabitudes
--

COPY public.games_game (id, created_date, modified_date, cardset, data, player_name, player_email, share_name, last_activity_date, completed, owner_id, player_id, share_id) FROM stdin;
83324a92-24c7-4336-b410-9135e22f5688	2020-07-28 17:53:25.499994+00	2020-07-28 17:53:25.619773+00	adult	{"answers": [-1, -1, 1, 1, -1, -1, -1, 1, 1, 1, -1, 0, -1, 1, 1, 1, -1, 0, 0, 1, 0, 1, 0, 0, -1, 0, -1, 1, 1, -1, 0, 0, -1, -1, 0, 0, 1, 1, -1, 0, 1, -1, 1, 1, -1, 1, -1, -1, 1, 0, 0, 1, 0, -1], "categories": {"ca": {"0": 4, "1": 2, "-1": 3}, "gi": {"0": 1, "1": 5, "-1": 3}, "pl": {"0": 3, "1": 3, "-1": 3}, "se": {"0": 0, "1": 4, "-1": 5}, "sp": {"0": 2, "1": 4, "-1": 3}, "st": {"0": 5, "1": 2, "-1": 2}}}	Alicia Fusco	alicia.fusco@example.com	Fitchburg Conference	2020-07-28 17:53:25.616289+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	bdff9a62-3dc2-491a-a24b-53926037bd0a	ada2b23a-e5cf-4b55-a6e8-f04f41eb355d
50906ded-6039-4f23-b094-47284a2e9fd6	2020-07-28 17:53:25.624375+00	2020-07-28 17:53:25.789625+00	adult	{"answers": [1, 0, -1, -1, 1, 1, 1, 0, 1, 0, -1, -1, -1, 1, 0, -1, 1, 1, -1, 0, 1, -1, 1, 0, 1, -1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1, -1, 1, 0, 0, 1, -1, 0, 1, 0, 1, -1, 1, -1, 0, 1, 0, 0, 0], "categories": {"ca": {"0": 4, "1": 5, "-1": 0}, "gi": {"0": 4, "1": 3, "-1": 2}, "pl": {"0": 4, "1": 3, "-1": 2}, "se": {"0": 2, "1": 5, "-1": 2}, "sp": {"0": 2, "1": 3, "-1": 4}, "st": {"0": 3, "1": 3, "-1": 3}}}	Con Jacque	con.jacque@example.com	Fitchburg Conference	2020-07-28 17:53:25.787943+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	a926dba0-9cef-4cfa-a783-bb60364fbea7	ada2b23a-e5cf-4b55-a6e8-f04f41eb355d
ee3454f2-a337-4f6b-89a5-163f46f4a785	2020-07-28 17:53:25.792538+00	2020-07-28 17:53:25.891036+00	adult	{"answers": [-1, 1, 0, -1, 1, -1, 1, -1, 0, 1, -1, -1, 0, 1, 1, 1, -1, 0, -1, 0, -1, -1, 0, 0, 1, 0, 0, 1, 0, 1, -1, 1, 1, 0, 1, 0, 0, 0, 0, 1, 1, -1, -1, 1, -1, 1, 0, 0, 0, 0, 1, 0, 1, 1], "categories": {"ca": {"0": 3, "1": 5, "-1": 1}, "gi": {"0": 3, "1": 3, "-1": 3}, "pl": {"0": 5, "1": 4, "-1": 0}, "se": {"0": 2, "1": 3, "-1": 4}, "sp": {"0": 2, "1": 4, "-1": 3}, "st": {"0": 5, "1": 1, "-1": 3}}}	Tierney Zeltner	tierney.zeltner@example.com	Fitchburg Conference	2020-07-28 17:53:25.887631+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	f82cb44c-391d-4389-b743-690ec29742a7	ada2b23a-e5cf-4b55-a6e8-f04f41eb355d
1d055d05-b8d1-43b3-90b3-47a5df321c1e	2020-07-28 17:53:25.895661+00	2020-07-28 17:53:26.080872+00	adult	{"answers": [-1, 0, 1, -1, 1, -1, -1, 1, 1, 0, -1, 1, 1, 0, 1, -1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, -1, 1, -1, -1, 0, 1, -1, 1, -1, 0, 1, 1, -1, 0, 0, 1, 1, 0, 1, 0, 0, 1, -1, 0, 1, 1, 0, -1], "categories": {"ca": {"0": 2, "1": 3, "-1": 4}, "gi": {"0": 3, "1": 5, "-1": 1}, "pl": {"0": 4, "1": 3, "-1": 2}, "se": {"0": 1, "1": 4, "-1": 4}, "sp": {"0": 3, "1": 4, "-1": 2}, "st": {"0": 3, "1": 5, "-1": 1}}}	Lionel Smolski	lionel.smolski@example.com	Fitchburg Conference	2020-07-28 17:53:26.079201+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	2f135876-64ff-4444-85f9-5f4709987037	ada2b23a-e5cf-4b55-a6e8-f04f41eb355d
a0df2e5b-5b6b-4a09-a82d-1f4c4a8cce0e	2020-07-28 17:53:26.08378+00	2020-07-28 17:53:26.170625+00	adult	{"answers": [1, 1, -1, 0, 1, -1, 0, -1, -1, 1, 1, 1, -1, -1, 1, -1, 1, 0, 0, 1, 1, 0, -1, 1, 1, 0, 0, -1, -1, 1, -1, 0, 0, -1, 1, 1, -1, 0, 1, -1, 1, 0, -1, 1, 0, -1, 1, 0, -1, -1, -1, -1, 0, -1], "categories": {"ca": {"0": 2, "1": 3, "-1": 4}, "gi": {"0": 3, "1": 3, "-1": 3}, "pl": {"0": 2, "1": 1, "-1": 6}, "se": {"0": 2, "1": 3, "-1": 4}, "sp": {"0": 1, "1": 5, "-1": 3}, "st": {"0": 4, "1": 4, "-1": 1}}}	Bart Vangoff	bart.vangoff@example.com	Fitchburg Conference	2020-07-28 17:53:26.169+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	49a6c204-8074-4ab5-966c-8db7ea863d20	ada2b23a-e5cf-4b55-a6e8-f04f41eb355d
dedf9c3c-0ee3-4371-a960-fd4ce3d50f95	2020-07-28 17:53:26.173393+00	2020-07-28 17:53:26.352485+00	adult	{"answers": [1, -1, -1, 1, -1, -1, 1, 0, 0, 1, 1, -1, -1, 1, 0, 1, -1, 1, -1, 0, 0, 1, -1, -1, 0, 0, -1, 1, 0, 1, -1, 1, 0, 1, 1, -1, -1, 0, -1, -1, -1, 0, 1, -1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1], "categories": {"ca": {"0": 2, "1": 5, "-1": 2}, "gi": {"0": 3, "1": 1, "-1": 5}, "pl": {"0": 6, "1": 3, "-1": 0}, "se": {"0": 2, "1": 3, "-1": 4}, "sp": {"0": 1, "1": 5, "-1": 3}, "st": {"0": 4, "1": 1, "-1": 4}}}	Margarete Salach	margarete.salach@example.com	Fitchburg Conference	2020-07-28 17:53:26.349023+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	f402cd46-4a05-4d68-93b4-9da85d4802db	ada2b23a-e5cf-4b55-a6e8-f04f41eb355d
d7e9c5cd-c062-485c-97b8-8d65861a12b5	2020-07-28 17:53:26.35718+00	2020-07-28 17:53:26.462363+00	adult	{"answers": [1, 1, 1, -1, 0, -1, 1, -1, -1, 0, 1, 1, -1, 0, 1, -1, 0, 1, 0, 1, 1, 1, 1, -1, -1, 1, -1, -1, 0, 1, 0, 0, 0, 0, 1, 0, -1, 1, -1, -1, 1, -1, 1, 1, -1, 1, -1, -1, 1, 0, 1, 1, 1, 0], "categories": {"ca": {"0": 6, "1": 2, "-1": 1}, "gi": {"0": 0, "1": 4, "-1": 5}, "pl": {"0": 2, "1": 5, "-1": 2}, "se": {"0": 1, "1": 4, "-1": 4}, "sp": {"0": 3, "1": 4, "-1": 2}, "st": {"0": 1, "1": 5, "-1": 3}}}	Isidora Lipner	isidora.lipner@example.com	Fitchburg Conference	2020-07-28 17:53:26.46076+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	bbb3b9e8-c374-4b3d-87ce-3b9e37b0fce3	ada2b23a-e5cf-4b55-a6e8-f04f41eb355d
1e738674-cf9a-4b6a-9da5-2374fa3b5b24	2020-07-28 17:53:26.465162+00	2020-07-28 17:53:26.621993+00	adult	{"answers": [0, 1, 0, 1, 1, -1, -1, -1, 1, -1, -1, -1, 1, 1, 0, -1, 0, 0, 0, 0, 0, -1, 1, 1, -1, 1, 0, 0, 0, -1, 1, 0, -1, -1, 0, -1, 0, 0, -1, 0, 0, 1, 0, 1, 0, 0, 1, -1, 0, -1, 0, 0, 1, 0], "categories": {"ca": {"0": 4, "1": 1, "-1": 4}, "gi": {"0": 6, "1": 2, "-1": 1}, "pl": {"0": 5, "1": 2, "-1": 2}, "se": {"0": 2, "1": 4, "-1": 3}, "sp": {"0": 3, "1": 2, "-1": 4}, "st": {"0": 4, "1": 3, "-1": 2}}}	Caz Bruton	caz.bruton@example.com	Fitchburg Conference	2020-07-28 17:53:26.618699+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	e5daee69-c821-4eb8-8e56-820752cf4aea	ada2b23a-e5cf-4b55-a6e8-f04f41eb355d
88cb1242-72ad-4696-9929-254af88cd01a	2020-07-28 17:53:26.626514+00	2020-07-28 17:53:26.751775+00	adult	{"answers": [-1, -1, 1, 0, 0, 0, 0, 1, 0, 1, -1, 1, 1, 0, -1, 0, -1, 0, 0, 0, 0, 0, 0, 1, -1, 1, 0, 1, 0, -1, 1, 0, -1, 1, -1, -1, -1, 1, 1, 0, 1, -1, 0, 1, -1, -1, 0, -1, -1, 1, 0, -1, 0, 0], "categories": {"ca": {"0": 2, "1": 3, "-1": 4}, "gi": {"0": 2, "1": 4, "-1": 3}, "pl": {"0": 4, "1": 1, "-1": 4}, "se": {"0": 5, "1": 2, "-1": 2}, "sp": {"0": 3, "1": 3, "-1": 3}, "st": {"0": 6, "1": 2, "-1": 1}}}	Tremain Mchone	tremain.mchone@example.com	Fitchburg Conference	2020-07-28 17:53:26.750186+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	ffec3b14-19f1-447b-add9-32216bf65726	ada2b23a-e5cf-4b55-a6e8-f04f41eb355d
24c16d69-00d9-43dd-9529-1e151cf487e5	2020-07-28 17:53:26.754506+00	2020-07-28 17:53:26.889827+00	adult	{"answers": [0, 0, 0, 1, 1, -1, -1, 0, 1, 1, 1, 1, 1, 1, 0, 1, -1, 0, 1, 1, -1, 0, -1, 0, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, 1, 0, -1, 1, -1, -1, -1, 1, 0, -1, 1, 0, 1, 1, 0, -1, 0, 0, 0], "categories": {"ca": {"0": 0, "1": 2, "-1": 7}, "gi": {"0": 2, "1": 2, "-1": 5}, "pl": {"0": 5, "1": 3, "-1": 1}, "se": {"0": 4, "1": 3, "-1": 2}, "sp": {"0": 2, "1": 6, "-1": 1}, "st": {"0": 2, "1": 3, "-1": 4}}}	Nikita Contratto	nikita.contratto@example.com	Fitchburg Conference	2020-07-28 17:53:26.886349+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	64c51e8e-a340-4eaa-ac23-6178d7d5a9a2	ada2b23a-e5cf-4b55-a6e8-f04f41eb355d
7d518058-a3d2-4955-9852-f106201fa253	2020-07-28 17:53:26.894511+00	2020-07-28 17:53:27.04241+00	adult	{"answers": [0, 0, -1, 0, 0, 1, 1, -1, 0, 1, 0, 0, 0, 0, -1, 1, 0, 0, 1, 1, -1, -1, 1, -1, 0, -1, 0, 1, 0, 0, 1, 1, 1, 0, -1, -1, 1, 1, 0, 0, 1, 1, 0, 1, -1, 1, 0, -1, 0, -1, 0, 0, 1, -1], "categories": {"ca": {"0": 3, "1": 4, "-1": 2}, "gi": {"0": 3, "1": 5, "-1": 1}, "pl": {"0": 4, "1": 2, "-1": 3}, "se": {"0": 5, "1": 2, "-1": 2}, "sp": {"0": 6, "1": 2, "-1": 1}, "st": {"0": 2, "1": 3, "-1": 4}}}	Dennie Skinkle	dennie.skinkle@example.com	Fitchburg Conference	2020-07-28 17:53:27.040766+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	f6115c05-14df-4beb-a7df-3f2410cf96a2	ada2b23a-e5cf-4b55-a6e8-f04f41eb355d
75dea0d2-96aa-44f0-9870-4bf2f9d82344	2020-07-28 17:53:27.045229+00	2020-07-28 17:53:27.160474+00	adult	{"answers": [1, -1, -1, -1, 0, 0, -1, 1, -1, 1, -1, 1, 1, 1, 0, 1, 0, -1, 0, 1, -1, -1, -1, 1, 0, -1, 1, 1, 0, 1, 1, 0, 0, -1, -1, 0, 1, 1, 0, 1, 1, -1, 0, 1, 1, 0, 1, 0, 0, 1, 0, -1, 0, 1], "categories": {"ca": {"0": 4, "1": 3, "-1": 2}, "gi": {"0": 2, "1": 6, "-1": 1}, "pl": {"0": 5, "1": 3, "-1": 1}, "se": {"0": 2, "1": 2, "-1": 5}, "sp": {"0": 2, "1": 5, "-1": 2}, "st": {"0": 2, "1": 3, "-1": 4}}}	Marianne Lisi	marianne.lisi@example.com	Fitchburg Conference	2020-07-28 17:53:27.157066+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	c4bd2578-506e-4f55-9ad4-726f99100c15	ada2b23a-e5cf-4b55-a6e8-f04f41eb355d
2955529a-2f5b-4c45-aae6-93bee4e250a8	2020-07-28 17:53:27.165069+00	2020-07-28 17:53:27.333142+00	adult	{"answers": [1, 0, 1, 0, 0, -1, 0, 1, -1, 1, -1, -1, 1, 0, -1, 1, 0, 1, 1, -1, 0, -1, -1, 1, 1, -1, -1, 1, 1, -1, 1, 0, 0, -1, -1, -1, -1, 0, -1, -1, 1, 1, -1, 1, -1, 0, -1, -1, 1, 0, 0, -1, 1, -1], "categories": {"ca": {"0": 2, "1": 3, "-1": 4}, "gi": {"0": 1, "1": 3, "-1": 5}, "pl": {"0": 3, "1": 2, "-1": 4}, "se": {"0": 4, "1": 3, "-1": 2}, "sp": {"0": 2, "1": 4, "-1": 3}, "st": {"0": 1, "1": 3, "-1": 5}}}	Pier Vensel	pier.vensel@example.com	Fitchburg Conference	2020-07-28 17:53:27.331456+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	fc1d97ae-33dd-41d7-bb2e-691378dd0ad2	ada2b23a-e5cf-4b55-a6e8-f04f41eb355d
d2c3c34e-2115-4560-b694-3a9cf8876bd6	2020-07-28 17:53:27.336109+00	2020-07-28 17:53:27.430865+00	adult	{"answers": [0, 0, -1, 1, -1, 0, 1, 1, -1, 1, 0, 0, -1, 0, -1, 1, 0, -1, 0, 1, 0, 0, 0, 1, 0, -1, 0, 0, 0, 1, -1, 0, 1, 0, 1, 1, 1, 0, 0, 0, -1, 1, 1, -1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0], "categories": {"ca": {"0": 4, "1": 4, "-1": 1}, "gi": {"0": 3, "1": 4, "-1": 2}, "pl": {"0": 3, "1": 6, "-1": 0}, "se": {"0": 3, "1": 3, "-1": 3}, "sp": {"0": 4, "1": 2, "-1": 3}, "st": {"0": 6, "1": 2, "-1": 1}}}	Katha Spayd	katha.spayd@example.com	Fitchburg Conference	2020-07-28 17:53:27.427523+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	8a820dca-bd6e-4f6e-a3a7-8d3d4e1f1d0b	ada2b23a-e5cf-4b55-a6e8-f04f41eb355d
e037ff09-583a-424d-b926-856d73c56196	2020-07-28 17:53:27.435313+00	2020-07-28 17:53:27.622888+00	adult	{"answers": [-1, 0, 0, -1, 1, 1, 1, 1, -1, 1, 0, 1, 1, 0, -1, 0, -1, -1, 0, 1, 1, 1, 0, 1, 0, 0, 0, -1, 1, 0, -1, -1, 0, 1, 0, 0, 0, -1, 0, 0, -1, 1, -1, -1, 0, 1, 1, -1, 1, -1, 0, -1, -1, -1], "categories": {"ca": {"0": 4, "1": 2, "-1": 3}, "gi": {"0": 4, "1": 1, "-1": 4}, "pl": {"0": 1, "1": 3, "-1": 5}, "se": {"0": 2, "1": 4, "-1": 3}, "sp": {"0": 3, "1": 3, "-1": 3}, "st": {"0": 5, "1": 4, "-1": 0}}}	Susann Rightnour	susann.rightnour@example.com	Fitchburg Conference	2020-07-28 17:53:27.61943+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	65638264-60fb-453a-a4b5-96c2185e1c64	ada2b23a-e5cf-4b55-a6e8-f04f41eb355d
ef7b183a-3524-4336-80b5-f2d0c9b2803f	2020-07-28 17:53:27.627509+00	2020-07-28 17:53:27.714813+00	adult	{"answers": [1, 1, 1, 1, 0, 0, 0, -1, -1, -1, 1, 0, 1, -1, 1, 1, 0, -1, -1, 1, -1, 1, 0, 1, 1, -1, -1, -1, 0, -1, 1, 0, -1, 1, 0, 0, 0, 1, 1, -1, 0, 1, 1, -1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1], "categories": {"ca": {"0": 4, "1": 2, "-1": 3}, "gi": {"0": 2, "1": 5, "-1": 2}, "pl": {"0": 3, "1": 6, "-1": 0}, "se": {"0": 3, "1": 4, "-1": 2}, "sp": {"0": 2, "1": 4, "-1": 3}, "st": {"0": 1, "1": 4, "-1": 4}}}	Pren Siddoway	pren.siddoway@example.com	Fitchburg Conference	2020-07-28 17:53:27.71317+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	9786beb4-8a4d-4568-a47c-305c7a010af1	ada2b23a-e5cf-4b55-a6e8-f04f41eb355d
8a23dacd-5c57-4eba-ab47-28fa8f0d313d	2020-07-28 17:53:27.724111+00	2020-07-28 17:53:27.906019+00	adult	{"answers": [0, -1, 1, 1, -1, 1, 1, 1, 0, -1, 0, -1, -1, -1, -1, 1, 1, 1, -1, -1, 1, 1, -1, -1, -1, -1, 1, 0, 0, -1, -1, 1, -1, -1, 0, 0, -1, 0, 1, 1, 1, -1, -1, 1, 1, 1, -1, -1, 1, 1, -1, 0, 0, 1], "categories": {"ca": {"0": 4, "1": 1, "-1": 4}, "gi": {"0": 1, "1": 5, "-1": 3}, "pl": {"0": 2, "1": 4, "-1": 3}, "se": {"0": 2, "1": 5, "-1": 2}, "sp": {"0": 1, "1": 3, "-1": 5}, "st": {"0": 0, "1": 3, "-1": 6}}}	Eddy Angevine	eddy.angevine@example.com	Tustin Conference	2020-07-28 17:53:27.902471+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	fdc8c2e0-d9f0-48df-90ae-9c5f83add885	28144124-3a15-494a-b3b0-a2b9b92dd64d
a359bada-4df7-4c41-9dcf-03c6b435f6c4	2020-07-28 17:53:27.910978+00	2020-07-28 17:53:28.017151+00	adult	{"answers": [1, 0, -1, 1, 0, -1, 1, 0, 1, 1, -1, 0, 0, 1, -1, 1, 0, 1, 0, 1, 1, 0, 0, 0, 1, 1, -1, -1, 1, 1, 1, -1, 1, 0, -1, 1, 0, -1, -1, 1, 0, -1, -1, 0, -1, -1, 0, -1, -1, 1, 1, 0, 1, 1], "categories": {"ca": {"0": 1, "1": 5, "-1": 3}, "gi": {"0": 3, "1": 1, "-1": 5}, "pl": {"0": 2, "1": 4, "-1": 3}, "se": {"0": 3, "1": 4, "-1": 2}, "sp": {"0": 3, "1": 4, "-1": 2}, "st": {"0": 4, "1": 4, "-1": 1}}}	Merrili Gustine	merrili.gustine@example.com	Tustin Conference	2020-07-28 17:53:28.015522+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	c57ef02d-8bd9-46f4-9085-1f1d57cb0194	28144124-3a15-494a-b3b0-a2b9b92dd64d
e1395f5d-7f62-4fda-9e18-6fee973050d8	2020-07-28 17:53:28.020096+00	2020-07-28 17:53:28.180422+00	adult	{"answers": [0, -1, 1, 0, 0, -1, 1, 1, 1, 1, -1, 0, 0, -1, -1, -1, 0, -1, -1, 1, 1, -1, 0, -1, -1, -1, -1, 1, 0, 0, 0, 0, 0, 0, 1, 1, -1, 1, -1, -1, -1, -1, 0, -1, 0, 1, 1, -1, 0, -1, 0, 0, 1, -1], "categories": {"ca": {"0": 6, "1": 3, "-1": 0}, "gi": {"0": 2, "1": 1, "-1": 6}, "pl": {"0": 3, "1": 3, "-1": 3}, "se": {"0": 3, "1": 4, "-1": 2}, "sp": {"0": 3, "1": 1, "-1": 5}, "st": {"0": 1, "1": 2, "-1": 6}}}	Estrella Gosden	estrella.gosden@example.com	Tustin Conference	2020-07-28 17:53:28.176925+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	41339314-7b6c-4a87-9ef2-2d7f664730c7	28144124-3a15-494a-b3b0-a2b9b92dd64d
d0266219-265c-4bad-a48a-0064344996fe	2020-07-28 17:53:28.18511+00	2020-07-28 17:53:28.315211+00	adult	{"answers": [-1, 1, -1, 0, 0, 1, -1, 0, 1, -1, 0, -1, -1, -1, 1, 1, 1, -1, 0, 0, 0, 1, 1, 0, 0, -1, 0, 1, -1, -1, -1, 1, 1, 0, 1, 0, 0, 0, 0, 0, -1, 1, 1, 0, 1, 0, 1, 1, 1, 1, -1, 0, -1, -1], "categories": {"ca": {"0": 2, "1": 4, "-1": 3}, "gi": {"0": 5, "1": 3, "-1": 1}, "pl": {"0": 2, "1": 4, "-1": 3}, "se": {"0": 3, "1": 3, "-1": 3}, "sp": {"0": 1, "1": 3, "-1": 5}, "st": {"0": 6, "1": 2, "-1": 1}}}	Brandie Rotruck	brandie.rotruck@example.com	Tustin Conference	2020-07-28 17:53:28.313513+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	61a9b975-f980-4a93-a15d-4d6ac6e7c946	28144124-3a15-494a-b3b0-a2b9b92dd64d
b93ceffb-faaf-4841-bf3d-ca38ece9657c	2020-07-28 17:53:28.318043+00	2020-07-28 17:53:28.457564+00	adult	{"answers": [1, 0, -1, 0, 1, 0, 0, 0, -1, 0, -1, 0, 1, 1, -1, -1, 1, 0, -1, -1, 1, -1, 1, -1, -1, -1, -1, 0, -1, -1, 1, 0, -1, 1, -1, 0, 1, 1, -1, 1, 0, -1, 1, 0, 1, 0, -1, 1, -1, 0, 0, 0, 1, 1], "categories": {"ca": {"0": 3, "1": 2, "-1": 4}, "gi": {"0": 2, "1": 5, "-1": 2}, "pl": {"0": 4, "1": 3, "-1": 2}, "se": {"0": 5, "1": 2, "-1": 2}, "sp": {"0": 3, "1": 3, "-1": 3}, "st": {"0": 0, "1": 2, "-1": 7}}}	Sarene Holsworth	sarene.holsworth@example.com	Tustin Conference	2020-07-28 17:53:28.45407+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	d8f2fccf-6ee7-4f63-84ea-f24266776a98	28144124-3a15-494a-b3b0-a2b9b92dd64d
86e64427-4244-4c1d-91d5-1abf1ab2aedd	2020-07-28 17:53:28.462268+00	2020-07-28 17:53:28.613431+00	adult	{"answers": [-1, 1, 1, -1, 0, 1, 0, 0, -1, -1, 1, -1, 1, 1, -1, -1, 1, 0, -1, 0, -1, 0, 0, 0, -1, -1, 0, 0, -1, -1, 0, 0, 1, 0, -1, 1, -1, 1, 1, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 1, 0, -1, -1], "categories": {"ca": {"0": 4, "1": 2, "-1": 3}, "gi": {"0": 3, "1": 5, "-1": 1}, "pl": {"0": 3, "1": 4, "-1": 2}, "se": {"0": 3, "1": 3, "-1": 3}, "sp": {"0": 1, "1": 4, "-1": 4}, "st": {"0": 5, "1": 0, "-1": 4}}}	Andie Nowosielski	andie.nowosielski@example.com	Tustin Conference	2020-07-28 17:53:28.611815+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	179fd8a2-3b08-4a0b-a539-62d43d924664	28144124-3a15-494a-b3b0-a2b9b92dd64d
1a9c7a6c-61d1-4993-8fec-755a56be7585	2020-07-28 17:53:28.616292+00	2020-07-28 17:53:28.732358+00	adult	{"answers": [0, 0, 1, 0, 1, 1, 0, 1, -1, 1, -1, 0, -1, -1, 0, 1, -1, -1, 1, 1, 0, 0, -1, 1, 1, 1, 1, 0, 1, -1, 1, 1, 1, 0, 0, 0, 0, 1, -1, 0, 1, 0, -1, -1, 0, 1, -1, -1, 1, 1, 0, 1, 0, 1], "categories": {"ca": {"0": 4, "1": 4, "-1": 1}, "gi": {"0": 4, "1": 2, "-1": 3}, "pl": {"0": 2, "1": 5, "-1": 2}, "se": {"0": 4, "1": 4, "-1": 1}, "sp": {"0": 2, "1": 2, "-1": 5}, "st": {"0": 2, "1": 6, "-1": 1}}}	Marius Eskra	marius.eskra@example.com	Tustin Conference	2020-07-28 17:53:28.728971+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	d1944ddb-6689-4d71-8cdc-194e15dbf01e	28144124-3a15-494a-b3b0-a2b9b92dd64d
c5b85549-f5ce-4bb0-a6e8-944ba12d0f82	2020-07-28 17:53:28.74694+00	2020-07-28 17:53:28.916436+00	adult	{"answers": [-1, 1, -1, 1, -1, -1, 0, 1, -1, 0, 0, 1, 1, -1, 0, 1, 1, 1, 0, 1, -1, -1, -1, -1, 0, 1, 0, 1, -1, 0, 0, 0, -1, 0, 1, 0, 1, 0, -1, 0, 1, -1, 1, 1, 1, -1, 1, 1, -1, 1, 0, -1, -1, 0], "categories": {"ca": {"0": 5, "1": 2, "-1": 2}, "gi": {"0": 2, "1": 5, "-1": 2}, "pl": {"0": 2, "1": 3, "-1": 4}, "se": {"0": 1, "1": 3, "-1": 5}, "sp": {"0": 3, "1": 5, "-1": 1}, "st": {"0": 3, "1": 2, "-1": 4}}}	Addy Detz	addy.detz@example.com	Forest Hills Conference	2020-07-28 17:53:28.914781+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	223151de-c49c-43a6-be39-f8d6f3d75980	2374e192-153a-47ea-9f55-6e1d3cce8f2c
723f887e-5c59-40dc-8bc1-212c8c4d1cd9	2020-07-28 17:53:28.919239+00	2020-07-28 17:53:29.017062+00	adult	{"answers": [-1, 1, 1, -1, 1, 0, -1, 1, 1, 1, 0, 1, 1, 1, -1, -1, -1, -1, 1, 0, 1, 0, -1, -1, 0, 0, 1, 1, 1, 1, 0, 1, -1, -1, 1, 0, -1, -1, 0, 1, 1, -1, 0, -1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0], "categories": {"ca": {"0": 2, "1": 5, "-1": 2}, "gi": {"0": 3, "1": 2, "-1": 4}, "pl": {"0": 4, "1": 5, "-1": 0}, "se": {"0": 1, "1": 5, "-1": 3}, "sp": {"0": 1, "1": 4, "-1": 4}, "st": {"0": 4, "1": 3, "-1": 2}}}	Lothario Lanzillotti	lothario.lanzillotti@example.com	Forest Hills Conference	2020-07-28 17:53:29.013752+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	da19874c-ea5e-48ff-ae3c-f9d8a14eaf36	2374e192-153a-47ea-9f55-6e1d3cce8f2c
cd79ac6d-adc2-4934-9eae-d3ef5b5bf450	2020-07-28 17:53:29.021655+00	2020-07-28 17:53:29.211696+00	adult	{"answers": [1, 0, 1, 1, 0, 1, 1, 0, -1, 1, -1, 1, -1, 0, 1, 0, 1, -1, -1, 1, 0, 1, -1, -1, 1, 0, -1, 1, -1, 0, 1, 0, 0, 0, 0, 1, 1, 0, -1, 1, -1, 1, 1, 0, 1, -1, -1, 0, -1, 1, -1, -1, -1, 0], "categories": {"ca": {"0": 5, "1": 3, "-1": 1}, "gi": {"0": 2, "1": 5, "-1": 2}, "pl": {"0": 2, "1": 1, "-1": 6}, "se": {"0": 3, "1": 5, "-1": 1}, "sp": {"0": 2, "1": 4, "-1": 3}, "st": {"0": 2, "1": 3, "-1": 4}}}	Shawn Risien	shawn.risien@example.com	Forest Hills Conference	2020-07-28 17:53:29.20993+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	e74655ac-86cf-4baf-9ff1-489df7e798c7	2374e192-153a-47ea-9f55-6e1d3cce8f2c
96702ab6-889f-42bd-b3bf-0323a7b223e7	2020-07-28 17:53:29.214753+00	2020-07-28 17:53:29.302208+00	adult	{"answers": [-1, -1, 0, 0, 0, 1, 1, 0, -1, 0, 0, -1, 1, -1, 1, 1, 0, 0, -1, -1, -1, 1, -1, 1, -1, -1, 1, 1, 0, 0, 0, -1, 0, 1, -1, -1, -1, -1, 1, 0, -1, 0, -1, 1, -1, 1, -1, -1, 0, 0, 0, -1, 0, 1], "categories": {"ca": {"0": 4, "1": 2, "-1": 3}, "gi": {"0": 2, "1": 2, "-1": 5}, "pl": {"0": 4, "1": 2, "-1": 3}, "se": {"0": 4, "1": 2, "-1": 3}, "sp": {"0": 4, "1": 3, "-1": 2}, "st": {"0": 0, "1": 3, "-1": 6}}}	Xena Wion	xena.wion@example.com	Forest Hills Conference	2020-07-28 17:53:29.300587+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	63715a3f-f503-46c5-8b2c-9335e68b4693	2374e192-153a-47ea-9f55-6e1d3cce8f2c
ae9005d2-26ce-489a-a9f9-80439d54bff4	2020-07-28 17:53:29.305022+00	2020-07-28 17:53:29.487391+00	adult	{"answers": [-1, 0, 1, 1, 0, -1, 0, -1, 0, 1, 0, -1, -1, 0, -1, 1, -1, -1, 1, 1, 1, 0, 0, -1, 1, 0, -1, 1, 0, 0, 0, 0, -1, 0, 1, -1, -1, 0, 0, 0, -1, 0, -1, 0, 0, 0, 0, -1, 0, 0, 1, 0, 0, -1], "categories": {"ca": {"0": 5, "1": 2, "-1": 2}, "gi": {"0": 6, "1": 0, "-1": 3}, "pl": {"0": 6, "1": 1, "-1": 2}, "se": {"0": 4, "1": 2, "-1": 3}, "sp": {"0": 2, "1": 2, "-1": 5}, "st": {"0": 3, "1": 4, "-1": 2}}}	Lucias Briar	lucias.briar@example.com	Forest Hills Conference	2020-07-28 17:53:29.483861+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	b17a5b14-1456-4933-8f1f-237ebdf27cda	2374e192-153a-47ea-9f55-6e1d3cce8f2c
229530a8-c047-45c5-990f-ad25bdd59fa8	2020-07-28 17:53:29.502547+00	2020-07-28 17:53:29.605998+00	adult	{"answers": [0, 1, -1, 0, -1, 1, 1, 0, -1, -1, 0, 0, -1, 1, -1, 1, -1, 0, 1, -1, 0, -1, 1, -1, 1, 0, 1, -1, -1, -1, 1, -1, -1, 0, -1, 1, 0, 1, -1, 1, 1, 1, 0, -1, 1, -1, -1, 0, 0, -1, 1, 0, -1, 0], "categories": {"ca": {"0": 1, "1": 2, "-1": 6}, "gi": {"0": 2, "1": 5, "-1": 2}, "pl": {"0": 4, "1": 1, "-1": 4}, "se": {"0": 3, "1": 3, "-1": 3}, "sp": {"0": 3, "1": 2, "-1": 4}, "st": {"0": 2, "1": 4, "-1": 3}}}	Laurianne Albury	laurianne.albury@example.com	Cumberland Meeting	2020-07-28 17:53:29.60433+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	a85de258-69cf-4455-aac7-a7fe96160895	e4554c18-1dc3-40bb-90c6-a18d63bc86f4
07d0c164-230f-4477-a8db-4457fdf79080	2020-07-28 17:53:29.608843+00	2020-07-28 17:53:29.772761+00	adult	{"answers": [-1, 0, -1, 0, 1, 1, 0, 1, 0, 1, 1, -1, 1, 0, -1, 1, -1, 0, 1, -1, 1, 0, 1, 0, 1, 0, 0, -1, -1, 1, 1, 1, -1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 1, -1, 1, 0, -1, 0, 0, 1, 0, 1], "categories": {"ca": {"0": 2, "1": 4, "-1": 3}, "gi": {"0": 6, "1": 3, "-1": 0}, "pl": {"0": 4, "1": 3, "-1": 2}, "se": {"0": 4, "1": 3, "-1": 2}, "sp": {"0": 2, "1": 4, "-1": 3}, "st": {"0": 4, "1": 4, "-1": 1}}}	William Proudfoot	william.proudfoot@example.com	Cumberland Meeting	2020-07-28 17:53:29.769293+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	8f9d11be-4271-4432-b939-d6d44f5833a1	e4554c18-1dc3-40bb-90c6-a18d63bc86f4
004cd109-92e8-4937-b5b6-0952956ba618	2020-07-28 17:53:29.777491+00	2020-07-28 17:53:29.904675+00	adult	{"answers": [1, 0, 0, 0, -1, -1, -1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, -1, 0, 1, 0, 1, 0, 0, 1, 0, 0, -1, 0, -1, -1, 1, 1, 1, -1, 0, 1, -1, 1, 0, 1, 1, 1, 1, 0, -1, 1, -1, 0, 1, 0, 0], "categories": {"ca": {"0": 3, "1": 3, "-1": 3}, "gi": {"0": 2, "1": 5, "-1": 2}, "pl": {"0": 4, "1": 3, "-1": 2}, "se": {"0": 4, "1": 2, "-1": 3}, "sp": {"0": 7, "1": 2, "-1": 0}, "st": {"0": 4, "1": 4, "-1": 1}}}	Arthur Reisner	arthur.reisner@example.com	Cumberland Meeting	2020-07-28 17:53:29.90306+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	bdf8a21a-efa8-422e-bbd8-73e0795f6868	e4554c18-1dc3-40bb-90c6-a18d63bc86f4
dfdf49be-a30d-4d87-8d8f-ce640c85ed4c	2020-07-28 17:53:29.907507+00	2020-07-28 17:53:30.047767+00	adult	{"answers": [-1, 1, 1, 0, 0, -1, 0, 1, 1, 1, -1, 0, -1, 0, 1, -1, 1, 0, 0, 0, -1, 0, -1, 1, 1, -1, 1, -1, 0, -1, -1, -1, 1, -1, -1, 0, -1, -1, -1, 1, 1, 0, 0, -1, 1, -1, 0, 0, 1, 1, 0, 0, 0, 1], "categories": {"ca": {"0": 2, "1": 1, "-1": 6}, "gi": {"0": 2, "1": 3, "-1": 4}, "pl": {"0": 5, "1": 3, "-1": 1}, "se": {"0": 3, "1": 4, "-1": 2}, "sp": {"0": 3, "1": 3, "-1": 3}, "st": {"0": 3, "1": 3, "-1": 3}}}	Mariska Pellam	mariska.pellam@example.com	Cumberland Meeting	2020-07-28 17:53:30.044305+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	5b329ea1-7052-46a2-9894-4a3caacb4696	e4554c18-1dc3-40bb-90c6-a18d63bc86f4
d679ba58-5e12-4f0a-82a0-2d1b64b0f6fb	2020-07-28 17:53:30.052517+00	2020-07-28 17:53:30.200092+00	adult	{"answers": [0, 1, 0, -1, 1, -1, 0, -1, 0, 0, 1, -1, 0, 0, 0, 0, 1, -1, -1, 0, 1, -1, -1, 0, 1, -1, 0, 0, 0, 1, 1, 0, 1, -1, 0, 1, 0, 0, -1, 1, 1, -1, 0, -1, 0, 1, -1, 0, 0, -1, 1, 0, -1, -1], "categories": {"ca": {"0": 4, "1": 4, "-1": 1}, "gi": {"0": 4, "1": 2, "-1": 3}, "pl": {"0": 3, "1": 2, "-1": 4}, "se": {"0": 4, "1": 2, "-1": 3}, "sp": {"0": 5, "1": 2, "-1": 2}, "st": {"0": 3, "1": 2, "-1": 4}}}	Britta Schermer	britta.schermer@example.com	Cumberland Meeting	2020-07-28 17:53:30.198406+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	db23a4b7-56fb-4831-9b8e-c38666dfb328	e4554c18-1dc3-40bb-90c6-a18d63bc86f4
1a8c5875-4bc6-4d3a-9927-b829a8ea5d4a	2020-07-28 17:53:30.20304+00	2020-07-28 17:53:30.322052+00	adult	{"answers": [-1, 1, 1, 1, -1, 1, 1, 0, 1, -1, 1, 0, 1, 1, -1, 1, 1, -1, -1, -1, -1, 1, -1, 0, -1, -1, -1, 0, 0, 0, 1, 0, -1, 1, 1, -1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, -1, 0, 1, 0, 0], "categories": {"ca": {"0": 4, "1": 3, "-1": 2}, "gi": {"0": 2, "1": 7, "-1": 0}, "pl": {"0": 5, "1": 3, "-1": 1}, "se": {"0": 1, "1": 6, "-1": 2}, "sp": {"0": 1, "1": 5, "-1": 3}, "st": {"0": 1, "1": 1, "-1": 7}}}	Auroora Sachar	auroora.sachar@example.com	Cumberland Meeting	2020-07-28 17:53:30.318679+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	feed2ce7-1804-406e-ad5c-4974c098ece1	e4554c18-1dc3-40bb-90c6-a18d63bc86f4
64bdec4d-518f-42ce-82e6-c314dbe49d28	2020-07-28 17:53:30.326533+00	2020-07-28 17:53:30.49101+00	adult	{"answers": [1, 0, 1, 1, 0, 1, 0, 0, 0, 1, -1, -1, -1, 0, 1, -1, -1, 1, 0, 1, -1, 1, 1, -1, 0, 0, 1, 0, 0, -1, -1, -1, -1, -1, -1, 0, 0, 1, -1, 0, 0, 0, -1, 1, 0, 0, 1, 0, -1, -1, 0, 0, -1, 0], "categories": {"ca": {"0": 3, "1": 0, "-1": 6}, "gi": {"0": 5, "1": 2, "-1": 2}, "pl": {"0": 5, "1": 1, "-1": 3}, "se": {"0": 5, "1": 4, "-1": 0}, "sp": {"0": 1, "1": 3, "-1": 5}, "st": {"0": 3, "1": 4, "-1": 2}}}	Friedrick Breisch	friedrick.breisch@example.com	Cumberland Meeting	2020-07-28 17:53:30.489323+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	6163d720-3ab5-4c63-bbd2-349385c477f6	e4554c18-1dc3-40bb-90c6-a18d63bc86f4
a2bada83-437f-4a6a-8857-026a0c444fbe	2020-07-28 17:53:30.494044+00	2020-07-28 17:53:30.598414+00	adult	{"answers": [1, 1, 1, -1, 0, 1, 1, 0, 1, 0, -1, 0, 1, 1, -1, 0, 1, 1, 0, -1, 0, 1, 1, -1, 1, 0, 1, 0, -1, 0, 0, 1, 0, 1, -1, 0, -1, 0, 0, -1, 0, -1, 0, 1, 0, 1, 0, -1, -1, -1, 1, 1, 1, 1], "categories": {"ca": {"0": 5, "1": 2, "-1": 2}, "gi": {"0": 5, "1": 1, "-1": 3}, "pl": {"0": 1, "1": 5, "-1": 3}, "se": {"0": 2, "1": 6, "-1": 1}, "sp": {"0": 3, "1": 4, "-1": 2}, "st": {"0": 3, "1": 4, "-1": 2}}}	Jacquelyn Belliston	jacquelyn.belliston@example.com	Cumberland Meeting	2020-07-28 17:53:30.594964+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	85c746a1-c4b6-4074-accc-c5ce30958e15	e4554c18-1dc3-40bb-90c6-a18d63bc86f4
c5e60913-3175-4d04-b18f-3dd200bf282a	2020-07-28 17:53:30.603062+00	2020-07-28 17:53:30.783972+00	adult	{"answers": [1, -1, 0, 0, -1, 0, 1, 1, 0, 0, -1, 0, 0, -1, -1, 0, 0, 0, 0, 1, 1, -1, -1, 1, 0, 1, 0, 1, 0, 0, -1, -1, 0, -1, -1, -1, 1, 1, -1, 1, 1, 1, 1, 0, -1, 0, 0, -1, 0, 1, 1, 1, -1, 1], "categories": {"ca": {"0": 3, "1": 1, "-1": 5}, "gi": {"0": 1, "1": 6, "-1": 2}, "pl": {"0": 3, "1": 4, "-1": 2}, "se": {"0": 4, "1": 3, "-1": 2}, "sp": {"0": 6, "1": 0, "-1": 3}, "st": {"0": 3, "1": 4, "-1": 2}}}	Dillie Senich	dillie.senich@example.com	Cumberland Meeting	2020-07-28 17:53:30.782272+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	341a7941-d97c-475d-ba8e-675e5d09721f	e4554c18-1dc3-40bb-90c6-a18d63bc86f4
7dbecd77-69b4-475a-b9c4-c064e3983f05	2020-07-28 17:53:30.793813+00	2020-07-28 17:53:30.880922+00	adult	{"answers": [1, -1, -1, 1, 1, 1, 1, -1, 1, 0, -1, -1, 1, 0, -1, -1, 1, -1, -1, -1, 1, 1, 1, 0, -1, 0, -1, 1, -1, -1, 0, -1, 0, 0, -1, 0, 0, 1, -1, 1, 0, -1, -1, -1, 1, -1, 0, 0, 0, 1, 1, 1, 1, -1], "categories": {"ca": {"0": 4, "1": 1, "-1": 4}, "gi": {"0": 2, "1": 3, "-1": 4}, "pl": {"0": 3, "1": 4, "-1": 2}, "se": {"0": 0, "1": 6, "-1": 3}, "sp": {"0": 2, "1": 2, "-1": 5}, "st": {"0": 2, "1": 3, "-1": 4}}}	Grover Brojakowski	grover.brojakowski@example.com	Romulus Conference	2020-07-28 17:53:30.8793+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	2782cae8-3af6-4bab-84b8-572762581feb	acc534e8-10ba-41f4-929b-ce687e8a9bf6
03e22fb5-f353-420e-86c3-eeba0dd028c6	2020-07-28 17:53:30.885457+00	2020-07-28 17:53:31.071378+00	adult	{"answers": [-1, 1, -1, -1, -1, -1, 0, -1, -1, 0, 0, -1, -1, -1, -1, 0, -1, -1, 0, -1, 0, 0, 0, 1, 1, -1, 0, -1, -1, 0, 0, -1, -1, 0, -1, -1, -1, 1, -1, 0, 0, 0, 0, -1, 1, -1, 1, -1, 1, 0, 0, -1, -1, -1], "categories": {"ca": {"0": 3, "1": 0, "-1": 6}, "gi": {"0": 4, "1": 2, "-1": 3}, "pl": {"0": 2, "1": 2, "-1": 5}, "se": {"0": 1, "1": 1, "-1": 7}, "sp": {"0": 3, "1": 0, "-1": 6}, "st": {"0": 5, "1": 2, "-1": 2}}}	Hortensia Michaelson	hortensia.michaelson@example.com	Romulus Conference	2020-07-28 17:53:31.067922+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	1919989e-2fac-436b-bec9-9a427f019cc0	acc534e8-10ba-41f4-929b-ce687e8a9bf6
e1d00504-8c94-4136-84f1-12d8fc8c50e0	2020-07-28 17:53:31.076008+00	2020-07-28 17:53:31.170857+00	adult	{"answers": [0, 0, 0, 1, -1, -1, 0, -1, -1, 0, 1, 0, 1, 1, -1, -1, -1, 1, 1, -1, 1, 1, -1, 1, -1, 0, 1, 0, 0, 0, 0, 1, -1, 0, 1, 1, -1, 0, 1, 0, 0, -1, 0, 0, 0, -1, 1, 0, 0, -1, 0, 0, 0, -1], "categories": {"ca": {"0": 5, "1": 3, "-1": 1}, "gi": {"0": 6, "1": 1, "-1": 2}, "pl": {"0": 5, "1": 1, "-1": 3}, "se": {"0": 4, "1": 1, "-1": 4}, "sp": {"0": 2, "1": 4, "-1": 3}, "st": {"0": 1, "1": 5, "-1": 3}}}	Ardisj Streetman	ardisj.streetman@example.com	Romulus Conference	2020-07-28 17:53:31.169261+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	ee107120-a482-47d4-99f0-749c6a699472	acc534e8-10ba-41f4-929b-ce687e8a9bf6
1dde0e0c-e38a-4ad2-961b-4c50beab9292	2020-07-28 17:53:31.173604+00	2020-07-28 17:53:31.340151+00	adult	{"answers": [0, -1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 0, 1, -1, -1, -1, -1, 1, 0, -1, 1, 1, 1, 1, 1, 1, -1, 0, 1, -1, 1, 1, 1, -1, -1, 0, 0, 1, -1, -1, -1, -1, 1, -1, 0, -1, 1, 0, 1, -1, -1], "categories": {"ca": {"0": 1, "1": 6, "-1": 2}, "gi": {"0": 2, "1": 1, "-1": 6}, "pl": {"0": 2, "1": 3, "-1": 4}, "se": {"0": 1, "1": 7, "-1": 1}, "sp": {"0": 1, "1": 4, "-1": 4}, "st": {"0": 1, "1": 5, "-1": 3}}}	Evered Rollison	evered.rollison@example.com	Romulus Conference	2020-07-28 17:53:31.336675+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	af7943a0-c4c7-49c6-b687-83b67d1ad2d0	acc534e8-10ba-41f4-929b-ce687e8a9bf6
d348986d-4948-476b-8610-fb5ae71a135d	2020-07-28 17:53:31.344936+00	2020-07-28 17:53:31.463873+00	adult	{"answers": [0, 1, -1, 0, -1, 0, 1, 0, -1, 0, -1, -1, 1, -1, 1, -1, 1, -1, -1, 1, -1, 1, 0, 1, 1, -1, 1, -1, -1, 1, -1, -1, 1, -1, 1, 0, 0, 0, 1, -1, -1, 1, -1, 0, 1, -1, 1, 0, 1, 0, 1, 1, 0, -1], "categories": {"ca": {"0": 1, "1": 3, "-1": 5}, "gi": {"0": 3, "1": 3, "-1": 3}, "pl": {"0": 3, "1": 4, "-1": 2}, "se": {"0": 4, "1": 2, "-1": 3}, "sp": {"0": 1, "1": 3, "-1": 5}, "st": {"0": 1, "1": 5, "-1": 3}}}	Jaquenetta Osvaldo	jaquenetta.osvaldo@example.com	Romulus Conference	2020-07-28 17:53:31.462237+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	3a2c012c-4080-4b6d-8097-725b6748c313	acc534e8-10ba-41f4-929b-ce687e8a9bf6
290d545a-a2d6-4b17-bc96-7030bb8e9972	2020-07-28 17:53:31.466685+00	2020-07-28 17:53:31.612191+00	adult	{"answers": [-1, 1, -1, 1, 0, -1, 1, 1, -1, 0, 1, 0, -1, 1, 1, 1, 1, 1, -1, 1, 0, 0, 1, 1, 0, 0, -1, 0, 1, -1, -1, -1, -1, -1, 0, -1, 1, -1, -1, 0, -1, 1, 1, 1, 0, 1, 1, -1, 1, -1, 1, 0, 0, 1], "categories": {"ca": {"0": 2, "1": 1, "-1": 6}, "gi": {"0": 2, "1": 4, "-1": 3}, "pl": {"0": 2, "1": 5, "-1": 2}, "se": {"0": 1, "1": 4, "-1": 4}, "sp": {"0": 2, "1": 6, "-1": 1}, "st": {"0": 4, "1": 3, "-1": 2}}}	Rodina Hausen	rodina.hausen@example.com	Romulus Conference	2020-07-28 17:53:31.608844+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	17b205fa-a02f-4017-afc1-134240e6019a	acc534e8-10ba-41f4-929b-ce687e8a9bf6
4c66765e-9bed-45e0-b7b1-d2b7be097dc3	2020-07-28 17:53:31.616797+00	2020-07-28 17:53:31.754671+00	adult	{"answers": [0, 1, 1, 0, 0, -1, -1, 0, -1, -1, 1, 0, 0, -1, -1, 1, 1, 0, -1, 1, 1, -1, 0, 1, 0, -1, 1, -1, 1, -1, -1, 1, 0, 1, 1, -1, -1, -1, -1, 0, 0, 0, -1, 1, 1, -1, -1, 0, -1, 1, -1, 0, 1, 1], "categories": {"ca": {"0": 1, "1": 4, "-1": 4}, "gi": {"0": 3, "1": 2, "-1": 4}, "pl": {"0": 2, "1": 3, "-1": 4}, "se": {"0": 4, "1": 2, "-1": 3}, "sp": {"0": 3, "1": 3, "-1": 3}, "st": {"0": 2, "1": 4, "-1": 3}}}	Nichole Haugh	nichole.haugh@example.com	Romulus Conference	2020-07-28 17:53:31.753023+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	2d5428bd-1fa2-4429-912b-0787c426d284	acc534e8-10ba-41f4-929b-ce687e8a9bf6
8ead9ff6-3aae-43af-9b02-f1e0f9ca923b	2020-07-28 17:53:31.757485+00	2020-07-28 17:53:31.881738+00	adult	{"answers": [1, 0, 0, -1, 0, -1, 1, -1, -1, 0, -1, -1, 1, -1, 1, -1, -1, 0, -1, 0, 1, -1, 0, 1, 1, 1, -1, 1, -1, 0, -1, -1, 0, -1, 0, -1, 1, 1, -1, -1, -1, -1, 0, 0, -1, 0, -1, 1, 0, -1, 0, 1, 1, 1], "categories": {"ca": {"0": 3, "1": 1, "-1": 5}, "gi": {"0": 2, "1": 2, "-1": 5}, "pl": {"0": 3, "1": 4, "-1": 2}, "se": {"0": 3, "1": 2, "-1": 4}, "sp": {"0": 2, "1": 2, "-1": 5}, "st": {"0": 2, "1": 4, "-1": 3}}}	Eldredge Muriel	eldredge.muriel@example.com	Romulus Conference	2020-07-28 17:53:31.878319+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	ca45c75d-6b37-4b0e-a2a8-ffd71d3e680d	acc534e8-10ba-41f4-929b-ce687e8a9bf6
9369e781-0fda-4432-866f-f59ccf6d086c	2020-07-28 17:53:31.886333+00	2020-07-28 17:53:32.04606+00	adult	{"answers": [1, -1, -1, 0, 0, -1, 1, -1, 0, 1, 1, 1, -1, 1, 0, 0, 0, 0, 0, 0, 1, -1, 0, 1, 1, 1, 1, 1, 0, 0, -1, 1, -1, 0, -1, 1, -1, -1, 1, -1, 0, 0, 1, 0, 1, -1, -1, -1, 1, 1, 1, -1, -1, 1], "categories": {"ca": {"0": 3, "1": 3, "-1": 3}, "gi": {"0": 3, "1": 3, "-1": 3}, "pl": {"0": 0, "1": 4, "-1": 5}, "se": {"0": 3, "1": 2, "-1": 4}, "sp": {"0": 4, "1": 4, "-1": 1}, "st": {"0": 3, "1": 5, "-1": 1}}}	Heall Neske	heall.neske@example.com	Romulus Conference	2020-07-28 17:53:32.044372+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	15d7ca22-86a4-43d4-aae5-4564cb5cb960	acc534e8-10ba-41f4-929b-ce687e8a9bf6
592b3453-05f5-4592-a24d-e9733b6997b0	2020-07-28 17:53:32.048989+00	2020-07-28 17:53:32.15287+00	adult	{"answers": [1, 0, -1, 1, 0, 1, 1, 1, -1, 1, 0, 1, 0, 0, -1, 0, 1, 0, -1, -1, -1, 0, 1, 1, 1, 0, 1, 0, -1, 1, 0, 1, -1, 0, 1, 0, -1, -1, -1, 1, -1, 1, -1, 1, 1, 1, 1, 0, -1, 0, 0, -1, 1, 1], "categories": {"ca": {"0": 4, "1": 3, "-1": 2}, "gi": {"0": 0, "1": 4, "-1": 5}, "pl": {"0": 3, "1": 4, "-1": 2}, "se": {"0": 2, "1": 5, "-1": 2}, "sp": {"0": 5, "1": 3, "-1": 1}, "st": {"0": 2, "1": 4, "-1": 3}}}	Chiquita Fragozo	chiquita.fragozo@example.com	Romulus Conference	2020-07-28 17:53:32.149449+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	5f1a67df-53ec-4605-9ed4-fb2323f1e8d0	acc534e8-10ba-41f4-929b-ce687e8a9bf6
1cd47cb4-4dc3-4e70-9e01-9ba317f30f83	2020-07-28 17:53:32.157522+00	2020-07-28 17:53:32.336404+00	adult	{"answers": [1, -1, 1, 0, 1, -1, 0, -1, -1, 0, 1, 0, 1, -1, 1, 1, 1, -1, 1, -1, 0, 1, 1, -1, -1, 0, -1, -1, -1, 0, -1, 0, -1, 0, -1, 1, 0, -1, 0, 0, -1, -1, 0, 1, 0, -1, -1, 1, 0, 0, 0, -1, 1, -1], "categories": {"ca": {"0": 3, "1": 1, "-1": 5}, "gi": {"0": 5, "1": 1, "-1": 3}, "pl": {"0": 3, "1": 2, "-1": 4}, "se": {"0": 2, "1": 3, "-1": 4}, "sp": {"0": 2, "1": 5, "-1": 2}, "st": {"0": 2, "1": 3, "-1": 4}}}	Belia Costilla	belia.costilla@example.com	Romulus Conference	2020-07-28 17:53:32.334687+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	0540f68c-2de5-49c5-9af5-a86da7a37ac8	acc534e8-10ba-41f4-929b-ce687e8a9bf6
c0868d07-8740-4af1-9a07-ebcb6fa782eb	2020-07-28 17:53:32.33935+00	2020-07-28 17:53:32.427031+00	adult	{"answers": [1, 0, -1, 0, 0, 0, 0, 1, -1, 0, -1, 0, -1, 1, 0, -1, -1, 0, 1, 1, 0, 0, -1, 0, 0, 0, -1, 0, -1, 1, -1, 0, 1, -1, -1, 0, 0, -1, -1, 1, 1, -1, 1, -1, -1, -1, 0, -1, 0, -1, 1, 0, 0, 0], "categories": {"ca": {"0": 3, "1": 2, "-1": 4}, "gi": {"0": 1, "1": 3, "-1": 5}, "pl": {"0": 5, "1": 1, "-1": 3}, "se": {"0": 5, "1": 2, "-1": 2}, "sp": {"0": 4, "1": 1, "-1": 4}, "st": {"0": 5, "1": 2, "-1": 2}}}	Dexter Kittles	dexter.kittles@example.com	Romulus Conference	2020-07-28 17:53:32.425412+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	3c80e01e-a293-486b-b020-7ba69c09d0a8	acc534e8-10ba-41f4-929b-ce687e8a9bf6
869c860c-f839-4476-934f-ebb3ca4f3050	2020-07-28 17:53:32.429842+00	2020-07-28 17:53:32.613921+00	adult	{"answers": [1, 1, 1, 0, 0, 0, 1, 1, -1, 0, -1, -1, 1, 1, -1, -1, 0, 1, 1, 0, 0, 1, 0, -1, 1, 0, 1, -1, 0, 0, 0, 1, -1, 1, 0, 1, 1, -1, -1, 1, -1, 0, -1, -1, 0, -1, 1, 0, 0, -1, -1, -1, -1, 0], "categories": {"ca": {"0": 4, "1": 3, "-1": 2}, "gi": {"0": 2, "1": 2, "-1": 5}, "pl": {"0": 3, "1": 1, "-1": 5}, "se": {"0": 3, "1": 5, "-1": 1}, "sp": {"0": 2, "1": 3, "-1": 4}, "st": {"0": 4, "1": 4, "-1": 1}}}	Rozanne Ozburn	rozanne.ozburn@example.com	Romulus Conference	2020-07-28 17:53:32.610535+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	c3055999-0f9d-45ff-9e52-5808d193d711	acc534e8-10ba-41f4-929b-ce687e8a9bf6
cfa8da19-8f0b-4884-b8f3-de01f01651ac	2020-07-28 17:53:32.618584+00	2020-07-28 17:53:32.71929+00	adult	{"answers": [0, 0, 0, 1, -1, -1, -1, 1, 1, -1, 0, 0, 0, 1, 0, 0, 1, 0, -1, 1, -1, 0, 1, 1, -1, -1, 1, 1, -1, 1, 1, -1, 1, 1, -1, -1, 1, 1, 0, 0, -1, -1, -1, -1, 1, 0, -1, 0, 0, 0, 0, 0, -1, -1], "categories": {"ca": {"0": 0, "1": 5, "-1": 4}, "gi": {"0": 2, "1": 3, "-1": 4}, "pl": {"0": 6, "1": 0, "-1": 3}, "se": {"0": 3, "1": 3, "-1": 3}, "sp": {"0": 6, "1": 2, "-1": 1}, "st": {"0": 1, "1": 4, "-1": 4}}}	Julee Vandervort	julee.vandervort@example.com	Romulus Conference	2020-07-28 17:53:32.717701+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	39d3c465-4f61-4647-a11a-f19b1cc874c4	acc534e8-10ba-41f4-929b-ce687e8a9bf6
a738f04d-b59d-4dbd-801c-c5b648c1c9f4	2020-07-28 17:53:32.722072+00	2020-07-28 17:53:32.885933+00	adult	{"answers": [0, -1, 1, -1, -1, -1, 1, 1, 0, 0, -1, -1, -1, 0, -1, 0, -1, -1, -1, 1, 0, 0, -1, 1, 1, -1, -1, 1, 1, 1, -1, -1, 0, -1, -1, 0, 1, 1, -1, 0, 0, -1, 0, 0, 1, -1, 0, 1, 1, 1, -1, -1, 1, -1], "categories": {"ca": {"0": 2, "1": 3, "-1": 4}, "gi": {"0": 4, "1": 3, "-1": 2}, "pl": {"0": 1, "1": 4, "-1": 4}, "se": {"0": 2, "1": 3, "-1": 4}, "sp": {"0": 3, "1": 0, "-1": 6}, "st": {"0": 2, "1": 3, "-1": 4}}}	Clari Effinger	clari.effinger@example.com	Romulus Conference	2020-07-28 17:53:32.882553+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	664a0d34-fbda-4762-b16b-2457d3c0eab6	acc534e8-10ba-41f4-929b-ce687e8a9bf6
a4cab0eb-c765-4a91-b174-21d688b651bd	2020-07-28 17:53:32.890496+00	2020-07-28 17:53:33.012196+00	adult	{"answers": [1, 1, 1, -1, -1, 1, 1, 1, 1, 1, 1, 0, 0, -1, 0, 1, 0, -1, 1, 1, -1, -1, 1, 0, -1, -1, 0, 0, 1, 1, 0, 1, -1, 1, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, -1, 1, -1, 1, 1, 0], "categories": {"ca": {"0": 3, "1": 5, "-1": 1}, "gi": {"0": 6, "1": 3, "-1": 0}, "pl": {"0": 4, "1": 3, "-1": 2}, "se": {"0": 0, "1": 7, "-1": 2}, "sp": {"0": 4, "1": 3, "-1": 2}, "st": {"0": 2, "1": 3, "-1": 4}}}	Katrina Seta	katrina.seta@example.com	Romulus Conference	2020-07-28 17:53:33.010567+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	8c60b3ea-180c-4f4b-89fe-0747efb244f7	acc534e8-10ba-41f4-929b-ce687e8a9bf6
af821c86-a0d9-4f92-a715-20e1c00c6afd	2020-07-28 17:53:33.021766+00	2020-07-28 17:53:33.165143+00	adult	{"answers": [0, 1, -1, -1, -1, -1, -1, -1, -1, 1, -1, -1, 1, 0, 0, 1, -1, 0, -1, 0, 0, 1, 0, 0, -1, 0, -1, 0, 0, 0, -1, -1, 0, 1, 0, 1, -1, 0, 0, -1, 1, 0, -1, -1, 1, 1, -1, 0, 0, -1, -1, 0, 0, -1], "categories": {"ca": {"0": 5, "1": 2, "-1": 2}, "gi": {"0": 3, "1": 2, "-1": 4}, "pl": {"0": 4, "1": 1, "-1": 4}, "se": {"0": 1, "1": 1, "-1": 7}, "sp": {"0": 3, "1": 3, "-1": 3}, "st": {"0": 5, "1": 1, "-1": 3}}}	Kahaleel Cunnick	kahaleel.cunnick@example.com	Somerville Meeting	2020-07-28 17:53:33.161908+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	bb1a1552-bb4f-4228-8d0c-dce369577184	e4dcca50-ed32-4150-9560-6e6827a6c99f
a2ddcb3b-6216-481a-a89b-a809d75d62e5	2020-07-28 17:53:33.169716+00	2020-07-28 17:53:33.301938+00	adult	{"answers": [0, 0, -1, 1, 0, -1, -1, -1, 0, 0, 1, 1, 0, -1, -1, 1, -1, 0, -1, 0, 0, 1, -1, -1, 0, 0, 1, 1, -1, 0, -1, 0, 1, 0, 0, -1, 1, 0, -1, 1, -1, 0, 1, -1, -1, 1, -1, 0, 1, 0, -1, 0, -1, 0], "categories": {"ca": {"0": 4, "1": 2, "-1": 3}, "gi": {"0": 2, "1": 3, "-1": 4}, "pl": {"0": 4, "1": 2, "-1": 3}, "se": {"0": 4, "1": 1, "-1": 4}, "sp": {"0": 3, "1": 3, "-1": 3}, "st": {"0": 4, "1": 2, "-1": 3}}}	Jeremy Niskanen	jeremy.niskanen@example.com	Somerville Meeting	2020-07-28 17:53:33.30035+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	49bcc538-e051-49b8-a21c-cebb4cab28ac	e4dcca50-ed32-4150-9560-6e6827a6c99f
f461460f-86d1-4278-93bd-3c428e7ae56c	2020-07-28 17:53:33.304687+00	2020-07-28 17:53:33.427718+00	adult	{"answers": [-1, 1, 0, -1, 0, 0, 1, 1, 1, -1, 0, 0, 0, -1, 0, 1, -1, 0, 0, -1, -1, 0, 0, 0, 0, 0, 1, 0, 1, -1, 1, -1, 1, -1, 0, 0, 1, -1, -1, 0, -1, 0, -1, 0, 0, -1, -1, -1, 1, 0, -1, 1, 1, -1], "categories": {"ca": {"0": 3, "1": 3, "-1": 3}, "gi": {"0": 4, "1": 1, "-1": 4}, "pl": {"0": 1, "1": 3, "-1": 5}, "se": {"0": 3, "1": 4, "-1": 2}, "sp": {"0": 5, "1": 1, "-1": 3}, "st": {"0": 6, "1": 1, "-1": 2}}}	Abbe Haubner	abbe.haubner@example.com	Somerville Meeting	2020-07-28 17:53:33.424423+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	837494a9-e175-4a4d-b59c-0c94b1ca2b8d	e4dcca50-ed32-4150-9560-6e6827a6c99f
6f8b4c6f-99e8-4a87-8fd4-b38bf2467a0d	2020-07-28 17:53:33.432154+00	2020-07-28 17:53:33.585297+00	adult	{"answers": [-1, 1, -1, 0, -1, 1, 0, 0, 0, -1, 1, 1, -1, -1, 1, 0, 1, 1, -1, 1, 1, -1, 1, 1, 1, -1, -1, 0, 1, 1, 1, 0, 1, 0, -1, 1, 1, 0, -1, 0, -1, -1, -1, 1, -1, 1, 0, 1, 1, 1, 1, -1, -1, 0], "categories": {"ca": {"0": 3, "1": 5, "-1": 1}, "gi": {"0": 2, "1": 2, "-1": 5}, "pl": {"0": 2, "1": 5, "-1": 2}, "se": {"0": 4, "1": 2, "-1": 3}, "sp": {"0": 1, "1": 5, "-1": 3}, "st": {"0": 0, "1": 5, "-1": 4}}}	Rey Komarek	rey.komarek@example.com	Somerville Meeting	2020-07-28 17:53:33.583687+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	09d872f3-51f9-4110-a5b0-b74b0cefa4ba	e4dcca50-ed32-4150-9560-6e6827a6c99f
2dc9cce5-551e-4e24-8278-f54921b1ac63	2020-07-28 17:53:33.588065+00	2020-07-28 17:53:33.690799+00	adult	{"answers": [-1, 0, 1, 1, 1, 1, -1, -1, -1, 0, -1, 0, 0, -1, -1, 1, 0, 0, 1, 0, 0, -1, 1, 1, -1, 0, 1, -1, 1, -1, -1, 1, 1, -1, -1, -1, -1, 1, 0, 0, -1, 0, 0, 0, 0, 1, -1, 1, 0, 0, 0, 0, 0, -1], "categories": {"ca": {"0": 0, "1": 3, "-1": 6}, "gi": {"0": 6, "1": 1, "-1": 2}, "pl": {"0": 5, "1": 2, "-1": 2}, "se": {"0": 1, "1": 4, "-1": 4}, "sp": {"0": 5, "1": 1, "-1": 3}, "st": {"0": 3, "1": 4, "-1": 2}}}	Kristoforo Difebbo	kristoforo.difebbo@example.com	Somerville Meeting	2020-07-28 17:53:33.687522+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	ce6a7f31-172f-41b4-8832-0331e867638b	e4dcca50-ed32-4150-9560-6e6827a6c99f
9f32fd89-f66e-49f9-b2fb-b43938889f35	2020-07-28 17:53:33.695232+00	2020-07-28 17:53:33.867994+00	adult	{"answers": [0, -1, 0, 1, 0, 0, 1, -1, 0, 1, 0, 1, 1, 0, -1, 1, 1, 1, 1, 1, -1, 0, -1, 1, -1, 0, -1, 0, -1, 0, -1, -1, -1, -1, -1, -1, -1, 0, 1, 1, -1, 0, 1, 1, 0, 1, 1, 0, 0, 1, 0, -1, 0, -1], "categories": {"ca": {"0": 2, "1": 0, "-1": 7}, "gi": {"0": 3, "1": 4, "-1": 2}, "pl": {"0": 4, "1": 3, "-1": 2}, "se": {"0": 5, "1": 2, "-1": 2}, "sp": {"0": 2, "1": 6, "-1": 1}, "st": {"0": 2, "1": 3, "-1": 4}}}	Bram Tousignant	bram.tousignant@example.com	Somerville Meeting	2020-07-28 17:53:33.866416+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	26792fca-33b7-496d-9b73-706b6776c1f6	e4dcca50-ed32-4150-9560-6e6827a6c99f
a5d342b7-882e-4fbe-a2f6-76ac6e59a100	2020-07-28 17:53:33.87075+00	2020-07-28 17:53:33.954655+00	adult	{"answers": [0, -1, 1, 0, 0, 1, 0, 0, 1, -1, 1, 0, -1, 0, -1, -1, -1, 0, -1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, -1, 0, 1, 1, 0, -1, -1, 1, 1, 1, -1, 1, -1, 1, -1, 0, -1, 1, -1, 1, -1, 1, 0, -1], "categories": {"ca": {"0": 4, "1": 3, "-1": 2}, "gi": {"0": 0, "1": 5, "-1": 4}, "pl": {"0": 2, "1": 3, "-1": 4}, "se": {"0": 5, "1": 3, "-1": 1}, "sp": {"0": 3, "1": 1, "-1": 5}, "st": {"0": 4, "1": 4, "-1": 1}}}	Adam Lopey	adam.lopey@example.com	Somerville Meeting	2020-07-28 17:53:33.953068+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	9dd1730a-fb0e-4eed-bf36-ecc4131a1cf4	e4dcca50-ed32-4150-9560-6e6827a6c99f
edbca57a-7753-49be-a287-511a9ff55347	2020-07-28 17:53:33.957518+00	2020-07-28 17:53:34.148042+00	adult	{"answers": [-1, 0, 0, 1, 0, -1, 0, 1, 0, -1, 0, 0, -1, 0, 1, -1, 0, 0, 0, -1, -1, 1, 0, 1, 0, 1, -1, -1, 1, 1, -1, -1, 1, -1, 1, -1, 0, -1, -1, -1, 1, 1, 1, 0, -1, -1, 0, -1, 0, 0, 1, -1, 0, -1], "categories": {"ca": {"0": 0, "1": 4, "-1": 5}, "gi": {"0": 2, "1": 3, "-1": 4}, "pl": {"0": 4, "1": 1, "-1": 4}, "se": {"0": 5, "1": 2, "-1": 2}, "sp": {"0": 5, "1": 1, "-1": 3}, "st": {"0": 3, "1": 3, "-1": 3}}}	Tod Dukelow	tod.dukelow@example.com	Somerville Meeting	2020-07-28 17:53:34.144521+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	2b3dc560-0c02-4f3a-8c0b-d1227628c548	e4dcca50-ed32-4150-9560-6e6827a6c99f
4bc9baee-aae4-45ad-87f1-15ccc8f687d9	2020-07-28 17:53:34.152875+00	2020-07-28 17:53:34.252119+00	adult	{"answers": [0, 0, 1, -1, 1, -1, -1, 1, 0, 0, -1, 0, 1, 0, 0, 0, 0, 1, 0, 0, -1, 1, 0, 0, 1, 0, 1, -1, -1, -1, 1, 0, -1, 1, 0, -1, 0, 0, 0, 1, 0, -1, -1, -1, 0, 1, 0, 1, 1, -1, 0, 0, 0, 0], "categories": {"ca": {"0": 2, "1": 2, "-1": 5}, "gi": {"0": 5, "1": 1, "-1": 3}, "pl": {"0": 5, "1": 3, "-1": 1}, "se": {"0": 3, "1": 3, "-1": 3}, "sp": {"0": 6, "1": 2, "-1": 1}, "st": {"0": 5, "1": 3, "-1": 1}}}	Brita Dew	brita.dew@example.com	Somerville Meeting	2020-07-28 17:53:34.250523+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	ba87511e-db93-4ab4-8b0a-df374871228c	e4dcca50-ed32-4150-9560-6e6827a6c99f
b452d3fc-42fe-4c0f-90b2-3cf25d83746a	2020-07-28 17:53:34.254912+00	2020-07-28 17:53:34.415501+00	adult	{"answers": [0, 0, -1, 0, 1, 1, 1, -1, 1, 0, 0, -1, 0, 1, 1, -1, -1, 0, 1, -1, -1, 0, 1, 0, 0, 1, 1, 1, -1, 1, -1, 0, 0, -1, 1, 0, 0, 1, -1, -1, 0, 0, 0, 1, 1, -1, 0, 1, 1, 1, 1, 1, 0, 1], "categories": {"ca": {"0": 3, "1": 3, "-1": 3}, "gi": {"0": 4, "1": 3, "-1": 2}, "pl": {"0": 2, "1": 6, "-1": 1}, "se": {"0": 3, "1": 4, "-1": 2}, "sp": {"0": 4, "1": 2, "-1": 3}, "st": {"0": 3, "1": 4, "-1": 2}}}	Mandel Strayham	mandel.strayham@example.com	Somerville Meeting	2020-07-28 17:53:34.412245+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	6bb1eb30-4557-4cd7-bc2d-f08befa532a2	e4dcca50-ed32-4150-9560-6e6827a6c99f
8db3d6b3-e654-45ab-812c-2aa135b9ce39	2020-07-28 17:53:34.420167+00	2020-07-28 17:53:34.534936+00	adult	{"answers": [0, 0, -1, 0, 1, -1, -1, 1, 1, -1, -1, 1, 1, -1, 0, 0, -1, 1, 0, 0, 0, 1, 1, 1, -1, 1, 1, -1, 0, 0, 0, 1, -1, -1, 0, 1, 1, 1, 0, -1, -1, 0, 0, -1, 0, 0, -1, -1, -1, 1, -1, -1, 0, -1], "categories": {"ca": {"0": 4, "1": 2, "-1": 3}, "gi": {"0": 4, "1": 2, "-1": 3}, "pl": {"0": 2, "1": 1, "-1": 6}, "se": {"0": 3, "1": 3, "-1": 3}, "sp": {"0": 2, "1": 3, "-1": 4}, "st": {"0": 3, "1": 5, "-1": 1}}}	Karl Nero	karl.nero@example.com	Somerville Meeting	2020-07-28 17:53:34.533357+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	710a38db-b0c2-45b1-a3d1-6c74412a4158	e4dcca50-ed32-4150-9560-6e6827a6c99f
a53f8d1a-b5ed-4792-9ef9-442714115537	2020-07-28 17:53:34.537804+00	2020-07-28 17:53:34.677689+00	adult	{"answers": [1, 1, 1, 1, -1, 0, -1, 1, 1, 0, -1, -1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, -1, -1, 1, 0, -1, 1, -1, 1, -1, 0, 0, -1, 0, 0, 0, -1, -1, 1, -1, -1, 1, -1, 1, 0, 0, 1, -1, -1, 1, 0, -1], "categories": {"ca": {"0": 3, "1": 2, "-1": 4}, "gi": {"0": 2, "1": 2, "-1": 5}, "pl": {"0": 3, "1": 3, "-1": 3}, "se": {"0": 1, "1": 6, "-1": 2}, "sp": {"0": 6, "1": 1, "-1": 2}, "st": {"0": 4, "1": 3, "-1": 2}}}	Brook Human	brook.human@example.com	Somerville Meeting	2020-07-28 17:53:34.674389+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	1fe86b02-546d-462d-931e-1328d90fd57e	e4dcca50-ed32-4150-9560-6e6827a6c99f
8e34cf75-72d7-4d2d-aae0-071bf1be1ff0	2020-07-28 17:53:34.682235+00	2020-07-28 17:53:34.817457+00	adult	{"answers": [0, 1, 0, 1, 1, 0, -1, 0, 0, -1, -1, 1, 0, 1, 0, 0, 0, 0, -1, -1, 0, -1, -1, 1, -1, -1, 1, 1, 1, 0, 0, 1, 1, 1, 0, -1, 1, 0, -1, -1, -1, 0, 1, 1, -1, 0, 1, -1, 0, 1, 0, 1, 1, 1], "categories": {"ca": {"0": 3, "1": 5, "-1": 1}, "gi": {"0": 2, "1": 3, "-1": 4}, "pl": {"0": 3, "1": 5, "-1": 1}, "se": {"0": 5, "1": 3, "-1": 1}, "sp": {"0": 5, "1": 2, "-1": 2}, "st": {"0": 1, "1": 2, "-1": 6}}}	Erv Chrisler	erv.chrisler@example.com	Somerville Meeting	2020-07-28 17:53:34.815886+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	a66a5efc-455c-4995-8828-ce2ff9e21a59	e4dcca50-ed32-4150-9560-6e6827a6c99f
397ab03d-ae62-45fd-9a5d-a6ec6114e173	2020-07-28 17:53:34.820269+00	2020-07-28 17:53:34.939997+00	adult	{"answers": [-1, 0, 1, -1, -1, 1, 1, 0, 0, 1, -1, -1, 0, 0, 0, 0, 1, -1, 1, 0, 0, 1, -1, -1, -1, -1, 0, -1, 0, 1, 0, 0, 0, -1, 1, 1, 1, -1, -1, 1, 0, 1, 0, 1, 0, 1, 1, -1, 0, 0, 1, 1, 1, -1], "categories": {"ca": {"0": 4, "1": 3, "-1": 2}, "gi": {"0": 3, "1": 4, "-1": 2}, "pl": {"0": 2, "1": 5, "-1": 2}, "se": {"0": 3, "1": 3, "-1": 3}, "sp": {"0": 4, "1": 2, "-1": 3}, "st": {"0": 3, "1": 2, "-1": 4}}}	Euphemia Lethco	euphemia.lethco@example.com	Somerville Meeting	2020-07-28 17:53:34.936667+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	476c84ef-54b9-40d3-9b25-15ea2cae7a7e	e4dcca50-ed32-4150-9560-6e6827a6c99f
e90241d8-d262-42d0-b057-6c0de39e7288	2020-07-28 17:53:34.944499+00	2020-07-28 17:53:35.10059+00	adult	{"answers": [1, 0, 0, 1, 1, 0, -1, -1, 1, -1, 1, 1, -1, 1, 1, 0, 0, 0, 1, 0, 1, 1, -1, 1, 1, -1, -1, -1, 0, -1, -1, -1, 1, 0, 0, 0, 0, 1, 1, 0, 1, -1, -1, 0, -1, 1, 1, -1, -1, 0, 1, 1, 1, 1], "categories": {"ca": {"0": 4, "1": 1, "-1": 4}, "gi": {"0": 3, "1": 3, "-1": 3}, "pl": {"0": 1, "1": 6, "-1": 2}, "se": {"0": 3, "1": 4, "-1": 2}, "sp": {"0": 3, "1": 4, "-1": 2}, "st": {"0": 1, "1": 5, "-1": 3}}}	Idell Cubie	idell.cubie@example.com	Somerville Meeting	2020-07-28 17:53:35.099017+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	1a24b2c5-8796-4489-a787-989f3e2a5bdc	e4dcca50-ed32-4150-9560-6e6827a6c99f
fe756a01-5e3c-4e82-8749-5f3b8d51fd0a	2020-07-28 17:53:35.103378+00	2020-07-28 17:53:35.202367+00	adult	{"answers": [-1, 0, -1, 1, 1, -1, -1, -1, 1, 0, 1, 0, 1, 0, -1, -1, -1, -1, 0, 0, -1, 1, -1, 1, 0, 0, -1, -1, -1, -1, -1, 0, 0, 1, 0, 1, 0, 1, 0, -1, 1, -1, 0, 1, 1, -1, -1, 1, 1, 0, 0, 0, 1, 0], "categories": {"ca": {"0": 3, "1": 2, "-1": 4}, "gi": {"0": 3, "1": 4, "-1": 2}, "pl": {"0": 4, "1": 3, "-1": 2}, "se": {"0": 1, "1": 3, "-1": 5}, "sp": {"0": 3, "1": 2, "-1": 4}, "st": {"0": 4, "1": 2, "-1": 3}}}	Trixie Madaris	trixie.madaris@example.com	Somerville Meeting	2020-07-28 17:53:35.199121+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	338d1a98-ec6d-4150-9918-f1f89d0cb71a	e4dcca50-ed32-4150-9560-6e6827a6c99f
c77ee091-1e2c-4363-a1a6-b9b41771780b	2020-07-28 17:53:35.206865+00	2020-07-28 17:53:35.382632+00	adult	{"answers": [0, 0, 0, -1, -1, -1, -1, -1, 1, 1, 1, -1, 0, 1, 0, 0, -1, 0, 0, -1, -1, 0, 1, 1, -1, 1, -1, -1, -1, 0, 1, -1, -1, 1, -1, 0, 0, 0, 1, 1, -1, 0, -1, 1, 0, -1, 1, 0, -1, 0, 0, 0, -1, 0], "categories": {"ca": {"0": 2, "1": 2, "-1": 5}, "gi": {"0": 4, "1": 3, "-1": 2}, "pl": {"0": 5, "1": 1, "-1": 3}, "se": {"0": 3, "1": 1, "-1": 5}, "sp": {"0": 4, "1": 3, "-1": 2}, "st": {"0": 2, "1": 3, "-1": 4}}}	Ban Lardieri	ban.lardieri@example.com	Somerville Meeting	2020-07-28 17:53:35.381046+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	5b900dea-6cf0-48a6-a1d7-c599528b45a2	e4dcca50-ed32-4150-9560-6e6827a6c99f
bcda175a-fa9b-4776-a84e-0517b20b767a	2020-07-28 17:53:35.385412+00	2020-07-28 17:53:35.46905+00	adult	{"answers": [-1, -1, -1, 1, 1, 0, 1, 0, 0, 1, -1, 0, -1, 0, -1, 1, -1, 1, 1, -1, 0, 1, -1, -1, -1, 1, -1, 0, 0, -1, 0, 0, 1, 0, -1, 1, -1, -1, 1, -1, -1, -1, 1, -1, -1, 1, 0, 0, 1, -1, 0, 0, 0, 0], "categories": {"ca": {"0": 5, "1": 2, "-1": 2}, "gi": {"0": 0, "1": 2, "-1": 7}, "pl": {"0": 6, "1": 2, "-1": 1}, "se": {"0": 3, "1": 3, "-1": 3}, "sp": {"0": 2, "1": 3, "-1": 4}, "st": {"0": 1, "1": 3, "-1": 5}}}	Marylynne Mezza	marylynne.mezza@example.com	Somerville Meeting	2020-07-28 17:53:35.467471+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	e17188db-e7ca-4472-9fb4-bcd183e6a391	e4dcca50-ed32-4150-9560-6e6827a6c99f
1bac83f2-e0cc-4b42-bbdb-a3957c17c01c	2020-07-28 17:53:35.478499+00	2020-07-28 17:53:35.666057+00	adult	{"answers": [1, 0, -1, 0, -1, 0, 1, 0, -1, -1, 0, 1, 1, -1, -1, 1, 1, -1, 0, 1, 1, 0, 0, -1, -1, 1, 1, 0, 0, 0, 1, -1, 1, 0, -1, 1, 0, 0, 0, 1, -1, 1, -1, -1, 1, -1, -1, -1, -1, 0, 1, 0, 1, 0], "categories": {"ca": {"0": 4, "1": 3, "-1": 2}, "gi": {"0": 3, "1": 3, "-1": 3}, "pl": {"0": 3, "1": 2, "-1": 4}, "se": {"0": 4, "1": 2, "-1": 3}, "sp": {"0": 1, "1": 4, "-1": 4}, "st": {"0": 3, "1": 4, "-1": 2}}}	Shane Boruvka	shane.boruvka@example.com	San Dimas Demo	2020-07-28 17:53:35.662677+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	8ecd3a61-e4bd-4acf-8a54-3f5d09431abf	73701371-d652-4b01-819c-fc7667184c95
9777bab1-851d-4422-b770-d96a60bd6da8	2020-07-28 17:53:35.670759+00	2020-07-28 17:53:35.763884+00	adult	{"answers": [0, 0, -1, -1, -1, 0, 1, 0, 1, 1, -1, 0, -1, 1, 0, -1, -1, 0, 1, -1, -1, -1, 0, 0, 1, 0, 0, -1, -1, 1, 0, -1, 0, -1, 0, 1, 0, 1, 0, 1, 0, -1, 1, -1, -1, -1, 1, -1, 0, -1, 1, 1, 1, -1], "categories": {"ca": {"0": 3, "1": 2, "-1": 4}, "gi": {"0": 3, "1": 3, "-1": 3}, "pl": {"0": 1, "1": 4, "-1": 4}, "se": {"0": 4, "1": 2, "-1": 3}, "sp": {"0": 3, "1": 2, "-1": 4}, "st": {"0": 4, "1": 2, "-1": 3}}}	Georgetta Beu	georgetta.beu@example.com	San Dimas Demo	2020-07-28 17:53:35.762241+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	529db385-09fa-4aeb-97b1-db5c8ebff88d	73701371-d652-4b01-819c-fc7667184c95
b8129af8-2dc2-468d-96be-274082098e9b	2020-07-28 17:53:35.766788+00	2020-07-28 17:53:35.936808+00	adult	{"answers": [-1, 0, 1, -1, 0, 1, 1, -1, -1, -1, 0, 1, -1, -1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, -1, 0, -1, 1, 1, 0, 1, 0, 1, 1, 1, -1, -1, 1, 0, 0, -1, -1, 0, -1, 1, 0, -1, 1, 0, 1, -1, 0, -1, 0], "categories": {"ca": {"0": 2, "1": 6, "-1": 1}, "gi": {"0": 3, "1": 2, "-1": 4}, "pl": {"0": 4, "1": 2, "-1": 3}, "se": {"0": 2, "1": 3, "-1": 4}, "sp": {"0": 3, "1": 3, "-1": 3}, "st": {"0": 2, "1": 5, "-1": 2}}}	Jerry Mentz	jerry.mentz@example.com	San Dimas Demo	2020-07-28 17:53:35.933318+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	74fef58b-4ed9-4b6b-8819-428d46f6e0ac	73701371-d652-4b01-819c-fc7667184c95
3ac04847-c2ed-4521-ae3a-d9adcafbcd79	2020-07-28 17:53:35.941455+00	2020-07-28 17:53:36.055986+00	adult	{"answers": [1, 0, 1, 0, 1, 0, 0, 0, 1, 1, -1, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, -1, 1, 1, -1, 0, -1, -1, 0, 1, 1, 0, 1, -1, 1, -1, -1, 0, 1, 1, 0, 1, 1, -1, 1, 0, 1, 0, 1, 0, 1, 1, -1, -1], "categories": {"ca": {"0": 2, "1": 4, "-1": 3}, "gi": {"0": 2, "1": 5, "-1": 2}, "pl": {"0": 3, "1": 4, "-1": 2}, "se": {"0": 5, "1": 4, "-1": 0}, "sp": {"0": 4, "1": 4, "-1": 1}, "st": {"0": 2, "1": 4, "-1": 3}}}	Page Bovey	page.bovey@example.com	San Dimas Demo	2020-07-28 17:53:36.054376+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	763a4942-e851-4f76-ad15-39cf961cb427	73701371-d652-4b01-819c-fc7667184c95
ba2cb4e3-a643-47a1-83b8-6fcf83aa3eb6	2020-07-28 17:53:36.065391+00	2020-07-28 17:53:36.216673+00	adult	{"answers": [0, -1, -1, -1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, -1, 1, -1, -1, -1, -1, -1, 1, 0, 1, -1, 0, 0, -1, 1, 0, -1, 1, -1, -1, 0, -1, 1, 0, -1, -1, 1, 1, 0, 0, 1, -1, -1, -1, 0, 0, 0, 0, -1, 1], "categories": {"ca": {"0": 2, "1": 2, "-1": 5}, "gi": {"0": 3, "1": 4, "-1": 2}, "pl": {"0": 4, "1": 1, "-1": 4}, "se": {"0": 5, "1": 0, "-1": 4}, "sp": {"0": 5, "1": 1, "-1": 3}, "st": {"0": 3, "1": 2, "-1": 4}}}	Thorsten Mekonis	thorsten.mekonis@example.com	Huntley Meeting	2020-07-28 17:53:36.213231+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	5688de6b-3d53-43c4-bce4-a953cf475a80	9fc0f165-eea9-4ff0-8ac1-08da55423ed9
fe653b00-a44e-4dec-92af-485d86617e4c	2020-07-28 17:53:36.221467+00	2020-07-28 17:53:36.349914+00	adult	{"answers": [-1, 1, 1, 0, -1, 1, 0, 1, 0, -1, -1, -1, 1, -1, -1, 1, -1, -1, -1, 1, 0, 0, 1, -1, -1, 1, -1, 1, 1, -1, -1, -1, 1, -1, -1, 0, -1, 0, 1, 1, 1, 1, -1, -1, 0, -1, -1, -1, -1, 0, -1, 0, 1, 1], "categories": {"ca": {"0": 1, "1": 3, "-1": 5}, "gi": {"0": 2, "1": 4, "-1": 3}, "pl": {"0": 2, "1": 2, "-1": 5}, "se": {"0": 3, "1": 4, "-1": 2}, "sp": {"0": 0, "1": 2, "-1": 7}, "st": {"0": 2, "1": 3, "-1": 4}}}	Hasheem Strausser	hasheem.strausser@example.com	Huntley Meeting	2020-07-28 17:53:36.348299+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	7d2064b4-3730-4fde-ba98-f5ad131edfda	9fc0f165-eea9-4ff0-8ac1-08da55423ed9
b42753f5-e57c-44d8-a460-c7499c1c05af	2020-07-28 17:53:36.352661+00	2020-07-28 17:53:36.48063+00	adult	{"answers": [1, -1, -1, -1, 0, 1, -1, 1, -1, -1, 1, -1, 1, -1, 0, 0, -1, 1, 0, 1, -1, -1, 1, 0, 0, 0, 0, -1, 1, -1, -1, 1, -1, 1, 0, 0, -1, 0, -1, 0, 1, 0, -1, -1, -1, -1, 0, -1, 0, 0, 1, 1, -1, 0], "categories": {"ca": {"0": 2, "1": 3, "-1": 4}, "gi": {"0": 3, "1": 1, "-1": 5}, "pl": {"0": 4, "1": 2, "-1": 3}, "se": {"0": 1, "1": 3, "-1": 5}, "sp": {"0": 2, "1": 3, "-1": 4}, "st": {"0": 5, "1": 2, "-1": 2}}}	Wes Belch	wes.belch@example.com	Huntley Meeting	2020-07-28 17:53:36.477407+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	fae4677e-adc1-4d14-b5df-b83314b7aff7	9fc0f165-eea9-4ff0-8ac1-08da55423ed9
1b9179bb-a6a9-4d03-83a1-52ca1bbe14bc	2020-07-28 17:53:36.48523+00	2020-07-28 17:53:36.632438+00	adult	{"answers": [0, 1, -1, -1, -1, 0, 1, 1, 1, 1, -1, -1, 0, -1, 1, 0, -1, 1, -1, 0, -1, 1, -1, -1, -1, 1, 0, -1, -1, 1, 0, 0, 1, 0, 1, -1, 0, 0, 0, 1, -1, -1, -1, 1, 0, 0, -1, 0, -1, 0, 0, -1, 1, 1], "categories": {"ca": {"0": 3, "1": 3, "-1": 3}, "gi": {"0": 4, "1": 2, "-1": 3}, "pl": {"0": 4, "1": 2, "-1": 3}, "se": {"0": 2, "1": 4, "-1": 3}, "sp": {"0": 2, "1": 3, "-1": 4}, "st": {"0": 2, "1": 2, "-1": 5}}}	Marlow Semrad	marlow.semrad@example.com	Huntley Meeting	2020-07-28 17:53:36.630875+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	d98585d0-1c47-4a97-b2ff-1da3c622780f	9fc0f165-eea9-4ff0-8ac1-08da55423ed9
0a92ce11-dfba-41b4-a570-35d325670398	2020-07-28 17:53:36.635295+00	2020-07-28 17:53:36.742877+00	adult	{"answers": [-1, -1, 1, 1, 0, -1, -1, 0, -1, 1, 1, -1, -1, -1, -1, -1, -1, 1, 0, 0, 0, -1, 1, -1, 0, 0, -1, 0, 0, 1, 1, 1, -1, 1, 0, 0, 0, -1, 1, -1, 1, 0, 0, 0, 1, -1, -1, -1, 0, 1, 1, -1, 0, 0], "categories": {"ca": {"0": 4, "1": 4, "-1": 1}, "gi": {"0": 4, "1": 3, "-1": 2}, "pl": {"0": 3, "1": 2, "-1": 4}, "se": {"0": 2, "1": 2, "-1": 5}, "sp": {"0": 0, "1": 3, "-1": 6}, "st": {"0": 5, "1": 1, "-1": 3}}}	Sophia Manning	sophia.manning@example.com	Huntley Meeting	2020-07-28 17:53:36.739618+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	ed91301e-be59-4c6d-bd06-908028ba0405	9fc0f165-eea9-4ff0-8ac1-08da55423ed9
f5afc890-558b-4f74-b176-f020b30c3f76	2020-07-28 17:53:36.747445+00	2020-07-28 17:53:36.921141+00	adult	{"answers": [0, -1, 1, 1, -1, 1, 0, -1, 1, -1, -1, 1, 0, 1, 1, 1, -1, 0, -1, 1, 0, -1, 0, -1, 0, 0, 1, -1, 0, 0, -1, -1, -1, -1, 1, 1, 0, -1, 0, 0, 0, 0, 0, 1, 1, 0, 0, -1, 1, 0, 1, 0, -1, -1], "categories": {"ca": {"0": 2, "1": 2, "-1": 5}, "gi": {"0": 6, "1": 2, "-1": 1}, "pl": {"0": 4, "1": 2, "-1": 3}, "se": {"0": 2, "1": 4, "-1": 3}, "sp": {"0": 2, "1": 4, "-1": 3}, "st": {"0": 4, "1": 2, "-1": 3}}}	Ninette Broden	ninette.broden@example.com	Huntley Meeting	2020-07-28 17:53:36.9195+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	5d92e412-ef8b-4332-bda1-ffa533e8e193	9fc0f165-eea9-4ff0-8ac1-08da55423ed9
0ef81626-de5b-4c80-a527-d4cad115a0f0	2020-07-28 17:53:36.924047+00	2020-07-28 17:53:37.011153+00	adult	{"answers": [1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, -1, 1, -1, 1, 0, -1, 0, 0, 0, -1, 0, -1, 0, 1, -1, 0, 0, 1, 0, -1, -1, 0, -1, 1, 0, 1, -1, 0, 0, 1, 1, 1, 1, 1, -1, 0, 1, -1, 1, -1, 0], "categories": {"ca": {"0": 4, "1": 1, "-1": 4}, "gi": {"0": 3, "1": 5, "-1": 1}, "pl": {"0": 2, "1": 4, "-1": 3}, "se": {"0": 3, "1": 6, "-1": 0}, "sp": {"0": 4, "1": 3, "-1": 2}, "st": {"0": 5, "1": 1, "-1": 3}}}	Artus Deats	artus.deats@example.com	Huntley Meeting	2020-07-28 17:53:37.007806+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	fb841f41-12be-4894-982a-c046106ec4c8	9fc0f165-eea9-4ff0-8ac1-08da55423ed9
73f286ba-f7d2-43ae-86d4-4cbec74dd530	2020-07-28 17:53:37.015843+00	2020-07-28 17:53:37.203824+00	adult	{"answers": [1, 0, -1, 1, 1, 1, -1, -1, 0, 1, -1, 1, -1, 1, -1, 0, 1, -1, 0, 1, -1, 0, 0, -1, 0, 0, 0, -1, 1, 0, 1, 1, 0, 0, 0, -1, -1, -1, 1, -1, 1, 1, -1, -1, -1, -1, 1, 1, 0, 0, 1, 0, -1, -1], "categories": {"ca": {"0": 4, "1": 3, "-1": 2}, "gi": {"0": 0, "1": 3, "-1": 6}, "pl": {"0": 3, "1": 3, "-1": 3}, "se": {"0": 2, "1": 4, "-1": 3}, "sp": {"0": 1, "1": 4, "-1": 4}, "st": {"0": 6, "1": 1, "-1": 2}}}	Zuzana Ulrich	zuzana.ulrich@example.com	Huntley Meeting	2020-07-28 17:53:37.200355+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	9f2f500a-1808-4967-a8b1-5e04b25d31fe	9fc0f165-eea9-4ff0-8ac1-08da55423ed9
e9518a56-134d-41f0-8610-b92fab38b35a	2020-07-28 17:53:37.208637+00	2020-07-28 17:53:37.30107+00	adult	{"answers": [0, 0, 1, 1, 0, -1, 1, 1, 1, 0, -1, 0, 1, 1, -1, 1, 0, 1, -1, 0, 0, 0, -1, -1, -1, 0, -1, 0, 0, -1, -1, 0, 0, 1, 0, 0, -1, -1, 0, 0, 0, 1, 0, 1, 0, 1, 1, 0, 0, -1, -1, 1, 0, 1], "categories": {"ca": {"0": 6, "1": 1, "-1": 2}, "gi": {"0": 5, "1": 2, "-1": 2}, "pl": {"0": 3, "1": 4, "-1": 2}, "se": {"0": 3, "1": 5, "-1": 1}, "sp": {"0": 3, "1": 4, "-1": 2}, "st": {"0": 4, "1": 0, "-1": 5}}}	Allene Hanekamp	allene.hanekamp@example.com	Huntley Meeting	2020-07-28 17:53:37.299491+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	222b20fa-fed5-4328-8cfa-f17be4278ad3	9fc0f165-eea9-4ff0-8ac1-08da55423ed9
511e2fbd-9525-456d-90df-2d4ec72d4a83	2020-07-28 17:53:37.303955+00	2020-07-28 17:53:37.475717+00	adult	{"answers": [-1, -1, -1, -1, 0, 1, 0, 0, -1, -1, 1, -1, 0, 1, 1, 1, -1, 0, 1, 0, 1, -1, -1, -1, 0, 0, 0, -1, -1, 0, 0, -1, -1, -1, -1, -1, -1, 1, -1, 1, 1, 0, -1, 0, -1, 0, -1, -1, -1, 1, 0, 0, 1, 0], "categories": {"ca": {"0": 2, "1": 0, "-1": 7}, "gi": {"0": 2, "1": 3, "-1": 4}, "pl": {"0": 4, "1": 2, "-1": 3}, "se": {"0": 3, "1": 1, "-1": 5}, "sp": {"0": 2, "1": 4, "-1": 3}, "st": {"0": 4, "1": 2, "-1": 3}}}	Frayda Selking	frayda.selking@example.com	Huntley Meeting	2020-07-28 17:53:37.472094+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	641f26f7-3773-4d5f-b60c-ae3878f207fd	9fc0f165-eea9-4ff0-8ac1-08da55423ed9
e3668b78-c8ba-42ed-a156-4373ae3d524f	2020-07-28 17:53:37.480546+00	2020-07-28 17:53:37.59404+00	adult	{"answers": [1, 0, 1, 1, 1, -1, 1, 1, -1, -1, -1, 1, -1, -1, -1, 0, 0, 1, -1, -1, -1, -1, 1, -1, 1, 0, 0, -1, 1, 0, 0, -1, -1, 1, 1, 0, 0, -1, 1, 0, -1, -1, 1, -1, 1, -1, 0, -1, 0, 1, -1, 1, -1, 0], "categories": {"ca": {"0": 3, "1": 3, "-1": 3}, "gi": {"0": 2, "1": 3, "-1": 4}, "pl": {"0": 3, "1": 2, "-1": 4}, "se": {"0": 1, "1": 6, "-1": 2}, "sp": {"0": 2, "1": 2, "-1": 5}, "st": {"0": 2, "1": 2, "-1": 5}}}	Ashil Bann	ashil.bann@example.com	Huntley Meeting	2020-07-28 17:53:37.592451+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	777083f6-97bb-4858-bb90-68900faeb668	9fc0f165-eea9-4ff0-8ac1-08da55423ed9
9d9528bb-1d62-478f-9db7-e6ae5ab98c2f	2020-07-28 17:53:37.596832+00	2020-07-28 17:53:37.745517+00	adult	{"answers": [1, 1, 0, 0, -1, 0, 1, 0, -1, -1, 1, 1, 1, 1, -1, -1, -1, 1, 0, -1, -1, 1, 1, -1, -1, -1, -1, 1, 1, 0, -1, -1, 1, 0, -1, 0, 1, 1, -1, 1, 0, -1, 0, 1, 0, 1, 0, -1, 0, 0, 1, -1, 1, 1], "categories": {"ca": {"0": 3, "1": 3, "-1": 3}, "gi": {"0": 3, "1": 4, "-1": 2}, "pl": {"0": 3, "1": 4, "-1": 2}, "se": {"0": 4, "1": 3, "-1": 2}, "sp": {"0": 0, "1": 5, "-1": 4}, "st": {"0": 1, "1": 2, "-1": 6}}}	Brynna Keogan	brynna.keogan@example.com	Huntley Meeting	2020-07-28 17:53:37.742139+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	88d06026-07be-4284-927e-6c62261e1858	9fc0f165-eea9-4ff0-8ac1-08da55423ed9
7c93ad67-d994-4ec9-b27a-b0247904c2d8	2020-07-28 17:53:37.750109+00	2020-07-28 17:53:37.884831+00	adult	{"answers": [0, 1, 0, -1, -1, -1, 0, 0, 0, 0, -1, 1, 1, 1, 1, 1, 0, -1, 0, 0, -1, 1, 1, 0, 1, -1, 1, 0, -1, 1, -1, 1, 0, 0, -1, 0, -1, 1, 1, 0, 0, 0, 0, -1, 0, -1, -1, 1, 1, 0, 0, -1, 1, 0], "categories": {"ca": {"0": 4, "1": 2, "-1": 3}, "gi": {"0": 5, "1": 2, "-1": 2}, "pl": {"0": 3, "1": 3, "-1": 3}, "se": {"0": 5, "1": 1, "-1": 3}, "sp": {"0": 2, "1": 5, "-1": 2}, "st": {"0": 3, "1": 4, "-1": 2}}}	Imogen Claassen	imogen.claassen@example.com	Huntley Meeting	2020-07-28 17:53:37.8832+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	e20cd9b8-44d0-4cfc-951a-ad99598ec9c0	9fc0f165-eea9-4ff0-8ac1-08da55423ed9
c6687ac7-09c2-4db6-9a7a-3520105b47c2	2020-07-28 17:53:37.887629+00	2020-07-28 17:53:38.013531+00	adult	{"answers": [-1, -1, -1, -1, -1, 0, 0, 1, 0, 0, -1, 1, 0, -1, 0, 1, 0, -1, -1, 0, -1, 1, 0, 1, 1, 0, 0, 1, -1, -1, 0, -1, 1, 1, 0, -1, 0, -1, 1, -1, 0, 1, -1, 0, 1, 1, 1, -1, 1, 0, 1, -1, -1, 0], "categories": {"ca": {"0": 2, "1": 3, "-1": 4}, "gi": {"0": 3, "1": 3, "-1": 3}, "pl": {"0": 2, "1": 4, "-1": 3}, "se": {"0": 3, "1": 1, "-1": 5}, "sp": {"0": 4, "1": 2, "-1": 3}, "st": {"0": 4, "1": 3, "-1": 2}}}	Maud Snelgrove	maud.snelgrove@example.com	Huntley Meeting	2020-07-28 17:53:38.010247+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	76fe6377-38a9-4a55-bcba-d56f751805ec	9fc0f165-eea9-4ff0-8ac1-08da55423ed9
5e66bb05-3902-45ff-a64c-325a8368b47e	2020-07-28 17:53:38.018214+00	2020-07-28 17:53:38.176756+00	adult	{"answers": [1, 1, 1, 1, -1, 1, 0, 0, 0, 1, 1, -1, -1, 0, 0, 0, 0, 0, 0, -1, 0, 0, 1, -1, 1, 0, 0, -1, 1, -1, 1, 1, -1, -1, -1, -1, -1, -1, 0, -1, 0, 0, 1, 1, 0, -1, -1, 1, -1, 0, -1, 0, 0, 1], "categories": {"ca": {"0": 0, "1": 3, "-1": 6}, "gi": {"0": 4, "1": 2, "-1": 3}, "pl": {"0": 3, "1": 2, "-1": 4}, "se": {"0": 3, "1": 5, "-1": 1}, "sp": {"0": 5, "1": 2, "-1": 2}, "st": {"0": 5, "1": 2, "-1": 2}}}	Angelico Feigh	angelico.feigh@example.com	Huntley Meeting	2020-07-28 17:53:38.175094+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	5f6eaec4-7b21-4fda-9a63-6ee0513f5042	9fc0f165-eea9-4ff0-8ac1-08da55423ed9
d5830124-8e31-4957-9a60-164a61e4acff	2020-07-28 17:53:38.179678+00	2020-07-28 17:53:38.284924+00	adult	{"answers": [0, -1, 0, 0, -1, -1, 0, 0, -1, -1, 1, 1, 1, 0, 1, 1, 1, 1, -1, -1, 0, 1, 0, -1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, -1, 1, -1, 0, 1, 1, 0, 0, 1, 0, -1, 1, 0, -1, -1, 0, 0, 0, 0], "categories": {"ca": {"0": 5, "1": 3, "-1": 1}, "gi": {"0": 4, "1": 4, "-1": 1}, "pl": {"0": 5, "1": 1, "-1": 3}, "se": {"0": 5, "1": 0, "-1": 4}, "sp": {"0": 1, "1": 7, "-1": 1}, "st": {"0": 5, "1": 1, "-1": 3}}}	Leann Feagan	leann.feagan@example.com	Huntley Meeting	2020-07-28 17:53:38.281521+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	962b8507-cfc7-4ebc-b1b1-b3690fe0eb7a	9fc0f165-eea9-4ff0-8ac1-08da55423ed9
b06a06e9-7bc5-4cdf-bc4e-d3f8bf655bf5	2020-07-28 17:53:38.289576+00	2020-07-28 17:53:38.467994+00	adult	{"answers": [0, -1, 0, 0, -1, 0, -1, 0, 1, 1, 1, 0, 0, -1, -1, 1, -1, -1, -1, -1, 1, -1, 1, 1, -1, 1, 0, 1, 1, 0, 0, -1, 1, -1, 1, 1, -1, 1, 1, -1, 0, 0, 1, 1, 1, -1, -1, 0, 0, 0, 1, -1, -1, 1], "categories": {"ca": {"0": 2, "1": 5, "-1": 2}, "gi": {"0": 2, "1": 5, "-1": 2}, "pl": {"0": 3, "1": 2, "-1": 4}, "se": {"0": 5, "1": 1, "-1": 3}, "sp": {"0": 2, "1": 3, "-1": 4}, "st": {"0": 1, "1": 4, "-1": 4}}}	Marleah Finlay	marleah.finlay@example.com	Huntley Meeting	2020-07-28 17:53:38.466179+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	ea5f3631-f4e7-43e2-a7bc-9684afe934d6	9fc0f165-eea9-4ff0-8ac1-08da55423ed9
0c980f53-be04-4137-95d6-702296f48c03	2020-07-28 17:53:38.471016+00	2020-07-28 17:53:38.555733+00	adult	{"answers": [1, 1, 0, -1, 1, -1, 0, 1, 0, 1, -1, -1, 1, -1, -1, 0, -1, 0, 0, 1, -1, -1, -1, 0, 1, 1, 1, -1, 0, -1, -1, 0, 1, -1, 1, 0, -1, 1, 1, 1, -1, 0, -1, 1, -1, 0, 0, -1, -1, 0, 0, 0, 0, 0], "categories": {"ca": {"0": 3, "1": 2, "-1": 4}, "gi": {"0": 1, "1": 4, "-1": 4}, "pl": {"0": 7, "1": 0, "-1": 2}, "se": {"0": 3, "1": 4, "-1": 2}, "sp": {"0": 2, "1": 2, "-1": 5}, "st": {"0": 2, "1": 4, "-1": 3}}}	Gerek Brasure	gerek.brasure@example.com	Huntley Meeting	2020-07-28 17:53:38.554179+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	e5a2dea4-d182-46ed-9822-0051cd22ceb9	9fc0f165-eea9-4ff0-8ac1-08da55423ed9
01d32396-d7dd-42a6-8dac-782db82bb24f	2020-07-28 17:53:38.569957+00	2020-07-28 17:53:38.755894+00	adult	{"answers": [0, 1, 0, 1, 0, -1, 0, 0, -1, -1, 0, 0, 1, 1, -1, 1, 0, 0, -1, 0, 1, 0, 1, -1, -1, -1, -1, 1, -1, -1, 0, 1, 1, -1, 1, 1, -1, 0, -1, 1, -1, 0, -1, 1, 1, 1, -1, -1, 0, -1, 1, -1, 1, -1], "categories": {"ca": {"0": 1, "1": 5, "-1": 3}, "gi": {"0": 2, "1": 3, "-1": 4}, "pl": {"0": 1, "1": 3, "-1": 5}, "se": {"0": 5, "1": 2, "-1": 2}, "sp": {"0": 4, "1": 3, "-1": 2}, "st": {"0": 2, "1": 2, "-1": 5}}}	Bianka Mamoran	bianka.mamoran@example.com	Lawrence Conference	2020-07-28 17:53:38.752557+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	70e1bf8e-ff43-4278-a407-81d18bf60913	568c5006-bd75-4cdc-934c-fbb54bdabb8c
6df85ab6-8309-4f6d-aadf-8e0866032c0a	2020-07-28 17:53:38.760527+00	2020-07-28 17:53:38.851887+00	adult	{"answers": [0, -1, -1, 0, 1, -1, 0, 1, 0, 1, -1, -1, -1, -1, 0, 0, -1, 0, 0, 0, 1, 0, 0, -1, 1, 1, 0, -1, 0, 0, -1, 0, 1, 1, 0, -1, 0, -1, -1, -1, 1, 0, -1, -1, 1, 0, -1, 0, 0, 1, 1, 1, 0, -1], "categories": {"ca": {"0": 4, "1": 2, "-1": 3}, "gi": {"0": 2, "1": 2, "-1": 5}, "pl": {"0": 4, "1": 3, "-1": 2}, "se": {"0": 4, "1": 2, "-1": 3}, "sp": {"0": 3, "1": 1, "-1": 5}, "st": {"0": 5, "1": 3, "-1": 1}}}	Grayce Avers	grayce.avers@example.com	Lawrence Conference	2020-07-28 17:53:38.850296+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	fa066412-fb74-44c9-9108-e935a5feef56	568c5006-bd75-4cdc-934c-fbb54bdabb8c
b594f3fc-cb96-465a-9f68-c682e8b642ad	2020-07-28 17:53:38.854678+00	2020-07-28 17:53:39.02381+00	adult	{"answers": [1, -1, 1, -1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, -1, -1, -1, -1, -1, -1, -1, -1, 1, -1, 1, -1, 0, 0, 0, -1, -1, -1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, -1, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 0], "categories": {"ca": {"0": 2, "1": 4, "-1": 3}, "gi": {"0": 5, "1": 3, "-1": 1}, "pl": {"0": 5, "1": 4, "-1": 0}, "se": {"0": 1, "1": 6, "-1": 2}, "sp": {"0": 2, "1": 3, "-1": 4}, "st": {"0": 1, "1": 2, "-1": 6}}}	Naoma Janice	naoma.janice@example.com	Lawrence Conference	2020-07-28 17:53:39.020223+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	2e0da655-8db5-40a7-a9fa-5979e078c44e	568c5006-bd75-4cdc-934c-fbb54bdabb8c
a7a7af0a-b70b-412c-8ba4-271476083e34	2020-07-28 17:53:39.02859+00	2020-07-28 17:53:39.143728+00	adult	{"answers": [0, -1, -1, 1, -1, -1, 1, -1, 0, -1, -1, 1, -1, 0, 1, -1, 1, -1, -1, -1, -1, 1, 1, 0, -1, 1, 0, -1, 1, 0, 1, 1, 1, 0, 1, -1, 0, 1, 0, -1, 1, -1, 0, -1, -1, 1, 0, -1, 0, 0, 0, 0, -1, 0], "categories": {"ca": {"0": 2, "1": 5, "-1": 2}, "gi": {"0": 3, "1": 2, "-1": 4}, "pl": {"0": 6, "1": 1, "-1": 2}, "se": {"0": 2, "1": 2, "-1": 5}, "sp": {"0": 1, "1": 3, "-1": 5}, "st": {"0": 2, "1": 3, "-1": 4}}}	Rebe Turybury	rebe.turybury@example.com	Lawrence Conference	2020-07-28 17:53:39.142151+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	9e85258d-ef9c-4d50-84c0-d13213245134	568c5006-bd75-4cdc-934c-fbb54bdabb8c
69b386ad-ccab-45fd-b090-75fa9d629f51	2020-07-28 17:53:39.14651+00	2020-07-28 17:53:39.295712+00	adult	{"answers": [-1, -1, 0, 0, 1, -1, 0, -1, 1, -1, -1, 0, 0, 1, -1, 1, 0, 0, -1, 1, 0, 0, 1, -1, 0, 0, -1, 1, 0, 0, 0, -1, 1, 0, 0, 1, -1, 0, -1, -1, -1, 1, -1, 0, 1, 0, -1, 0, 0, -1, 1, -1, 0, -1], "categories": {"ca": {"0": 5, "1": 3, "-1": 1}, "gi": {"0": 2, "1": 2, "-1": 5}, "pl": {"0": 4, "1": 1, "-1": 4}, "se": {"0": 3, "1": 2, "-1": 4}, "sp": {"0": 4, "1": 2, "-1": 3}, "st": {"0": 4, "1": 2, "-1": 3}}}	Elvira Mcclimens	elvira.mcclimens@example.com	Lawrence Conference	2020-07-28 17:53:39.292263+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	fed7c6b6-ee58-4df3-84a3-e06aac58d3dd	568c5006-bd75-4cdc-934c-fbb54bdabb8c
4a2fdaa9-c628-45fa-b310-2ac1b5d5ca77	2020-07-28 17:53:39.300416+00	2020-07-28 17:53:39.435816+00	adult	{"answers": [0, 1, -1, -1, 1, 1, -1, 0, -1, 0, 0, 1, 1, 1, -1, 1, 1, 0, 0, -1, -1, 0, -1, 0, -1, -1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0, -1, 0, 1, 0, -1, 0, -1, 0, -1, -1, 0, -1, 1, 1, 1, 1], "categories": {"ca": {"0": 3, "1": 6, "-1": 0}, "gi": {"0": 4, "1": 2, "-1": 3}, "pl": {"0": 2, "1": 4, "-1": 3}, "se": {"0": 2, "1": 3, "-1": 4}, "sp": {"0": 3, "1": 5, "-1": 1}, "st": {"0": 3, "1": 1, "-1": 5}}}	Fancie Bucklin	fancie.bucklin@example.com	Lawrence Conference	2020-07-28 17:53:39.434148+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	e44e6f6b-03f8-4ac3-a77a-5ed4531f840c	568c5006-bd75-4cdc-934c-fbb54bdabb8c
aa4089e6-3158-4133-a794-bd5062e4306c	2020-07-28 17:53:39.446187+00	2020-07-28 17:53:39.575128+00	adult	{"answers": [0, 1, 1, -1, -1, -1, -1, -1, -1, 0, -1, -1, 0, -1, -1, 0, 1, 0, 1, -1, 0, -1, 0, -1, 0, 0, 0, 0, 0, 0, -1, 1, -1, 1, 0, -1, 0, 0, 1, -1, 0, 0, -1, -1, 0, 1, -1, 0, 1, 1, 0, -1, -1, 0], "categories": {"ca": {"0": 4, "1": 2, "-1": 3}, "gi": {"0": 5, "1": 1, "-1": 3}, "pl": {"0": 3, "1": 3, "-1": 3}, "se": {"0": 1, "1": 2, "-1": 6}, "sp": {"0": 4, "1": 1, "-1": 4}, "st": {"0": 5, "1": 1, "-1": 3}}}	Brit Quiram	brit.quiram@example.com	brit.quiram@example.com	2020-07-28 17:53:39.571804+00	t	971350a6-5e84-4ad5-b6b0-768fb945dad3	a8abca7d-03d8-45e4-a222-230d51e2e2c4	2b62a800-cde9-4357-a1bf-a47a3fff8c8e
\.


--
-- Data for Name: orders_order; Type: TABLE DATA; Schema: public; Owner: moneyhabitudes
--

COPY public.orders_order (id, created_date, modified_date, active, active_until, stripe_product_id, stripe_product_name, account_id) FROM stdin;
\.


--
-- Data for Name: orders_subscription; Type: TABLE DATA; Schema: public; Owner: moneyhabitudes
--

COPY public.orders_subscription (id, created_date, modified_date, active, active_until, stripe_subscription_id, stripe_plan_id, stripe_plan_name, group_codes, admin_reports, manual_override, "interval", games, account_id) FROM stdin;
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: moneyhabitudes
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: moneyhabitudes
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: moneyhabitudes
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 48, true);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: moneyhabitudes
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: moneyhabitudes
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 101, true);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: moneyhabitudes
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: moneyhabitudes
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 12, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: moneyhabitudes
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 18, true);


--
-- Name: accounts_account accounts_account_pkey; Type: CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.accounts_account
    ADD CONSTRAINT accounts_account_pkey PRIMARY KEY (id);


--
-- Name: accounts_account accounts_account_user_id_key; Type: CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.accounts_account
    ADD CONSTRAINT accounts_account_user_id_key UNIQUE (user_id);


--
-- Name: accounts_availablegames accounts_availablegames_pkey; Type: CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.accounts_availablegames
    ADD CONSTRAINT accounts_availablegames_pkey PRIMARY KEY (id);


--
-- Name: accounts_branding accounts_branding_account_id_key; Type: CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.accounts_branding
    ADD CONSTRAINT accounts_branding_account_id_key UNIQUE (account_id);


--
-- Name: accounts_branding accounts_branding_pkey; Type: CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.accounts_branding
    ADD CONSTRAINT accounts_branding_pkey PRIMARY KEY (id);


--
-- Name: accounts_share accounts_share_code_key; Type: CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.accounts_share
    ADD CONSTRAINT accounts_share_code_key UNIQUE (code);


--
-- Name: accounts_share accounts_share_pkey; Type: CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.accounts_share
    ADD CONSTRAINT accounts_share_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: games_game games_game_pkey; Type: CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.games_game
    ADD CONSTRAINT games_game_pkey PRIMARY KEY (id);


--
-- Name: orders_order orders_order_pkey; Type: CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.orders_order
    ADD CONSTRAINT orders_order_pkey PRIMARY KEY (id);


--
-- Name: orders_subscription orders_subscription_pkey; Type: CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.orders_subscription
    ADD CONSTRAINT orders_subscription_pkey PRIMARY KEY (id);


--
-- Name: accounts_availablegames_account_id_8b50770c; Type: INDEX; Schema: public; Owner: moneyhabitudes
--

CREATE INDEX accounts_availablegames_account_id_8b50770c ON public.accounts_availablegames USING btree (account_id);


--
-- Name: accounts_availablegames_subscription_id_fdc68c97; Type: INDEX; Schema: public; Owner: moneyhabitudes
--

CREATE INDEX accounts_availablegames_subscription_id_fdc68c97 ON public.accounts_availablegames USING btree (subscription_id);


--
-- Name: accounts_share_code_3e841fa1_like; Type: INDEX; Schema: public; Owner: moneyhabitudes
--

CREATE INDEX accounts_share_code_3e841fa1_like ON public.accounts_share USING btree (code varchar_pattern_ops);


--
-- Name: accounts_share_owner_id_f1c39eb5; Type: INDEX; Schema: public; Owner: moneyhabitudes
--

CREATE INDEX accounts_share_owner_id_f1c39eb5 ON public.accounts_share USING btree (owner_id);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: moneyhabitudes
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: moneyhabitudes
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: moneyhabitudes
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: moneyhabitudes
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: moneyhabitudes
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: moneyhabitudes
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: moneyhabitudes
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: moneyhabitudes
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: moneyhabitudes
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: moneyhabitudes
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: moneyhabitudes
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: games_game_owner_id_c554a59d; Type: INDEX; Schema: public; Owner: moneyhabitudes
--

CREATE INDEX games_game_owner_id_c554a59d ON public.games_game USING btree (owner_id);


--
-- Name: games_game_player_id_747add80; Type: INDEX; Schema: public; Owner: moneyhabitudes
--

CREATE INDEX games_game_player_id_747add80 ON public.games_game USING btree (player_id);


--
-- Name: games_game_share_id_c8f09112; Type: INDEX; Schema: public; Owner: moneyhabitudes
--

CREATE INDEX games_game_share_id_c8f09112 ON public.games_game USING btree (share_id);


--
-- Name: orders_order_account_id_cf843c80; Type: INDEX; Schema: public; Owner: moneyhabitudes
--

CREATE INDEX orders_order_account_id_cf843c80 ON public.orders_order USING btree (account_id);


--
-- Name: orders_subscription_account_id_43c91dc5; Type: INDEX; Schema: public; Owner: moneyhabitudes
--

CREATE INDEX orders_subscription_account_id_43c91dc5 ON public.orders_subscription USING btree (account_id);


--
-- Name: accounts_account accounts_account_user_id_d61b40c6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.accounts_account
    ADD CONSTRAINT accounts_account_user_id_d61b40c6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: accounts_availablegames accounts_availablega_account_id_8b50770c_fk_accounts_; Type: FK CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.accounts_availablegames
    ADD CONSTRAINT accounts_availablega_account_id_8b50770c_fk_accounts_ FOREIGN KEY (account_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: accounts_availablegames accounts_availablega_subscription_id_fdc68c97_fk_orders_su; Type: FK CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.accounts_availablegames
    ADD CONSTRAINT accounts_availablega_subscription_id_fdc68c97_fk_orders_su FOREIGN KEY (subscription_id) REFERENCES public.orders_subscription(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: accounts_branding accounts_branding_account_id_6b0ff6f8_fk_accounts_account_id; Type: FK CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.accounts_branding
    ADD CONSTRAINT accounts_branding_account_id_6b0ff6f8_fk_accounts_account_id FOREIGN KEY (account_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: accounts_share accounts_share_owner_id_f1c39eb5_fk_accounts_account_id; Type: FK CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.accounts_share
    ADD CONSTRAINT accounts_share_owner_id_f1c39eb5_fk_accounts_account_id FOREIGN KEY (owner_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: games_game games_game_owner_id_c554a59d_fk_accounts_account_id; Type: FK CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.games_game
    ADD CONSTRAINT games_game_owner_id_c554a59d_fk_accounts_account_id FOREIGN KEY (owner_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: games_game games_game_player_id_747add80_fk_accounts_account_id; Type: FK CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.games_game
    ADD CONSTRAINT games_game_player_id_747add80_fk_accounts_account_id FOREIGN KEY (player_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: games_game games_game_share_id_c8f09112_fk_accounts_share_id; Type: FK CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.games_game
    ADD CONSTRAINT games_game_share_id_c8f09112_fk_accounts_share_id FOREIGN KEY (share_id) REFERENCES public.accounts_share(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: orders_order orders_order_account_id_cf843c80_fk_accounts_account_id; Type: FK CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.orders_order
    ADD CONSTRAINT orders_order_account_id_cf843c80_fk_accounts_account_id FOREIGN KEY (account_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: orders_subscription orders_subscription_account_id_43c91dc5_fk_accounts_account_id; Type: FK CONSTRAINT; Schema: public; Owner: moneyhabitudes
--

ALTER TABLE ONLY public.orders_subscription
    ADD CONSTRAINT orders_subscription_account_id_43c91dc5_fk_accounts_account_id FOREIGN KEY (account_id) REFERENCES public.accounts_account(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: DATABASE moneyhabitudes; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON DATABASE moneyhabitudes TO moneyhabitudes;


--
-- PostgreSQL database dump complete
--

\connect postgres

--
-- PostgreSQL database dump
--

-- Dumped from database version 11.2 (Debian 11.2-1.pgdg90+1)
-- Dumped by pg_dump version 11.2 (Debian 11.2-1.pgdg90+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

