--{{{HEADER
--------------------------------------------------------------------------------
--          
--         FILE:  rc.lua
--        USAGE:  ./rc.lua 
--  DESCRIPTION:  Mi configuracion de Awesome WM :P
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:  w4rlock GPL
--      COMPANY:  
--      VERSION:  1.0
--      CREATED:  04/23/2011 03:05:29 PM ART
--     REVISION:  ---
--------------------------------------------------------------------------------
--}}}

-- {{{ IMPORTS LIBRARIES

require("awful")            --Standard awesome library
require("awful.autofocus") 
require("awful.rules")      --Reglas de las applicaciones
--require("mail/mail-long")   --GMail Widget
require("beautiful")        --Theme handling library
require("naughty")          --Notification library
require("vicious")          --Framework Widget

-- }}}

-- {{{ VARIABLES ----------------------------------------------------
dir = awful.util.getdir("config") --DIR DE LA CONF DE AWESOME
beautiful.init(dir.."/themes/default/theme.lua")

env = {
     interface  = "wlan0",
      terminal  = os.getenv("TERMINAL") or "urxvt",
        editor  = os.getenv("EDITOR") or "vim",
       browser  = "firefox",
    wallpapers  = "/media/Multimedia/PICTURES"

      }

 editor_cmd = env.terminal .. " -e " .. env.editor

--naughty.config.padding = 10
--naughty.config.height = 30
--naughty.config.width = 300

modkey = "Mod4"
altkey = "Mod1"

local msg --PARA LAS NOTIFICACIONES 
-- }}}

--{{{ LAYOUTS ------------------------------------------------------
require("menu") --Menu de Awesome
layouts =
{
    awful.layout.suit.tile,            -- 1
    awful.layout.suit.tile.left,       -- 2 
    awful.layout.suit.tile.bottom,     -- 3
    awful.layout.suit.tile.top,        -- 4
    awful.layout.suit.fair,            -- 5
    awful.layout.suit.fair.horizontal, -- 6
    --awful.layout.suit.spiral,        -- 7
    --awful.layout.suit.spiral.dwindle,-- 8
    awful.layout.suit.max,             -- 9
    --awful.layout.suit.max.fullscreen,-- 10
    awful.layout.suit.magnifier,     -- 11
    awful.layout.suit.floating         -- 12
}
-- }}}

--{{{ AWESOME MENU MAPPING

awful.menu.menu_keys = {
       up = {"Up","k"},
     down = {"Down","j"},
     back = {"Left","h"},
     exec = {"Return","Right","l"},
    close = {"Escape","q"},
    }

--}}}

-- {{{ AUTORUN APPS INIT

autorun = true
autorunApps = {"urxvt"
               --,"script"
               --,"otroProgram"
              }
if autorun then
    for app = 1, #autorunApps do
        awful.util.spawn(autorunApps[app])
    end
end


--}}}

-- {{{ CONFIGS POR TAG -----------------------------------------------
index = 1
labels = { "1:arch", "2:term", "3:vim", "4:dev", "5:mpd", "6:www","7:hack" }
workspace = {}
for d = 1, #labels do -- VISIBILIDAD POR CADA TAG
    workspace[d] = { witop = true, wibottom = false }
end

--}}}

-- {{{ TAGS ----------------------------------------------------------
tags = {}
for s = 1, screen.count() do
    tags[s] = awful.tag(labels,s, layouts[2]) 
end
--}}}

-- {{{ KEYBOARD ACTIONS 
local keyboard_action = {
           raisevol = "amixer set Speaker 2%+",
     raisevolMaster = "amixer set Master 2%+",
           lowervol = "amixer set Speaker 2%-",
     lowervolMaster = "amixer set Master 2%-",
               mute = "amixer set 'Master' toggle",
               next = "mpc next",
               prev = "mpc prev",
               play = "mpc toggle"
             --stop = "mpc stop"
             --Mail = env.terminal .. " -e mutt"
             --Mail = env.browser .. " http://www.gmail.com"
                 }

--}}}

-- {{{ WIBOX CREATION 
mysystray = widget({ type = "systray" }) --soporte para iconos 
       mywibox = {}
mywibox_bottom = {}
   mypromptbox = {}
   mylayoutbox = {}
     mytaglist = {}
--}}}

--{{{ TAGLIST MAPPINGS 
mytaglist.buttons = awful.util.table.join(
                    awful.button({        } , 1, awful.tag.viewonly),
                    awful.button({ modkey } , 1, awful.client.movetotag),
                    awful.button({        } , 3, awful.tag.viewtoggle),
                    awful.button({ modkey } , 3, awful.client.toggletag),
                    awful.button({        } , 4, awful.tag.viewnext),
                    awful.button({        } , 5, awful.tag.viewprev)
                    )
mytasklist = {}
--}}}

--{{{ FUNCTIONS 

--{{{HIDDEN TAGS TO SHOW PROMPT
function taghidde(t, bool)
     for s = 1, screen.count() do
         for i, t in ipairs(tags[s]) do
           awful.tag.setproperty(t, "hide", bool)
          end
     end
end
--}}}

--{{{

function naughty_error(text)
     if text then
         naughty.notify({ text = text, timeout = 3, 
                          fg = "#FF0000", --RED
                          border_color = "#610101", 
                          position = "top_right" })
     end
end

--}}}

--{{{RESIZE WIBOX
function resize_wibox(w, porc)
         if w.width + porc < 1367 then --TOMAR RESOLUCION SCREEN IN WORKING
              w.width = w.width + porc
              awful.wibox.align(w, w.align, 1)

              dbg({'W:'..w.width, 'H:'..w.height, 'X:'..w.x, 'Y:'..w.y})
         end
end 
--}}}

--{{{ SCROLL
--function scroll(text, maxlen, widget)
    --if not scroller[widget] then
        --scroller[widget] = { i = 1, d = true }
    --end

    --local txtlen = text:len()
    --local state  = scroller[widget]

    --if txtlen > maxlen then
        --if state.d then
            --text = text:sub(state.i, state.i + maxlen) .. "..."
            --state.i = state.i + 3

            --if maxlen + state.i >= txtlen then
                --state.d = false
            --end
        --else
            --text = "..." .. text:sub(state.i, state.i + maxlen)
            --state.i = state.i - 3

            --if state.i <= 1 then
                --state.d = true
            --end
        --end
    --end

    --return text
--end
--}}}

--{{{ ESCAPE CHARS

function escape(text)
    local xml_entities = {
        ["\""] = "&quot;",
        ["&"]  = "&amp;",
        ["'"]  = "&apos;",
        ["<"]  = "&lt;",
        [">"]  = "&gt;"
    }
return text and text:gsub("[\"&'<>]", xml_entities)
end
--}}}

--{{{ DUBUGGER VARIABLES 

function dbg(vars)
  local text = ""
  for i=1, #vars do 
     text = text .. vars[i] .. " | " 
  end

  naughty.notify({ text = setColor(text), timeout = 3, 
                   border_color = "#006666",
                 })
end
--}}}

--{{{ DEBUGGER CLIENT 
function dbg_client(c)
    local text = ""
    if c.class then
        text = "CLASS: "..c.class 
    end
    if c.instance then
        text = text .. "\nINST: "..c.instance
    end
    if c.type then
       text = text .. "\nTYPE: "..c.type 
    end
    if c.role then
        text = text .. "\nROLE: "  .. c.role
    end
    naughty.notify({ text = text, timeout = 5 })
end

-- USAGE: MODKEY + X DBG({VAR1, VAR2, VAR3}) en minusculas	
--}}}

--{{{ SET COLOR WIDGET
function setColor(txt, clr)
    if clr then
        return "<span foreground='".. color[clr] .."'>"..txt.."</span>"
    end
    return "<span foreground='".. color.CYAN .."'>"..txt.."</span>"
end
--}}}


--{{{ MENU_HIDE 
--Oculta el menu principal y el menu de la lista de tareas
--El menu de awesome no puede tener nil
function menu_hide(menu, isTasklist)
    if menu then
        menu:hide()
        if isTasklist then 
            menu = nil
        end
    end
end
--}}}

--{{{ WIBOX_HIDE 
function wibox_hide()
    mywibox[mouse.screen].visible = workspace[index].witop
    mywibox_bottom[mouse.screen].visible = workspace[index].wibottom
end
--}}}

--}}} END FUNCTIONS

--{{{ WIDGETS ------------------------------------------------------

--{{{ NETWORK 

net = widget({ type = "textbox" })
vicious.register(net,
                vicious.widgets.net, setColor("NET:") .. 
                setColor("${" ..env.interface.. " down_kb}KB|${"..env.interface.. " up_kb}KB","DARKCYAN"), 3)
--}}}

--{{{ SEPARATOR 

spacer    = widget({ type = "textbox" })
spacer.text = setColor(" :: ","MAGENTA")

--}}}

--{{{ CLOCK - DATE 
datewidget = widget({ type = "textbox" })
vicious.register(datewidget, vicious.widgets.date,
                setColor("%b %e, %R ","CYAN"), 61)
--}}}

--{{{ TEMP CPU 
--tempwidget = widget({ type = "textbox" })
    --vicious.register(tempwidget, vicious.widgets.thermal,
    --function (widget, args)
        --if  args[1] >= 65 and args[1] < 75 then
            --return setColor("TEM: ") .. setColor(args[1] .. "°C","YELLOW")
        --elseif args[1] >= 75 and args[1] < 80 then
            --return setColor("TEM: ") .. setColor(args[1] .. "°C","RED")
        --else
            --return setColor("TEM: ") .. setColor(args[1] .. "°C","DARKCYAN")
        --end
    --end, 19, "thermal_zone0" )
--}}}

-- {{{ UPTIME 

uptimewidget = widget({ type = "textbox", height=20 })
vicious.register(uptimewidget, vicious.widgets.uptime,
function (widget, args)
return string.format(setColor("UP:")..setColor("%2d:%02d:%02d ","DARKCYAN"), args[1], args[2], args[3]) end, 61)

-- }}}

--{{{ CPU USAGE 

cpu = widget({ type = "textbox" })

cpu_g1 = awful.widget.graph({ layout = awful.widget.layout.horizontal.rightleft })
cpu_g1:set_width(50)
cpu_g1:set_background_color("#101010")
cpu_g1:set_color("#00FFFF")
cpu_g1:set_border_color("#0a0a0a")
cpu_g1:set_gradient_colors({ '#0B615E', '#01DFD7', '#81F7F3' })
vicious.register(cpu_g1, vicious.widgets.cpu, "$2", 1)

cpu_g2 = awful.widget.graph({ layout = awful.widget.layout.horizontal.rightleft })
cpu_g2:set_width(50)
cpu_g2:set_background_color("#101010")
cpu_g2:set_color("#00FFFF")
cpu_g2:set_border_color("#0a0a0a")
cpu_g2:set_gradient_colors({ '#0B615E', '#01DFD7', '#81F7F3' })

vicious.register(cpu_g2, vicious.widgets.cpu, "$3", 1)

--}}}

--{{{ WIFI 

--wifiwidget = widget({type = "textbox"})
--vicious.register(wifiwidget, vicious.widgets.wifi, setColor("${ssid}")..setColor(" ${link}% ${rate} ","DARKCYAN"), 5, "eth1")

--}}}

--{{{ BATTERY NOTEBOOK 

batwidget = widget({ type = "textbox" })
vicious.register(batwidget, vicious.widgets.bat, setColor("BAT:")..setColor("$1$2%","DARKCYAN"), 61, "BAT0")

--}}}

--{{{ FILESYSTEM 

fs = widget({ type = "textbox" })
vicious.register(fs, vicious.widgets.fs, setColor("FS:")..setColor("${/ used_gb}GB ${/ used_p}%","DARKCYAN"), 20)

--}}}

--{{{ MEM 

mem = widget({ type = "textbox" })
vicious.register(mem,vicious.widgets.mem, setColor("MEM:")..setColor("$1% $2MB","DARKCYAN"),2)

--}}}

--{{{ TEMP 

--tempinfo = widget({ type = "textbox", align = "right" })
--function get_temp()
	--local s = ""
	--local filedescriptor = io.popen('awk \'{print $2 "°C"}\' /proc/acpi/thermal_zone/TZ00/temperature')
	--local value = filedescriptor:read()
	--filedescriptor:close()
	--s = setColor( .. "TEM:" .. color.Close .. color.DARKCYAN .. value .. color.Close
	--return s
--end

--}}}

--{{{ CPU 

jiffies = {}
   function activecpu()
	   local s = ""
	   for line in io.lines("/proc/stat") do
		   local cpu, newjiffies = string.match(line, "(cpu%d)\ +(%d+)")
		   if cpu and newjiffies then
			   if not jiffies[cpu] then
				   jiffies[cpu] = newjiffies
			   end
			   s = s .. setColor("CPU:")..setColor((newjiffies-jiffies[cpu]) .. "% ","DARKCYAN")
			   jiffies[cpu] = newjiffies
		   end
	   end
	   return s
   end

--}}}

--{{{ MUSIC ICON 
--music = widget({ type = "imagebox" })
--music.image = image(dir.."/images/music-icon.png")
--
--}}}

--{{{ MAIL ICON 

mail = widget({ type = "imagebox" })
mail.image = image(dir.."/images/mail.gif")
mail:buttons(awful.util.table.join(
             awful.button({ }, 1, function () 
                                     awful.util.spawn_with_shell(env.terminal.." -e mutt") 
                                  end)
             ))
--}}}

--{{{ MPD AUDIO 
local coverart_nf
now_playing = ""
mpdwidget = widget({ type = "textbox"})
function now_playing_update()
     local inf = io.popen(dir.."/bash/w4rlockInfo.sh -m")
     now_playing = escape(inf:read())

     if now_playing ~= " - " then 
        if now_playing:len() > 57 then
           now_playing = now_playing:sub(1,57).."..."
        end
        mpdwidget.text = setColor(" "..now_playing)
     else
        now_playing = ""
        mpdwidget.text = setColor(" MPD:")..setColor(" -- ","DARKCYAN")
     end
     inf:close()
end
	--Al hacer click sobre el widget de music
    mpdwidget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () 
							  awful.util.spawn_with_shell(keyboard_action.prev) 
							  now_playing_update()
							  coverart_show()
	end),
    awful.button({ }, 3, function () 
							  awful.util.spawn_with_shell(keyboard_action.next) 
							  now_playing_update()
							  coverart_show()
	end)))

mpdwidget:add_signal("mouse::enter", function() coverart_show()             end)
mpdwidget:add_signal("mouse::leave", function() notify_destroy(msg) end)

-- }}}

--{{{ KEYBOARD LANG 
--CAMBIO RAPIDO DE IDIOMA DE TECLADO ES - US
keyboard_lang = widget({ type = "textbox"})
keyboard_lang.text = setColor("[US]")
keyboard_lang:buttons(awful.util.table.join(
                      awful.button({ }, 1, function()
                                              if keyboard_lang.text:sub(29,30) == "ES" then
                                                 keyboard_lang.text = setColor("[US]","CYAN")
                                                 awful.util.spawn_with_shell("setxkbmap us")
                                              else
                                                 keyboard_lang.text = setColor("[ES]","CYAN")
                                                 awful.util.spawn_with_shell("setxkbmap es")
                                              end
                                            end)))
--}}}

--}}} END WIDGETS

--{{{ NOTIFICATIONS

--{{{ NOTIFY SHOW MPD 
function coverart_show()
    notify_destroy(msg)
    --naughty.destroy(msg)
    if now_playing ~= "" then
         local img = awful.util.pread(dir.."/bash/w4rlockCoverart.sh")
         local ico = image(img)

         -- Leo la info
         local musicSH = io.popen(dir.."/bash/w4rlockMusicinfo.sh")

         -- Quito caracteres especiales
         local txt = setColor("Title:  ") .. setColor(escape(musicSH:read()),"YELLOW") .. "\n"
                  .. setColor("Artist: ") .. setColor(escape(musicSH:read()),"YELLOW") .. "\n"
                  .. setColor("Album:  ") .. setColor(escape(musicSH:read()),"YELLOW") .. "\n"
                  .. setColor("Genre:  ") .. setColor(escape(musicSH:read()),"YELLOW") .. "\n"
                  .. setColor("Year:   ") .. setColor(escape(musicSH:read()),"YELLOW") 
                   --.. setColor("Time:   ") .. setColor(escape(musicSH:read()),"YELLOW")
         musicSH:close()
         -- Muestro la notificacion
         -- Para que la notificacion no moleste cuando escribimos en la shell
         local pos
         if mywibox_bottom[mouse.screen].visible then
              --SI SE CAMBIO DE POSICION EL WIBOX QUE CONTIENE EL WIDGET DEL MPD LO SIGO
              pos = awful.wibox.get_position(mywibox_bottom[mouse.screen]).."_left"
         else
              pos = "top_right"
         end

         --coverart_nf = naughty.notify({
         msg  = naughty.notify({
                       icon = ico, 
                       icon_size = 61, 
                       timeout = 3,
                       text = txt, 
                       border_color = "#006666",
                       position = pos
                       })
     end
end
-- }}}

-- {{{ NOTIFY DESTROY 
function notify_destroy(notificacion)
    if notificacion ~= nil then
        naughty.destroy(notificacion)
    end
end
-- }}}

-- {{{ PLAY SOUND BACKGROUND
function play_sound(path)
     awful.util.spawn_with_shell("mplayer -quiet " .. path .. " > /dev/null 2>&1")
end
-- }}}

--{{{ NOTIFY BATTERY NOTEBOOK 
	function getNotification()
        porc = string.sub(batwidget.text,67,68)		
        sign = string.sub(batwidget.text, 66,66)
        if sign == '-' then
            if porc == '15' or porc == '10' then
               naughty_error("Danger battery low")
               play_sound("~/.irssi/sounds/default.mp3")
            end
        end
	end
--}}}

--{{{ NOTIFY VOLUME LEVEL 
-- msg es para no mostrar mas de una notificacion
function getVolumenLevel()
     if msg ~= nil then
          naughty.destroy(msg)
          naughty.destroy(coverart_nf)
     end
     local f = io.popen(dir..'/bash/w4rlockVolumen.sh')
     local pcm = setColor("PCM: ") ..setColor(f:read(),"YELLOW").."\n"
     pcm = pcm .. setColor("MST: ")..setColor(f:read(),"YELLOW")
     
     msg = naughty.notify({ text=pcm, timeout=1, border_color = "#006666",
                            icon= dir.."/images/emblem-sound2.png"
                          })
end
--}}}

--}}} END NOTIFICATIONS

-- {{{ TIMERS (UPDATE WIDGETS) 
timers = {}
timers["cpu"] = timer({ timeout = 2 })
timers["cpu"]:add_signal("timeout", function()
									 cpu.text = activecpu()
									 now_playing_update()
							 end)
timers["cpu"]:start()

timers["bat"] = timer({ timeout = 28})
timers["bat"]:add_signal("timeout", function() getNotification() end)
timers["bat"]:start()

--timers["mpd"] = timer({ timeout = 2})
--timers["mpd"]:add_signal("timeout", function() now_playing_update() end)
--timers["mpd"]:start()
--}}}

--{{{ TASKLIST MOUSE MAPPINGS
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
											  	  menu_hide(mymainmenu,nil)
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
                                          end))
--}}}

--{{{ INSERT WIDGETS 
for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.

    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)


    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)


    -- Create the wibox
    mywibox[s] = awful.wibox({ align="center", position = "top", screen = s})
    -- POSICIONAR EL  WIDGET TOP-BOTTOM LEFT-RIGHT ARRASTRANDOLO CON EL MOUSE
    mywibox[s]:buttons(awful.util.table.join( 
                       --awful.button({  }, 1,              function () awful.mouse.wibox.move(mywibox[s]) end),
                       awful.button({ modkey }, 3,        function () resize_wibox(mywibox[s], -20) end),
                       awful.button({ modkey }, 1,        function () resize_wibox(mywibox[s], 20) end)
             ))
    
    --mywibox[s] = awful.wibox({ align="center", position = "top", screen = s, width=1200 })
        -- Create a table with widgets that go to the right
    right_aligned = {  layout = awful.widget.layout.horizontal.rightleft }

    if s == 1 then table.insert(right_aligned, mysystray) end

	table.insert(right_aligned, mylayoutbox[s])
	table.insert(right_aligned, datewidget)
	--table.insert(right_aligned, spacer)
	--table.insert(right_aligned, mail)
	--table.insert(right_aligned, w_imap) 
	table.insert(right_aligned, spacer)
	table.insert(right_aligned, keyboard_lang)
     table.insert(right_aligned, spacer)
     table.insert(right_aligned, cpu_g1)
     table.insert(right_aligned, cpu_g2)
     table.insert(right_aligned, spacer)
	table.insert(right_aligned, cpu)
	table.insert(right_aligned, spacer)
	table.insert(right_aligned, batwidget)
	table.insert(right_aligned, spacer)
     table.insert(right_aligned, net)
	table.insert(right_aligned, spacer)
	table.insert(right_aligned, fs)
	table.insert(right_aligned, spacer)
	table.insert(right_aligned, mem)

    mywibox[s].widgets = {
	   mylauncher,
        mytaglist[s],
        spacer,
        mypromptbox[s],
        right_aligned,
        layout = awful.widget.layout.horizontal.leftright,
        height = mywibox[s].height
    }
	
    mywibox_bottom[s] = awful.wibox({ align="center", position = "bottom", screen = s, height=16 })
    mywibox_bottom[s]:buttons(awful.util.table.join( 
                       --awful.button({  }, 1, function () awful.mouse.wibox.move(mywibox_bottom[s]) end),
                       awful.button({ modkey }, 3,        function () resize_wibox(mywibox_bottom[s], -20) end),
                       awful.button({ modkey }, 1,        function () resize_wibox(mywibox_bottom[s], 20) end)
             ))
    mywibox_bottom[s].visible = false
    mywibox_bottom[s].widgets={
	{ 
		layout = awful.widget.layout.horizontal.rightleft,
		uptimewidget,
		spacer
		--wifiwidget
		--batwidget,
		--spacer

	},
		layout = awful.widget.layout.horizontal.leftright,
		mpdwidget,
		spacer,
          --mypromptbox[s],
		mytasklist[s]
	 }
end
-- }}}

-- {{{ MOUSE EVENTS ON DESKTOP
root.buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn_with_shell('setWallpaper.sh -r ' .. env.wallpapers) end),
    awful.button({ }, 3, function () 
							menu_hide(instance,true)							
							mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ APPLICATIONS MAPPINGS
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

  --{{{ KEYBOARD MULTIMEDIA

	awful.key({}, "XF86AudioMute", 
	               function() awful.util.spawn_with_shell(keyboard_action.mute) 
	               end),
	awful.key({}, "XF86AudioRaiseVolume",
				  function() --++++++++++++++++++++++++++++++++++++++++++++++++ PCM UP
							awful.util.spawn_with_shell(keyboard_action.raisevol)
							getVolumenLevel()
				  end),
	awful.key({ modkey }, "XF86AudioRaiseVolume", 
				  function() --++++++++++++++++++++++++++++++++++++++++++++++++ MASTER UP
							awful.util.spawn_with_shell(keyboard_action.raisevolMaster)
							getVolumenLevel()
				  end),
	awful.key({}, "XF86AudioLowerVolume",
				  function() --++++++++++++++++++++++++++++++++++++++++++++++++ PCM DOWN
							awful.util.spawn_with_shell(keyboard_action.lowervol) 
							getVolumenLevel()
				  end),
	awful.key({ modkey }, "XF86AudioLowerVolume",
				  function() --++++++++++++++++++++++++++++++++++++++++++++++++ MASTER DOWN
							awful.util.spawn_with_shell(keyboard_action.lowervolMaster)
							getVolumenLevel()
				  end),
	awful.key({}, "XF86AudioNext",
				  function() --++++++++++++++++++++++++++++++++++++++++++++++++ NEXT SONG 
							  awful.util.spawn_with_shell(keyboard_action.next) 
							  now_playing_update()
							  coverart_show() 
				  end),
	awful.key({}, "XF86AudioPrev",
				  function()--+++++++++++++++++++++++++++++++++++++++++++++++++ PREVIOUS SONG
							  awful.util.spawn_with_shell(keyboard_action.prev)
							  now_playing_update()
							  coverart_show() 
				  end),
	awful.key({}, "XF86AudioPause", function() awful.util.spawn_with_shell(keyboard_action.pause) end ),
	--awful.key({}, "XF86AudioStop", function() awful.util.spawn_with_shell(keyboard_action.stop) end ),
	awful.key({}, "XF86AudioPlay", function() awful.util.spawn_with_shell(keyboard_action.play) end ),

	--}}}
	
	--awful.key({}, "XF86Mail", function() awful.util.spawn_with_shell(keyboard_action.Mail) end ),
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function ()
											menu_hide(instance,true)
											mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
	awful.key({ modkey,           }, "b", function () 
                                            workspace[index].witop = not mywibox[mouse.screen].visible
                                            mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible 
                                          end),
	--awful.key({ modkey, "Control" }, "Space", function () 
                                                    --mytasklist[1].visible = not mytasklist[1].visible end),
	awful.key({ modkey,           }, "v", function ()   
                                            workspace[index].wibottom = not mywibox_bottom[mouse.screen].visible
                                            mywibox_bottom[mouse.screen].visible = not mywibox_bottom[mouse.screen].visible 
                                            notify_destroy(coverart_nf)
                                          end),
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(env.terminal)  end),
    awful.key({ modkey, "Control" }, "t",      function () awful.util.spawn("thunar")  end),
    awful.key({ modkey, "Control" }, "c",      function () awful.util.spawn("chromium")  
                                               end),
    awful.key({ modkey, "Control" }, "f",      function () awful.util.spawn("firefox") end),
    awful.key({ modkey, "Control" }, "m",      function () 
                                                           if now_playing ~= "" then 
                                                                 coverart_show()           
                                                           end                         end),
    awful.key({ modkey, "Control" }, "g",      function () awful.util.spawn("gimp")    end),
    awful.key({ modkey, "Control" }, "r",      awesome.restart),
    awful.key({ modkey, "Shift"   }, "q",      awesome.quit),

    awful.key({ modkey,           }, "h",      function () awful.tag.incmwfact(0.05)    end),
    awful.key({ modkey,           }, "l",      function () awful.tag.incmwfact(-0.05)    end),
    --awful.key({ modkey,           }, "l",    function () awful.mouse.cli_res_tiled2()    end),

    awful.key({ modkey,  "Shift"  }, "h",      function () awful.tag.incmwfact(0.15)     end),
    awful.key({ modkey,  "Shift"  }, "l",      function () awful.tag.incmwfact(-0.15)    end),

    --awful.key({ modkey, "Shift"   }, "h",    function () awful.tag.incnmaster( 1)      end),
    --awful.key({ modkey, "Shift"   }, "l",    function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "l",      function () awful.tag.incncol(2)          end),
    awful.key({ modkey, "Control" }, "h",      function () awful.tag.incncol(-2)         end),
    awful.key({ modkey,           }, "space",  function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space",  function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    --awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),
    awful.key({ modkey },            "r",     function () 
    --awful.util.spawn_with_shell( "exe=`dmenu_path | dmenu -b -i -nf '#FFFF00' -nb '#000000' -sf '#000000' -sb '#FFFF00'` && exec $exe") 
    awful.util.spawn_with_shell("dmenu_run -b -i -nf '#04B4AE' -nb '#000000' -sf '#000000' -sb '#00FFFF'") 
    
    end),

    awful.key({ modkey }, "x",
              function ()
                  taghidde(nil,true)
                  awful.prompt.run({ prompt = setColor("Run Lua cod3: ","CYAN")},
                  mypromptbox[mouse.screen].widget,
                  function(arg)
                    taghidde(nil,false)
                    --awful.util.eval
                    res,val = pcall(loadstring(arg))
                    if not res then
                         naughty_error("Invalid lua code: "..arg)
                    end
                  end,
                  function() --completion_callback
                     taghidde(nil,false) 
                  end,
                  awful.util.getdir("cache") .. "/history_eval",
                  120,       --history_max
                  function() --done_callback
                    taghidde(nil,false)
                  end 
                  )
              end)
)
--}}}

--{{{ CLIENT RESIZE MAPPINGS 
clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) 
                                                  c.fullscreen = not c.fullscreen     
                                               end),
    awful.key({ modkey,           }, "z",      
                                             function (c) 
                                                    if awful.client.floating.get(c) then
                                                       awful.client.moveresize(0,0,20,0)   
                                                    end                                 
                                               end),
    awful.key({ modkey, "Shift"   }, "z",      function (c) 
                                                    if awful.client.floating.get(c) then
                                                       awful.client.moveresize(0,0,-20,0)  
                                                    end 
                                               end),
    awful.key({ modkey,           }, "<",      function (c) 
                                                    if awful.client.floating.get(c) then
                                                       awful.client.moveresize(0,0,0,20)   
                                                    end
                                               end),
    awful.key({ modkey, "Shift"   }, "<",      function (c) 
                                                    if awful.client.floating.get(c) then
                                                       awful.client.moveresize(0,0,0,-20)
                                                    end                                 
                                               end),
    awful.key({ modkey, "Shift"   }, "a",      function (c)
                                                    if awful.client.floating.get(c) then
                                                       awful.client.moveresize(0,0,-20,-20)
                                                    end
                                               end),
    awful.key({ modkey,           }, "a",      function (c) 
                                                    if awful.client.floating.get(c) then
                                                       awful.client.moveresize(0,0,20,20)  
                                                    end
                                               end),
    awful.key({ modkey, altkey    }, "h",      function (c) 
                                                    if awful.client.floating.get(c) then
                                                         awful.client.moveresize(-12,0,0,0)  
                                                    end
                                               end),
    awful.key({ modkey, altkey    }, "l",      function (c) 
                                                    if awful.client.floating.get(c) then
                                                         awful.client.moveresize(12,0,0,0)  
                                                    end
                                               end),
    awful.key({ modkey, altkey    }, "j",      function (c) 
                                                    if awful.client.floating.get(c) then
                                                         awful.client.moveresize(0,12,0,0)  
                                                    end
                                               end),
    awful.key({ modkey, altkey    }, "k",      function (c) 
                                                    if awful.client.floating.get(c) then
                                                         awful.client.moveresize(0,-12,0,0)  
                                                    end
                                               end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) 
                                                  c:kill()                         
                                               end),
    awful.key({ modkey, "Control" }, "Return", function (c) 
                                                  c:swap(awful.client.getmaster()) 
                                               end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen),
    awful.key({ modkey, "Shift"   }, "t",      function (c) 
                                                    if beautiful.border_focus == '#000000' then
                                                        beautiful.border_focus = '#04B4AE'
                                                    else
                                                        beautiful.border_focus = '#000000'
                                                    end
                                                    c.border_focus = beautiful.border_focus  end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    -- BUG IN APPLICATIONS WHERE NOT FLOAT (mplayer) "s"
    awful.key({ modkey,           }, "s",      function (c) c.size_hints_honor = not c.size_hints_honor end),
    awful.key({ modkey, "Shift"   }, "v",      function (c) 
                                                c.maximized_vertical   = not c.maximized_vertical
                                                                                             end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey, "Shift"   }, "m",      awful.client.floating.toggle                     ),
    awful.key({ modkey,           }, "m",      function (c)
                                                    c.maximized_horizontal = not c.maximized_horizontal
                                                    c.maximized_vertical   = not c.maximized_vertical
                                               end)
)
--}}}

--{{{ TAGS MAPPINGS
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
                            index = i
                            wibox_hide()
                        end
                        --Oculto la notificacion cuando cambio de tag
                        notify_destroy(coverart_nf)
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
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

--{{{ CLIENT MAPPINGS
clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))
--}}}

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ SIGNALS CLIENT
-- Signal function to execute when a new client appears.
require("rules")     --REGLAS DE LAS APLICACIONES
client.add_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and awful.client.focus.filter(c) then
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

client.add_signal("focus", function(c) 
                                c.border_color = beautiful.border_focus 
                                c.opacity = 0.8
					  end)

client.add_signal("unfocus", function(c) 
                                c.border_color = beautiful.border_normal 
                                --dbg_client(c)
                                c.opacity = 0.9
					    end)
-- }}}

awful.util.spawn_with_shell("sleep 3 && xsetroot -cursor_name left_ptr")
-- vim: foldmethod=marker:filetype=lua:expandtab:shiftwidth=5:tabstop=5:softtabstop=5:textwidth=80
