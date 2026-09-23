local unpack = table.unpack or unpack

local function pick_first_available(formatters)
  return function(bufnr)
    local conform = require("conform")
    for _, formatter in ipairs(formatters) do
      if conform.get_formatter_info(formatter, bufnr).available then
        return formatter
      end
    end
    return formatters[1]
  end
end

local prettier_configs = {
  ".prettierrc",
  ".prettierrc.json",
  ".prettierrc.yml",
  ".prettierrc.yaml",
  ".prettierrc.json5",
  ".prettierrc.js",
  ".prettierrc.cjs",
  ".prettierrc.mjs",
  ".prettierrc.toml",
  "prettier.config.js",
  "prettier.config.cjs",
  "prettier.config.mjs",
}

local configs = {
  oxfmt = {
    ".oxfmtrc.json",
    ".oxfmtrc.jsonc",
    "oxfmt.config.ts",
    "oxfmt.config.mts",
  },
  prettier = prettier_configs,
  prettierd = prettier_configs,
}

local function normalize(v)
  if v == nil then return {} end
  return type(v) == "string" and { v } or v
end

local function resolve(options)
  local prefer_configured = options.prefer_configured
  local always = normalize(options.always)
  local formatters = {}

  for _, fmt in ipairs(options) do
    if type(fmt) == "table" then
      for _, v in ipairs(fmt) do
        table.insert(formatters, v)
      end
    else
      table.insert(formatters, fmt)
    end
  end

  return function(bufnr)
    local list = {}
    local seen = {}

    if prefer_configured then
      for _, fmt in ipairs(formatters) do
        local cfg = configs[fmt]
        if cfg and vim.fs.root(bufnr, cfg) then
          table.insert(list, fmt)
          seen[fmt] = true
          break
        end
      end
    end

    for _, fmt in ipairs(formatters) do
      if not seen[fmt] then
        table.insert(list, fmt)
        seen[fmt] = true
      end
    end

    local best = pick_first_available(list)(bufnr)
    return { best, unpack(always) }
  end
end

local default_formatters = { "oxfmt", "prettierd", "prettier", stop_after_first = true }

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
      javascript = resolve({ default_formatters, prefer_configured = true, always = "injected" }),
      javascriptreact = resolve({ default_formatters, prefer_configured = true, always = "injected" }),
      typescript = resolve({ default_formatters, prefer_configured = true, always = "injected" }),
      typescriptreact = resolve({ default_formatters, prefer_configured = true, always = "injected" }),
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
