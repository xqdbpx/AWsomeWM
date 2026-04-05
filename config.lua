
local apps = {
  Browser = 'zen-browser',
  Browser2 = 'firefox', 
  DevBrowser = 'chromium',
  Terminal = "kitty",
  Editor = os.getenv("EDITOR") or "vim",
  Anky = "anky",
  IDE = "code",
  Launcher = "rofi"
}

local function AutoTollRun(cmd)
  local findme = cmd:match("%S+")
  awful.spawn.with_shell(string.format("pgrep -u $USER -x %s > /dev/null || (%s)", findme, cmd))
end

local utils = {
  keyboard = "setxkbmap -layout 'us,ru' -option 'grp:win_space_toggle'",
  wifi = "nm-applet",
  picom = "picom",
  gestures= "libinput-gestures-setup start",
}
apps.Editor_cmd = apps.Terminal .. " -e " .. apps.Editor 

local config = {
    apps = apps,
    utils = utils,
    AutoTollrun()
  }

return config
