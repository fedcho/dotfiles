---@param bufnr integer The buffer handle
---@param formatters string[] A list (array) of formatter names to check
---@return string|nil The first available formatter, or the first in the list as fallback
local function first(bufnr, formatters)
  local conform = require("conform")
  for _, formatter in ipairs(formatters) do
    if conform.get_formatter_info(formatter, bufnr).available then
      return formatter
    end
  end
  return formatters[1]
end

local function injected(formatters)
  return function(bufnr)
    if formatters.stop_after_first == true then
      return { first(bufnr, formatters), "injected" }
    else
      return { table.unpack(formatters), "injected" }
    end
  end
end

local default = { "prettierd", "prettier", "oxfmt", stop_after_first = true }

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
      javascript = default,
      javascriptreact = default,
      typescript = injected(default),
      typescriptreact = default,
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
