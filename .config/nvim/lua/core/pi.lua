local M = {}

local state = {
  buf = nil,
  win = nil,
  job = nil,
}

local function make_pi_cmd(args)
  if type(args) == "table" then
    local cmd = { "pi" }
    vim.list_extend(cmd, args)
    return cmd
  end

  args = args or ""
  if args == "" then
    return { "pi" }
  end
  return { "pi", args }
end

local function open_pi_terminal(args, opts)
  opts = opts or {}
  local cmd = make_pi_cmd(args)

  if not opts.new_session and state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_set_current_win(state.win)
    vim.cmd.startinsert()
    return
  end

  vim.cmd("botright 80vsplit")
  state.win = vim.api.nvim_get_current_win()

  if not opts.new_session and state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    vim.api.nvim_win_set_buf(state.win, state.buf)
  else
    state.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(state.win, state.buf)
    vim.bo[state.buf].bufhidden = "hide"
    vim.bo[state.buf].filetype = "pi-terminal"
    state.job = vim.fn.termopen(cmd, {
      cwd = vim.fn.getcwd(),
      on_exit = function()
        vim.schedule(function()
          if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
            vim.bo[state.buf].modifiable = false
          end
        end)
      end,
    })
  end

  vim.cmd.startinsert()
end

local function close_pi_terminal()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
    state.win = nil
  end
end

local function toggle_pi_terminal()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    close_pi_terminal()
  else
    open_pi_terminal()
  end
end

local function visual_selection_text()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local start_line = start_pos[2]
  local end_line = end_pos[2]
  local start_col = start_pos[3]
  local end_col = end_pos[3]

  if start_line > end_line then
    start_line, end_line = end_line, start_line
    start_col, end_col = end_col, start_col
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  if #lines == 0 then
    return "", start_line, end_line
  end

  lines[1] = string.sub(lines[1], start_col)
  if #lines == 1 then
    lines[1] = string.sub(lines[1], 1, end_col - start_col + 1)
  else
    lines[#lines] = string.sub(lines[#lines], 1, end_col)
  end

  return table.concat(lines, "\n"), start_line, end_line
end

local function selection_prompt()
  local text, start_line, end_line = visual_selection_text()
  if text == "" then
    return nil
  end

  local path = vim.api.nvim_buf_get_name(0)
  local filetype = vim.bo.filetype
  return table.concat({
    "I want to discuss this selected code/text from Neovim.",
    "",
    "File: " .. (path ~= "" and path or "[unsaved buffer]"),
    "Lines: " .. start_line .. "-" .. end_line,
    "Filetype: " .. (filetype ~= "" and filetype or "unknown"),
    "",
    "Selected content:",
    "```" .. (filetype ~= "" and filetype or "text"),
    text,
    "```",
    "",
  }, "\n")
end

local function copy_selection_for_pi()
  local prompt = selection_prompt()
  if not prompt then
    vim.notify("No visual selection for pi", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", prompt)
  vim.fn.setreg('"', prompt)
  vim.notify("Copied selection context for pi", vim.log.levels.INFO)
end

local function paste_selection_into_pi_chat()
  local prompt = selection_prompt()
  if not prompt then
    vim.notify("No visual selection for pi", vim.log.levels.WARN)
    return
  end

  copy_selection_for_pi()
  open_pi_terminal()

  vim.defer_fn(function()
    if state.job then
      vim.api.nvim_chan_send(state.job, prompt)
      vim.cmd.startinsert()
    else
      vim.notify("Pi terminal is not ready; context copied to clipboard", vim.log.levels.WARN)
    end
  end, 150)
end

function M.setup()
  vim.api.nvim_create_user_command("PiTerminal", function(opts)
    open_pi_terminal(opts.args)
  end, {
    nargs = "*",
    desc = "Open pi in a Neovim terminal split",
  })

  vim.api.nvim_create_user_command("PiTerminalToggle", function()
    toggle_pi_terminal()
  end, {
    desc = "Toggle pi terminal split",
  })

  vim.api.nvim_create_user_command("PiTerminalClose", function()
    close_pi_terminal()
  end, {
    desc = "Close pi terminal split",
  })

  vim.api.nvim_create_user_command("PiChatSelection", function()
    paste_selection_into_pi_chat()
  end, {
    range = true,
    desc = "Paste visual selection context into the interactive pi chat",
  })

  vim.api.nvim_create_user_command("PiCopySelection", function()
    copy_selection_for_pi()
  end, {
    range = true,
    desc = "Copy visual selection context for pi",
  })

  vim.keymap.set("n", "<leader>at", toggle_pi_terminal, { desc = "Toggle pi terminal" })
  vim.keymap.set("n", "<leader>aT", function()
    open_pi_terminal()
  end, { desc = "Open pi terminal" })
  vim.keymap.set("v", "<leader>ay", function()
    vim.cmd.normal({ "gv", bang = true })
    copy_selection_for_pi()
  end, { desc = "Copy selection for pi" })
end

return M
