return {
  {
    "dmtrKovalenko/fff.nvim",
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    lazy = false,
    opts = {
      lazy_sync = true,
      prompt = "> ",
      title = "FFFiles",
      max_results = 100,
      layout = {
        width = 0.85,
        height = 0.8,
        preview_position = "right",
        preview_size = 0.55,
        border = "rounded",
      },
    },
    keys = {
      { "<leader>.", function() require("fff").find_files() end, desc = "Find file (FFF)" },
      { "<leader>ff", function() require("fff").find_files() end, desc = "Find file (FFF)" },
      { "<leader>/", function() require("fff").live_grep() end, desc = "Search project (FFF)" },
      { "<leader>sg", function() require("fff").live_grep() end, desc = "Grep (FFF)" },
      {
        "<leader>sw",
        function() require("fff").live_grep_under_cursor() end,
        mode = { "n", "x" },
        desc = "Search word/selection (FFF)",
      },
      { "<leader>fI", "<cmd>FFFScan<CR>", desc = "FFF rescan index" },
      { "<leader>fH", "<cmd>FFFHealth<CR>", desc = "FFF health" },
    },
  },
}
