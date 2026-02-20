local wezterm = require 'wezterm'
local act = wezterm.action
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Theme
config.color_scheme = 'GruvboxDarkHard'
config.font = wezterm.font 'JetBrains Mono'
config.font_size = 14.0

-- Window appearance
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.85
config.macos_window_background_blur = 16
config.window_padding = {
  left = 8,
  right = 8,
  top = 8,
  bottom = 8,
}

-- Tab bar styling
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 32

-- Pane borders with better visibility
config.inactive_pane_hsb = {
  saturation = 0.7,
  brightness = 0.6,
}

-- Status bar at bottom
wezterm.on('update-status', function(window, pane)
  local date = wezterm.strftime '%a %b %-d %H:%M'
  window:set_right_status(wezterm.format {
    { Foreground = { Color = '#928374' } },
    { Text = ' ' .. date .. ' ' },
  })
end)

-- Cursor styling
config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'

-- Scrollback
config.scrollback_lines = 10000

-- Skip confirmation prompts
config.skip_close_confirmation_for_processes_named = {}
config.window_close_confirmation = 'NeverPrompt'

-- Bell
config.audible_bell = 'Disabled'
config.visual_bell = {
  fade_in_duration_ms = 75,
  fade_out_duration_ms = 75,
  target = 'CursorColor',
}

-- Performance
config.front_end = "WebGpu"
config.max_fps = 120
config.animation_fps = 60
config.enable_wayland = false

-- Smart navigation function - try pane navigation, fallback to Aerospace
local function smart_navigate(direction)
  local direction_map = {
    left = "Left",
    right = "Right", 
    up = "Up",
    down = "Down"
  }
  
  return wezterm.action_callback(function(window, pane)
    local pane_id_before = pane:pane_id()
    
    -- Attempt navigation
    window:perform_action(act.ActivatePaneDirection(direction_map[direction]), pane)
    
    -- Use a timer to check if we moved after a brief delay
    wezterm.time.call_after(0.05, function()
      local current_pane = window:active_pane()
      if current_pane then
        local pane_id_after = current_pane:pane_id()
        
        -- If pane didn't change, we're at the edge
        if pane_id_before == pane_id_after then
          os.execute('/opt/homebrew/bin/aerospace focus ' .. direction .. ' &')
        end
      end
    end)
  end)
end

-- Keybindings
config.keys = {
  -- Smart navigation with edge escape (i3/Emacs pattern)
  { key = 'h', mods = 'CMD', action = smart_navigate('left') },
  { key = 'j', mods = 'CMD', action = smart_navigate('down') },
  { key = 'k', mods = 'CMD', action = smart_navigate('up') },
  { key = 'l', mods = 'CMD', action = smart_navigate('right') },
  
  -- Arrow keys as alternative
  { key = 'LeftArrow', mods = 'CMD', action = smart_navigate('left') },
  { key = 'RightArrow', mods = 'CMD', action = smart_navigate('right') },
  { key = 'UpArrow', mods = 'CMD', action = smart_navigate('up') },
  { key = 'DownArrow', mods = 'CMD', action = smart_navigate('down') },
  
  -- Split creation
  { key = '\\', mods = 'CMD', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '-', mods = 'CMD', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  
  -- Close pane
  { key = 'w', mods = 'CMD', action = act.CloseCurrentPane { confirm = false } },
  
  -- Resize panes
  { key = '-', mods = 'CMD|SHIFT', action = act.AdjustPaneSize { 'Down', 5 } },
  { key = '=', mods = 'CMD|SHIFT', action = act.AdjustPaneSize { 'Up', 5 } },
  
  -- Unbind cmd+q to let Aerospace handle it
  { key = 'q', mods = 'CMD|SHIFT', action = act.DisableDefaultAssignment },
}

return config
