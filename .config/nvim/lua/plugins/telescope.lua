--[[
  Telescope
  Fuzzy finder (like Doom's ivy/counsel)
]]

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      "nvim-telescope/telescope-ui-select.nvim",
      "ahmedkhalf/project.nvim",
    },
    keys = {
      -- Doom-style SPC keybindings
      { "<leader><leader>", "<cmd>Telescope commands<CR>", desc = "Commands (M-x)" },
      { "<leader>.", "<cmd>Telescope find_files<CR>", desc = "Find file" },
      { "<leader>,", "<cmd>Telescope buffers<CR>", desc = "Switch buffer" },
      { "<leader>/", "<cmd>Telescope live_grep<CR>", desc = "Search project" },
      { "<leader>'", "<cmd>Telescope resume<CR>", desc = "Resume last search" },

      -- File (SPC f)
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find file" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
      { "<leader>fR", "<cmd>Telescope oldfiles cwd_only=true<CR>", desc = "Recent files (cwd)" },

      -- Search (SPC s)
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Search buffer" },
      { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<CR>", desc = "Document diagnostics" },
      { "<leader>sD", "<cmd>Telescope diagnostics<CR>", desc = "Workspace diagnostics" },
      { "<leader>sg", "<cmd>Telescope live_grep<CR>", desc = "Grep" },
      { "<leader>sh", "<cmd>Telescope help_tags<CR>", desc = "Help" },
      { "<leader>sk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
      { "<leader>sm", "<cmd>Telescope marks<CR>", desc = "Marks" },
      { "<leader>so", "<cmd>Telescope vim_options<CR>", desc = "Options" },
      { "<leader>sr", "<cmd>Telescope resume<CR>", desc = "Resume" },
      { "<leader>ss", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Document symbols" },
      { "<leader>sS", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", desc = "Workspace symbols" },
      { "<leader>sw", "<cmd>Telescope grep_string<CR>", desc = "Word under cursor" },

      -- Project (SPC p)
      { "<leader>pp", "<cmd>Telescope projects<CR>", desc = "Switch project" },
      { "<leader>pf", "<cmd>Telescope find_files<CR>", desc = "Find file in project" },
      { "<leader>ps", "<cmd>Telescope live_grep<CR>", desc = "Search in project" },

      -- Git (SPC g)
      { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
      { "<leader>gC", "<cmd>Telescope git_bcommits<CR>", desc = "Buffer commits" },
      { "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "Branches" },
      { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Status" },
      { "<leader>gS", "<cmd>Telescope git_stash<CR>", desc = "Stash" },

      -- Help (SPC h)
      { "<leader>hh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
      { "<leader>hk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
      { "<leader>hm", "<cmd>Telescope man_pages<CR>", desc = "Man pages" },
      { "<leader>hc", "<cmd>Telescope commands<CR>", desc = "Commands" },
      { "<leader>ht", "<cmd>Telescope colorscheme<CR>", desc = "Themes" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          prompt_prefix = "   ",
          selection_caret = "  ",
          entry_prefix = "  ",
          initial_mode = "insert",
          selection_strategy = "reset",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          file_ignore_patterns = {
            "node_modules",
            ".git/",
            "target/",
            "dist/",
            "build/",
            "%.lock",
          },
          path_display = { "truncate" },
          winblend = 0,
          border = {},
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = true,
          set_env = { ["COLORTERM"] = "truecolor" },
          mappings = {
            i = {
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-c>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-s>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<C-l>"] = actions.complete_tag,
            },
            n = {
              ["<esc>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-s>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["H"] = actions.move_to_top,
              ["M"] = actions.move_to_middle,
              ["L"] = actions.move_to_bottom,
              ["gg"] = actions.move_to_top,
              ["G"] = actions.move_to_bottom,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["?"] = actions.which_key,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
          },
          buffers = {
            show_all_buffers = true,
            sort_lastused = true,
            mappings = {
              i = {
                ["<C-d>"] = actions.delete_buffer,
              },
              n = {
                ["d"] = actions.delete_buffer,
              },
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      })

      -- Load extensions
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")
      pcall(telescope.load_extension, "projects")
    end,
  },

  -- Project management
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
      require("project_nvim").setup({
        detection_methods = { "pattern", "lsp" },
        patterns = { ".git", "Makefile", "package.json", "Cargo.toml", ".project" },
        show_hidden = true,
        silent_chdir = true,
      })
    end,
  },
}
