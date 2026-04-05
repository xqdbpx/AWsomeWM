local awful= require("awful")
local naughty= require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")

--APPS 
local config= require("config")                                                                                       
local apps = config.apps
--KEY
local modkeys = require("binds.modkeys")
local modkey, alt, ctrl, shift = table.unpack(modkeys)


-- {{{ Key bindings
awful.keyboard.append_global_keybindings{
-- Screen Light 
    awful.key({ shift }, "XF86AudioRaiseVolume", function () awful.spawn.with_shell("brightnessctl s 11%+") end),
    awful.key({ shift }, "XF86AudioLowerVolume", function ()  awful.spawn.with_shell("brightnessctl s 11%-") end),
-- Volume 
    awful.key({ }, "XF86AudioRaiseVolume", function () awful.spawn.with_shell("wpctl set-volume @DEFAULT_SINK@ 12%+") end),
    awful.key({ }, "XF86AudioLowerVolume", function () awful.spawn.with_shell("wpctl set-volume @DEFAULT_SINK@ 12%-") end),
    awful.key({modkey, "Mod1"}, "m", function () awful.spawn("wpctl set-mute @DEFAULT_SINK@ toggle") end),
  }

awful.keyboard.append_global_keybindings{
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey, shift   }, "h",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey, shift   }, "l",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "`", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, shift   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, shift   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, ctrl }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, ctrl }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
  }
  awful.keyboard.append_global_keybindings{
    -- Standard program
    awful.key({ modkey}, "t", function () awful.spawn(apps.Terminal) end,
              {description = "open a terminal", group = "launcher"}),
  
    awful.key({ modkey}, "w", function() awful.spawn(apps.Browser) end,
              {description = "open main brouser", group = "launcher"}),

    awful.key({ modkey, shift }, "w", function() awful.spawn(apps.Browser2) end,
              {description = "open two brouser", group = "launcher"}),
    
    awful.key({ modkey, alt }, "w", function() awful.spawn(apps.DevBrowser) end,
              {description = "open dev brouser", group = "launcher"}),
    awful.key({modkey}, "c", function() awful.spawn(apps.IDE) end,
              {description = "My IDE", group= "launcher"}),
    }

awful.keyboard.append_global_keybindings{
   --
    awful.key({ modkey, ctrl }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, shift }, "Delete", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",    function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, shift   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey,  ctrl   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, ctrl    }, "h",     function () awful.tag.incncol( 1, nil, true)    end,

              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, ctrl }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "Tab", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, shift   }, "Tab", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, ctrl }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, F12,
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
}

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
--
for i = 1, 9 do
    awful.keyboard.append_global_keybindings({
        -- View tag only
        awful.key({ modkey }, "#" .. i + 9, function ()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                tag:view_only()
            end
        end, { description = "view tag #" .. i, group = "tag" }),

        -- Toggle tag display
        awful.key({ modkey, "Control" }, "#" .. i + 9, function ()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end, { description = "toggle tag #" .. i, group = "tag" }),

        -- Move client to tag
        awful.key({ modkey, "Shift" }, "#" .. i + 9, function ()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end, { description = "move focused client to tag #" .. i, group = "tag" }),

        -- Toggle tag on focused client
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function ()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end, { description = "toggle focused client on tag #" .. i, group = "tag" })
    })
end
