--[[
  Doom Emacs-style Keybindings
  
  Leader key: SPC (Space)
  Local leader: , (comma)
  
  Mnemonic structure:
  SPC b - buffers
  SPC f - files
  SPC g - git
  SPC h - help
  SPC o - open
  SPC p - project
  SPC q - quit
  SPC s - search
  SPC t - toggle
  SPC w - windows
  SPC c - code
  SPC x - text
]]

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Better escape
map("i", "jk", "<Esc>", opts)
map("i", "kj", "<Esc>", opts)

-- Better window navigation (Doom style: SPC w)
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Resize windows with arrows
map("n", "<C-Up>", ":resize -2<CR>", opts)
map("n", "<C-Down>", ":resize +2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Move lines up/down (like Doom's M-j/M-k)
map("n", "<A-j>", ":m .+1<CR>==", opts)
map("n", "<A-k>", ":m .-2<CR>==", opts)
map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Stay in visual mode when indenting
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Clear search highlighting
map("n", "<Esc>", ":noh<CR>", opts)

-- Better paste (don't yank replaced text)
map("v", "p", '"_dP', opts)

-- Keep cursor centered when scrolling
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

-- Quick save
map("n", "<C-s>", ":w<CR>", opts)
map("i", "<C-s>", "<Esc>:w<CR>", opts)

--[[ 
  DOOM-STYLE SPC KEYBINDINGS
  These are defined in which-key plugin for discoverability
  Basic ones defined here as fallback
]]

-- SPC SPC - M-x equivalent (command palette via telescope)
map("n", "<leader><leader>", "<cmd>Telescope commands<CR>", { desc = "Commands" })

-- SPC . - Find file (like Doom's SPC .)
map("n", "<leader>.", function()
  require("fff").find_files()
end, { desc = "Find file (FFF)" })

-- SPC , - Switch buffer (like Doom's SPC ,)
map("n", "<leader>,", "<cmd>Telescope buffers<CR>", { desc = "Switch buffer" })

-- SPC / - Search project (like Doom's SPC /)
map("n", "<leader>/", function()
  require("fff").live_grep()
end, { desc = "Search project (FFF)" })

-- SPC : - M-x (command mode)
map("n", "<leader>:", ":", { desc = "Command mode" })

-- SPC ` - Switch to last buffer
map("n", "<leader>`", "<cmd>e #<CR>", { desc = "Last buffer" })

-- Buffer keymaps (SPC b)
map("n", "<leader>bb", "<cmd>Telescope buffers<CR>", { desc = "Switch buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Kill buffer" })
map("n", "<leader>bk", "<cmd>bdelete<CR>", { desc = "Kill buffer" })
map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bs", "<cmd>w<CR>", { desc = "Save buffer" })
map("n", "<leader>bS", "<cmd>wa<CR>", { desc = "Save all buffers" })

-- File keymaps (SPC f)
map("n", "<leader>ff", function()
  require("fff").find_files()
end, { desc = "Find file (FFF)" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
map("n", "<leader>fs", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>fS", "<cmd>wa<CR>", { desc = "Save all files" })

-- Window keymaps (SPC w)
map("n", "<leader>ww", "<C-w>w", { desc = "Other window" })
map("n", "<leader>wd", "<C-w>c", { desc = "Delete window" })
map("n", "<leader>wh", "<C-w>h", { desc = "Window left" })
map("n", "<leader>wj", "<C-w>j", { desc = "Window down" })
map("n", "<leader>wk", "<C-w>k", { desc = "Window up" })
map("n", "<leader>wl", "<C-w>l", { desc = "Window right" })
map("n", "<leader>ws", "<C-w>s", { desc = "Split horizontal" })
map("n", "<leader>wv", "<C-w>v", { desc = "Split vertical" })
map("n", "<leader>w=", "<C-w>=", { desc = "Balance windows" })
map("n", "<leader>wm", "<cmd>only<CR>", { desc = "Maximize window" })

-- Quit keymaps (SPC q)
map("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit all" })
map("n", "<leader>qQ", "<cmd>qa!<CR>", { desc = "Quit without saving" })
map("n", "<leader>qs", "<cmd>wqa<CR>", { desc = "Save and quit" })

-- Toggle keymaps (SPC t)
map("n", "<leader>tn", "<cmd>set relativenumber!<CR>", { desc = "Toggle relative numbers" })
map("n", "<leader>tw", "<cmd>set wrap!<CR>", { desc = "Toggle word wrap" })
map("n", "<leader>ts", "<cmd>set spell!<CR>", { desc = "Toggle spell check" })

-- Help keymaps (SPC h)
map("n", "<leader>hk", "<cmd>Telescope keymaps<CR>", { desc = "Keymaps" })
map("n", "<leader>hh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })
map("n", "<leader>hm", "<cmd>Telescope man_pages<CR>", { desc = "Man pages" })
