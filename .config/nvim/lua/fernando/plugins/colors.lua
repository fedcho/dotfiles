--- Colorschemes. `melange` is the active theme; the others are installed and
--- set up so `<leader>st` (theme search) can switch to them at any time.
local pack = require("fernando.pack")

vim.pack.add({
  pack.gh("savq/melange-nvim"),
  pack.gh("Aejkatappaja/sora"),
  pack.gh("vimcolorschemes/olive-crt.nvim"),
  -- `name` keeps the data directory tidy even though the repo is `neovim`
  { src = pack.gh("rose-pine/neovim"), name = "rose-pine" },
})

require("sora").setup({})

require("rose-pine").setup({
  variant = "auto", -- auto, main, moon, or dawn
  extend_background_behind_borders = true,
  styles = {
    bold = true,
    italic = false,
    transparency = false,
  },
  highlight_groups = {
    -- CursorLine = { bg = "none" },
    CursorLineNr = { fg = "gold" },
    -- Identifier = { fg = "pine" },
    ["@module.elixir"] = { fg = "foam" },
    ["@string.special.symbol.elixir"] = { fg = "iris" },
    ["@constant.elixir"] = { fg = "text" },
    Comment = { italic = true },
    -- TabLine = { bg = "overlay" },
    -- TabLineFill = { bg = "overlay", fg = "text" },
    -- TabLineHead = { fg = "highlight_med" },
    -- TabLineSel = { bg = "base", fg = "text" },
    -- TabLineSelMark = { fg = "muted" },
    NotificationInfo = { bg = "overlay", fg = "text" },
    -- Visual = { fg = "text", blend = 30 },
  },
})

