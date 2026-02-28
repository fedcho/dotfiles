return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>kf",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = "",
      desc = "[F]ormat buffer",
    },
  },
  opts = {
    notify_on_error = true,
    format_on_save = false,
    formatters_by_ft = {
      lua = { "stylua" },
      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" },
      --
      -- You can use 'stop_after_first' to run the first available formatter from the list
      -- javascript = { "prettierd", "prettier", stop_after_first = true },
      javascript = { "oxfmt" },
      javascriptreact = { "oxfmt" },
      typescript = { "oxfmt", "injected" },
      typescriptreact = { "oxfmt" },
      json = { "oxfmt" },
      jsonc = { "oxfmt" },
      vue = { "oxfmt" },
      css = { "oxfmt" },
      html = { "oxfmt" },
      yaml = { "oxfmt" },
      markdown = { "oxfmt" },
      handlebars = { "oxfmt" },
      sh = { "shfmt" },
      sql = { "sqruff" },
    },
    formatters = {
      oxfmt = {
        args = function(_, ctx)
          local filename = ctx.filename
          if filename and filename:match("%.vil$") then
            filename = filename:gsub("%.vil$", ".json")
          end
          return { "--stdin-filepath", filename }
        end,
      },
    },
  },
}
