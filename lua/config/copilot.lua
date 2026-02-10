local ok_copilot, copilot = pcall(require, 'copilot')

if ok_copilot then
  copilot.setup({
    panel = {
      enabled = true,
      auto_refresh = false,
      keymap = {
        jump_prev = "[[",
        jump_next = "]]",
        accept = "<CR>",
        refresh = "gr",
        open = "<M-CR>"
      },
      layout = {
        position = "bottom", -- top | bottom | left | right
        ratio = 0.4
      },
    },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      debounce = 75,
      keymap = {
        accept = "<M-l>",
        accept_word = false,
        accept_line = false,
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
    },
    filetypes = {
      yaml = false, -- desabilita para arquivos YAML
    },
  })

  -- vim.g.copilot_no_tab_map = true  -- Desabilita tab padrão

  local map = vim.keymap.set
  local opts = { noremap = true, silent = true }

  map('i', '<leader>ca', ':Copilot panel<CR>', { desc = "Abrir painel do Copilot" }, opts)
  map('i', '<leader>cn', ':Copilot next<CR>', { desc = "Próxima sugestão do Copilot" }, opts)
  map('i', '<leader>cp', ':Copilot prev<CR>', { desc = "Sugestão anterior do Copilot" }, opts)
  map('i', '<leader>cd', ':Copilot dismiss<CR>', { desc = "Descartar sugestão do Copilot" }, opts)

  map('n', '<F1>', ':Copilot enable<CR>', { desc = "Habilitar Copilot" }, opts)
  map('n', '<F2>', ':Copilot disable<CR>', { desc = "Desabilitar Copilot" }, opts)
  map('n', '<F3>', ':Copilot panel<CR>', { desc = "Abrir painel do Copilot" }, opts)
  map('n', '<F4>', ':Copilot status<CR>', { desc = "Copilot Status" }, opts)
end
