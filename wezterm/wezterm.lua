local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

------------------------------------------------------------
-- Default Shell (Fixes opening CMD instead of Pwsh)
------------------------------------------------------------
if wezterm.target_triple:find("windows") then
  config.default_prog = { "pwsh.exe", "-NoLogo" }
elseif wezterm.target_triple:find("linux") then
  config.default_prog = { "zsh" }
end

------------------------------------------------------------
-- Theme
------------------------------------------------------------

config.colors = require("cyberdream")

config.colors.tab_bar = {
  background = "#16181a",

  active_tab = {
    bg_color = "#24283b",
    fg_color = "#ffffff",
  },

  inactive_tab = {
    bg_color = "#16181a",
    fg_color = "#7b8496",
  },

  inactive_tab_hover = {
    bg_color = "#2b3244",
    fg_color = "#ffffff",
  },

  new_tab = {
    bg_color = "#16181a",
    fg_color = "#7b8496",
  },

  new_tab_hover = {
    bg_color = "#2b3244",
    fg_color = "#ffffff",
  },

  inactive_tab_edge = "#16181a",
}

------------------------------------------------------------
-- Fonts
------------------------------------------------------------

config.font = wezterm.font("Fira Code")
config.font_size = 12
config.line_height = 1.10

config.window_frame = {
  font = wezterm.font("Inter", {
    weight = "Medium",
  }),
  font_size = 13,
}

------------------------------------------------------------
-- Window (Fixes jittering and Win+Up maximizing)
------------------------------------------------------------

-- "RESIZE" keeps it borderless but allows Windows to handle snapping/maximizing
config.window_decorations = "RESIZE"

config.window_background_opacity = 0.95
-- Set text opacity to 1.0 to stop the Windows compositor jittering
config.text_background_opacity = 1.0

config.window_padding = {
  left = 8,
  right = 8,
  top = 8,
  bottom = 8,
}

------------------------------------------------------------
-- Cursor
------------------------------------------------------------

config.default_cursor_style = "SteadyBlock"
config.animation_fps = 120
config.cursor_blink_rate = 0

------------------------------------------------------------
-- Tabs
------------------------------------------------------------

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 36
config.switch_to_last_active_tab_when_closing_tab = true

------------------------------------------------------------
-- Launch Menu
------------------------------------------------------------

config.launch_menu = {}

if wezterm.target_triple:find("windows") then
  config.launch_menu = {
    {
      label = wezterm.nerdfonts.md_powershell .. "  PowerShell 7",
      args = { "pwsh.exe", "-NoLogo" },
    },
    {
      label = wezterm.nerdfonts.md_console .. "  Command Prompt",
      args = { "cmd.exe" },
    },
    {
      label = wezterm.nerdfonts.md_powershell .. "  Windows PowerShell",
      args = { "powershell.exe", "-NoLogo" },
    },
    {
      label = wezterm.nerdfonts.md_microsoft_azure .. "  Azure PowerShell",
      args = { "pwsh.exe", "-NoLogo", "-NoExit", "-Command", "Connect-AzAccount" },
    },
    {
      label = wezterm.nerdfonts.md_microsoft_windows .. "  WSL Arch Linux",
      args = {
        "wsl.exe",
        "-d",
        "Arch",
      },
    },
  }
elseif wezterm.target_triple:find("linux") then
  config.launch_menu = {
    {
      label = wezterm.nerdfonts.cod_terminal .. "  Zsh",
      args = { "zsh" },
    },
    {
      label = wezterm.nerdfonts.cod_terminal .. "  Bash",
      args = { "bash" },
    },
    {
      label = wezterm.nerdfonts.md_chart_timeline .. "  Btop",
      args = { "btop" },
    },
  }
end

------------------------------------------------------------
-- Keybindings
------------------------------------------------------------

config.keys = {
  {
    key = "l",
    mods = "ALT",
    action = act.ShowLauncherArgs({ flags = "FUZZY|LAUNCH_MENU_ITEMS" }),
  },
}

------------------------------------------------------------
-- Helpers
------------------------------------------------------------

local function basename(path)
  if not path or path == "" then
    return "shell"
  end

  return path:gsub("(.*[/\\])(.*)", "%2"):gsub("%.exe$", "")
end

------------------------------------------------------------
-- Applications
------------------------------------------------------------

local icons = {
  zsh = wezterm.nerdfonts.cod_terminal,
  bash = wezterm.nerdfonts.cod_terminal,
  fish = wezterm.nerdfonts.cod_terminal,
  nu = wezterm.nerdfonts.cod_terminal,
  pwsh = wezterm.nerdfonts.md_powershell,
  ["pwsh.exe"] = wezterm.nerdfonts.md_powershell,
  powershell = wezterm.nerdfonts.md_powershell,
  ["powershell.exe"] = wezterm.nerdfonts.md_powershell,
  cmd = wezterm.nerdfonts.md_console,
  ["cmd.exe"] = wezterm.nerdfonts.md_console,
  wsl = wezterm.nerdfonts.md_microsoft_windows,
  ["wsl.exe"] = wezterm.nerdfonts.md_microsoft_windows,
  wslhost = wezterm.nerdfonts.md_microsoft_windows,
  ["wslhost.exe"] = wezterm.nerdfonts.md_microsoft_windows,
  azure = wezterm.nerdfonts.md_microsoft_azure,
  nvim = wezterm.nerdfonts.custom_vim,
  vim = wezterm.nerdfonts.custom_vim,
  lazygit = wezterm.nerdfonts.dev_git,
  git = wezterm.nerdfonts.dev_git,
  python = wezterm.nerdfonts.dev_python,
  python3 = wezterm.nerdfonts.dev_python,
  node = wezterm.nerdfonts.dev_nodejs,
  npm = wezterm.nerdfonts.dev_npm,
  go = wezterm.nerdfonts.seti_go,
  cargo = wezterm.nerdfonts.dev_rust,
  rustc = wezterm.nerdfonts.dev_rust,
  lua = wezterm.nerdfonts.seti_lua,
  docker = wezterm.nerdfonts.linux_docker,
  lazydocker = wezterm.nerdfonts.linux_docker,
  ssh = wezterm.nerdfonts.md_server_network,
  yazi = wezterm.nerdfonts.md_folder,
  btop = wezterm.nerdfonts.md_chart_timeline,
  htop = wezterm.nerdfonts.md_chart_timeline,
  shell = wezterm.nerdfonts.cod_terminal,
}

------------------------------------------------------------
-- Tab Renderer
------------------------------------------------------------

local titles = {
  zsh = "Zsh", bash = "Bash", fish = "Fish", nu = "Nu",
  pwsh = "PowerShell", ["pwsh.exe"] = "PowerShell",
  powershell = "Windows PowerShell", ["powershell.exe"] = "Windows PowerShell",
  cmd = "CMD", ["cmd.exe"] = "CMD",
  wsl = "WSL", ["wsl.exe"] = "WSL", wslhost = "WSL", ["wslhost.exe"] = "WSL",
  azure = "Azure",
  nvim = "Neovim", vim = "Vim",
  lazygit = "LazyGit", git = "Git",
  python = "Python", python3 = "Python",
  node = "Node", npm = "NPM",
  docker = "Docker", lazydocker = "LazyDocker",
  ssh = "SSH", yazi = "Yazi",
  go = "Go", cargo = "Rust", rustc = "Rust", lua = "Lua",
  btop = "Btop", htop = "Htop",
}

wezterm.on("format-tab-title", function(tab, tabs, panes, _config, hover, max_width)
  local process = basename(tab.active_pane.foreground_process_name)

  local pane_title = tab.active_pane.title:lower()
  local shells = {
    zsh = true, bash = true, fish = true, nu = true,
    pwsh = true, powershell = true, cmd = true,
    wsl = true, wslhost = true
  }

  if shells[process] then
      for key, _ in pairs(titles) do
        if pane_title:find(key, 1, true) then
          process = key
          break
        end
      end
  end

  local icon = icons[process] or wezterm.nerdfonts.cod_terminal
  local title = titles[process] or process

  local bg = "#16181a"
  local fg = "#7b8496"

  if tab.is_active then
    bg = "#24283b"
    fg = "#ffffff"
  elseif hover then
    bg = "#2b3244"
    fg = "#d8dee9"
  end

  title = wezterm.truncate_right(title, max_width - 11)

  return {
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = "    " .. icon .. "  " .. title .. "    " },
  }
end)

return config
