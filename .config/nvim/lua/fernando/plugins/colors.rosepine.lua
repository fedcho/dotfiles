return {
  "rose-pine/neovim",
  name = "rose-pine",
  -- priority = 1000,
  -- lazy = false,
  config = function()
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
        -- TabLineFill = { bg = "overlay" },
        -- TabLineSel = { bg = "base", fg = "text" },
        -- TabLineHead = { bg = "foam", fg = "highlight_med" },
        -- TabLineSelMark = { fg = "muted" },
        NotificationInfo = { bg = "overlay", fg = "text" },
        -- Visual = { bg = "foam", blend = 30 },
      },
    })

    -- vim.cmd.colorscheme("rose-pine")
  end,
}

-- vim: ts=2 sts=2 sw=2 et
