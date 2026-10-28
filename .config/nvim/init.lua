-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

--- Set <space> as the leader key
--- NOTE: Must happen before plugins are required
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

require("fernando.options")
require("fernando.filetypes")
require("fernando.keymaps")
require("fernando.autocommands")
require("fernando.plugins")

vim.cmd.colorscheme("melange")

-- vim: ts=2 sts=2 sw=2 et
