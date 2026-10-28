# vim.pack Migration Plan

Status: **done (Oct 28, 2026)** — migrated on branch `nvim-vim-pack-migration`,
with the deviations below. This document is kept as the record of the plan
plus the migration outcome.

## Outcome (Oct 28, 2026)

- **All plugins are eager** (per the plan decision): every plugin is
  `vim.pack.add`ed at startup — no lazy-loading emulation was kept.
- **`diffview.nvim` dropped** from the plan (it was not in the config anyway).
- New `lua/fernando/pack.lua` holds `gh()`, `run_build()` and the
  `PackChanged` build-step dispatch (fzf-native `make`, LuaSnip
  `make install_jsregexp`, nvim-treesitter `TSUpdate`), matching upstream
  kickstart, including the `ev.data.active`/`:packadd` nuance for treesitter.
- `init.lua` requires plugin modules in dependency order via a list loop
  (see the comment there); `plugins/init.lua` is now the guess-indent /
  undotree / fugitive / rhubarb module.
- Startup time: ~100 ms before (lazy.nvim) → ~107 ms after, well within the
  10% acceptance target.
- Lockfile correction vs the plan: the plan expected
  `stdpath("data")/site/pack/core/pack.lock`, but Neovim 0.12.6 writes the
  lock to `stdpath("config")/nvim-pack-lock.json` (config-local). It is
  committed to the repo, which upstream's docs actually recommend for
  reproducibility across machines.
- Gotcha found and fixed during the migration, worth remembering for future
  kickstart syncs: **`vim.pack.add` during `init.lua` activates plugins with
  `:packadd!`, which does NOT source `plugin/` files** (they are sourced in
  the normal plugin-loading phase right after init.lua). tabby.nvim's
  `setup()` sets the 'tabline' option *synchronously* (its
  `nvim_get_vvar('vim_did_enter')` check is a bug in Lua — the API returns the
  number 0, which is truthy) to `%!TabbyRenderTabline()`, whose function lives
  in tabby's `plugin/tabby.vim` → E117 on the first redraw. `tabline.lua`
  therefore runs a non-bang `:packadd tabby.nvim` before `setup()`. Any plugin
  whose `setup()` depends on its `plugin/` scripts during startup needs the
  same treatment.

This document is the plan that was followed to migrate to the built-in
`vim.pack` plugin manager, matching kickstart.nvim's April 2026 migration.
## Why / when

- **Why:** one less external dependency (no lazy.nvim bootstrap), follows
  upstream kickstart, lockfile and update flow built into Neovim.
- **When:** after kickstart has been on `vim.pack` long enough that new upstream
  changes are written `vim.pack`-first (already the case), and when you are
  willing to spend a focused session on the rewrite plus plugin-load testing.
- **Prerequisite:** Neovim >= 0.12 (currently 0.12.6 — OK).

## What changes conceptually

| lazy.nvim | vim.pack |
| --- | --- |
| `require("lazy").setup({ { import = "fernando.plugins" } })` | explicit `vim.pack.add { ... }` + `require(...).setup()` in `init.lua` or required modules |
| `lazy = false` | implicit: plugins added at startup are active |
| `event`, `cmd`, `keys`, `ft` | **not provided** — emulate with autocommands / keymap wrappers / user commands that call `vim.pack.add` then `require` |
| `dependencies` | **not resolved** — call `vim.pack.add` in the right order |
| `opts = {}` calls `.setup(opts)` | call `require("plugin").setup(opts)` explicitly |
| `build = ":TSUpdate"` | `PackChanged` autocommand + `vim.cmd "TSUpdate"` |
| `cond`, `enabled` | `if` statements in Lua |
| `lazy-lock.json` | `site/pack/core/pack.lock`, written by `vim.pack.update()` |
| `:Lazy` UI | `vim.pack.update(nil, { offline = true })` (status), `vim.pack.update()` (update) |
| lazy plugin dir: `stdpath("data")/lazy` | `stdpath("data")/site/pack/core/opt` |

Plugins live under `opt/` and are activated with `:packadd`. `vim.pack.add`
installs (if missing) and activates immediately, so "lazy loading" = calling
`vim.pack.add` later, from the trigger.

## Current plugin inventory and triggers

| file | plugins | current trigger | migration note |
| --- | --- | --- | --- |
| `init.lua` | bootstrap | lazy.nvim | replace with `vim.loader.enable()` + `vim.pack` helpers |
| `plugins/init.lua` | vim-sleuth, fugitive, rhubarb, surround, undotree | startup | simple `vim.pack.add` at startup |
| `plugins/colors.lua` | colorscheme(s) | `lazy = false` | startup, load colorscheme after `add` |
| `plugins/lsp.lua` | nvim-lspconfig, mason, mason-lspconfig, mason-tool-installer, fidget, blink dep | eager | startup block; keep `vim.lsp.config`/`enable` code |
| `plugins/completion.lua` | blink.cmp, LuaSnip, friendly-snippets | `VimEnter` | add at startup (lazy loading adds little for a completion engine) |
| `plugins/treesitter.lua` | nvim-treesitter (branch `main`) | `lazy = false` | startup + `PackChanged` hook for `:TSUpdate` |
| `plugins/formatting.lua` | conform.nvim | `BufWritePre`, `cmd = ConformInfo`, `<leader>kf` | startup (cheap), keep keymap |
| `plugins/linting.lua` | nvim-lint | `BufReadPre`/`BufNewFile` | `BufReadPre` autocmd → `vim.pack.add` + `require("lint").try_lint` |
| `plugins/telescope.lua` | telescope, plenary, fzf-native (build `make`), ui-select, advanced-git-search | `VimEnter` | startup or first `<leader>s*` keymap; fzf-native needs `make` in `PackChanged` |
| `plugins/gitsigns.lua` | gitsigns | startup | startup |
| `plugins/which-key.lua` | which-key | `VimEnter` | startup (needs to observe keymaps) |
| `plugins/mini.lua` | mini.nvim (ai, icons, statusline) | startup | startup; `MiniIcons.mock_nvim_web_devicons()` after `add` |
| `plugins/tabline.lua` | tabby | startup | startup |
| `plugins/oil.lua` | oil | startup (opts) | startup, keep `-` keymap |
| `plugins/ufo.lua` | nvim-ufo + promise-async | startup | `add` both in order |
| `plugins/dadbod.lua` | vim-dadbod, dadbod-ui, completion | `cmd` + `ft` | `cmd` user command + `FileType sql` wrapper |
| `plugins/harpoon.lua` | harpoon + plenary | startup | startup, plenary `add` first |
| `plugins/comment.lua` | mini.comment config / comment plugin | startup (with `enable_autocmd = false`) | startup |
| `custom/`, `snippets/` | Lua modules | required by plugins | no change |

Re-audit triggers at migration time (`grep -n "event\\|cmd\\|keys\\|ft\\|lazy"`),
since the list above can drift.

## Migration steps

### 0. Branch and baseline

```sh
git switch -c nvim-vim-pack-migration
nvim --startuptime /tmp/startup_before.log +qa   # baseline (run twice, take second)
```

### 1. Add a `vim.pack` helper module

Create `lua/fernando/pack.lua` with:

- `gh(repo)` → `"https://github.com/" .. repo`
- `add(specs)` wrapper for `vim.pack.add`
- `build(name, cmd, cwd)` helper that reports failures with `vim.notify`
- a `PackChanged` autocommand dispatching build steps (telescope-fzf-native
  `make`, LuaSnip `make install_jsregexp`, nvim-treesitter `TSUpdate`)

This mirrors upstream's `run_build`/`PackChanged` block.

### 2. Rewrite `init.lua`

```lua
vim.loader.enable()
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

require("fernando.pack")         -- vim.pack helpers + PackChanged
require("fernando.options")
require("fernando.filetypes")
require("fernando.keymaps")
require("fernando.autocommands")
require("fernando.plugins")      -- returns a list of module names to require
```

`fernando.plugins` is today a lazy.nvim import root. Replace it with a loader
that requires each module explicitly (order matters — see inventory), e.g.:

```lua
for _, mod in ipairs({ "colors", "mini", "icons_or_mini", "tabline", ... }) do
  require("fernando.plugins." .. mod)
end
```

Each plugin file must stop returning a lazy spec and instead perform
`vim.pack.add` + `setup` at require time (or expose an `M.load()` called from
the trigger).

### 3. Convert files in dependency order

1. plugins with no dependencies: `mini`, `colors`, `tabline`, `gitsigns`,
   `which-key`, `oil`, `comment`, `ufo` (ufo needs promise-async first), `diffview`
2. `treesitter` (top-level and independent)
3. `lsp` (mason must be set up before `mason-tool-installer`)
4. `completion` (blink + LuaSnip + friendly-snippets)
5. `telescope` (plenary → telescope → extensions)
6. `formatting`, `linting`
7. `dadbod`, `harpoon`

For lazy-loading emulation keep it only where startup cost is measurable:

```lua
-- command-based
vim.api.nvim_create_user_command("DiffviewOpen", function()
  vim.pack.add({ "https://github.com/sindrets/diffview.nvim" })
  require("diffview").open()
end, { nargs = "*" })
```

```lua
-- filetype-based
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sql", "mysql", "plsql" },
  once = true,
  callback = function()
    vim.pack.add({ "..." })
    require("...").setup()
  end,
})
```

```lua
-- keymap-based (telescope)
vim.keymap.set("n", "<leader>sf", function()
  vim.pack.add(telescope_specs)
  require("telescope.builtin").find_files()
end)
```

### 4. Update paths and references

- `<leader>sp` (search plugin files) must point to
  `vim.fs.joinpath(vim.fn.stdpath("data"), "site", "pack", "core", "opt")`
  instead of `stdpath("data")/lazy`.
- Remove `lua/fernando/plugins/init.lua`'s lazy import role.
- Delete `lazy-lock.json` from the repo; the new lock lives at
  `stdpath("data")/site/pack/core/pack.lock` (machine-local).
- Search for other `lazy` references: `grep -rn "lazy" .config/nvim`.
- Keep `vim.pack.add` argument API in one place: `version = "main"` for branch
  tracking (treesitter), `vim.version.range("1.*")` for tagged plugins
  (blink, LuaSnip).

### 5. Validate behavior

- `nvim --headless -c 'lua print("ok")' -c qa` — no errors.
- `nvim --startuptime /tmp/startup_after.log +qa` — compare with baseline;
  expect parity or improvement (loader cache).
- Treesitter attaches, parsers auto-install.
- LSP: `lua_ls`, `stylua`, `ts_ls`, `cssls`, `tailwindcss`, `elixirls` attach
  on their filetypes; `<leader>kf` formats Lua through stylua LSP.
- blink completion, snippets, signature help work.
- `<leader>sf`, `<leader>sn`, `<leader>sg` telescopes work.
- gitsigns hunk keymaps, oil `-`, harpoon marks, dadbod SQL completion.
- `vim.pack.update(nil, { offline = true })` lists installed plugins cleanly.

### 6. Rollback

The migration is confined to `.config/nvim`; `git switch -` (or delete the
branch/worktree) restores lazy.nvim. Nothing outside the config directory
changes, except the machine-local `site/pack` tree, which can be removed with
`vim.pack.del` or by deleting `stdpath("data")/site/pack/core`.

## Risks

- **Startup regression** if everything is `add`ed eagerly; measure with
  `--startuptime` and only lazy-load where it matters.
- **Missing dependency ordering** — no resolver; wrong order means plugins
  load before their dependencies exist.
- **No per-plugin `cond`/`enabled`** — the `fzf-native` "only if `make` exists"
  logic becomes an `if vim.fn.executable("make") == 1` at `add` time; removing
  it later requires manual `vim.pack.del`.
- **No lockfile in git** — reproducibility relies on version ranges/branches;
  document the expected branch/tag per plugin.
- **Upstream drift**: kickstart's `init.lua` is the reference implementation;
  keep following `KICKSTART_SYNC.md` after migrating.

## Acceptance criteria

- No lazy.nvim code left (`grep -rn "lazy" .config/nvim` only matches comments).
- All keymaps from the inventory work on a fresh Neovim.
- Startup time within ~10% of the current baseline.
- `KICKSTART_SYNC.md` deviations log updated (drop the lazy.nvim deviation).
