local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local statusbar = {}


-- 1. Wiget Board
statusbar.layout_indicator = wibox.widget.textbox()
statusbar.layout_indicator:set_text(" US ") -- Начальное значение

function statusbar.update_layout()
    awful.spawn.easy_async_with_shell("xkblayout-state print '%s'", function(stdout)
        local layout = stdout:gsub("%s+", ""):upper()
        if layout ~= "" then
        statusbar.layout_indicator:set_text(" " .. layout .. " ")
      end
  end)
end

gears.timer {
    timeout = 0.3,
    autostart = true,
    call_now = true,
    callback = function()
      statusbar.update_layout()
    end
}
mytextclock = wibox.widget.textclock("%H:%M")
-- 3. (Wibar)
function statusbar.setup(s)
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
