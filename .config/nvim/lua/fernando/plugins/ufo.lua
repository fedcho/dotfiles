--- nvim-ufo: folding with LSP and treesitter fold providers
local pack = require("fernando.pack")

-- `promise-async` is ufo's unresolved dependency; add it first.
vim.pack.add({
  pack.gh("kevinhwang91/promise-async"),
  pack.gh("kevinhwang91/nvim-ufo"),
})

vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
vim.keymap.set("n", "zm", require("ufo").closeFoldsWith)

vim.keymap.set("n", "K", function()
  local winid = require("ufo").peekFoldedLinesUnderCursor()
  if not winid then
    vim.lsp.buf.hover()
  end
end)

require("ufo").setup()
