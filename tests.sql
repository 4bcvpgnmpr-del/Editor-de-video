-- Tests para las jugadoras. Ejecutar UNA vez en Supabase > SQL Editor.
-- Las preguntas y las respuestas correctas solo las ve el entrenador: las jugadoras
-- reciben las preguntas y envian sus respuestas a traves de funciones del servidor,
-- que corrigen. Cada jugadora solo puede enviar un test una vez.

create table if not exists public.tests (
  id uuid primary key default gen_random_uuid(),
  titulo text not null,
  preguntas jsonb not null default '[]',      -- [{id, texto, opciones:[...], correcta:0}]
  n_preguntas int not null default 5,         -- cuantas le salen a cada jugadora
  jugadoras text[],                           -- null = todas
  abierto boolean not null default true,
  mostrar_correccion boolean not null default true,
  creado timestamptz not null default now()
);

create table if not exists public.test_intentos (
  id uuid primary key default gen_random_uuid(),
  test_id uuid not null references public.tests(id) on delete cascade,
  jugadora_id text not null,
  servidas jsonb not null,                    -- [{id, orden:[...]}] lo que le salio y en que orden
  respuestas jsonb,                           -- {id_pregunta: opcion elegida (indice original) o null}
  aciertos int,
  total int,
  iniciado timestamptz not null default now(),
  terminado timestamptz,
  unique (test_id, jugadora_id)
);

-- Mismo criterio que el resto de la app: leen los entrenadores, escribe el propietario.
create or replace function public.es_propietario() returns boolean
language sql stable security definer set search_path = public as $$
  select coalesce(
    (select lower(valor) = lower(coalesce(auth.jwt()->>'email','')) from public.ajustes where clave = 'propietario' limit 1),
    true);
$$;

alter table public.tests enable row level security;
alter table public.test_intentos enable row level security;

drop policy if exists tests_leer on public.tests;
create policy tests_leer on public.tests for select to authenticated using (public.es_entrenador());
drop policy if exists tests_escribir on public.tests;
create policy tests_escribir on public.tests for all to authenticated
  using (public.es_entrenador() and public.es_propietario())
  with check (public.es_entrenador() and public.es_propietario());

drop policy if exists intentos_leer on public.test_intentos;
create policy intentos_leer on public.test_intentos for select to authenticated using (public.es_entrenador());
drop policy if exists intentos_borrar on public.test_intentos;
create policy intentos_borrar on public.test_intentos for delete to authenticated
  using (public.es_entrenador() and public.es_propietario());

-- Quien es la jugadora que ha entrado (por su correo)
create or replace function public.mi_jugadora_id() returns text
language sql stable security definer set search_path = public as $$
  select id::text from public.jugadoras
  where lower(email) = lower(coalesce(auth.jwt()->>'email','')) limit 1;
$$;

-- Lista de tests de la jugadora: pendiente / en_curso / hecho
create or replace function public.tests_mios() returns jsonb
language sql stable security definer set search_path = public as $$
  select coalesce(jsonb_agg(jsonb_build_object(
      'id', t.id, 'titulo', t.titulo,
      'preguntas', least(t.n_preguntas, jsonb_array_length(t.preguntas)),
      'estado', case when i.terminado is not null then 'hecho' when i.id is not null then 'en_curso' else 'pendiente' end,
      'aciertos', i.aciertos, 'total', i.total, 'terminado', i.terminado)
    order by t.creado desc), '[]'::jsonb)
  from public.tests t
  left join public.test_intentos i on i.test_id = t.id and i.jugadora_id = public.mi_jugadora_id()
  where public.mi_jugadora_id() is not null
    and ((t.abierto and (t.jugadoras is null or public.mi_jugadora_id() = any(t.jugadoras))) or i.terminado is not null);
$$;

-- Empezar (o retomar) un test: devuelve sus preguntas, sin la respuesta correcta.
-- La primera vez se sortean las preguntas y el orden de las opciones; si se recarga
-- la pagina le salen las mismas.
create or replace function public.test_empezar(p_test uuid) returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  jid text := public.mi_jugadora_id();
  t public.tests; it public.test_intentos; n int; serv jsonb;
begin
  if jid is null then raise exception 'No estas dada de alta como jugadora'; end if;
  select * into t from public.tests where id = p_test;
  if not found then raise exception 'Ese test no existe'; end if;
  select * into it from public.test_intentos where test_id = p_test and jugadora_id = jid;
  if found and it.terminado is not null then
    return jsonb_build_object('hecho', true, 'aciertos', it.aciertos, 'total', it.total);
  end if;
  if not found then
    if not t.abierto or not (t.jugadoras is null or jid = any(t.jugadoras)) then
      raise exception 'Este test no esta disponible';
    end if;
    n := least(t.n_preguntas, jsonb_array_length(t.preguntas));
    if n < 1 then raise exception 'Este test no tiene preguntas'; end if;
    select coalesce(jsonb_agg(jsonb_build_object(
             'id', q.elem->>'id',
             'orden', (select jsonb_agg(o - 1 order by random())
                       from generate_series(1, jsonb_array_length(q.elem->'opciones')) o)
           ) order by q.rn), '[]'::jsonb)
      into serv
    from (select e as elem, row_number() over (order by random()) as rn
          from jsonb_array_elements(t.preguntas) e) q
    where q.rn <= n;
    insert into public.test_intentos (test_id, jugadora_id, servidas)
      values (p_test, jid, serv) returning * into it;
  end if;
  return (
    select jsonb_build_object('hecho', false, 'titulo', t.titulo,
      'mostrar_correccion', t.mostrar_correccion,
      'preguntas', coalesce(jsonb_agg(jsonb_build_object(
        'id', s.s->>'id',
        'texto', p.elem->>'texto',
        'opciones', (select jsonb_agg(p.elem->'opciones'->(z.x::int) order by z.ord)
                     from jsonb_array_elements_text(s.s->'orden') with ordinality as z(x, ord))
      ) order by s.sord), '[]'::jsonb))
    from jsonb_array_elements(it.servidas) with ordinality as s(s, sord)
    join jsonb_array_elements(t.preguntas) as p(elem) on p.elem->>'id' = s.s->>'id'
  );
end $$;

-- Enviar respuestas: { id_pregunta: posicion elegida tal como se la mostraron }
-- Se corrige aqui. Solo se puede una vez.
create or replace function public.test_enviar(p_test uuid, p_resp jsonb) returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  jid text := public.mi_jugadora_id();
  t public.tests; it public.test_intentos;
  s jsonb; q jsonb; k int; elegida int; ok boolean;
  ac int := 0; tot int := 0; guardadas jsonb := '{}'::jsonb; det jsonb := '[]'::jsonb;
begin
  if jid is null then raise exception 'No estas dada de alta como jugadora'; end if;
  select * into it from public.test_intentos where test_id = p_test and jugadora_id = jid for update;
  if not found then raise exception 'Primero tienes que empezar el test'; end if;
  if it.terminado is not null then raise exception 'Ya has respondido este test'; end if;
  select * into t from public.tests where id = p_test;
  for s in select e from jsonb_array_elements(it.servidas) e loop
    q := null;
    select e into q from jsonb_array_elements(t.preguntas) e where e->>'id' = s->>'id';
    if q is null then continue; end if;
    tot := tot + 1;
    elegida := null;
    if jsonb_typeof(p_resp->(s->>'id')) = 'number' then
      k := (p_resp->>(s->>'id'))::int;
      if k >= 0 and k < jsonb_array_length(s->'orden') then elegida := (s->'orden'->>k)::int; end if;
    end if;
    ok := elegida is not null and elegida = (q->>'correcta')::int;
    if ok then ac := ac + 1; end if;
    guardadas := guardadas || jsonb_build_object(s->>'id', elegida);
    det := det || jsonb_build_array(jsonb_build_object(
      'texto', q->>'texto', 'ok', ok,
      'tu', case when elegida is null then null else q->'opciones'->>elegida end,
      'correcta', case when t.mostrar_correccion then q->'opciones'->>((q->>'correcta')::int) else null end));
  end loop;
  update public.test_intentos
    set respuestas = guardadas, aciertos = ac, total = tot, terminado = now()
    where id = it.id;
  return jsonb_build_object('aciertos', ac, 'total', tot,
    'detalle', case when t.mostrar_correccion then det else '[]'::jsonb end);
end $$;

grant execute on function public.mi_jugadora_id() to authenticated;
grant execute on function public.tests_mios() to authenticated;
grant execute on function public.test_empezar(uuid) to authenticated;
grant execute on function public.test_enviar(uuid, jsonb) to authenticated;
