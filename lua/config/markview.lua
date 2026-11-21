-- ==========================================
-- Markview.nvim - Preview de Markdown/LaTeX/Typst/YAML
--
-- ATENÇÃO: os blocos `markdown`, `markdown_inline`, `yaml`, etc.
-- NÃO são definidos aqui de propósito.
--
-- O markview só mescla os defaults externos (markview.config.markdown)
-- quando a quantidade de chaves do user config DIFERE da do default.
-- Como os defaults já entregam exatamente o visual desejado
-- (headings com ícones, listas ●, blockquotes ▋, tabelas
-- arredondadas, checkboxes com nerd fonts), manter o bloco fora
-- do setup garante que os defaults completos sejam aplicados.
-- ==========================================

local ok_markview, markview = pcall(require, 'markview')

if ok_markview then
  markview.setup {
    preview = {
      -- Preview nos modos normal e comando
      modes = { "n", "no", "c" },

      -- Modo híbrido só sob demanda (mapeado no <leader>mh)
      hybrid_modes = {},

      -- Usa o nvim-web-devicons já instalado
      icon_provider = "devicons",

      -- Não aplica preview em buffers sem arquivo (help, etc.)
      ignore_buftypes = { "nofile", "quickfix", "help" },

      -- Evita travamentos em arquivos gigantes
      max_buf_lines = 500,

      -- Deixa o debounce um pouco maior p/ digitação fluida
      debounce = 100,
    },

    renderers = {},
  }

  -- ----------------------------------------
  -- Mappings (modo híbrido só por atalho)
  -- ----------------------------------------
  local map = vim.keymap.set

  map('n', '<leader>mv', '<cmd>Markview toggle<cr>',            { desc = "Markview: liga/desliga preview" })
  map('n', '<leader>mh', '<cmd>Markview HybridToggle<cr>',       { desc = "Markview: modo híbrido (editar+preview)" })
  map('n', '<leader>ms', '<cmd>Markview splitToggle<cr>',        { desc = "Markview: preview lateral (splitview)" })
  map('n', '<leader>mr', '<cmd>Markview Render<cr>',             { desc = "Markview: atualizar preview" })
end