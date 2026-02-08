--- Set <space> as the leader key
--- NOTE: Must happen before plugins are required
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

--- Install `lazy.nvim` plugin manager
--  See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end

-- Add lazy to the `runtimepath`
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("fernando.options")
require("fernando.filetypes")
require("fernando.keymaps")
require("fernando.autocommands")

-- Setup lazy and load my plugins
require("lazy").setup({ { import = "fernando.plugins" } }, {
  change_detection = {
    notify = false,
  },
  ui = {
    border = "rounded",
  },
})
