return {
  "nvim-mini/mini.nvim",
  config = function()
    -- If a nerd font is available, load the icons module for pretty icons in various plugins.
    if vim.g.have_nerd_font then
      require("mini.icons").setup({
        extension = {
          log = { glyph = "󰯂", hl = "MiniIconsGrey" },
        },
        file = {
          [".env"] = { glyph = "󰒓", hl = "MiniIconsYellow" },
          [".env.local"] = { glyph = "󰒓", hl = "MiniIconsYellow" },
        },
      })
      -- Used for backwards compatibility with plugins that require `nvim-web-devicons` (e.g. telescope.nvim)
      MiniIcons.mock_nvim_web_devicons()
    end

    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yiNq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require("mini.ai").setup({
      -- NOTE: Avoid conflicts with the built-in incremental selection mappings
      -- on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
      mappings = {
        around_next = "aN",
        inside_next = "iN",
        around_last = "aL",
        inside_last = "iL",
      },
      n_lines = 500,
    })

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require("mini.surround").setup()

    local statusline = require("mini.statusline")
    statusline.setup({ use_icons = vim.g.have_nerd_font })

    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return "%2l:%-2v"
    end

    local orig_sm = statusline.section_mode

    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_mode = function(args)
      local mode, mode_hl = orig_sm(args)
      return string.upper(mode), mode_hl
    end
  end,
}
