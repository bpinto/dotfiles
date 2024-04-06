return {
  'folke/trouble.nvim',
  event = 'BufWinEnter',
  keys = {
    { '<leader>xw', '<cmd>Trouble lsp_workspace_diagnostics<cr>', silent = true },
    { '<leader>xd', '<cmd>Trouble lsp_document_diagnostics<cr>', silent = true },
    { '<leader>xx', '<cmd>Trouble<cr>', silent = true },
    { 'gR', '<cmd>Trouble lsp_references<cr>', silent = true },
  },
  opts = {
    icons = false, -- do not use devicons for filenames
  },
  config = function()
    --Diagnostic icons
    local signs = { Error = "", Warning = "", Hint = "", Information = "" }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end
  end
}
