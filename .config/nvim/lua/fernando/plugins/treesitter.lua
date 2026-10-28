--- nvim-treesitter (main branch): syntax highlighting and indentation
local pack = require("fernando.pack")

vim.pack.add({ { src = pack.gh("nvim-treesitter/nvim-treesitter"), version = "main" } })

do
  -- Parsers installed upfront. Any other parser available in nvim-treesitter
  -- is installed on demand the first time a matching file is opened.
  local parsers = {
    "bash",
    "c",
    "diff",
    "html",
    "lua",
    "luadoc",
    "markdown",
    "markdown_inline",
    "query",
    "vim",
    "vimdoc",
    "sql",
    "git_rebase",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "yaml",
  }

  require("nvim-treesitter").install(parsers)

  --- Attach treesitter to a buffer
  ---@param buf integer
  ---@param language string
  local function treesitter_try_attach(buf, language)
    -- Check if the buffer is valid (might not be after install completes)
    if not vim.api.nvim_buf_is_valid(buf) then
      return
    end

    -- Check if a parser exists and load it
    if not vim.treesitter.language.add(language) then
      return
    end

    -- Enable syntax highlighting and other treesitter features
    vim.treesitter.start(buf, language)

    -- Enable treesitter based indentation when the language provides an
    -- indents query; otherwise the built-in indentexpr is kept
    local has_indent_query = vim.treesitter.query.get(language, "indents") ~= nil
    if has_indent_query then
      vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end

  local available_parsers = require("nvim-treesitter").get_available()
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      local buf, filetype = args.buf, args.match

      -- Resolve the treesitter language from the filetype, so special cases
      -- like typescriptreact -> tsx and sh -> bash are handled for us
      local language = vim.treesitter.language.get_lang(filetype)
      if not language then
        return
      end

      local installed_parsers = require("nvim-treesitter").get_installed("parsers")

      if vim.tbl_contains(installed_parsers, language) then
        -- Enable the parser if it is already installed
        treesitter_try_attach(buf, language)
      elseif vim.tbl_contains(available_parsers, language) then
        -- Auto-install the parser and attach once the installation is done
        require("nvim-treesitter").install(language):await(function()
          treesitter_try_attach(buf, language)
        end)
      else
        -- Try to attach in case the parser exists but is not available from nvim-treesitter
        treesitter_try_attach(buf, language)
      end
    end,
  })
end
