return {
  {
    dir = "/Users/pgrenda/indra-company/indra-core/editors/neovim",
    ft = { "markdown" },
    config = function()
      require("indra").setup({
        cmd = { "/Users/pgrenda/.local/bin/indra", "lsp" },
      })

      local indra_cmd = "/Users/pgrenda/.local/bin/indra"

      vim.api.nvim_set_hl(0, "IndraWikiLinkBracket", {
        fg = "#7f849c",
      })
      vim.api.nvim_set_hl(0, "IndraWikiLinkText", {
        fg = "#ff9e64",
        bold = true,
        italic = true,
        underline = true,
      })

      local function highlight_wiki_links()
        if vim.bo.filetype ~= "markdown" then
          return
        end
        if vim.w.indra_wiki_link_matches then
          for _, match_id in ipairs(vim.w.indra_wiki_link_matches) do
            pcall(vim.fn.matchdelete, match_id)
          end
        end
        vim.w.indra_wiki_link_matches = {
          vim.fn.matchadd("IndraWikiLinkBracket", [=[\v\[\[]=], 20),
          vim.fn.matchadd("IndraWikiLinkBracket", [=[\v\]\]]=], 20),
          vim.fn.matchadd("IndraWikiLinkText", [=[\v\[\[\zs[^]]+\ze\]\]]=], 21),
        }
      end

      local function location_items(result)
        local items = {}
        for _, backlink in ipairs(result.backlinks or {}) do
          table.insert(items, {
            filename = vim.uri_to_fname(backlink.uri),
            lnum = backlink.line,
            col = backlink.range.start.character + 1,
            text = backlink.preview or backlink.target or backlink.path,
          })
        end
        return items
      end

      local function vault_root(path)
        local dir = vim.fs.dirname(path)
        return vim.fs.root(dir, ".indra")
      end

      local function update_backlinks_list(bufnr, opts)
        opts = opts or {}
        bufnr = bufnr or vim.api.nvim_get_current_buf()
        if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].filetype ~= "markdown" then
          return
        end

        local client = vim.lsp.get_clients({ bufnr = bufnr, name = "indra" })[1]
        if not client then
          return
        end

        local params = {
          textDocument = vim.lsp.util.make_text_document_params(bufnr),
        }

        client:request("indra/backlinks", params, function(err, result)
          if err or not result then
            return
          end

          vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(bufnr) or vim.api.nvim_get_current_buf() ~= bufnr then
              return
            end

            vim.fn.setloclist(0, {}, " ", {
              title = "Indra backlinks to " .. result.target.path,
              items = location_items(result),
            })

            if opts.open and #(result.backlinks or {}) > 0 then
              vim.cmd("silent! lopen")
            end
          end)
        end, bufnr)
      end

      local function index_then_update(bufnr)
        bufnr = bufnr or vim.api.nvim_get_current_buf()
        local path = vim.api.nvim_buf_get_name(bufnr)
        local root = vault_root(path)
        if not root then
          return
        end

        vim.fn.jobstart({ indra_cmd, "--vault", root, "index" }, {
          stdout_buffered = true,
          stderr_buffered = true,
          on_exit = function(_, code)
            if code == 0 then
              vim.schedule(function()
                update_backlinks_list(bufnr, { open = true })
              end)
            end
          end,
        })
      end

      local function jump_wiki_link(direction)
        local flags = direction == "prev" and "bW" or "W"
        local found = vim.fn.search("\\[\\[", flags)
        if found == 0 then
          vim.notify("No " .. direction .. " Indra link", vim.log.levels.INFO)
        end
      end

      vim.keymap.set("n", "]i", function()
        jump_wiki_link("next")
      end, { desc = "Next Indra link" })
      vim.keymap.set("n", "[i", function()
        jump_wiki_link("prev")
      end, { desc = "Previous Indra link" })

      vim.keymap.set("n", "<leader>ib", "<cmd>IndraBacklinks<CR>", { desc = "Indra backlinks buffer" })
      vim.keymap.set("n", "<leader>il", "<cmd>IndraBacklinksList<CR>", {
        desc = "Indra backlinks list",
        silent = true,
      })
      vim.keymap.set("n", "<leader>ii", function()
        index_then_update(0)
      end, { desc = "Indra index current vault" })
      vim.keymap.set("n", "<leader>ic", "<cmd>lclose<CR>", { desc = "Indra close backlinks list" })
      vim.keymap.set("n", "<leader>in", "<cmd>lnext<CR>", { desc = "Indra next backlink" })
      vim.keymap.set("n", "<leader>ip", "<cmd>lprev<CR>", { desc = "Indra previous backlink" })
      vim.keymap.set("n", "<leader>id", vim.lsp.buf.definition, { desc = "Indra go to linked note" })
      vim.keymap.set("n", "<leader>ih", vim.lsp.buf.hover, { desc = "Indra link hover" })
      vim.keymap.set("n", "<leader>ia", vim.lsp.buf.code_action, { desc = "Indra link action" })

      local group = vim.api.nvim_create_augroup("indra-auto-backlinks-list", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "FileType" }, {
        group = group,
        pattern = { "*.md", "markdown" },
        callback = function()
          highlight_wiki_links()
        end,
      })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        group = group,
        pattern = "*.md",
        callback = function(args)
          vim.defer_fn(function()
            update_backlinks_list(args.buf, { open = false })
          end, 100)
        end,
      })

      vim.api.nvim_create_autocmd("BufWritePost", {
        group = group,
        pattern = "*.md",
        callback = function(args)
          index_then_update(args.buf)
        end,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = group,
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "indra" then
            vim.keymap.set("n", "<CR>", vim.lsp.buf.definition, {
              buffer = args.buf,
              desc = "Indra open linked note",
            })
            vim.keymap.set("n", "<2-LeftMouse>", "<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>", {
              buffer = args.buf,
              desc = "Indra open linked note on double click",
              silent = true,
            })

            vim.defer_fn(function()
              update_backlinks_list(args.buf, { open = false })
            end, 100)
          end
        end,
      })
    end,
  },
}
