return {
  {
    'ervandew/supertab',
    event = "InsertEnter",
    init = function()
      -- Navigate the completion menu from top to bottom
      vim.g.SuperTabDefaultCompletionType = '<c-n>'
    end,
  }
}
