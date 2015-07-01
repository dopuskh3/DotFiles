local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local wibox = require("wibox")
local utils = require("utils")
local blingbling = require("blingbling")
local battery = require("battery")

awful.autofocus = require("awful.autofocus")
awful.rules = require("awful.rules")
awful.util = require("awful.util")
awful.widget = require("awful.widget")
vicious = require("vicious")

-- {{{ Helper functions:
function run_command_cb (command)
  return (function ()
    awful.util.spawn(command)
  end)
end

-- Tag functions to switch tag on all screens at once
function nextTag (t)
    for s = 1, screen.count() do
      awful.tag.viewnext(screen[s].index)
    end
end

function prevTag (t)
    for s = 1, screen.count() do
      awful.tag.viewprev(screen[s].index)
    end
end


-- }}}

--{{---| Error handling |---------------------------------------------------------------------------

if awesome.startup_errors then
  naughty.notify({ preset = naughty.config.presets.critical,
  title = "Oops, there were errors during startup!",
  text = awesome.startup_errors })
end
do
  local in_error = false
  awesome.connect_signal("debug::error", function (err)
    if in_error then return end
    in_error = true
    naughty.notify({ preset = naughty.config.presets.critical,
    title = "Oops, an error happened!",
    text = err })
    in_error = false
  end)
end



-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/usr/share/awesome/themes/zenburn/theme.lua")


-- This is used later as the default terminal and editor to run.
commands = {
  lock = "slimlock",
  ide = utils.HOME_DIR .. "/.local/idea/bin/idea.sh",
  terminal = "x-terminal-emulator",
  browser = "x-www-browser",
  filebrowser = "nautilus",
  mail = "thunderbird",
  player_next = "spotify-command next",
  player_prev = "spotify-command previous",
  player_pause = "spotify-command playpause",
  volume_up = "amixer -D pulse sset Master 5%+",
  volume_down = "amixer -D pulse sset Master 5%-",
  wallpaper = "awsetbg " .. os.getenv("HOME") .. "/.config/awesome/wallpaper.jpg" 
}

startup_commands = {
  "light-locker",
  "unity-settings-daemon",
  "nm-applet",
  "gnome-sound-applet",
  commands["wallpaper"],
}

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- ######## Line too long (84 chars) ######## :
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
wactionkey = "Alt"
appactionkey = "Mod4"
desktopkey = { "Alt", "Control" }


-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  awful.layout.suit.floating,
  -- awful.layout.suit.spiral,
  -- awful.layout.suit.spiral.dwindle,
  -- awful.layout.suit.max,
  -- awful.layout.suit.max.fullscreen,
  -- awful.layout.suit.magnifier
}
-- }}}

local function mouse_move(x_co,y_co)
  mouse.coords({ x=x_co, y=y_co })
end

function dbg(vars)
  local text = ""
  for i=1, #vars do text = text .. vars[i] .. " | " end
  naughty.notify({ text = text, timeout = 0 })
end

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
  -- Each screen has its own tag table.
  tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}

-- {{{ Menu
mymainmenu = awful.menu({
  items = { 
    { "Terminal", commands["terminal"] },
    { "Browser", commands["browser"] },
    { "Mail", commands["mail"] },
    { "IntelliJ", os.getenv("HOME") .. "/.local/idea/bin/idea.sh" },
    { "Pidgin", "pigin" },
    { "Spotify", "spotify" },
    { "Wallpaper", commands["wallpaper"] },
    { "Restart", awesome.restart },
    { "Quit", awesome.quit },
  }})

spacer       = wibox.widget.textbox()
spacer:set_text(' | ')

--Battery Widget


mylauncher = awful.widget.launcher({
  image = beautiful.awesome_icon,
  menu = mymainmenu 
})

mytextclock = awful.widget.textclock()

mysystray = wibox.widget.systray()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}

mytaglist.buttons = awful.util.table.join(
  awful.button({ }, 1, awful.tag.viewonly),
  awful.button({ modkey }, 1, awful.client.movetotag),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, awful.client.toggletag),
  awful.button({ }, 4, nextTag),
  awful.button({ }, 5, prevTag)
)

mytasklist = {}
mytasklist.buttons = awful.util.table.join(
  awful.button({ }, 1, function (c)
    if not c:isvisible() then
      awful.tag.viewonly(c:tags()[1])
    end
    client.focus = c
    c:raise()
  end),
  awful.button({ }, 3, function ()
    if instancwe then
      instance:hide()
      instance = nil
    else
      instance = awful.menu.clients({ width=250 })
    end
  end),
  awful.button({ }, 4, function ()
    awful.client.focus.byidx(1)
    if client.focus then client.focus:raise() end
  end),
  awful.button({ }, 5, function ()
    awful.client.focus.byidx(-1)
    if client.focus then client.focus:raise() end
  end)
)

for s = 1, screen.count() do
    
  -- Widget : CPU
  cpu_graph = blingbling.line_graph({
    height = 25,
    width = 200,
    show_text = true,
    label = "Load: $percent %",
    rounded_size = 0,
    graph_background_color = "#00000033"
  })

  blingbling.popups.htop(cpu_graph,
  { title_color = beautiful.notify_font,
    user_color = beautiful.notify_fg,
    root_color = beautiful.notify_bg,
    terminal = "urxvt"})
  vicious.register(cpu_graph, vicious.widgets.cpu, "$1", 2)

  -- Widget : Memory
  mem_graph = blingbling.line_graph({
    height = 25,
    width = 200,
    show_text = true,
    label = "Mem: $percent %",
    rounded_size = 0,
    graph_background_color = "#00000033"
  })
  vicious.register(mem_graph, vicious.widgets.mem, "$1", 2)

  batterywidget = wibox.widget.textbox()
  batterywidget_timer = timer({timeout = 1})
  batterywidget_timer:connect_signal("timeout", function()
    batterywidget:set_text(batteryInfo("BAT0"))
  end)
  batterywidget_timer:start()
  batterywidget:set_text(batteryInfo("BAT0"))

  -- Create a promptbox for each screen
  -- ######## Line too long (92 chars) ######## :
  mypromptbox[s] = awful.widget.prompt()
  -- ######## Line too long (94 chars) ######## :
  -- Create an imagebox widget which will contains an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  mylayoutbox[s] = awful.widget.layoutbox(s)
  mylayoutbox[s]:buttons(awful.util.table.join(
  awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
  awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
  awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
  awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
  -- Create a taglist widget
  -- ######## Line too long (90 chars) ######## :
  mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

  -- Create a tasklist widget
  mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

  -- Create the wibox
  mywibox[s] = awful.wibox({ position = "top", screen = s })
  local left_layout = wibox.layout.fixed.horizontal()
  left_layout:add(mylauncher)
  left_layout:add(mytaglist[s])
  left_layout:add(mypromptbox[s])

  local right_layout = wibox.layout.fixed.horizontal()
  right_layout:add(cpu_graph)
  right_layout:add(mem_graph)
  right_layout:add(batterywidget)
  right_layout:add(spacer)
  right_layout:add(mytextclock)
  if s == 1 then
    right_layout:add(mysystray)
  end
  right_layout:add(mylayoutbox[s])
  local layout = wibox.layout.align.horizontal()
  layout:set_left(left_layout)
  layout:set_middle(mytasklist[s])
  layout:set_right(right_layout)
  mywibox[s]:set_widget(layout)

end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
  awful.button({ }, 3, function () mymainmenu:toggle() end),
  awful.button({ }, 4, nextTag),
  awful.button({ }, 5, prevTag)))
-- }}}

  --- {{{ Global keys 
  globalkeys = awful.util.table.join(
  awful.key({ "Mod1", }, "Left",  prevTag),
  awful.key({ "Mod1", }, "Right",  nextTag),
  awful.key({ "Mod1", }, "Escape", awful.tag.history.restore),
  awful.key({ "Mod1", }, "Tab",
    function ()
      awful.client.focus.history.previous()
      if client.focus then
        client.focus:raise()
      end
    end
  ),
  awful.key({ modkey, }, "j",
    function ()
      awful.client.focus.byidx( 1)
      if client.focus then client.focus:raise() end
    end
  ),
  awful.key({ modkey, }, "k",
    function ()
      awful.client.focus.byidx(-1)
      if client.focus then client.focus:raise() end
    end
  ),
  -- Layout manipulation
  awful.key({ modkey, "Shift" }, "j",
    function ()
      awful.client.swap.byidx(1)
    end
  ),
  awful.key({ modkey, "Shift" }, "k",
    function ()
      awful.client.swap.byidx(-1)
    end
  ),
  awful.key({ modkey, "Control" }, "j",
    function ()
      awful.screen.focus_relative( 1)
    end
  ),
  -- ######## Line too long (87 chars) ######## :
  awful.key({ modkey, "Control" }, "k",
    function ()
      awful.screen.focus_relative(-1)
    end
  ),
  awful.key({ modkey, }, "u", awful.client.urgent.jumpto),
  awful.key({ modkey, }, "Tab",
    function ()
      awful.client.focus.history.previous()
      if client.focus then
        client.focus:raise()
      end
    end
  ),
  
  -- Standard program
  awful.key({ modkey, }, "Return", run_command_cb(commands["terminal"])),
  awful.key({ "Control", modkey, "Mod1" }, "Right", run_command_cb(commands["player_next"])),
  awful.key({ "Control", modkey, "Mod1" }, "Left", run_command_cb(commands["player_prev"])),
  awful.key({ "Control", modkey, "Mod1" }, "Up", run_command_cb(commands["volume_up"])),
  awful.key({ "Control", modkey, "Mod1" }, "Down", run_command_cb(commands["volume_down"])),
  awful.key({ "Control", modkey, "Mod1" }, "space", run_command_cb(commands["player_pause"])),
  awful.key({ modkey, }, "c", run_command_cb(commands["terminal"])),
  awful.key({ modkey, }, "l", run_command_cb(commands["lock"])),
  awful.key({ modkey, "Control" }, "r", awesome.restart),
  awful.key({ modkey, "Control"   }, "q", awesome.quit),

  awful.key({ modkey, }, "l", function () awful.tag.incmwfact( 0.05) end),
  awful.key({ modkey, }, "h", function () awful.tag.incmwfact(-0.05) end),
  awful.key({ modkey, "Shift"   }, "h", function () awful.tag.incnmaster( 1) end),
  awful.key({ modkey, "Shift"   }, "l", function () awful.tag.incnmaster(-1) end),
  awful.key({ modkey, "Control" }, "h", function () awful.tag.incncol( 1) end),
  awful.key({ modkey, "Control" }, "l", function () awful.tag.incncol(-1) end),
  awful.key({ modkey, }, "space", function () awful.layout.inc(layouts,  1) end),
  awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

  -- Prompt
  awful.key({ modkey },            "e",     function () mypromptbox[mouse.screen]:run() end),

  -- Other programx
  awful.key({ modkey },   "b", function () awful.util.spawn(commands["browser"]) end),
  awful.key({ modkey },   "m", function () awful.util.spawn(commands["mail"]) end),
  awful.key({ modkey },   "n", function () awful.util.spawn(commands["filebrowser"]) end),

  awful.key({ modkey }, "x",
    function ()
      awful.prompt.run({ prompt = "Run Lua code: " },
      mypromptbox[mouse.screen].widget,
      awful.util.eval, nil,
      awful.util.getdir("cache") .. "/history_eval")
    end
  ),
  awful.key({ "Mod1" }, "s", 
    function(c)
      local newscreen = mouse.screen + 1
      if newscreen > screen.count() then
        newscreen = 1
      end 
      mouse_move(200, 200)
      mouse.screen = newscreen
      -- local xm = mouse.screen.geometry.width/2.0
      -- local ym = mouse.screen.geometry.height/2.0
    end
  )
)
--- }}} Global keys


--- {{{ Client Keys
clientkeys = awful.util.table.join(
  awful.key({ "Mod1" }, "f", function (c) c.fullscreen = not c.fullscreen end),
  awful.key({ "Mod1" }, "q", function (c) c:kill() end),
  awful.key({ "Mod1" }, "w", function (c) c:lower() end),
  awful.key({ "Mod1" }, "space",  awful.client.floating.toggle),
  awful.key({ "Mod1", "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
  awful.key({ "Mod1" }, "o", awful.client.movetoscreen ),
  awful.key({ "Mod1", "Shift" }, "r", function (c) c:redraw() end),
  awful.key({ "Mod1" }, "t", function (c) c.ontop = not c.ontop end),
  awful.key({ "Mod1" }, "n", function (c) c.minimized = not c.minimized end),
  awful.key({ "Mod1" }, "m",
    function (c)
      c.maximized_horizontal = not c.maximized_horizontal
      c.maximized_vertical   = not c.maximized_vertical
    end)
)
-- }}} Client keys 
--



  -- Compute the maximum number of digit we need, limited to 9
  keynumber = 0
  for s = 1, screen.count() do
    keynumber = math.min(9, math.max(#tags[s], keynumber));
  end

  -- Bind all key numbers to tags.
  -- Be careful: we use keycodes to make it works on any keyboard layout.
  -- This should map on the top row of your keyboard, usually 1 to 9.

  for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
    awful.key({ modkey }, "#" .. i + 9,
    function ()
      local screen = mouse.screen
      if tags[screen][i] then
        awful.tag.viewonly(tags[screen][i])
      end
    end),
    awful.key({ modkey, "Control" }, "#" .. i + 9,
    function ()
      local screen = mouse.screen
      if tags[screen][i] then
        awful.tag.viewtoggle(tags[screen][i])
      end
    end),
    awful.key({ "Mod1",  }, "#" .. i + 9,
    function ()
      if client.focus and tags[client.focus.screen][i] then
        awful.client.movetotag(tags[client.focus.screen][i])
      end
    end),
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
    function ()
      if client.focus and tags[client.focus.screen][i] then
        awful.client.toggletag(tags[client.focus.screen][i])
      end
    end))
  end

  clientbuttons = awful.util.table.join(
  awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
  awful.button({ appactionkey }, 1, awful.mouse.client.move),
  awful.button({ appactionkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
    properties = { border_width = beautiful.border_width,
    border_color = beautiful.border_normal,
    focus = true,
    keys = clientkeys,
    buttons = clientbuttons } },
    -- { rule = { class = "X-www-browser" },
    --  properties = { tag = tags[2][1] }},
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
  }
-- }}} client rules

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
  -- Add a titlebar
  -- awful.titlebar.add(c, { modkey = modkey })

  -- Enable sloppy focus
  c:connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
      and awful.client.focus.filter(c) then
      client.focus = c
    end
  end)

  if not startup then
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- awful.client.setslave(c)

    -- Put windows in a smart way, only if they does not set an initial position.
    if not c.size_hints.user_position and not c.size_hints.program_position then
      awful.placement.no_overlap(c)
      awful.placement.no_offscreen(c)
    end
  end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- {{{ Startup applications: 
for i, startup_command in pairs(startup_commands) do
  awful.util.spawn_with_shell(startup_command)
end
-- }}}

