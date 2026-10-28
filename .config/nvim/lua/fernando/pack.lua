--- Helpers for the built-in `vim.pack` plugin manager.
-- Mirrors the build-hook pattern from kickstart.nvim's `vim.pack` migration.
-- See `:help vim.pack`, `:help vim.pack-examples` and
-- https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack

local M = {}

--- Build the URL of a GitHub-hosted plugin.
-- Most plugins are hosted on GitHub, so this reduces repetition in the
-- plugin modules.
---@param repo string `owner/plugin_name`
---@return string
function M.gh(repo)
  return "https://github.com/" .. repo
end

--- Run a build command for a plugin, reporting failures with a notification.
---@param name string Plugin name, used in the error message
---@param cmd string[] The command to run
---@param cwd string Directory to run the command in
function M.run_build(name, cmd, cwd)
  local result = vim.system(cmd, { cwd = cwd }):wait()
  if result.code ~= 0 then
    local stderr = result.stderr or ""
    local stdout = result.stdout or ""
    local output = stderr ~= "" and stderr or stdout
    if output == "" then output = "No output from build command." end
    vim.notify(("Build failed for %s:\n%s"):format(name, output), vim.log.levels.ERROR)
  end
end

-- Post-install/update build steps, dispatched on `PackChanged` below.
-- Each entry receives the event data (see `:help vim.pack-events`).
local build_steps = {
  ["telescope-fzf-native.nvim"] = function(data)
    if vim.fn.executable("make") == 1 then
      M.run_build("telescope-fzf-native.nvim", { "make" }, data.path)
    end
  end,

  -- LuaSnip: optional jsregexp regex support outside of Windows.
  ["LuaSnip"] = function(data)
    if vim.fn.has("win32") ~= 1 and vim.fn.executable("make") == 1 then
      M.run_build("LuaSnip", { "make", "install_jsregexp" }, data.path)
    end
  end,

  -- nvim-treesitter: update parsers/queries after install or update.
  ["nvim-treesitter"] = function(data)
    -- During install/update the plugin may not be on the runtimepath yet.
    if not data.active then vim.cmd.packadd("nvim-treesitter") end
    vim.cmd("TSUpdate")
  end,
}

vim.api.nvim_create_autocmd("PackChanged", {
  desc = "Run plugin build steps after install or update",
  callback = function(ev)
    local kind = ev.data.kind
    if kind ~= "install" and kind ~= "update" then return end

    local step = build_steps[ev.data.spec.name]
    if step then step(ev.data) end
  end,
})

return M

-- vim: ts=2 sts=2 sw=2 et
