local set = vim.keymap.set

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostics
set("n", "<leader>d", vim.diagnostic.setloclist, { desc = "[D]iagnostics" })

-- Split window management
-- Disabled in favor of Harpoon. Testing the change.
-- set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
-- set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
-- set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
-- set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Control the size of splits (height/width)
set("n", "<M-,>", "<c-w>5<")
set("n", "<M-.>", "<c-w>5>")

-- Keep the cursor in the middle when jumping vertically
set("n", "<C-d>", "<C-d>zz")
set("n", "<C-u>", "<C-u>zz")
set("n", "n", "nzzzv")
set("n", "N", "Nzzzv")

-- Move selected lines up and down in visual mode
set("v", "J", ":m '>+1<CR>gv=gv") -- Move selected lines down
set("v", "K", ":m '<-2<CR>gv=gv") -- Move selected lines up

-- Increase numbers
-- default <C-a> conflicts with Tmux prefix
set({ "n", "v" }, "+", "<C-a>")
set("x", "g+", "g<C-a>") -- V-Block multiline increment. :help v_g_CTRL-A

-- Alternative delete/replace: avoid registers
set({ "n", "v" }, "<leader>ad", '"_d', { desc = "Delete to void" })
set("x", "<leader>ap", [["_dP]], { desc = "Paste to void" }) -- Paste to void register

-- Replace all of the word-under-cursor occurrences
local cmd = [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]
set("n", "<leader>rw", cmd, { desc = "[R]eplace [W]ord under cursor..." })

-- Toggle keymaps
set("n", "<leader>tc", function()
  vim.g.copilot_enabled = not vim.g.copilot_enabled
  require("cmp").setup({ enabled = not vim.g.copilot_enabled })
end, { desc = "[T]oggle [C]ompletions" })

-- Git keymaps
set("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git [S]tatus" })
set("n", "<leader>gp", "<cmd>Git push<CR>", { desc = "Git [P]ush" })
set("n", "<leader>ga", "<cmd>Gwrite<CR>", { desc = "Git [A]dd" })
set("n", "<leader>gr", "<cmd>Gread<CR>", { desc = "Git [R]eload" })
set("n", "<leader>gl", "<cmd>Git log --oneline %<CR>", { desc = "Git [L]og" })
set("n", "<leader>gc", "<cmd>Git commit<CR>", { desc = "Git [C]ommit" })

set("n", "<leader>gq", function()
  local winids = vim.api.nvim_list_wins()
  for _, id in pairs(winids) do
    local status = pcall(vim.api.nvim_win_get_var, id, "fugitive_status")
    if status then
      vim.api.nvim_win_close(id, false)
      return
    end
  end
end, { desc = "Git [Q]uit" })

-- Browse/View
set("n", "<leader>vf", vim.cmd.GBrowse, { desc = "[V]iew [F]ile" })
set("n", "<leader>vr", "<cmd>!gh repo view -w<CR><ESC>", { desc = "[V]iew [R]epo", silent = true })
set("n", "<leader>vp", "<cmd>!gh pr view -w<CR>", { desc = "[V]iew [P]ull request", silent = true })

-- Komands keymaps
set("n", "<leader>kq", "<cmd>noautocmd wqa!<CR>", { desc = "[Q]uit" })
set("n", "<leader>kw", "<cmd>noautocmd w<CR>", { desc = "[W]rite to disk" })
set("n", "<leader>kr", "<cmd>edit! %<CR>", { desc = "[R]eload file" })
set("n", "<leader>ku", vim.cmd.UndotreeToggle, { desc = "[U]ndo tree" })
set("n", "<leader>kd", vim.cmd.DBUIToggle, { desc = "DBU[I]" })
set("n", "<leader>kx", "<cmd>source %<CR>", { desc = "Source file" })
set("n", "<leader>ks", "<cmd>mksession! session.vim<CR>", { desc = "[S]ave session" })

-- Disable annoying legacy navigation
vim.keymap.set("n", "Q", "<nop>")

-- vim: ts=2 sts=2 sw=2 et
