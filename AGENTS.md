# AGENTS.md — Neovim config (lazy.nvim)

## Entrypoint & Structure

- `init.lua` requires: `config.lazy`, `config.options`, `config.keymaps`, `config.autocmds`, `util.ssh`
- All plugin specs live in `lua/plugins/` — one file per plugin
- Core config in `lua/config/`, utilities in `lua/util/`
- LSP keymaps: defined in `lua/util/lsp-keymaps.lua`, applied on `LspAttach` in `lua/plugins/lsp.lua`

## Gotchas

- **`nvim-cmp` is DISABLED** (`lua/plugins/cmp.lua` has `enabled = false`). Active completion is `blink.cmp` (`lua/plugins/blink-cmp.lua`). Do not re-enable cmp.
- **Picker is `snacks.nvim`**, not telescope. All picker invocations use `Snacks.picker`.
- **Format on save is OFF by default**. Toggle with `:FormatEnable` (global) or `:FormatEnable!` (buffer).
- **Keyboard shortcuts**: `<space>` = mapleader, `\` = maplocalleader.
- **Nerd Font required** for icons.
- **Clipboard**: `util/ssh.lua` auto-configures for SSH/TMUX (OSC52 or tmux load-buffer).
- **Windows differs**: Ctrl+Space is a system feature; Lualine + dashboard filetype handling differs; see `README.md`.

## Keymaps (notable)

- `<leader>l` — Lazy plugin UI
- `<leader>ee` — neo-tree toggle
- `-` — Oil file explorer
- `<leader>cf` — format with conform
- `<leader>p` — yank history picker
- `s` — flash jump, `S` — treesitter flash
- `<leader>ca` — LSP code action
- `<leader>rn` — LSP rename
- `<C-h/j/k/l>` — smart window navigation

## Adding a plugin

Create file in `lua/plugins/`, return a lazy.nvim spec table with `opts` (simple config) or `config` (custom logic). Prefer lazy loading via `event`, `cmd`, `ft`, or `keys`.

## External deps

Nerd Font, git, curl, unzip, tar. LSP servers/formatters/linters via mason (auto-installed).

## Known issues (see README.md)

- HyprLSP needs Go to compile
- Image backend: kitty protocol > ueberzug; tmux detection is unreliable
- mini.indentscope can't be disabled on snacks dashboard
- Noice table messages cause blank space below statusline