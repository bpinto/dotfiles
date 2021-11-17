local null_ls = require 'null-ls'
local lsp = vim.lsp

lsp.handlers['textDocument/publishDiagnostics'] = lsp.with(
  lsp.diagnostic.on_publish_diagnostics, {
    signs = true,
    underline = true,
    update_in_insert = false, -- delay update diagnostics
    virtual_text = false -- do not show diagnostics message inline
  }
)

lsp.handlers['textDocument/hover'] = lsp.with(lsp.handlers.hover, { border = 'single' })
lsp.handlers['textDocument/signatureHelp'] = lsp.with(lsp.handlers.signature_help, { border = 'single' })

vim.opt.updatetime = 300 -- set inactivity time to 300ms

null_ls.config({
  sources = {
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.formatting.fish_indent,
    null_ls.builtins.formatting.prettier_d_slim,
    null_ls.builtins.formatting.eslint_d
  }
})

local on_attach = function(client, bufnr)
  local function map(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  -- mappings options
  local opts = { noremap = true, silent = true }

  map('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev({ popup_opts = { border = "single" }})<CR>', opts)
  map('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next({ popup_opts = { border = "single" }})<CR>', opts)
  map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)

  if client.resolved_capabilities.document_formatting then
    map('n', '<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
  elseif client.resolved_capabilities.document_range_formatting then
    map('n', '<leader>=', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
  end

  -- Show line diagnostics after inactivity
  vim.cmd('autocmd CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics({ border = "single", focusable = false })')

  -- Show singature help after inactivity on insertion mode
  vim.cmd('autocmd CursorHoldI <buffer> silent! lua vim.lsp.buf.signature_help()')
end

lspconfig = require('lspconfig')
lspconfig['null-ls'].setup({
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  }
})
