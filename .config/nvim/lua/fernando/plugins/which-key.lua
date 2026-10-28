--- Useful plugin to show you pending keybinds.
-- Loaded eagerly so it can observe every keymap defined afterwards.
local pack = require("fernando.pack")

vim.pack.add({ pack.gh("folke/which-key.nvim") })

require("which-key").setup({
  delay = 0,
  icons = {
    mappings = false,
  },
  spec = {
    { "<leader>r", group = "[R]eplace" },
    { "<leader>s", group = "[S]earch" },
    { "<leader>g", group = "[G]it" },
    { "<leader>t", group = "[T]oggle" },
    { "<leader>b", group = "[B]rowse" },
    { "<leader>k", group = "[K]ommands", mode = { "n", "v" } },
    { "<leader>h", group = "[H]unk", mode = { "n", "v" } },
    { "<leader>a", group = "[A]lternatives", mode = { "n", "v", "x" } },
    { "<leader>j", group = "[J]umps" },
    { "gr", group = "LSP Actions", mode = { "n" } },
  },
})
