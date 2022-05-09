# -*- coding: utf-8 -*-
import os

# import re
# import socket
import subprocess
from typing import List
from libqtile.utils import guess_terminal  # noqa: F401
from libqtile import qtile
import psutil

from libqtile import layout, bar, widget, hook
from libqtile.dgroups import simple_key_binder
from libqtile.lazy import lazy
from libqtile.config import (
    EzClick as Click,
    EzDrag as Drag,
    EzKey as Key,
    Screen,
    Group,
    ScratchPad,
    DropDown,
    Match,
    # Keychord,
)
from keys import KbdOverview

terminal = guess_terminal()

modifier_keys = dict(
    M="mod4",
    A="mod1",
    S="shift",
    C="control",
)
# current = qtile.current_layout.name
keys = [
    ### The essentials
    # Key("M-<Enter>", lazy.spawn(terminal)),
    # Key("M-S-<Enter>" lazy.spawn(dmenu_run)),
    Key("M-d", lazy.group["scratchpad"].dropdown_toggle("term")),
    Key("M-a", lazy.function(KbdOverview().toggle)),
    Key("M-<Tab>", lazy.next_layout()),
    Key("M-S-<Tab>", lazy.prev_layout()),
    Key("M-S-r", lazy.restart()),
    Key("M-S-q", lazy.shutdown()),
    Key("M-S-c", lazy.window.kill()),
    ### Switch focus to specific monitor (out of three)
    # M-w, lazy.to_screen(0)),
    # M-e, lazy.to_screen(1)),
    # M-r, lazy.to_screen(2)),
    ### Switch focus of monitors
    Key("M-<period>", lazy.next_screen()),
    Key("M-<comma>", lazy.prev_screen()),
    ### Window controls
    ## Change focus
    Key("M-h", lazy.layout.left()),
    Key("M-j", lazy.layout.down()),
    Key("M-k", lazy.layout.up()),
    Key("M-l", lazy.layout.right()),
    Key("M-<space>", lazy.layout.next()),
    # lazy.layout.previous()),
    ## Move windows within group
    Key(
        "M-S-h",
        lazy.layout.move_left().when(layout="treetab"),
        lazy.layout.shuffle_left(),
        # lazy.layout.client_to_previous(),
        lazy.layout.swap_left().when(layout=["monadtall", "monadwide"]),
    ),
    Key(
        "M-S-j",
        lazy.layout.move_down().when(layout="treetab"),
        lazy.layout.shuffle_down(),
    ),
    Key(
        "M-S-k",
        lazy.layout.move_up().when(layout="treetab"),
        lazy.layout.shuffle_up(),
    ),
    Key(
        "M-S-l",
        lazy.layout.move_right().when(layout="treetab"),
        lazy.layout.shuffle_right(),
        # lazy.layout.client_to_next(),
        lazy.layout.swap_right().when(layout=["monadtall", "monadwide"]),
    ),
    ## Flip layouts
    Key(
        "M-C-h",
        lazy.layout.flip_left(),
        lazy.layout.swap_column_left(),
        lazy.layout.integrate_left(),
    ),
    Key(
        "M-C-j",
        lazy.layout.flip_down(),
        lazy.layout.section_down().when(layout="treetab"),
        lazy.layout.integrate_down(),
    ),
    Key(
        "M-C-k",
        lazy.layout.flip_up(),
        lazy.layout.section_up().when(layout="treetab"),
        lazy.layout.integrate_up(),
    ),
    Key(
        "M-C-l",
        lazy.layout.flip_right(),
        lazy.layout.swap_column_right(),
        lazy.layout.integrate_right(),
    ),
    # Key("M-S-<space>", lazy.layout.flip())),
    ## Resize windows
    Key("M-A-h", lazy.layout.grow_width(-30)),
    Key("M-A-j", lazy.layout.grow_height(-30)),
    Key("M-A-k", lazy.layout.grow_width(30)),
    Key("M-A-l", lazy.layout.grow_height(30)),
    Key("M-n", lazy.layout.normalize()),
    # Key("M-n", lazy.layout.reset_size()),
    # lazy.layout.grow()),
    # lazy.layout.shrink()),
    ## Window states
    Key("M-f", lazy.window.toggle_fullscreen()),
    Key("M-S-f", lazy.window.toggle_floating()),
    Key("M-m", lazy.window.toggle_maximize()),
    # Key("M-h", lazy.window.toggle_minimize()),
    # Key("M-S-h", lazy.group.unminimize_all()),
    ## TODO, Adjust paddings/margins
    ### Plasma controls
    # Key("M-o", lazy.layout.mode_horizontal().when(layout="plasma")),
    # Key("M-u", lazy.layout.mode_vertical().when(layout="plasma")),
    # Key("M-S-o", lazy.layout.mode_horizontal_split().when(layout="plasma")),
    # Key("M-S-u", lazy.layout.mode_vertical_split().when(layout="plasma")),
    ### Toggle split direction
    Key("M-s", lazy.layout.toggle_split()),
    ### Floating controls
    # Key("M-<bracketleft>", lazy.group.prev_window()),
    # Key("M-<bracketleft>", lazy.window.bring_to_front()),
    # Key("M-<bracketright", lazy.group.next_window()),
    # Key("M-<bracketright", lazy.window.bring_to_front()),
    ### Treetab controls
    Key("M-v", lazy.layout.expand_branch().when(layout="treetab")),
    Key("M-S-v", lazy.layout.collapse_branch().when(layout="treetab")),
    ### Monad controls
    # lazy.layout.decrease_nmaster()),
    # lazy.layout.increase_nmaster()),
    # lazy.layout.rotate()),
]

# Define groups
groups = [
    # define a drop down terminal.
    # it is placed in the upper third of screen by default.
    ScratchPad(
        "scratchpad",
        [
            DropDown(
                "term",
                "alacritty --class dropdown",  # -e tmux_startup.sh
                height=0.6,
                on_focus_lost_hide=False,
                opacity=0.85,
                warp_pointer=False,
            ),
        ],
    ),
    Group("1", label="爵", matches=[Match(wm_class="brave-browser")], layout="bsp"),
    Group("2", label="﬏", matches=[Match(wm_class=["code", "emacs"])], layout="bsp"),
    Group(
        "3",
        label="",
        matches=[Match(wm_class=["geary", "ptask", "pantheon-calendar"])],
        layout="bsp",
    ),
    Group(
        "4",
        label="",
        matches=[Match(wm_class=["joplin", "libreoffice", "zathura", "evince"])],
        layout="bsp",
    ),
    Group("5", label="", matches=[Match(wm_class=["firefox"])], layout="bsp"),
    Group(
        "6",
        label="",
        matches=[Match(wm_class=["ferdi", "discord", "polari"])],
        layout="bsp",
    ),
    Group(
        "7",
        label="阮",
        matches=[Match(wm_class=["spotify", "ncmpcpp", "cmus"])],
        layout="bsp",
    ),
    Group("8", label="辶", matches=[Match(wm_class=["gimp"])], layout="bsp"),
    Group("9", label="", matches=[Match(wm_class=["pcmanfm"])], layout="bsp"),
    Group(
        "10",
        label="漣",
        matches=[
            Match(wm_class=["nm-connection-editor", "blueman-manager", "pavucontrol"])
        ],
        layout="floating",
    ),
]


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
    ["#d77bc6", "#d77bc6"],  # 15 border focus
]


# Configuration variables
auto_fullscreen = True
bring_front_click = "floating_only"
cursor_warp = True
dgroups_key_binder = simple_key_binder("mod4")
dgroups_app_rules = []
extension_defaults = dict(
    background=colors[0],
    font="monospace",
    fontsize=18,
    padding=0,
)
layout_defaults = dict(
    font="monospace",
    border_width=3,
    margin=6,
    border_focus=colors[7],  # colors[15]
    border_normal=colors[6],  # colors[2]
    grow_amount=2,
)
floating_layout = layout.Floating(
    **layout_defaults,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(title="pinentry"),  # GPG key password entry
        Match(title="Qalculate!"),  # qalculate-gtk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(wm_class="kdenlive"),
        Match(title="Farge"),
        Match(wm_class="eog"),
        Match(wm_class="blueman-manager"),
    ],
)
focus_on_window_activation = "focus"
follow_mouse_focus = True
widget_defaults = extension_defaults.copy()
reconfigure_screens = True
wmname = "qtile"
auto_minimize = True


# Available layouts
layouts = [
    layout.Bsp(**layout_defaults, fair=False, border_on_single=True),
    layout.Columns(
        **layout_defaults,
        border_on_single=True,
        num_columns=2,
        border_focus_stack=colors[7],
        border_normal_stack=colors[6],
        split=False,
        wrap_focus_columns=True,
        wrap_focus_rows=True,
        wrap_focus_stacks=True,
    ),
    # layout.Zoomy(**layout_defaults, columnwidth=250),
    # layout.TreeTab(
    #    **layout_defaults,
    #    active_bg=colors[2],
    #    active_fg=colors[1],
    #    bg_color=colors[0],
    #    urgent_bg=colors[3],
    #    urgent_fg=colors[0],
    #    fontsize=16,
    #    inactive_bg=colors[14],
    #    inactive_fg=colors[1],
    #    sections=["Adenine", "Cytosine", "Guanine", "Thymine"],
    #    section_fontsize=18,
    #    section_fg=colors[1],
    #    section_top=12,
    #    section_bottom=12,
    #    section_left=6,
    #    section_padding=6,
    #    vspace=2,
    #    margin_y=10,
    #    margin_left=10,
    #    padding_left=9,
    #    padding_x=3,
    #    padding_y=5,
    #    panel_width=300,
    # ),
    # layout.MonadTall(**layout_defaults),
    # layout.Stack(num_stacks=2, **layout_defaults),
    # layout.Matrix(**layout_defaults, columns=3),
    # layout.Max(**layout_defaults),
    # layout.MonadWide(**layout_defaults),
    # layout.Slice(**layout_defaults, width=1920, match=Match(wm_class="joplin"), side="right"),
    # layout.RatioTile(**layout_defaults),
    # layout.Tile(shift_windows=True, **layout_defaults),
    # layout.VerticalTile(**layout_defaults),
    floating_layout,
]


# prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())


# Define functions for bar
def taskwarrior():
    return subprocess.check_output(["taskbar.sh"]).decode("utf-8").strip()


location = subprocess.check_output(["zipcode"]).decode("utf-8").strip()


# TODO: write a script to read volume faster
get_volume = (
    subprocess.check_output(["levels", "volume", "get"]).decode("utf-8").strip()
)


def longNameParse(text):
    for string in [
        "Chromium",
        "Firefox",
        "Brave",
        "Ferdi",
        "NVIM",
    ]:  # Add other apps that have long names here
        if string in text:
            text = string
        else:
            text = text
    return text


### Mouse_callback functions
def finish_task():
    qtile.cmd_spawn('task "$((`cat /tmp/tw_polybar_id`))" done')


# Don't keep?
def toggle_bluetooth():
    qtile.cmd_spawn("./.config/qtile/system-bluetooth-bluetoothctl.sh --toggle")


def todays_date():
    qtile.cmd_spawn("./.config/qtile/calendar.sh")


# widget templates
def l_text():
    return widget.TextBox(
        text="",
        foreground=colors[14],
        fontsize=48,
    )


def sep():
    return widget.Sep(
        padding=10,
        foreground=colors[2],
        linewidth=0,
        size_percent=50,
    )


def r_text():
    return widget.TextBox(
        text="",
        foreground=colors[14],
        fontsize=48,
    )


screens = [
    Screen(
        top=bar.Bar(
            [
                widget.TextBox(
                    text="ﮂ",
                    foreground=colors[13],
                    fontsize=28,
                    padding=20,
                    mouse_callbacks={"Button3": lambda: qtile.cmd_spawn(terminal)},
                ),
                l_text(),
                widget.GroupBox(
                    padding=5,
                    borderwidth=0,
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
                r_text(),
                sep(),
                l_text(),
                widget.CurrentLayoutIcon(
                    custom_icon_paths=[os.path.expanduser("~/.config/qtile/icons")],
                    foreground=colors[2],
                    background=colors[14],
                    padding=-5,
                    scale=0.70,
                ),
                r_text(),
                sep(),
                l_text(),
                widget.GenPollText(
                    func=taskwarrior,
                    update_interval=5,
                    foreground=colors[11],
                    background=colors[14],
                    mouse_callbacks={"Button1": finish_task},
                ),
                r_text(),
                widget.Spacer(),
                widget.TextBox(
                    text=" ",
                    foreground=colors[12],
                ),
                widget.WindowName(
                    foreground=colors[12],
                    for_current_screen=True,
                    width=bar.CALCULATED,
                    empty_group_string="Desktop",
                    max_chars=20,
                    mouse_callbacks={
                        "Button2": lambda: qtile.cmd_spawn(
                            "xdotool getwindowfocus windowkill"
                        )
                    },
                    parse_text=longNameParse,
                ),
                widget.CheckUpdates(
                    # distro="Arch",
                    foreground=colors[3],
                    colour_have_updates=colors[3],
                    display_format=" {updates}",
                    # colour_no_updates=colors[12],
                    # no_update_string=" 0",
                    mouse_callbacks={
                        "Button2": lambda: qtile.cmd_spawn("alacritty -e paru")
                    },
                    custom_command="paru -Qua ; checkupdates",
                    padding=20,
                ),
                widget.Spacer(),
                l_text(),
                widget.Systray(
                    icon_size=26,
                    background=colors[14],
                ),
                widget.Pomodoro(
                    background=colors[14],
                    padding=5,
                    fontsize=20,
                    color_active=colors[3],
                    color_break=colors[6],
                    color_inactive=colors[10],
                    # timer_visible=False,
                    # length_pomodori=25
                    # length_short_break=5
                    # length_long_break=15
                    # num_pomodori=4
                    prefix_active=" ",
                    prefix_break=" ",
                    prefix_inactive=" ",
                    prefix_long_break=" ",
                    prefix_paused=" ",
                ),
                r_text(),
                sep(),
                l_text(),
                widget.TextBox(
                    text="墳 ",
                    foreground=colors[8],
                    background=colors[14],
                ),
                widget.PulseVolume(
                    foreground=colors[8],
                    # emoji=True,
                    get_volume_command=get_volume,
                    background=colors[14],
                    limit_max_volume="True",
                    mouse_callbacks={"Button3": lambda: qtile.cmd_spawn("pavucontrol")},
                ),
                r_text(),
                sep(),
                l_text(),
                widget.OpenWeather(
                    background=colors[14],
                    foreground=colors[7],
                    app_key="7834197c2338888258f8cb94ae14ef49",
                    zip=location,
                    language="en",
                    metric=False,
                    format="{icon} {temp:.0f}°{units_temperature}",
                    # from https://github.com/sffjunkie/qtile-openweathermap/blob/de368ac36736391dfafe18367f9d12c2fc258149/owm.py#L37
                    # NOTE: Nerdfonts is missing the MD icon for partly cloudy night
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
                r_text(),
                sep(),
                l_text(),
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
                    mouse_callbacks={
                        "Button3": lambda: qtile.cmd_spawn(terminal + " -e btm")
                    },
                ),
                r_text(),
                sep(),
                l_text(),
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
                r_text(),
                widget.TextBox(
                    text="⏻",
                    foreground=colors[13],
                    fontsize=28,
                    padding=20,
                    mouse_callbacks={"Button3": lambda: qtile.cmd_spawn("sysact")},
                ),
            ],
            25,
            margin=[0, 0, 10, 0],
            border_width=[5, 0, 5, 0],
            border_color="#2e3440",
        ),
        bottom=bar.Gap(10),
        left=bar.Gap(10),
        right=bar.Gap(10),
    ),
]


# Drag floating layouts.
mouse = [
    Drag("M-1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag("M-3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click("M-2", lazy.window.bring_to_front()),
    Click("M-C-3", lazy.spawn("jgmenu --csv-file=~/.config/jgmenu/qtile.csv")),
    Click("M-A-3", lazy.spawn("jgmenu_run")),
]

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
