return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    -- stylua: ignore start
    vim.keymap.set("n", "<leader>ka", function() harpoon:list():add() end, { desc = "Harpoon: [A]dd" })
    vim.keymap.set("n", "<leader>ke", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc= "Harpoon: [E]xplore" })

    vim.keymap.set("n", "<M-7>", function() harpoon:list():select(1) end, { desc = "Harpoon: file 1" })
    vim.keymap.set("n", "<M-8>", function() harpoon:list():select(2) end, { desc = "Harpoon: file 2" })
    vim.keymap.set("n", "<M-9>", function() harpoon:list():select(3) end, { desc = "Harpoon: file 3" })
    vim.keymap.set("n", "<M-0>", function() harpoon:list():select(4) end, { desc = "Harpoon: file 4" })

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set("n", "<C-p>", function() harpoon:list():prev({ ui_nav_wrap = true }) end, { desc = "Harpoon: [P]revious" })
    vim.keymap.set("n", "<C-n>", function() harpoon:list():next({ ui_nav_wrap = true }) end, { desc = "Harpoon: [N]ext" })
    -- stylua: ignore end
  end,
}
