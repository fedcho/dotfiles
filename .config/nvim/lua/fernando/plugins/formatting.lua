---@param bufnr integer The buffer handle
---@param formatters string[] A list (array) of formatter names to check
---@return string|nil The first available formatter, or the first in the list as fallback
local function pick_first_available(bufnr, formatters)
  local conform = require("conform")
  for _, formatter in ipairs(formatters) do
    if conform.get_formatter_info(formatter, bufnr).available then
      return formatter
    end
  end
  return formatters[1]
end

local function resolve(formatters, extras)
  return function(bufnr)
      return { pick_first_available(bufnr, formatters), table.unpack(extras) }
  end
end

local prettier_with_fallbacks = { "prettierd", "prettier", "oxfmt", stop_after_first = true }

local oxfmt_configs = {
  ".oxfmtrc.json",
  ".oxfmtrc.jsonc",
  "oxfmt.config.ts",
  "oxfmt.config.mts",
}

local function prefer_oxfmt(fallback)
  return function(bufnr)
    if vim.fs.root(bufnr, oxfmt_configs) then
      return { "oxfmt", "injected" }
    end
    return fallback(bufnr)
  end
end

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
      javascript = { "prettierd", "prettier", "oxfmt", stop_after_first = true },
      javascriptreact = { "prettierd", "prettier", "oxfmt", stop_after_first = true },
      typescript = prefer_oxfmt(resolve({ "prettierd", "prettier", "oxfmt" }, "injected")),
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
