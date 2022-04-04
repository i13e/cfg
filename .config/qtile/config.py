# -*- coding: utf-8 -*-
import os
#import re
import socket
import subprocess
from typing import List  # noqa: F401
import psutil

from libqtile.config import (
	Key,
	Screen,
	Group,
	Drag,
	Click,
	ScratchPad,
	DropDown,
	Match,
    #Keychord,
)
from libqtile import layout, bar, widget, hook
from libqtile.lazy import lazy
#from libqtile.utils import guess_terminal
from libqtile import qtile

mod = "mod4"                # sets mod key to SUPER/WINDOWS
terminal = "alacritty"      # sets default terminal program
location = "brooklyn"       # sets location for OpenWeather

keys = [
# The essentials
    Key([mod], "Tab", lazy.next_layout()),

    Key([mod],"d",
        lazy.group["scratchpad"].dropdown_toggle("term"),
		desc="Toggle dropdown terminal"),
    Key([mod, "shift"], "r", lazy.restart()),
    Key([mod, "shift"], "q", lazy.shutdown()),
    Key([mod, "shift"], "c", lazy.window.kill()),

         ### Switch focus to specific monitor
         Key([mod], "w",
            lazy.to_screen(0),
            desc='Keyboard focus to monitor 1'),
         Key([mod], "e",
            lazy.to_screen(1),
            desc='Keyboard focus to monitor 2'),
         Key([mod], "r",
            lazy.to_screen(2),
            desc='Keyboard focus to monitor 3'),
         ### Switch focus of monitors
         Key([mod], "period",
            lazy.next_screen(),
            desc='Move focus to next monitor'),
         Key([mod], "comma",
            lazy.prev_screen(),
            desc='Move focus to prev monitor'),
         ### Treetab controls
          Key([mod, "shift"], "h",
            lazy.layout.move_left(),
            desc='Move up a section in treetab'),
         Key([mod, "shift"], "l",
            lazy.layout.move_right(),
            desc='Move down a section in treetab'),
         ### Window controls
         Key([mod], "j",
            lazy.layout.down(),
            desc='Move focus down in current stack pane'),
         Key([mod], "k",
            lazy.layout.up(),
            desc='Move focus up in current stack pane'),
         Key([mod, "shift"], "j",
            lazy.layout.shuffle_down(),
            lazy.layout.section_down(),
            desc='Move windows down in current stack'),
         Key([mod, "shift"], "k",
            lazy.layout.shuffle_up(),
            lazy.layout.section_up(),
            desc='Move windows up in current stack'),
         Key([mod], "h",
            lazy.layout.shrink(),
            lazy.layout.decrease_nmaster(),
            desc='Shrink window (MonadTall), decrease number in master pane (Tile)'),
         Key([mod], "l",
            lazy.layout.grow(),
            lazy.layout.increase_nmaster(),
            desc='Expand window (MonadTall), increase number in master pane (Tile)'),
         Key([mod], "n",
            lazy.layout.normalize(),
            desc='normalize window size ratios'),
         Key([mod], "m",
            lazy.layout.maximize(),
            desc='toggle window between minimum and maximum sizes'),
         Key([mod, "shift"], "f",
            lazy.window.toggle_floating(),
            desc='toggle floating'),
         Key([mod], "f",
            lazy.window.toggle_fullscreen(),
            desc='toggle fullscreen'),
         ### Stack controls
        Key([mod, "shift"], "Tab",
            lazy.layout.rotate(),
            lazy.layout.flip(),
            desc='Switch which side main pane occupies (XmonadTall)'),
        Key([mod], "space",
            lazy.layout.next(),
            desc='Switch window focus to other pane(s) of stack'),
        Key([mod, "shift"], "space",
            lazy.layout.toggle_split(),
            desc='Toggle between split and unsplit sides of stack'),
        ]

workspaces = [
	{"name": "爵", "key": "1", "matches": [
            Match(wm_class="brave-browser")
        ], "lay": "bsp"
    },
	{"name": "","key": "2","matches": [
			Match(wm_class="geary"),
			Match(wm_class="ptask"),
			Match(wm_class="pantheon-calendar"),
		],"lay": "bsp",
	},
	{"name": "", "key": "3", "matches": [
            Match(wm_class="joplin"),
		    Match(wm_class="libreoffice"),
		    Match(wm_class="evince"),
		],"lay": "columns",
	},
	{"name": "", "key": "4", "matches": [
            Match(wm_class="code")
        ], "lay": "bsp"
    },
	{"name": "", "key": "5", "matches": [

        ], "lay": "bsp"
    },
	{"name": "", "key": "6", "matches": [
		    Match(wm_class="Ferdi"),
		    Match(wm_class="discord"),
		    Match(wm_class="polari"),
		],"lay": "bsp",
	},
	{"name": "阮", "key": "7", "matches": [
            Match(wm_class="ncmpcpp"),
            Match(wm_class="spotify"),
        ],"lay": "bsp"
    },
	{"name": "辶", "key": "8", "matches": [
            Match(wm_class="gimp")
        ], "lay": "bsp"
    },
	{"name": "", "key": "9", "matches": [

        ], "lay": "bsp"},
	{"name": "漣", "key": "0", "matches": [
			Match(wm_class="blueman-manager"),
			Match(wm_class="pavucontrol"),
			Match(wm_class="nm-connection-editor"),
		],"lay": "bsp",
	},
]

groups = [
	ScratchPad(
		"scratchpad",
		[
			# define a drop down terminal.
			# it is placed in the upper third of screen by default.
			DropDown(
				"term",
				"alacritty --class dropdown", #-e tmux_startup.sh
				height=0.6,
				on_focus_lost_hide=False,
				opacity=0.85,
				warp_pointer=False,
			),
		],
	),
]

for workspace in workspaces:
	matches = workspace["matches"] if "matches" in workspace else None
	groups.append(Group(workspace["name"], matches=matches, layout=workspace["lay"]))
	keys.append(
		Key(
			[mod],
			workspace["key"],
			lazy.group[workspace["name"]].toscreen(),
			desc="Focus this desktop",
		)
	)
	keys.append(
		Key(
			[mod, "shift"],
			workspace["key"],
			lazy.window.togroup(workspace["name"]),
			desc="Move focused window to another group",
		)
	)

# Define colors
colors = [
    ["#2e3440", "#2e3440"],  # 0 background
    ["#d8dee9", "#d8dee9"],  # 1 foreground
    ["#3b4252", "#3b4252"],  # 2 background lighter
    ["#bf616a", "#bf616a"],  # 3 red
    ["#a3be8c", "#a3be8c"],  # 4 green
    ["#ebcb8b", "#ebcb8b"],  # 5 yellow
    ["#81a1c1", "#81a1c1"],  # 6 blue
    ["#b48ead", "#b48ead"],  # 7 magenta
    ["#88c0d0", "#88c0d0"],  # 8 cyan
    ["#e5e9f0", "#e5e9f0"],  # 9 white
    ["#4c566a", "#4c566a"],  # 10 grey
    ["#d08770", "#d08770"],  # 11 orange
    ["#8fbcbb", "#8fbcbb"],  # 12 super cyan
    ["#5e81ac", "#5e81ac"],  # 13 super blue
    ["#242831", "#242831"],  # 14 super dark background
]
layout_theme = {
    "border_width": 3,
    "margin": 6,
    "border_focus": "d77bc6", #3b4252
    "border_normal": "81a1c1",
    "font": "monospace",
    "grow_amount": 2,
}

layouts = [
    # layout.MonadWide(**layout_theme),
    layout.Bsp(**layout_theme, fair=False),
    layout.Columns(
        **layout_theme,
        border_on_single=True,
        num_columns=2,
        border_focus_stack='#3b4252',
        border_normal_stack='#3b4252',
        split=False,
        wrap_focus_columns=True,
        wrap_focus_rows=True,
        wrap_focus_stacks=True),
    # layout.RatioTile(**layout_theme),
    # layout.VerticalTile(**layout_theme),
    # layout.Matrix(**layout_theme, columns=3),
    #CustomZoomy(**layout_theme, columnwidth=250),
    #layout.Zoomy(**layout_theme),
    #layout.Slice(**layout_theme, width=1920, fallback=layout.TreeTab(), match=Match(wm_class="joplin"), side="right"),
    layout.TreeTab(
        **layout_theme,
        active_bg=colors[2],
        active_fg=colors[1],
        bg_color=colors[0],
        urgent_bg=colors[3],
        urgent_fg=colors[0],
        fontsize=16,
        inactive_bg=colors[14],
        inactive_fg=colors[1],
        sections=["Adenine", "Cytosine", "Guanine", "Thymine"],
        section_fontsize=18,
        section_fg=colors[1],
        section_top=12,
        section_bottom=12,
        section_left=6,
        section_padding=6,
        vspace=2,
        margin_y=10,
        margin_left=10,
        padding_left = 9,
        padding_x = 3,
        padding_y = 5,
        panel_width=300),
    #layout.MonadTall(**layout_theme),
    #layout.Max(**layout_theme),
    #layout.Tile(shift_windows=True, **layout_theme),
    #layout.Stack(num_stacks=2, **layout_theme),
    layout.Floating(**layout_theme, fullscreen_border_width=3, max_border_width=3),
    #Plasma(**layout_theme, border_normal_fixed='#3b4252', border_focus_fixed='#3b4252', border_width_single=3),
]
#prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())


# Configuration variables (TODO: move widget defaults here?)
auto_fullscreen = True
bring_front_click = "floating_only"
cursor_warp = False
dgroups_key_binder = None
dgroups_app_rules = []  # type: List
extension_defaults = dict(
    font="monospace",
    fontsize=18,
    padding=0,
    background=colors[0],
)
floating_layout = layout.Floating(
	**layout_theme,
	float_rules=[
		# Run the utility of `xprop` to see the wm class and name of an X client.
		*layout.Floating.default_float_rules,
		Match(title="pinentry"),        # GPG key password entry
		Match(title="Qalculate!"),      # qalculate-gtk
		Match(wm_class="ssh-askpass"),  # ssh-askpass
		Match(wm_class="kdenlive"),
		Match(title="Farge"),           # TODO
		Match(wm_class="eog"),          # TODO
		Match(wm_class="blueman-manager"),
	],
)
focus_on_window_activation = "focus"
follow_mouse_focus = True
widget_defaults = extension_defaults.copy()
reconfigure_screens = True
wmname = "qtile"
auto_minimize = True


# Setup bar
# Define functions for bar
def taskwarrior():
	return (
		subprocess.check_output(["taskbar.sh"])
		.decode("utf-8")
		.strip()
	)


def longNameParse(text):
    for string in ["Chromium", "Firefox", "Brave", "Ferdi", "NVIM"]: #Add any other apps that have long names here
        if string in text:
            text = string
        else:
            text = text
    return text


### Mouse_callback functions
def finish_task():
	qtile.cmd_spawn('task "$((`cat /tmp/tw_polybar_id`))" done')


# Don't keep?
def open_launcher():
	qtile.cmd_spawn("./.config/rofi/launchers/colorful/launcher.sh")


def toggle_bluetooth():
	qtile.cmd_spawn("./.config/qtile/system-bluetooth-bluetoothctl.sh --toggle")


def todays_date():
	qtile.cmd_spawn("./.config/qtile/calendar.sh")


screens = [
	Screen(
		top=bar.Bar(
            [
				widget.TextBox(
					text="ﮂ",
					foreground=colors[13],
					fontsize=28,
					padding=20,
                    #	mouse_callbacks={"Button3": lambda: open_launcher},
				),
				widget.TextBox(
					text="",
					foreground=colors[14],
					fontsize=48,
					padding=0,
				),
                widget.GroupBox(
                    padding=5,
                    active=colors[9],
                    inactive=colors[10],
                    disable_drag=True,
                    rounded=True,
                    highlight_color=colors[2],
                    block_highlight_text_color=colors[6],
                    highlight_method="block",
                    this_current_screen_border=colors[14],
                    this_screen_border=colors[7],
                    other_current_screen_border=colors[14],
                    other_screen_border=colors[14],
                    foreground=colors[1],
                    background=colors[14],
                    urgent_border=colors[3],
                ),
				widget.TextBox(
					text="",
					foreground=colors[14],
					fontsize=48,
					padding=0,
				),
                widget.Sep(
					linewidth=0,
					foreground=colors[2],
					padding=10,
					size_percent=40,
				),
				widget.TextBox(
					text="",
					foreground=colors[14],
					fontsize=48,
					padding=0,
				),
				widget.CurrentLayoutIcon(
					custom_icon_paths=[os.path.expanduser("~/.config/qtile/icons")],
					foreground=colors[2],
					background=colors[14],
					padding=-5,
					scale=0.70,
				),
				widget.TextBox(
					text="",
					foreground=colors[14],
					fontsize=48,
					padding=0,
				),
				widget.Sep(
					linewidth=0,
					foreground=colors[2],
					padding=10,
					size_percent=50,
				),
                widget.TextBox(
					text="",
					foreground=colors[14],
					fontsize=48,
					padding=0,
				),
                widget.GenPollText(
					func=taskwarrior,
					update_interval=5,
					foreground=colors[11],
					background=colors[14],
					mouse_callbacks={"Button1": finish_task},
				),
				widget.TextBox(
					text="",
					foreground=colors[14],
			    	fontsize=48,
					padding=0,
				),
				widget.Spacer(),
				widget.TextBox(
				    text=" ",
				    foreground=colors[12],
                    padding=0,
				),
				widget.WindowName(
				    foreground=colors[12],
                    for_current_screen=True,
				    width=bar.CALCULATED,
				    empty_group_string="Desktop",
				    max_chars=40,
                    mouse_callbacks={"Button2": lambda: qtile.cmd_spawn("xdotool getwindowfocus windowkill")},
                    parse_text=longNameParse,
				),
				#widget.TextBox(
				#	text="",
				#	foreground=colors[14],
				#	fontsize=48,
				#	padding=0,
				#),
				#widget.TaskList(
				#	border=colors[6],
				#	background=colors[14],
				#	highlight_method="block",
				#	icon_size=24,
				#	#margin=10,
				#	#padding=8,
				#	margin_y=14,
				#	#margin_x=0,
				#	padding_y=2,
				#	#padding_x=0,
				#	spacing=0,
				#	max_title_width=36,
				#	title_width_method="uniform",
				#	urgent_alert_method="block",
				#	urgent_border=colors[3],
				#	txt_floating="",
				#	txt_maximized="",
				#	txt_minimized="",
				#	icon_y=12,
				#	icon_x=1,
				#	#length=bar.CALCULATED,
				#),
				#widget.TextBox(
				#	text="",
				#	foreground=colors[14],
				#	fontsize=48,
				#	padding=0,
				#),
				 widget.CheckUpdates(
                    #distro="Arch",
				    foreground=colors[3],
				    colour_have_updates=colors[3],
				    display_format=" {updates}",
                    #colour_no_updates=colors[12],
                    #no_update_string=" 0",
				    mouse_callbacks={"Button2": lambda: qtile.cmd_spawn("alacritty -e paru")},
                    custom_command="paru -Qua ; checkupdates",
				    padding=20,
				),
				widget.Spacer(),
                widget.TextBox(
					text="",
					foreground=colors[14],
					fontsize=48,
					padding=0,
				),
				widget.Systray(
                    icon_size=26,
                    background=colors[14],
                    padding=0,
                ),
				widget.Pomodoro(
				    background=colors[14],
                    padding=5,
                    fontsize=20,
				    color_active=colors[3],
				    color_break=colors[6],
				    color_inactive=colors[10],
				    #timer_visible=False,
                    #length_pomodori=25
                    #length_short_break=5
                    #length_long_break=15
                    #num_pomodori=4
				    prefix_active=" ",
				    prefix_break=" ",
				    prefix_inactive=" ",
				    prefix_long_break=" ",
				    prefix_paused=" ",
				),
				widget.TextBox(
					text="",
					foreground=colors[14],
					fontsize=48,
					padding=0,
				),
				widget.Sep(
					linewidth=0,
					foreground=colors[2],
					padding=10,
					size_percent=50,
				),
                widget.TextBox(
					text="",
					foreground=colors[14],
					fontsize=48,
					padding=0,
				),
				widget.TextBox(
					text="墳 ",
					foreground=colors[8],
					background=colors[14],
				),
				widget.PulseVolume(
					foreground=colors[8],
                    #emoji=True,
					background=colors[14],
					limit_max_volume="True",
                    mouse_callbacks={"Button3": lambda: qtile.cmd_spawn("pavucontrol")},
				),
				widget.TextBox(
					text="",
					foreground=colors[14],
					fontsize=48,
					padding=0,
				),
				widget.Sep(
					linewidth=0,
					foreground=colors[2],
					padding=10,
					size_percent=50,
				),
				#widget.TextBox(
				#   text="",
				#   foreground=colors[14],
				#   fontsize=28,
				#   padding=0,
				#),
				#widget.TextBox(
				#    text=" ",
				#    foreground=colors[6],
				#    background=colors[14],
				#    # fontsize=38,
				#),
				#widget.Bluetooth(
				#    background=colors[14],
				#    foreground=colors[6],
				#    hci="/dev_00_0A_45_0D_24_47",
				#    mouse_callbacks={
				#       "Button1": toggle_bluetooth,
				#       "Button3": open_bt_menu,
				#    },
				#),
				#widget.TextBox(
				#   text="",
				#   foreground=colors[14],
				#   fontsize=28,
				#   padding=0,
				#),
				#widget.Sep(
				#   linewidth=0,
				#   foreground=colors[2],
				#   padding=10,
				#   size_percent=50,
				#),
				widget.TextBox(
					text="",
					foreground=colors[14],
					fontsize=48,
					padding=0,
				),
                widget.OpenWeather(
                    background=colors[14],
                    foreground=colors[7],
                    app_key="7834197c2338888258f8cb94ae14ef49",
                    location=location,
                    language="en",
                    metric=False,
                    format="{icon} {main_temp:.0f}°{units_temperature}",
                    # from https://github.com/sffjunkie/qtile-openweathermap/blob/de368ac36736391dfafe18367f9d12c2fc258149/owm.py#L37
                    # NOTE: Nerdfonts is missing the Material Design icon for partly cloudy night
                    weather_symbols={
                        "01d": "\U0000fa98",  # Clear sky 滛望
                        "01n": "\U0000fa93",
                        "02d": "\U0000fa94",  # Few clouds 杖
                        "02n": "\U0000e37e",
                        "03d": "\U0000fa94",  # Scattered Clouds 杖
                        "03n": "\U0000e37e",
                        "04d": "\U0000fa8f",  # Broken clouds 摒
                        "04n": "\U0000fa8f",
                        "09d": "\U0000fa95",  # Shower Rain 歹
                        "09n": "\U0000fa95",
                        "10d": "\U0000fa95",  # Rain 歹
                        "10n": "\U0000fa95",
                        "11d": "\U0000fb7c",  # Thunderstorm ﭼ
                        "11n": "\U0000fb7c",
                        "13d": "\U0000fa97",  # Snow 流
                        "13n": "\U0000fa97",
                        "50d": "\U0000fa90",  # Mist 敖
                        "50n": "\U0000fa90",
                        "sleetd": "\U0000fb7d",
                        "sleetn": "\U0000fb7d",
                    },
                ),
                widget.TextBox(
					text="",
					foreground=colors[14],
					fontsize=48,
					padding=0,
				),
				widget.Sep(
					linewidth=0,
					foreground=colors[2],
					padding=10,
					size_percent=50,
				),
                #widget.TextBox(
				#	text="",
				#	foreground=colors[14],
				#	fontsize=48,
				#	padding=0,
				#),
				#widget.TextBox(
				#	text=" ",
				#	foreground=colors[7],  # fontsize=38
				#	background=colors[14],
				#),
				#widget.Wlan(
				#	interface="wlp61s0",
				#	format="{essid}",
				#	foreground=colors[7],
				#	background=colors[14],
				#	padding=5,
				#	mouse_callbacks={"Button1": open_connman},
				#),
				#widget.TextBox(
				#	text="",
				#	foreground=colors[14],
				#	fontsize=48,
				#	padding=0,
				#),
				#widget.Sep(
				#	linewidth=0,
				#	foreground=colors[2],
				#	padding=10,
				#	size_percent=50,
				#),
				widget.TextBox(
					text="",
					foreground=colors[14],
					fontsize=48,
					padding=0,
				),
                widget.Battery(
                    fontsize=18,
                    full_char="",
                    charge_char="",
                    discharge_char="",
                    empty_char="",
                    unknown_char="",
                    format="{char} {percent:2.0%}",
                    foreground=colors[5],
                    low_foreground=colors[3],
                    low_percentage=0.25,
                    background=colors[14],
                    notify_below=0.1,
				    mouse_callbacks={"Button3": lambda: qtile.cmd_spawn(terminal + ' -e btm')},
                ),
                widget.TextBox(
					text="",
					foreground=colors[14],
					fontsize=48,
					padding=0,
				),
                widget.Sep(
					linewidth=0,
					foreground=colors[2],
					padding=10,
					size_percent=50,
				),
				widget.TextBox(
					text="",
					foreground=colors[14],
					fontsize=48,
					padding=0,
				),
				widget.TextBox(
					text=" ",
					foreground=colors[4],  # fontsize=38
					background=colors[14],
				),
				widget.Clock(
					format="%a %d %R",
					foreground=colors[4],
					background=colors[14],
					#    mouse_callbacks={"Button1": todays_date},
				),
				widget.TextBox(
					text="",
					foreground=colors[14],
					fontsize=48,
					padding=0,
				),
				widget.TextBox(
					text="⏻",
					foreground=colors[13],
					fontsize=28,
					padding=20,
					mouse_callbacks={"Button3": lambda: qtile.cmd_spawn("sysact")},
				),
			],
            25,
            #margin=[0, 0, 21, 0],
            border_width=[5, 0, 5, 0],
            border_color="#2e3440",
        ),
		#bottom=bar.Gap(18),
		#left=bar.Gap(18),
		#right=bar.Gap(18),
    ),
]


# Drag floating layouts.
mouse = [
	Drag([mod],"Button1",lazy.window.set_position_floating(),start=lazy.window.get_position(),),
	Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
	Click([mod], "Button2", lazy.window.bring_to_front()),]


# Startup scripts
@hook.subscribe.startup_once
def start_once():
	home = os.path.expanduser("~")
	subprocess.call([home + "/.config/qtile/autostart.sh"])


# Window swallowing
@hook.subscribe.client_new
def _swallow(window):
	pid = window.window.get_net_wm_pid()
	ppid = psutil.Process(pid).ppid()
	cpids = {
		c.window.get_net_wm_pid(): wid for wid, c in window.qtile.windows_map.items()
	}
	for i in range(5):
		if not ppid:
			return
		if ppid in cpids:
			parent = window.qtile.windows_map.get(cpids[ppid])
			parent.minimized = True
			window.parent = parent
			return
		ppid = psutil.Process(ppid).ppid()


@hook.subscribe.client_killed
def _unswallow(window):
	if hasattr(window, "parent"):
		window.parent.minimized = False


# Go to group when app opens on matched group
@hook.subscribe.client_new
def modify_window(client):
	# if (client.window.get_wm_transient_for() or client.window.get_wm_type() in floating_types):
	#    client.floating = True

	for group in groups:  # follow on auto-move
		match = next((m for m in group.matches if m.compare(client)), None)
		if match:
			targetgroup = client.qtile.groups_map[
				group.name
			]  # there can be multiple instances of a group
			targetgroup.cmd_toscreen(toggle=False)
			break
