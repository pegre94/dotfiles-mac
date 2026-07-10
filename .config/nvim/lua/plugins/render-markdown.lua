return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      file_types = { "markdown" },
      render_modes = { "n", "c", "t" },
      heading = {
        enabled = true,
        sign = true,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
      code = {
        enabled = true,
        sign = true,
        style = "full",
        border = "thin",
      },
      bullet = {
        enabled = true,
        icons = { "●", "○", "◆", "◇" },
      },
      checkbox = {
        enabled = true,
      },
      link = {
        enabled = true,
      },
    },
    keys = {
      { "<leader>mr", "<cmd>RenderMarkdown toggle<CR>", desc = "Toggle rendered Markdown" },
      { "<leader>mR", "<cmd>RenderMarkdown buf_toggle<CR>", desc = "Toggle rendered Markdown buffer" },
      { "<leader>me", "<cmd>RenderMarkdown expand<CR>", desc = "Expand rendered Markdown" },
      { "<leader>mc", "<cmd>RenderMarkdown contract<CR>", desc = "Contract rendered Markdown" },
    },
  },
}
