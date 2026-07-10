return {
  {
    "pablopunk/pi.nvim",
    cmd = { "PiAsk", "PiAskSelection", "PiCancel", "PiLog" },
    keys = {
      { "<leader>ai", "<cmd>PiAsk<CR>", desc = "Ask pi" },
      { "<leader>ai", "<cmd>PiAskSelection<CR>", mode = "v", desc = "Ask pi about selection" },
      { "<leader>ax", "<cmd>PiCancel<CR>", desc = "Cancel pi request" },
      { "<leader>al", "<cmd>PiLog<CR>", desc = "Open pi log" },
    },
    opts = {
      binary = "pi",
      thinking = "off",
      context = {
        max_bytes = 24000,
        ask = {
          surrounding_lines = 80,
        },
        selection = {
          surrounding_lines = 40,
        },
        diagnostics = {
          enabled = true,
        },
      },
      skills = true,
      extensions = true,
    },
  },
}
