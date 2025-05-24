--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.4

-- Started on 2025-05-24 02:23:08

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
-- TOC entry 225 (class 1255 OID 16443)
-- Name: eliminar_producto(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.eliminar_producto(_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM productos WHERE id = _id;
END;
$$;


ALTER FUNCTION public.eliminar_producto(_id integer) OWNER TO postgres;

--
-- TOC entry 226 (class 1255 OID 16445)
-- Name: insertar_producto(character varying, text, numeric, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_producto(_nombre character varying, _descripcion text, _precio numeric, _stock integer, _id_categoria integer, _id_proveedor integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO productos(nombre, descripcion, precio, stock, id_categoria, id_proveedor)
    VALUES (_nombre, _descripcion, _precio, _stock, _id_categoria, _id_proveedor);
END;
$$;


ALTER FUNCTION public.insertar_producto(_nombre character varying, _descripcion text, _precio numeric, _stock integer, _id_categoria integer, _id_proveedor integer) OWNER TO postgres;

--
-- TOC entry 227 (class 1255 OID 16446)
-- Name: listar_productos(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.listar_productos() RETURNS TABLE(id integer, nombre character varying, descripcion text, precio numeric, stock integer, id_categoria integer, id_proveedor integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT p.id, p.nombre, p.descripcion, p.precio, p.stock, p.id_categoria, p.id_proveedor
    FROM productos p;
END;
$$;


ALTER FUNCTION public.listar_productos() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 218 (class 1259 OID 16390)
-- Name: categorias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categorias (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL
);


ALTER TABLE public.categorias OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16389)
-- Name: categorias_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categorias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categorias_id_seq OWNER TO postgres;

--
-- TOC entry 4837 (class 0 OID 0)
-- Dependencies: 217
-- Name: categorias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categorias_id_seq OWNED BY public.categorias.id;


--
-- TOC entry 224 (class 1259 OID 16425)
-- Name: ordenes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ordenes (
    id integer NOT NULL,
    tipo character varying(10),
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    id_producto integer,
    cantidad integer NOT NULL,
    CONSTRAINT ordenes_cantidad_check CHECK ((cantidad > 0)),
    CONSTRAINT ordenes_tipo_check CHECK (((tipo)::text = ANY ((ARRAY['compra'::character varying, 'venta'::character varying])::text[])))
);


ALTER TABLE public.ordenes OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16424)
-- Name: ordenes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ordenes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ordenes_id_seq OWNER TO postgres;

--
-- TOC entry 4838 (class 0 OID 0)
-- Dependencies: 223
-- Name: ordenes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ordenes_id_seq OWNED BY public.ordenes.id;


--
-- TOC entry 222 (class 1259 OID 16404)
-- Name: productos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.productos (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text,
    precio numeric(10,2) NOT NULL,
    stock integer DEFAULT 0 NOT NULL,
    id_categoria integer,
    id_proveedor integer,
    CONSTRAINT productos_precio_check CHECK ((precio >= (0)::numeric))
);


ALTER TABLE public.productos OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16403)
-- Name: productos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.productos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.productos_id_seq OWNER TO postgres;

--
-- TOC entry 4839 (class 0 OID 0)
-- Dependencies: 221
-- Name: productos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.productos_id_seq OWNED BY public.productos.id;


--
-- TOC entry 220 (class 1259 OID 16397)
-- Name: proveedores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.proveedores (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    contacto character varying(100)
);


ALTER TABLE public.proveedores OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16396)
-- Name: proveedores_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.proveedores_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.proveedores_id_seq OWNER TO postgres;

--
-- TOC entry 4840 (class 0 OID 0)
-- Dependencies: 219
-- Name: proveedores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.proveedores_id_seq OWNED BY public.proveedores.id;


--
-- TOC entry 4659 (class 2604 OID 16393)
-- Name: categorias id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorias ALTER COLUMN id SET DEFAULT nextval('public.categorias_id_seq'::regclass);


--
-- TOC entry 4663 (class 2604 OID 16428)
-- Name: ordenes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordenes ALTER COLUMN id SET DEFAULT nextval('public.ordenes_id_seq'::regclass);


--
-- TOC entry 4661 (class 2604 OID 16407)
-- Name: productos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos ALTER COLUMN id SET DEFAULT nextval('public.productos_id_seq'::regclass);


--
-- TOC entry 4660 (class 2604 OID 16400)
-- Name: proveedores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedores ALTER COLUMN id SET DEFAULT nextval('public.proveedores_id_seq'::regclass);


--
-- TOC entry 4825 (class 0 OID 16390)
-- Dependencies: 218
-- Data for Name: categorias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categorias (id, nombre) FROM stdin;
1	Limpieza
2	Alimentos
\.


--
-- TOC entry 4831 (class 0 OID 16425)
-- Dependencies: 224
-- Data for Name: ordenes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ordenes (id, tipo, fecha, id_producto, cantidad) FROM stdin;
1	venta	2025-05-22 20:52:12.55091	1	2
2	compra	2025-05-22 20:52:12.55091	2	10
\.


--
-- TOC entry 4829 (class 0 OID 16404)
-- Dependencies: 222
-- Data for Name: productos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.productos (id, nombre, descripcion, precio, stock, id_categoria, id_proveedor) FROM stdin;
2	Panquecitos	Panquecitos con chispas de chocolate	2500.00	50	2	2
4	JABON ARIEL	Jabón para lavar ropa	12000.00	30	1	1
5	Gomitas	Gomitas trululu	1500.00	20	2	2
6	Curry	Curry instantáneo	16000.00	15	2	2
1	Lavaloza	Lozacream	10000.00	12	1	1
8	Suavitel	Suavizante de Ropa	35000.00	40	1	1
9	Salsa	Salsa	0.00	0	1	1
\.


--
-- TOC entry 4827 (class 0 OID 16397)
-- Dependencies: 220
-- Data for Name: proveedores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.proveedores (id, nombre, contacto) FROM stdin;
1	Suavitel	suavitel@gmail.com
2	Bimbo	bimbo@gmail.com
\.


--
-- TOC entry 4841 (class 0 OID 0)
-- Dependencies: 217
-- Name: categorias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categorias_id_seq', 2, true);


--
-- TOC entry 4842 (class 0 OID 0)
-- Dependencies: 223
-- Name: ordenes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ordenes_id_seq', 2, true);


--
-- TOC entry 4843 (class 0 OID 0)
-- Dependencies: 221
-- Name: productos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.productos_id_seq', 9, true);


--
-- TOC entry 4844 (class 0 OID 0)
-- Dependencies: 219
-- Name: proveedores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.proveedores_id_seq', 2, true);


--
-- TOC entry 4669 (class 2606 OID 16395)
-- Name: categorias categorias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY (id);


--
-- TOC entry 4675 (class 2606 OID 16433)
-- Name: ordenes ordenes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordenes
    ADD CONSTRAINT ordenes_pkey PRIMARY KEY (id);


--
-- TOC entry 4673 (class 2606 OID 16413)
-- Name: productos productos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_pkey PRIMARY KEY (id);


--
-- TOC entry 4671 (class 2606 OID 16402)
-- Name: proveedores proveedores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedores
    ADD CONSTRAINT proveedores_pkey PRIMARY KEY (id);


--
-- TOC entry 4678 (class 2606 OID 16434)
-- Name: ordenes ordenes_id_producto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordenes
    ADD CONSTRAINT ordenes_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES public.productos(id);


--
-- TOC entry 4676 (class 2606 OID 16414)
-- Name: productos productos_id_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES public.categorias(id);


--
-- TOC entry 4677 (class 2606 OID 16419)
-- Name: productos productos_id_proveedor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_id_proveedor_fkey FOREIGN KEY (id_proveedor) REFERENCES public.proveedores(id);


-- Completed on 2025-05-24 02:23:08

--
-- PostgreSQL database dump complete
--

