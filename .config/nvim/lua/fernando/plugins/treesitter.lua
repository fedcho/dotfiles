return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  branch = "main",
  config = function()
    local filetypes = {
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
      "elixir",
      "heex",
      "git_rebase",
      "css",
      "javascript",
      "typescript",
      "tsx",
    }

    require("nvim-treesitter").install(filetypes)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = filetypes,
      callback = function()
        vim.treesitter.start()
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "typescriptreact",
      callback = function(args)
        vim.treesitter.start(args.buf, "tsx")
      end,
    })
  end,
}

-- vim: ts=2 sts=2 sw=2 et
