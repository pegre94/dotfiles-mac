# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A Doom Emacs-inspired Neovim configuration using **lazy.nvim** as the plugin manager. The config is written entirely in Lua and organized into core settings and plugin specs.

## Structure

```
init.lua                    # Entry point: sets leader keys, loads core + plugins
lua/
  core/
    options.lua             # Editor settings (2-space indent, relative numbers, etc.)
    keymaps.lua             # All keybindings (Doom-style SPC leader)
    autocmds.lua            # Autocommands (format on save, highlight yank, etc.)
    lazy.lua                # lazy.nvim bootstrap and plugin loading
    tutor.lua               # Custom :Tutor command (16 interactive lessons)
  plugins/
    ui.lua                  # alpha, lualine, bufferline, indent-blankline, notify
    lsp.lua                 # nvim-lspconfig, mason, conform, nvim-lint
    completion.lua          # nvim-cmp, LuaSnip, lspkind
    telescope.lua           # telescope.nvim, project.nvim
    treesitter.lua          # nvim-treesitter with text objects and navigation
    editor.lua              # neo-tree, gitsigns, neogit, comment, surround, flash, etc.
    colorscheme.lua         # gruvbox (hard contrast)
    which-key.lua           # which-key with Doom-style group labels
    misc.lua                # persistence, zen-mode, twilight, colorizer, hydra
tutor/                      # 16 .txt lesson files (00-index through 15-performance)
lazy-lock.json              # Plugin version lockfile
```

## Key Architectural Decisions

- **Leader key**: `<Space>`, **local leader**: `,`
- **Keybinding pattern**: Doom Emacs groups — `<leader>b` buffer, `<leader>c` code, `<leader>f` file, `<leader>g` git, `<leader>o` open, `<leader>p` project, `<leader>s` search, `<leader>t` toggle, `<leader>w` window, `<leader>x` diagnostics
- **Lazy loading**: All plugins lazy by default; many built-in Vim plugins disabled for performance
- **Auto-format on save**: via `conform.nvim` with 500ms timeout, LSP fallback
- **Auto-lint**: via `nvim-lint` on BufEnter, BufWritePost, InsertLeave

## Configured LSP Servers

`lua_ls`, `pyright`, `ts_ls`, `rust_analyzer`, `gopls`, `clangd`, `bashls`, `jsonls`, `yamlls`, `html`, `cssls`

All managed through Mason (`:Mason` to open UI, `:MasonUpdate` to update).

## Adding a New Plugin

Add a plugin spec table to the appropriate file in `lua/plugins/`. lazy.nvim picks up all specs returned from files in that directory. Follow the existing patterns:

```lua
-- In lua/plugins/<category>.lua, add to the return table:
{
  "author/plugin-name",
  event = "VeryLazy",   -- for lazy loading
  config = function()
    require("plugin-name").setup({ ... })
  end,
}
```

## Adding LSP Support for a New Language

In `lua/plugins/lsp.lua`, add the server name to the `servers` table in the `mason-lspconfig` `ensure_installed` list, and add a configuration entry in the `lspconfig` setup section.

## Tutor System

`:Tutor [lesson-name]` opens interactive lessons. Lessons live in `tutor/` as `.txt` files. Navigate lessons with `[l` / `]l`. Add new lessons by creating a numbered `.txt` file and registering it in `lua/core/tutor.lua`.

## Native Build Requirements

Some plugins require native compilation:
- `telescope-fzf-native`: requires `make` and a C compiler
- `LuaSnip`: requires `make install_jsregexp` (optional, for JS regex snippets)
- `markdown-preview.nvim`: requires Node.js/npm (`cd app && npm install`)

## Plugin Lock File

`lazy-lock.json` pins exact plugin versions. After intentional updates, commit this file to preserve reproducibility. Run `:Lazy update` to update plugins and regenerate the lockfile.
