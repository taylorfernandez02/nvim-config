# nvim-config

Personal Neovim configuration. This README is written for an AI coding agent (e.g. Claude Code) running on a fresh machine — follow the steps top-to-bottom.

## Prerequisites

Verify (and install if missing) before cloning:

- `nvim` — Neovim **0.10+** required (`nvim --version`). Uses `vim.uv` and the new `vim.lsp.config` API.
- `git`
- A C compiler (`cc` / `clang` / `gcc`) — Mason builds some LSPs from source.
- `node` and `npm` — needed by Mason to install `yaml-language-server`.
- `claude` CLI on `$PATH` — the `claudecode.nvim` plugin shells out to it. If absent, the plugin loads but its commands fail; everything else still works.
- A Nerd Font configured in the terminal — `nvim-web-devicons` renders glyphs in the file tree.

## Install

```sh
# Back up any existing config first
[ -e ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.bak.$(date +%s)

git clone https://github.com/taylorfernandez02/nvim-config.git ~/.config/nvim
nvim --headless "+Lazy! sync" +qa
```

The headless `Lazy! sync` bootstraps `lazy.nvim`, installs every plugin at the version pinned in `lazy-lock.json`, then exits. Expect it to take 30–90 seconds and print progress to stderr. A non-zero exit code means a plugin failed to clone — re-run it; transient network errors are the usual cause.

On first interactive launch (`nvim`), Mason will auto-install `yaml-language-server`. Run `:Mason` to verify, or `:checkhealth` for a full diagnostic.

## Layout

```
init.lua                  # entry point: sets <leader>=Space, loads config.*
lua/config/lazy.lua       # bootstraps lazy.nvim, imports lua/plugins/
lua/config/terminal.lua   # terminal-mode keymaps + auto-insert autocmds
lua/plugins/lsp.lua       # mason, mason-lspconfig, nvim-lspconfig, nvim-cmp
lua/plugins/explorer.lua  # neo-tree (file explorer)
lua/plugins/claudecode.lua# coder/claudecode.nvim integration
lazy-lock.json            # pinned plugin versions — commit changes after :Lazy update
```

To add a plugin: drop a new file in `lua/plugins/` returning a lazy.nvim spec table. The `{ import = "plugins" }` line in `lua/config/lazy.lua` picks it up automatically — no manual registration.

## Key bindings (leader = Space)

| Keys           | Action                          |
| -------------- | ------------------------------- |
| `<leader>e`    | Toggle Neo-tree file explorer   |
| `<leader>ac`   | Toggle Claude Code              |
| `<leader>af`   | Focus Claude Code window        |
| `<leader>ar`   | Resume previous Claude session  |
| `<leader>aC`   | Continue last Claude session    |
| `<leader>am`   | Select Claude model             |
| `<leader>ab`   | Add current buffer to Claude    |
| `<leader>as`   | Send selection / tree node      |
| `<leader>aa`   | Accept Claude diff              |
| `<leader>ad`   | Deny Claude diff                |
| `<C-Esc>`      | Exit terminal-insert mode       |
| `<M-h/j/k/l>`  | Window navigation (any mode)    |
| `<Tab>` (cmp)  | Confirm completion              |

## Updating

```sh
cd ~/.config/nvim
nvim --headless "+Lazy! update" +qa
git add lazy-lock.json && git commit -m "Update plugins" && git push
```

Always commit `lazy-lock.json` after updates so other machines stay in sync.

## Troubleshooting

- **`yamlls` not running** — `:Mason`, confirm it's installed; check `:LspInfo` in a YAML buffer.
- **Icons render as boxes** — terminal isn't using a Nerd Font.
- **`claudecode` commands error** — `claude` CLI not on `$PATH`. Install it or remove `lua/plugins/claudecode.lua`.
- **Plugin clone fails on `Lazy! sync`** — usually a network blip; re-run. If a single plugin is wedged, `rm -rf ~/.local/share/nvim/lazy/<plugin>` and sync again.
