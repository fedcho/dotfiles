--- harpoon2: quick buffer navigation
local pack = require("fernando.pack")

vim.pack.add({
  pack.gh("nvim-lua/plenary.nvim"), -- harpoon's dependency, added first
  { src = pack.gh("ThePrimeagen/harpoon"), version = "harpoon2" },
})

local harpoon = require("harpoon")
harpoon:setup()

-- stylua: ignore start
vim.keymap.set("n", "<leader>ka", function() harpoon:list():add() end, { desc = "Harpoon: [A]dd" })
vim.keymap.set("n", "<leader>ke", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc= "Harpoon: [E]xplore" })

vim.keymap.set("n", "<leader>ja", function() harpoon:list():select(1) end, { desc = "Harpoon: file 1" })
vim.keymap.set("n", "<leader>js", function() harpoon:list():select(2) end, { desc = "Harpoon: file 2" })
vim.keymap.set("n", "<leader>jd", function() harpoon:list():select(3) end, { desc = "Harpoon: file 3" })
vim.keymap.set("n", "<leader>jf", function() harpoon:list():select(4) end, { desc = "Harpoon: file 4" })
vim.keymap.set("n", "<leader>jg", function() harpoon:list():select(5) end, { desc = "Harpoon: file 5" })

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-p>", function() harpoon:list():prev({ ui_nav_wrap = true }) end, { desc = "Harpoon: [P]revious" })
vim.keymap.set("n", "<C-n>", function() harpoon:list():next({ ui_nav_wrap = true }) end, { desc = "Harpoon: [N]ext" })
-- stylua: ignore end
