return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    { "tpope/vim-dadbod", lazy = true },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
  },
  cmd = {
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_execute_on_save = false
    vim.g.db_ui_auto_execute_table_helpers = 1

    -- Custom Keymaps for SQL buffers
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "sql", "mysql", "plsql" },
      callback = function()
        vim.keymap.set({ "n", "v" }, "<leader>ks", "<Plug>(DBUI_ExecuteQuery)", { buffer = true, desc = "Execute Query" })
        vim.keymap.set({ "n", "v" }, "<leader>kw", "<Plug>(DBUI_SaveQuery)", { buffer = true, desc = "Save Query" })
      end,
    })
  end,
}
