--- Comment.nvim with treesitter-aware commentstrings
local pack = require("fernando.pack")

vim.pack.add({
  pack.gh("JoosepAlviste/nvim-ts-context-commentstring"),
  pack.gh("numToStr/Comment.nvim"),
})

require("ts_context_commentstring").setup({
  enable_autocmd = false,
})

---@diagnostic disable-next-line: missing-fields
require("Comment").setup({
  pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})
