local pack = require("fernando.pack")

vim.pack.add({
  pack.gh("savq/melange-nvim"),
  pack.gh("Aejkatappaja/sora"),
  pack.gh("Aejkatappaja/cendre"),
  pack.gh("vimcolorschemes/olive-crt.nvim"),
  { src = pack.gh("rose-pine/neovim"), name = "rose-pine" },
  pack.gh("RazikSF/lumina-themes"),
  pack.gh("ntk148v/lauds"),
  pack.gh("jonestristand/dune.nvim"),
})

vim.g.lumina_flavor = "quartz"

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

vim.keymap.set("n", "<leader>td", function() 
  if vim.o.background == "dark" then 
    vim.o.background = "light"
    return
  end

  vim.o.background = "dark"
end, { desc = "[T]oggle [D]ark/light background" })
