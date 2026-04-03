local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local statusbar = {}


-- 1. Wiget Board
statusbar.layout_indicator = wibox.widget.textbox(" US ")
mytextclock = wibox.widget.textclock("%H:%M")

function statusbar.update_layout()
    awful.spawn.easy_async_with_shell("xkblayout-state print '%s'", function(stdout)
        local layout = stdout:gsub("%s+", ""):upper()
        if layout ~= "" then
        statusbar.layout_indicator:set_text(" " .. layout .. " ")
      end
    end)
end

-- Menubar configuration
menubar.utils.terminal = apps.Terminal -- Set the terminal for applications that require it
-- }}}

gears.timer {
  timeout = 0.3,
  autostart = true,
  call_now = true,
  callback = function()
  statusbar.update_layout()
end
}



-- 3. (Wibar)
function statusbar.setup(s)

awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Menu
   myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", apps.Terminal .. " -e man awesome" },
   { "edit config", apps.Editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

    mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu }) 

    -- Virtual Screens 
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Processe list
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    --Creeate Wibar
    s.mywibox = awful.wibar({ position = "top", screen = s })

    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Лево
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
        },
        s.mytasklist, -- Центр
        { -- Право
            layout = wibox.layout.fixed.horizontal,
            statusbar.layout_indicator,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox
        },
    }
end

return statusbar
