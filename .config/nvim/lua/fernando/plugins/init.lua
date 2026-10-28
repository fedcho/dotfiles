--- `vim.pack` helpers and the `PackChanged` build-step hooks. 
---  Must be loaded before the plugin modules, which call `vim.pack.add`.
local pack = require("fernando.pack")

--- Plugins are loaded in an order that respects their dependencies
--- (vim.pack does not resolve them):
--- - colors first, so the colorscheme is set before any UI highlight lookups
--- - mini before telescope (its `mini.icons` mock replaces `nvim-web-devicons`)
--- - mini/tabby before tabline (tabline reads `MiniStatusLine*` highlights)
--- - completion (blink) before lsp (blink provides LSP capabilities)
--- - treesitter before comment (commentstring integration)
--- - ufo/harpoon/telescope load their own dependencies first

require("fernando.plugins.colors")

vim.pack.add({
  pack.gh("NMAC427/guess-indent.nvim"),
  pack.gh("mbbill/undotree"),
  pack.gh("tpope/vim-fugitive"),
  pack.gh("tpope/vim-rhubarb"),
})

require("guess-indent").setup({})

 require("fernando.plugins.mini")
 require("fernando.plugins.tabline")
 require("fernando.plugins.gitsigns")
 require("fernando.plugins.which-key")
 require("fernando.plugins.oil")
 require("fernando.plugins.ufo")
 require("fernando.plugins.treesitter")
 require("fernando.plugins.comment")
 require("fernando.plugins.completion")
 require("fernando.plugins.lsp")
 require("fernando.plugins.formatting")
 require("fernando.plugins.linting")
 require("fernando.plugins.telescope")
 require("fernando.plugins.harpoon")
 require("fernando.plugins.dadbod")
