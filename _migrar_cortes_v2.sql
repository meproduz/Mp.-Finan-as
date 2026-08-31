-- Ajuste: vídeos e cortes ficam DENTRO do mesmo projeto (não um seletor exclusivo),
-- cada um com sua própria quantidade e taxa de edição.
-- Rode isto no SQL Editor do Supabase (não apaga nada, só adiciona colunas e migra o que já foi lançado).

ALTER TABLE fin_editores ADD COLUMN IF NOT EXISTS rate_corte NUMERIC DEFAULT 20;
ALTER TABLE fin_editor_projetos ADD COLUMN IF NOT EXISTS qtd_video INT DEFAULT 0;
ALTER TABLE fin_editor_projetos ADD COLUMN IF NOT EXISTS qtd_corte INT DEFAULT 0;

-- Migra os projetos já lançados (que usavam qtd + tipo) pro novo formato
UPDATE fin_editor_projetos SET
  qtd_video = CASE WHEN tipo = 'video' THEN qtd ELSE qtd_video END,
  qtd_corte = CASE WHEN tipo = 'corte' THEN qtd ELSE qtd_corte END
WHERE qtd_video = 0 AND qtd_corte = 0;
