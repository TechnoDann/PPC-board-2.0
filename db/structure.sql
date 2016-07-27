--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: crc32(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION crc32(word text) RETURNS bigint
    LANGUAGE plpgsql IMMUTABLE
    AS $$
          DECLARE tmp bigint;
          DECLARE i int;
          DECLARE j int;
          DECLARE byte_length int;
          DECLARE word_array bytea;
          BEGIN
            IF COALESCE(word, '') = '' THEN
              return 0;
            END IF;

            i = 0;
            tmp = 4294967295;
            byte_length = bit_length(word) / 8;
            word_array = decode(replace(word, E'\\', E'\\\\'), 'escape');
            LOOP
              tmp = (tmp # get_byte(word_array, i))::bigint;
              i = i + 1;
              j = 0;
              LOOP
                tmp = ((tmp >> 1) # (3988292384 * (tmp & 1)))::bigint;
                j = j + 1;
                IF j >= 8 THEN
                  EXIT;
                END IF;
              END LOOP;
              IF i >= byte_length THEN
                EXIT;
              END IF;
            END LOOP;
            return (tmp # 4294967295);
          END
        $$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: bans; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE bans (
    id integer NOT NULL,
    user_id integer,
    ip character varying(255),
    email character varying(255),
    length integer DEFAULT 60 NOT NULL,
    reason character varying(500) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: bans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bans_id_seq OWNED BY bans.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE posts (
    id integer NOT NULL,
    locked boolean,
    poofed boolean,
    sort_timestamp timestamp without time zone,
    subject character varying(255),
    user_id integer,
    author character varying(255),
    body text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    ancestry text,
    previous_version_id integer,
    next_version_id integer,
    being_cloned boolean DEFAULT false
);


--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE posts_id_seq OWNED BY posts.id;


--
-- Name: posts_tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE posts_tags (
    tag_id integer,
    post_id integer
);


--
-- Name: posts_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE posts_users (
    post_id integer,
    user_id integer
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tags (
    id integer NOT NULL,
    name character varying(255)
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    moderator boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    guest_user boolean DEFAULT true,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255)
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bans ALTER COLUMN id SET DEFAULT nextval('bans_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts ALTER COLUMN id SET DEFAULT nextval('posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: bans_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bans
    ADD CONSTRAINT bans_pkey PRIMARY KEY (id);


--
-- Name: posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_bans_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_bans_on_email ON bans USING btree (email);


--
-- Name: index_bans_on_ip; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_bans_on_ip ON bans USING btree (ip);


--
-- Name: index_posts_on_ancestry; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_posts_on_ancestry ON posts USING btree (ancestry text_pattern_ops NULLS FIRST);


--
-- Name: index_posts_on_text_search; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_posts_on_text_search ON posts USING gin ((((setweight(to_tsvector('english'::regconfig, COALESCE((subject)::text, ''::text)), 'A'::"char") || setweight(to_tsvector('english'::regconfig, COALESCE((author)::text, ''::text)), 'C'::"char")) || setweight(to_tsvector('english'::regconfig, COALESCE(body, ''::text)), 'B'::"char"))));


--
-- Name: index_posts_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_posts_on_user_id ON posts USING btree (user_id);


--
-- Name: index_users_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_name ON users USING btree (name);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: bans_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bans
    ADD CONSTRAINT bans_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: posts_next_version_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_next_version_id_fk FOREIGN KEY (next_version_id) REFERENCES posts(id);


--
-- Name: posts_previous_version_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_previous_version_id_fk FOREIGN KEY (previous_version_id) REFERENCES posts(id);


--
-- Name: posts_tags_post_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts_tags
    ADD CONSTRAINT posts_tags_post_id_fk FOREIGN KEY (post_id) REFERENCES posts(id);


--
-- Name: posts_tags_tag_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts_tags
    ADD CONSTRAINT posts_tags_tag_id_fk FOREIGN KEY (tag_id) REFERENCES tags(id);


--
-- Name: posts_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: posts_users_post_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts_users
    ADD CONSTRAINT posts_users_post_id_fk FOREIGN KEY (post_id) REFERENCES posts(id);


--
-- Name: posts_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts_users
    ADD CONSTRAINT posts_users_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20120807155544');

INSERT INTO schema_migrations (version) VALUES ('20120807210241');

INSERT INTO schema_migrations (version) VALUES ('20120807210832');

INSERT INTO schema_migrations (version) VALUES ('20120808140632');

INSERT INTO schema_migrations (version) VALUES ('20120808145818');

INSERT INTO schema_migrations (version) VALUES ('20120808215504');

INSERT INTO schema_migrations (version) VALUES ('20120809212240');

INSERT INTO schema_migrations (version) VALUES ('20120810143218');

INSERT INTO schema_migrations (version) VALUES ('20120810153105');

INSERT INTO schema_migrations (version) VALUES ('20120810155937');

INSERT INTO schema_migrations (version) VALUES ('20120810161317');

INSERT INTO schema_migrations (version) VALUES ('20120811142914');

INSERT INTO schema_migrations (version) VALUES ('20120811181007');

INSERT INTO schema_migrations (version) VALUES ('20120811230633');

INSERT INTO schema_migrations (version) VALUES ('20120812220416');

INSERT INTO schema_migrations (version) VALUES ('20120814011643');

INSERT INTO schema_migrations (version) VALUES ('20130822190500');

INSERT INTO schema_migrations (version) VALUES ('20140403211929');

INSERT INTO schema_migrations (version) VALUES ('20150723034043');

INSERT INTO schema_migrations (version) VALUES ('20160727003452');

