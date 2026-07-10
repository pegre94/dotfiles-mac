return {
  {
    "carderne/pi-nvim",
    cmd = {
      "Pi",
      "PiSend",
      "PiSendFile",
      "PiSendSelection",
      "PiSendBuffer",
      "PiPing",
      "PiSessions",
    },
    keys = {
      { "<leader>ap", "<cmd>Pi<CR>", desc = "Send to running pi" },
      { "<leader>ap", ":Pi<CR>", mode = "v", desc = "Send selection to running pi" },
      { "<leader>aa", "<cmd>PiSend<CR>", desc = "Send prompt to pi" },
      { "<leader>aF", "<cmd>PiSendFile<CR>", desc = "Send file to pi" },
      { "<leader>aB", "<cmd>PiSendBuffer<CR>", desc = "Send buffer to pi" },
      { "<leader>aV", ":PiSendSelection<CR>", mode = "v", desc = "Send selection to pi" },
      { "<leader>a?", "<cmd>PiPing<CR>", desc = "Ping pi bridge" },
      { "<leader>aS", "<cmd>PiSessions<CR>", desc = "Pi sessions" },
    },
    opts = {
      socket_path = nil,
      set_default_keymaps = false,
    },
  },
}
