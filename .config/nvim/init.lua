--[[
  Doom Emacs-inspired Neovim Configuration

  Key features:
  - SPC as leader key with mnemonic keybindings
  - which-key for discoverability
  - Doom-style dashboard
  - Modern plugin ecosystem
]]

-- Set leader key before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Load core modules
require("core.options")
require("core.lazy")
require("core.keymaps")
require("core.autocmds")
require("core.pi").setup()
require("core.tutor").setup()
