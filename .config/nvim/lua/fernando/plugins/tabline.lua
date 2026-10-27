return {
  "nanozuki/tabby.nvim",
  config = function()
    local function get_hl(name, fallback)
      local hl = vim.api.nvim_get_hl(0, { name = name })
      local is_valid = next(hl) ~= nil
      return is_valid and name or fallback
    end

    local function merge_hl(hl_name_1, hl_name_2)
      local hl1 = vim.api.nvim_get_hl(0, { name = hl_name_1 })
      local hl2 = vim.api.nvim_get_hl(0, { name = hl_name_2 })
      return vim.tbl_extend("force", hl1, hl2)
    end

    local theme = {
      fill = "TabLineFill",
      head = get_hl("TabLineHead", get_hl("MiniStatusLineModeNormal", "StatusLine")),
      current_tab = "TabLineSel",
      tab = "TabLine",
      win = "TabLine",
      tail = "TabLine",
      mark = get_hl("TabLineSelMark", "Comment"),
    }

    require("tabby").setup({
      line = function(line)
        return {
          {
            { "  ", hl = theme.head },
            line.sep("", theme.head, theme.fill),
            { " ", hl = theme.fill },
          },
          line.tabs().foreach(function(tab)
            local hl = tab.is_current() and theme.current_tab or theme.tab
            local pad = {
              tab.is_current() and "::" or " ",
              hl = merge_hl(hl, theme.mark),
            }
            return { pad, tab.name(), pad, hl = hl }
          end),
          line.spacer(),
          hl = theme.fill,
        }
      end,
    })
  end,
}
