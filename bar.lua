local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local statusbar = {}


-- 1. Создаем виджет индикатора
statusbar.layout_indicator = wibox.widget.textbox()
statusbar.layout_indicator:set_text(" US ") -- Начальное значение

-- 2. Функция обновления (вызывается извне)
function statusbar.update_layout()
    awful.spawn.easy_async_with_shell("setxkbmap -query | grep layout | awk '{print $2}'", function(stdout)
        local layout = stdout:gsub("%s+", ""):upper()
        statusbar.layout_indicator:set_text(" " .. layout .. " ")
    end)
end

-- 3. Функция создания самой панели (Wibar)
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
            statusbar.layout_indicator, -- Наш индикатор
            wibox.widget.systray(),
            wibox.widget.textclock(),
            s.mylayoutbox,
        },
    }
end

return statusbar
