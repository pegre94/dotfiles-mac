--[[
  Advanced Neovim Tutor
  Launch with :Tutor or :Tutor {lesson}
]]

local M = {}

local tutor_dir = vim.fn.stdpath("config") .. "/tutor"

local lessons = {
  ["00"] = "00-index.txt",
  ["01"] = "01-motions.txt",
  ["02"] = "02-textobjects.txt",
  ["03"] = "03-registers.txt",
  ["04"] = "04-marks.txt",
  ["05"] = "05-search.txt",
  ["06"] = "06-buffers.txt",
  ["07"] = "07-commandline.txt",
  ["08"] = "08-treesitter.txt",
  ["09"] = "09-lsp.txt",
  ["10"] = "10-telescope.txt",
  ["11"] = "11-git.txt",
  ["12"] = "12-doom.txt",
  ["13"] = "13-lua.txt",
  ["14"] = "14-plugins.txt",
  ["15"] = "15-performance.txt",
}

function M.open(lesson)
  local file
  if lesson and lesson ~= "" then
    -- Pad single digit with zero
    if #lesson == 1 then
      lesson = "0" .. lesson
    end
    file = lessons[lesson]
    if not file then
      vim.notify("Lesson " .. lesson .. " not found. Use :Tutor to see index.", vim.log.levels.ERROR)
      return
    end
  else
    file = "00-index.txt"
  end

  local path = tutor_dir .. "/" .. file
  if vim.fn.filereadable(path) == 0 then
    vim.notify("Tutor file not found: " .. path, vim.log.levels.ERROR)
    return
  end

  vim.cmd("edit " .. path)
  vim.notify("Advanced Neovim Tutor - Lesson " .. (lesson or "Index"), vim.log.levels.INFO)
end

function M.next_lesson()
  local current = vim.fn.expand("%:t")
  local num = current:match("^(%d+)")
  if num then
    local next_num = string.format("%02d", tonumber(num) + 1)
    if lessons[next_num] then
      M.open(next_num)
    else
      vim.notify("No more lessons!", vim.log.levels.INFO)
    end
  end
end

function M.prev_lesson()
  local current = vim.fn.expand("%:t")
  local num = current:match("^(%d+)")
  if num then
    local prev_num = string.format("%02d", tonumber(num) - 1)
    if lessons[prev_num] then
      M.open(prev_num)
    else
      vim.notify("Already at first lesson!", vim.log.levels.INFO)
    end
  end
end

function M.setup()
  -- Create :Tutor command
  vim.api.nvim_create_user_command("Tutor", function(opts)
    M.open(opts.args)
  end, {
    nargs = "?",
    complete = function()
      local completions = {}
      for k, _ in pairs(lessons) do
        table.insert(completions, k)
      end
      table.sort(completions)
      return completions
    end,
    desc = "Open Advanced Neovim Tutor",
  })

  -- Navigation keymaps for tutor files
  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = tutor_dir .. "/*.txt",
    callback = function()
      vim.keymap.set("n", "]l", M.next_lesson, { buffer = true, desc = "Next lesson" })
      vim.keymap.set("n", "[l", M.prev_lesson, { buffer = true, desc = "Previous lesson" })
    end,
  })
end

return M
