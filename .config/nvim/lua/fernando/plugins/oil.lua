return {
  "stevearc/oil.nvim",
  opts = {},
  config = function()
    require("oil").setup({
      default_file_explorer = false,
      keymaps = {
        ["<C-c>"] = false, -- actions.close
        ["<C-h>"] = false, -- actions.select_split
        ["<C-l>"] = false, -- actions.refresh
        ["gq"] = "actions.close",
        ["gr"] = "actions.refresh",
      },
      view_options = {
        show_hidden = true,
      },
      skip_confirm_for_simple_edits = true,
    })

    -- Open parent directory in current window
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  end,
}
