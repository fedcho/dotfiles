# Kickstart.nvim Sync Guide

Instructions for an agent (or future you) performing the periodic sync of
[kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) changes into this
modular configuration.

Upstream kickstart ships a **single `init.lua`**. This config splits it into
modules, so every sync is a translation task, not a merge. Do not copy files
wholesale, and do not introduce lazy.nvim features kickstart no longer uses.

## Prerequisites

- `nvim --version` is >= 0.12 (kickstart HEAD targets 0.12+).
- Network access to `api.github.com` and `raw.githubusercontent.com`.
- Clean working tree: `git status` in the dotfiles repo.
- Read `VIM_PACK_MIGRATION.md` first: upstream migrated to `vim.pack` in
  April 2026. As long as this repo stays on lazy.nvim, upstream changes that
  are purely about `vim.pack` must be **skipped, not ported**.

## Step 1 — Find the last sync

```sh
git log --oneline --grep="kickstart sync" -- .config/nvim | head -5
```

The latest such commit tells you the cutoff date. Use its date, not today's.

## Step 2 — List upstream commits since then

```sh
curl -s "https://api.github.com/repos/nvim-lua/kickstart.nvim/commits?since=<YYYY-MM-DDT00:00:00Z>&per_page=100" \
  | jq -r '.[] | "\(.commit.author.date[:10])  \(.commit.message | split("\n")[0])  [\(.sha[:10])]"'
```

If there are more than 100 commits, page with `&page=2` and merge results.
Merge commits named `Merge pull request ...` can usually be ignored — the
underlying commit carries the actual change.

## Step 3 — Read the relevant upstream diffs

For each candidate commit:

```sh
curl -s "https://api.github.com/repos/nvim-lua/kickstart.nvim/commits/<sha>" \
  | jq -r '.commit.message, (.files[] | "=== \(.filename) ===", (.patch // ""))'
```

Kickstart also ships helper files (`lua/kickstart/plugins/*.lua`). Check those
only if the change touches a feature this config actually uses (lint, neo-tree,
debug, etc. are *not* used here).

Fetching the whole current `init.lua` is useful for context:

```sh
curl -s https://raw.githubusercontent.com/nvim-lua/kickstart.nvim/master/init.lua
```

## Step 4 — Map upstream sections to local files

| kickstart section | local file |
| --- | --- |
| 1. options | `lua/fernando/options.lua` |
| 2. keymaps & autocommands | `lua/fernando/keymaps.lua`, `lua/fernando/autocommands.lua` |
| 3. plugin manager intro / build hooks | `init.lua` (lazy.nvim bootstrap) |
| 4. UI / core UX (gitsigns, which-key, colorscheme, mini) | `lua/fernando/plugins/{gitsigns,which-key,colors,mini}.lua` |
| 5. search & navigation (telescope) | `lua/fernando/plugins/telescope.lua` |
| 6. LSP | `lua/fernando/plugins/lsp.lua` |
| 7. formatting (conform) | `lua/fernando/plugins/formatting.lua` |
| 8. autocomplete & snippets (blink, LuaSnip) | `lua/fernando/plugins/completion.lua` |
| 9. treesitter | `lua/fernando/plugins/treesitter.lua` |
| 10. optional examples | not used (see `lua/fernando/plugins/` for equivalents) |

Other local files with no direct kickstart counterpart: `dadbod.lua`,
`diffview.lua`, `harpoon.lua`, `linting.lua`, `oil.lua`, `tabline.lua`,
`ufo.lua`, `comment.lua`, plus `custom/` and `snippets/`.

## Step 5 — Triage each upstream change

Port it when all of the following hold:

1. The concept still exists in this config (e.g. we use telescope, so telescope
   changes apply; we do not use neo-tree, so its changes do not).
2. It is not merely a consequence of `vim.pack` (e.g. `PackChanged` build
   hooks, `vim.pack.add` calls, section restructure into numbered sections).
3. It does not fight this config's deliberate deviations (see below).

When a change is desirable but written against `vim.pack`, reimplement the
*intent* in the lazy.nvim spec (see the deviations log).

## Step 6 — Apply changes

- Edit one file at a time; keep the existing code style (`stylua` via the
  `stylua` LSP, 2-space indent, double quotes).
- Preserve local additions. Many upstream hunks sit next to customizations
  (keymaps, servers, formatters); port only the upstream part.
- If upstream adds a setting that is purely cosmetic/preference (icons, keymap
  choices), still port it but keep this config's naming conventions.

## Step 7 — Refresh plugin lockfile

```sh
nvim --headless "+Lazy! clean" +qa
nvim --headless "+Lazy! update" +qa
```

`clean` removes plugins that are no longer referenced (e.g. after replacing
`nvim-web-devicons` with `mini.icons`).

## Step 8 — Verify

```sh
cd .config/nvim

# 1. Lua syntax of changed files
for f in init.lua lua/fernando/options.lua lua/fernando/plugins/*.lua; do
  nvim --headless -c "lua assert(loadfile('$f'))" -c q
done

# 2. Startup without errors
nvim --headless -c 'lua vim.defer_fn(function() print("STARTUP_OK") vim.cmd("qa!") end, 4000)'

# 3. Treesitter + LSP attach on a Lua file
nvim --headless lua/fernando/options.lua -c 'lua vim.defer_fn(function()
  print("TS:", vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil)
  local c = vim.lsp.get_clients({ bufnr = 0 })
  print("LSP:", table.concat(vim.tbl_map(function(x) return x.name end, c), ","))
  vim.cmd("qa!")
end, 3000)'
```

Then manually check: `:checkhealth`, `:Lazy`, `<leader>sf`, `<leader>sn`,
formatting with `<leader>kf` on a Lua and a TypeScript file, and gitsigns
keymaps inside a modified file.

## Step 9 — Record the sync

- Update the "Last sync" line below.
- Update the deviations log if you intentionally skipped or reimplemented
  something.
- Commit with the established message format:

```sh
git add .config/nvim
git commit -m "nvim: kickstart sync [<Mon D, YYYY>]"
```

## Last sync

- **Date:** Oct 25, 2026 (upstream cutoff: commits through 2026-10-03)
- **Commit:** pending

## Deliberate deviations from upstream (keep this log)

- **Plugin manager:** lazy.nvim, not `vim.pack`. All `vim.pack`-specific changes
  are skipped. See `VIM_PACK_MIGRATION.md`.
- **blink.cmp capabilities:** upstream removed
  `require("blink.cmp").get_lsp_capabilities()` because blink registers
  capabilities through `vim.lsp.config('*')` in its `plugin/blink-cmp.lua`.
  With lazy.nvim, blink is loaded on `VimEnter` while `lsp.lua` enables servers
  during startup, so server configs can resolve before blink's defaults exist
  (notably when opening a file directly: `nvim foo.ts`). We therefore keep the
  explicit `get_lsp_capabilities()` call in `lsp.lua` until blink is loaded
  eagerly or servers are enabled lazily.
- **TypeScript server:** kept `ts_ls` instead of upstream's `tsc`. The `tsc`
  server requires a TypeScript 7+ (`tsc`/`tsgo`) binary with `--lsp`; without it
  the server silently does not attach. Revisit when projects move to TS 7.
- **Formatting:** Lua formatting runs through the `stylua` LSP (upstream
  direction) while `conform.nvim` still owns JavaScript/TypeScript/JSON/YAML/
  Markdown (`oxfmt`, `prettierd`, `prettier`) and `shfmt`/`sqruff`. `lua_ls`
  formatting is disabled.
- **Lua formatting via LSP requires** `stylua` on `$PATH` (installed by mason as
  a server entry), because the lspconfig server runs `stylua --lsp`.
