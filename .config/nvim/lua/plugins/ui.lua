--[[
  UI Plugins
  Dashboard, statusline, bufferline, and visual enhancements
]]

return {
  -- Dashboard (like Doom's splash screen)
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- Custom ASCII art
      dashboard.section.header.val = {
        [[                 ==.                                                      ]],
        [[                #@x&@&*-                                                  ]],
        [[               .@@X+*@@@@&+      $+                                       ]],
        [[              .X@@@@+#@@@@@@$==$=#@X- -                                   ]],
        [[             =@@@@@@##@@@@@@X$X*.+@@@@&.$XXx-X&-                          ]],
        [[            *@@@Xx@@@@@@@@@@@#xX@@@@@@@@&.$XXX#                           ]],
        [[           +@@@@@+#@@X&X@@@@@@@@@@@@@@@@@@&.&X=+XXX#                      ]],
        [[          +X@@=@@@#&.XX&x=. =*=X@@@@@@@@@@@@#.X $XXXXX+                   ]],
        [[         X@@$- @@*#@@@@ .     -$x.+**&@@@@@@@@- .+X&*XXX&.                ]],
        [[        --@@x@@@@@@@@@+++===*#*+=xXXX&+=@@@@@@@&+*+#-*+XXXX=              ]],
        [[       #.&@@x*@@@@@@@@&+*=-***&XXXXXXX**-==$@@@@@+.-X@+xXXXX+             ]],
        [[      *X.@@@$=@@@@@@@@@X+.XXXx++++XX&=&x    =@@@@++@@@@-&XX$X=            ]],
        [[     .XX.X@@X=&@+X@@@@x   X&-+. -$.&+xX      @@@@@@@@@@$-X* -X.           ]],
        [[     -&X-x@@@@@@&*@@x     X-$    =**&-#*    -*=..   .=X@.*-X-x$           ]],
        [[     -+=-.@@@@@@@@#      .X.&.   #.&Xx.=x  &XXX&        *@-.X@X.$         ]],
        [[     -@@&x@@@@@@@+       +X&-+*++=&XX&xxX XXXXXx-...-.-@@X@@@@$..         ]],
        [[     -.X@@@@@@@@@$        XXXXX&&XX&=-=+==+x&XXXXXX#+=X@@@@@@@@x          ]],
        [[     -*+@@@@@@@X*=       $XXXXXXXXXXX*=+  .=.+*****#XXXX@@@@@@@@.         ]],
        [[      X.X@@@@@@-#X$ .  xXXX=$XXXXXXXXXXXx*-+X@@@@X -+**+- x@@@@@.         ]],
        [[      =-=@@@@@@ XXX.X+=XX+X =XXXXXXXXXXXXX+=@@#*-= $x**x#+*@@@@X          ]],
        [[      -@@@@@@@@ XXX.X*-X&.X XXXXXXXXXXXXXXX.=*=--x.#XXXXX-$@@@@*          ]],
        [[       #@@@@@@@ XXX.X$ XX.X+=XXXXXXXXXXXXXXX*.**=.+==XXXXX.@@@@X          ]],
        [[        &@@@@@@ XXX.XX.#X*=X+-&XXXXXXXXXXXXX*=@@@@#*.+****-@@@@-          ]],
        [[         &@@@@@ XXX.XX$.&Xx=x$-=#XXXXXXXXXX$.**+&@@@@XXXX@@@@@=           ]],
        [[          #@@@@.+$Xx==++.#XX$+.=.-+++*+=----+XX.XX@@@@@@@@@X-             ]],
        [[           +@@@@$*++ $XXX*=++****+++=xXX $XX XXx+**=#@@@@@&               ]],
        [[            #@@@@@@ &XXXXXXXXXXXXXXX &X+-+* $XXXX#=$@@@X=                 ]],
        [[             .#@@@@&**-=*.-++++ ++ *.+XXXX#-* ***$@@@X+                   ]],
        [[                *X@@@@+*X-*@@@X XX @x +-=+ XX.X@@@@&=                     ]],
        [[                  .+&@+*X=+@@@@ XX @$.X=x@-#X=x@$=                        ]],
        [[                      -#=+@@@@ XX.@&.X*=@*=x-                             ]],
        [[                           .-= ++ ++ -.                                   ]],
      }

      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file", ":lua require('fff').find_files()<CR>"),
        dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
        dashboard.button("p", "  Find project", ":Telescope projects<CR>"),
        dashboard.button("g", "  Find text", ":lua require('fff').live_grep()<CR>"),
        dashboard.button("c", "  Configuration", ":e $MYVIMRC<CR>"),
        dashboard.button("l", "󰒲  Lazy", ":Lazy<CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }

      dashboard.section.footer.val = "Doom Emacs, but Neovim"

      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"

      dashboard.opts.layout[1].val = 4

      alpha.setup(dashboard.opts)

      -- Disable folding on alpha buffer
      vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
    end,
  },

  -- Statusline (modeline in Doom)
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "alpha", "dashboard" },
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        extensions = { "neo-tree", "lazy", "toggleterm" },
      })
    end,
  },

  -- Bufferline (tabs like Doom)
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<CR>", desc = "Pin buffer" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<CR>", desc = "Close non-pinned" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", desc = "Close other buffers" },
      { "<leader>bl", "<cmd>BufferLineCloseRight<CR>", desc = "Close buffers to right" },
      { "<leader>bh", "<cmd>BufferLineCloseLeft<CR>", desc = "Close buffers to left" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer" },
      { "]b", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
    },
    opts = {
      options = {
        mode = "buffers",
        separator_style = "thin",
        show_buffer_close_icons = true,
        show_close_icon = false,
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true,
          },
        },
      },
    },
  },

  -- Indent guides (like Doom)
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
      },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
        },
      },
    },
  },

  -- Notifications
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      render = "compact",
      stages = "fade",
      background_colour = "#000000",
    },
    config = function(_, opts)
      require("notify").setup(opts)
      vim.notify = require("notify")
    end,
  },

  -- Better UI elements
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        default_prompt = "➤ ",
        win_options = { winblend = 0 },
      },
      select = {
        backend = { "telescope", "builtin" },
      },
    },
  },

  -- Icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
}
