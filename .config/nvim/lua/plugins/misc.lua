--[[
  Miscellaneous Plugins
  Additional utilities
]]

return {
  -- Plenary (required by many plugins)
  { "nvim-lua/plenary.nvim", lazy = true },

  -- Nui (UI components)
  { "MunifTanjim/nui.nvim", lazy = true },

  -- Persistence (session management like Doom)
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't save session" },
    },
    opts = {
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
    },
  },

  -- Zen mode (like Doom's writeroom)
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      { "<leader>tz", "<cmd>ZenMode<CR>", desc = "Zen mode" },
    },
    opts = {
      window = {
        backdrop = 0.95,
        width = 120,
        height = 1,
        options = {
          signcolumn = "no",
          number = false,
          relativenumber = false,
          cursorline = false,
          cursorcolumn = false,
          foldcolumn = "0",
          list = false,
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false,
          showcmd = false,
        },
        twilight = { enabled = true },
        gitsigns = { enabled = false },
        tmux = { enabled = true },
      },
    },
  },

  -- Twilight (dim inactive code)
  {
    "folke/twilight.nvim",
    cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
    keys = {
      { "<leader>tt", "<cmd>Twilight<CR>", desc = "Twilight" },
    },
    opts = {},
  },

  -- Colorizer (show colors inline)
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      filetypes = { "*" },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = false,
        RRGGBBAA = true,
        AARRGGBB = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = "background",
        tailwind = true,
        virtualtext = "■",
      },
    },
  },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && npm install",
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", desc = "Markdown preview" },
    },
  },

  -- Claude Code integration
  {
    "coder/claudecode.nvim",
    cmd = { "ClaudeCode", "ClaudeCodeFocus", "ClaudeCodeAdd", "ClaudeCodeSend" },
    keys = {
      { "<leader>ac", "<cmd>ClaudeCode<cr>",                desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",           desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",       desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>",     desc = "Continue Claude" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",           desc = "Add buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection" },
    },
    opts = {
      terminal = { provider = "auto" },
    },
  },

  -- Which-key hydra-like repeatable keys
  {
    "anuvyklack/hydra.nvim",
    event = "VeryLazy",
    config = function()
      local Hydra = require("hydra")

      -- Window resize hydra (like Doom's window hydra)
      Hydra({
        name = "Window",
        mode = "n",
        body = "<leader>wr",
        hint = [[
  _h_: ←  _l_: →  _j_: ↓  _k_: ↑
  _=_: balance  _q_: quit
        ]],
        config = {
          invoke_on_body = true,
          hint = {
            border = "rounded",
          },
        },
        heads = {
          { "h", "<C-w><" },
          { "l", "<C-w>>" },
          { "j", "<C-w>+" },
          { "k", "<C-w>-" },
          { "=", "<C-w>=", { desc = "balance" } },
          { "q", nil, { exit = true, nowait = true } },
        },
      })
    end,
  },
}
