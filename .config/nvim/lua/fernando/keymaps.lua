-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostics
vim.keymap.set("n", "<leader>d", vim.diagnostic.setloclist, { desc = "[D]iagnostics" })

-- Split window management
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Control the size of splits (height/width)
vim.keymap.set("n", "<C-w>,", "<C-w>10<", { desc = "Decrease width 10x" })
vim.keymap.set("n", "<C-w>.", "<C-w>10>", { desc = "Increase width 10x" })
vim.keymap.set("n", "<C-w>-", "<C-w>5-")
vim.keymap.set("n", "<C-w>+", "<C-w>5+")

-- Keep the cursor in the middle when jumping vertically
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Move selected lines up and down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- Move selected lines down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv") -- Move selected lines up

-- Increase numbers
vim.keymap.set({ "n", "v" }, "<C-=>", "<C-a>")
vim.keymap.set({ "n", "v" }, "<C-_>", "<C-x>")
vim.keymap.set("x", "g<C-=>", "g<C-a>") -- V-Block multiline increment. :help v_g_CTRL-A
vim.keymap.set("x", "g<C-_>", "g<C-x>") -- V-Block multiline decrement. :help v_g_CTRL-X

-- Alternative delete/replace: avoid registers
vim.keymap.set({ "n", "v" }, "<leader>ad", '"_d', { desc = "Delete to void" })
vim.keymap.set("x", "<leader>ap", [["_dP]], { desc = "Paste to void" })

-- Replace all of the word-under-cursor occurrences
local cmd = [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]
vim.keymap.set("n", "<leader>rw", cmd, { desc = "[R]eplace [W]ord under cursor..." })

-- Git keymaps
vim.keymap.set("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git [S]tatus" })
vim.keymap.set("n", "<leader>gp", "<cmd>Git push<CR>", { desc = "Git [P]ush" })
vim.keymap.set("n", "<leader>ga", "<cmd>Gwrite<CR>", { desc = "Git [A]dd" })
vim.keymap.set("n", "<leader>gr", "<cmd>Gread<CR>", { desc = "Git [R]eload" })
vim.keymap.set("n", "<leader>gl", "<cmd>Git log --oneline %<CR>", { desc = "Git [L]og" })
vim.keymap.set("n", "<leader>gc", "<cmd>Git commit<CR>", { desc = "Git [C]ommit" })

vim.keymap.set("n", "<leader>gq", function()
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
vim.keymap.set("n", "<leader>bf", vim.cmd.GBrowse, { desc = "[B]rowse [F]ile" })
vim.keymap.set("n", "<leader>br", "<cmd>!gh repo view -w<CR><ESC>", { desc = "[B]rowse [R]epo", silent = true })
vim.keymap.set("n", "<leader>bp", "<cmd>!gh pr view -w<CR>", { desc = "[B]rowse [P]ull request", silent = true })

-- Komands keymaps
vim.keymap.set("n", "<leader>kq", "<cmd>noautocmd wqa!<CR>", { desc = "[Q]uit" })
vim.keymap.set("n", "<leader>kw", "<cmd>noautocmd w<CR>", { desc = "[W]rite to disk" })
vim.keymap.set("n", "<leader>kr", "<cmd>edit! %<CR>", { desc = "[R]eload file" })
vim.keymap.set("n", "<leader>ku", vim.cmd.UndotreeToggle, { desc = "[U]ndo tree" })
vim.keymap.set("n", "<leader>kd", vim.cmd.DBUIToggle, { desc = "[D]BUI toggle" })
vim.keymap.set("n", "<leader>kx", "<cmd>source %<CR>", { desc = "Source file" })
vim.keymap.set("v", "<leader>kx", ":lua<CR>", { desc = "Lua: Execute selected" })
vim.keymap.set("n", "<leader>ks", "<cmd>mksession! session.vim<CR>", { desc = "[S]ave session" })
vim.keymap.set("n", "<leader>ky", function()
  local text = vim.fn.expand("%:.") .. ":" .. vim.fn.line(".")
  vim.fn.setreg("+", text)
  vim.fn.setreg('"', text)
  vim.notify('"' .. text .. '" ' .. "copied")
end, { desc = "[Y]ank file position" })
vim.keymap.set("n", "<leader>kR", "<cmd>restart<CR>", { desc = "Restart" })

-- Text edit hacks
vim.keymap.set("i", "<C-l>", "<CR><ESC>O", { desc = "Begin two new lines after the cursor and insert at first" })

-- Disable annoying legacy navigation
vim.keymap.set("n", "Q", "<nop>")

-- vim: ts=2 sts=2 sw=2 et
