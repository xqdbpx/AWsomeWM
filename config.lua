
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

apps.Editor_cmd = apps.Terminal .. " -e " .. apps.Editor 

local config = {
    apps = apps
  }

return config
