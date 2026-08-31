-- Migração: mover "Capacidade da Equipe" (editores/projetos) do localStorage pro Supabase.
-- Rode isto uma vez no SQL Editor do Supabase antes de recarregar o app com o código novo.

create table if not exists fin_editores (
  id uuid primary key default gen_random_uuid(),
  nome text not null,
  rate numeric not null default 40,
  created_at timestamptz not null default now()
);

create table if not exists fin_editor_projetos (
  id uuid primary key default gen_random_uuid(),
  editor_id uuid not null references fin_editores(id) on delete cascade,
  mes_ref text not null,
  nome text not null default '',
  qtd integer not null default 1,
  entregue boolean not null default false,
  created_at timestamptz not null default now()
);

create index if not exists fin_editor_projetos_mes_idx on fin_editor_projetos(mes_ref);
create index if not exists fin_editor_projetos_editor_idx on fin_editor_projetos(editor_id);

alter table fin_editores enable row level security;
alter table fin_editor_projetos enable row level security;

-- Mesmo modelo de acesso das outras tabelas fin_*: qualquer usuário autenticado
-- do app pode ler/escrever (é um app de uso interno de uma pessoa/equipe só).
create policy "fin_editores_all" on fin_editores for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
create policy "fin_editor_projetos_all" on fin_editor_projetos for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
