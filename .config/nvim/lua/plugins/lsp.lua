return {
  'neovim/nvim-lspconfig',
  event = 'VeryLazy',
  config = function()
    local lspconfig = require('lspconfig')

    vim.diagnostic.config({
      float = { border = 'single', focusable = false },
      signs = true,
      underline = true,
      update_in_insert = false, -- delay update diagnostics
      virtual_text = false -- do not show diagnostics message inline
    })

    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'single' })
    --vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'single' })

    vim.opt.updatetime = 300 -- set inactivity time to 300ms

    -- Enable language server
    lspconfig.eslint.setup({
      -- Format document on save
      on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          command = "EslintFixAll",
        })
      end,
    })
  end
}

