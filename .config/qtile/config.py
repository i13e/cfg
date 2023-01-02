"""
Qtile main config file
======================
Requires: dbus-next, psutil, mypy, jq,
ttf-nerd-fonts-symbols,
"""

import os
import psutil

# import socket
import subprocess

from libqtile import bar, hook, layout, qtile, widget

from libqtile.dgroups import simple_key_binder
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

# from custom import battery
# import traverse
from libqtile.config import (
    EzClick as Click,
    EzDrag as Drag,
    EzKey as Key,
    DropDown,
    Group,
    # Keychord,
    Match,
    ScratchPad,
    Screen,
)

TERM = guess_terminal()  # let qtile guess your terminal


# def focus_previous_group(qtile):
#     group = qtile.current_screen.group
#     group_index = qtile.groups.index(group)
#     previous_group = group.get_previous_group(skip_empty=True)
#     previous_group_index = qtile.groups.index(previous_group)
#     if previous_group_index < group_index:
#         qtile.current_screen.set_group(previous_group)


# def focus_next_group(qtile):
#     group = qtile.current_screen.group
#     group_index = qtile.groups.index(group)
#     next_group = group.get_next_group(skip_empty=True)
#     next_group_index = qtile.groups.index(next_group)
#     if next_group_index > group_index:
#         qtile.current_screen.set_group(next_group)


def window_to_previous_column_or_group(qtile):
    layout = qtile.current_group.layout
    group_index = qtile.groups.index(qtile.current_group)
    previous_group_name = qtile.current_group.get_previous_group().name

    if layout.name != "columns":
        qtile.current_window.togroup(previous_group_name)
    elif layout.current == 0 and len(layout.cc) == 1:
        if group_index != 0:
            qtile.current_window.togroup(previous_group_name)
    else:
        layout.cmd_shuffle_left()


def window_to_next_column_or_group(qtile):
    layout = qtile.current_group.layout
    group_index = qtile.groups.index(qtile.current_group)
    next_group_name = qtile.current_group.get_next_group().name

    if layout.name != "columns":
        qtile.current_window.togroup(next_group_name)
    elif layout.current + 1 == len(layout.columns) and len(layout.cc) == 1:
        if group_index + 1 != len(qtile.groups):
            qtile.current_window.togroup(next_group_name)
    else:
        layout.cmd_shuffle_right()


def window_to_previous_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i != 0:
        group = qtile.screens[i - 1].group.name
        qtile.current_window.togroup(group)


def window_to_next_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i + 1 != len(qtile.screens):
        group = qtile.screens[i + 1].group.name
        qtile.current_window.togroup(group)


# def switch_screens(qtile):
#     if len(qtile.screens) == 1:
#         previous_switch = getattr(qtile, "previous_switch", None)
#         qtile.previous_switch = qtile.current_group
#         return qtile.current_screen.toggle_group(previous_switch)
#
#     i = qtile.screens.index(qtile.current_screen)
#     group = qtile.screens[i - 1].group
#     qtile.current_screen.set_group(group)


modifier_keys = dict(
    M="mod4",
    A="mod1",
    S="shift",
    C="control",
)


keys = [
    # Switch between windows
    Key("M-h", lazy.layout.left(), desc="Move focus to left"),
    Key("M-l", lazy.layout.right(), desc="Move focus to right"),
    Key("M-j", lazy.layout.down(), desc="Move focus down"),
    Key("M-k", lazy.layout.up(), desc="Move focus up"),
    Key("M-<space>", lazy.layout.next(), desc="Move window focus forward"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key("M-S-h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key("M-S-l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key("M-S-j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key("M-S-k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key("M-C-h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key("M-C-l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key("M-C-j", lazy.layout.grow_down(), desc="Grow window down"),
    Key("M-C-k", lazy.layout.grow_up(), desc="Grow window up"),
    Key("M-n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Go to left group (hold shift to send window there)
    Key("M-g", lazy.screen.prev_group(skip_empty=True)),
    Key("M-S-g", lazy.function(window_to_previous_column_or_group)),
    # Go to right tag (hold shift to send window there)
    Key("M-<semicolon>", lazy.screen.next_group(skip_empty=True)),
    Key("M-S-<semicolon>", lazy.function(window_to_next_column_or_group)),
    # Go to another display
    Key("M-<Left>", lazy.prev_screen()),
    Key("M-<Right>", lazy.next_screen()),
    # Move window to another display
    Key("M-S-<Left>", lazy.function(window_to_previous_screen)),
    Key("M-S-<Right>", lazy.function(window_to_next_screen)),
    # Key([mod], "t", lazy.function(switch_screens)),
    # Change focus
    Key("M-<Up>", lazy.group.prev_window()),
    Key("M-<Down>", lazy.group.next_window()),
    # Key("M-j", lazy.function(traverse.down), "Traverse down"),
    # Key("M-k", lazy.function(traverse.up), "Traverse up"),
    # Key("M-h", lazy.function(traverse.left), "Traverse left"),
    # Key("M-l", lazy.function(traverse.right), "Traverse right"),
    # # Keybindings for resizing windows in MonadTall layout
    # Key([mod], "i", lazy.layout.grow()),
    # Key([mod], "m", lazy.layout.shrink()),
    # Key([mod], "n", lazy.layout.normalize()),
    # Key([mod], "o", lazy.layout.maximize()),
    Key("M-<Tab>", lazy.next_layout()),
    Key("M-S-<Tab>", lazy.prev_layout()),
    # Toggle fullscreen
    Key("M-f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    # Key("M-<space>", lazy.window.bring_to_front()),
    # Key([mod], "s", lazy.layout.toggle_split()),
    # Reload config / restart qtile
    Key("M-r", lazy.reload_config()),
    Key("M-S-r", lazy.restart()),
    # Key("M-S-<BackSpace>", lazy.shutdown()),
    Key("M-v", lazy.validate_config()),
    # The essentials
    # Spawn terminal
    Key("M-<Return>", lazy.spawn(TERM)),
    # Close window
    # Key("M-x", lazy.window.kill()),
    # dmenu (for running commands or programs without shortcuts)
    Key("M-S-<Return>", lazy.spawn("dmenu_run")),
    # Cycle thru windows by their stack order
    # Make selected window the master (or switch master with 2nd)
    # Change width of master window
    # Toggle floating (move and resize with Mod+left/right click).
    Key("M-S-<space>", lazy.window.toggle_floating(), desc="Toggle floating"),
    # Make/unmake a window “sticky” (follows you from tag to tag)
    # Toggle statusbar (may also middle click on desktop)
    # Jump to master window
    # Switch focus of monitors
    # M-w, lazy.to_screen(0)),
    # M-e, lazy.to_screen(1)),
    # M-r, lazy.to_screen(2)),
    # Window controls
    # Key("M-<space>", lazy.layout.next()),
    # Key("M-k", lazy.layout.previous()),
    # TODO old
    # # Flip layouts
    # Key(
    #     "M-C-j",
    #     lazy.layout.flip_down(),
    #     lazy.layout.section_down().when(layout="treetab"),
    #     lazy.layout.integrate_down(),
    # ),
    # Key(
    #     "M-C-k",
    #     lazy.layout.flip_up(),
    #     lazy.layout.section_up().when(layout="treetab"),
    #     lazy.layout.integrate_up(),
    # ),
    # Key(
    #     "M-C-h",
    #     lazy.layout.flip_left(),
    #     lazy.layout.swap_column_left(),
    #     lazy.layout.integrate_left(),
    # ),
    # Key(
    #     "M-C-l",
    #     lazy.layout.flip_right(),
    #     lazy.layout.swap_column_right(),
    #     lazy.layout.integrate_right(),
    # ),
    # Key("M-S-<space>", lazy.layout.flip())),
    # Key("M-n", lazy.layout.reset_size()),
    # Key([mod, "control"], "space", lazy.layout.flip()),
    # Window states
    # Key("M-m", lazy.window.toggle_maximize()),
    # Key("M-h", lazy.window.toggle_minimize()),
    # Key("M-S-h", lazy.group.unminimize_all()),
    # TODO, Adjust paddings/margins
    # Plasma controls
    # Key("M-o", lazy.layout.mode_horizontal().when(layout="plasma")),
    # Key("M-u", lazy.layout.mode_vertical().when(layout="plasma")),
    # Key("M-S-o", lazy.layout.mode_horizontal_split().when(layout="plasma")),
    # Key("M-S-u", lazy.layout.mode_vertical_split().when(layout="plasma")),
    # Toggle split direction
    Key("M-s", lazy.layout.toggle_split()),
    # Floating controls
    # Key("M-<bracketleft>", lazy.group.prev_window()),
    # Key("M-<bracketleft>", lazy.window.bring_to_front()),
    # Key("M-<bracketright", lazy.group.next_window()),
    # Key("M-<bracketright", lazy.window.bring_to_front()),
    # Treetab controls
    Key("M-v", lazy.layout.expand_branch().when(layout="treetab")),
    Key("M-S-v", lazy.layout.collapse_branch().when(layout="treetab")),
    # Monad controls
    Key("M-o", lazy.layout.increase_nmaster()),
    Key("M-S-o", lazy.layout.decrease_nmaster()),
    # lazy.layout.rotate()),
]

# Define groups
groups = [
    Group(
        "1",
        label="一",
        matches=[
            Match(wm_class=["brave", "librewolf"]),
        ],
        layout="stack",
    ),
    Group(
        "2",
        label="二",
        matches=[
            Match(wm_class=["code", "emacs"]),
        ],
        layout="bsp",
    ),
    Group(
        "3",
        label="三",
        matches=[
            Match(wm_class=["pcmanfm"]),
        ],
        layout="bsp",
    ),
    Group(
        "4",
        label="四",
        matches=[
            Match(wm_class=["geary", "ptask", "thunderbird"]),
        ],
        layout="bsp",
    ),
    Group(
        "5",
        label="五",
        matches=[
            Match(wm_class=["joplin", "libreoffice", "zathura"]),
        ],
        layout="bsp",
    ),
    Group(
        "6",
        label="六",
        matches=[
            Match(wm_class=["ferdium"]),
        ],
        layout="bsp",  # max
    ),
    Group(
        "7",
        label="七",
        matches=[
            Match(wm_class=["spotify", "lollypop", "cmus"]),
        ],
        layout="bsp",
    ),
    Group(
        "8",
        label="八",
        matches=[
            Match(wm_class=["gimp", "obs", "steam", "lutris"]),
        ],
        layout="bsp",
    ),
    Group(
        "9",
        label="九",
        matches=[
            # Match(wm_class=["nm-connection-editor", "blueman-manager", "pavucontrol"]),
        ],
        # layout="floating",
    ),
    Group(
        "10",
        label="十",
        matches=[
            Match(wm_class=["..."]),
        ],
        layout="floating",
    ),
]

# Append scratchpad with dropdowns to groups
groups.append(
    ScratchPad(
        "scratchpad",
        [
            DropDown(
                "term",
                "alacritty --class dropdown",
                height=0.6,
                # x=0.3,
                # y=0.1,
                on_focus_lost_hide=False,
                opacity=0.85,
                warp_pointer=False,
            ),
            DropDown(
                "calc",
                "qalculate-gtk --class dropdown",
                height=0.4,
                width=0.4,
                on_focus_lost_hide=False,
                warp_pointer=False,
            ),
            # DropDown(
            #     "bitwarden",
            #     "bitwarden-desktop",
            #     width=0.4,
            #     height=0.6,
            #     x=0.3,
            #     y=0.1,
            #     opacity=1,
            # ),
        ],
    ),
)
# Extend keys list with keybinding for scratchpad
keys.extend(
    [
        # Show/hide dropdown terminal
        Key("M-d", lazy.group["scratchpad"].dropdown_toggle("term")),
        # Show/hide dropdown calculator
        Key("M-<grave>", lazy.group["scratchpad"].dropdown_toggle("calc")),
    ]
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
    ["#d77bc6", "#d77bc6"],  # 15 border focus
]


# Configuration variables
extension_defaults = dict(
    background=colors[0],
    font="monospace",
    fontsize=18,
    padding=0,
)
layout_defaults = dict(
    font="monospace",
    border_width=2,
    margin=5,
    border_focus=colors[7],  # colors[15]
    border_normal=colors[6],  # colors[2]
    # grow_amount=2,
)
widget_defaults = extension_defaults.copy()
dgroups_key_binder = simple_key_binder("mod4")
dgroups_app_rules = []
bring_front_click = "floating_only"  # ""
cursor_warp = True
auto_fullscreen = True
focus_on_window_activation = "focus"  # "smart"
follow_mouse_focus = True
reconfigure_screens = True
auto_minimize = True
wmname = "qtile"  # "LG3D"

floating_layout = layout.Floating(
    **layout_defaults,
    float_rules=[
        # Run $(xprop) to see the class and name of a window.
        *layout.Floating.default_float_rules,
        # From default config file
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        # Added
        Match(title="Qalculate!"),
        Match(wm_class="lutris"),
        Match(title="Farge"),
        Match(wm_class="blueman-manager"),
        Match(wm_class="pavucontrol"),
        Match(wm_class="bitwarden"),
        Match(wm_class="eog"),
        Match(wm_class="imv"),
        Match(wm_class="mpv"),
    ],
)
# Drag floating layouts.
mouse = [
    Drag("M-1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag("M-3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click("M-2", lazy.window.bring_to_front()),
    # Click("M-2", lazy.window.kill())]
    Click("M-C-3", lazy.spawn("jgmenu --csv-file=~/.config/jgmenu/qtile.csv")),
    Click("M-A-3", lazy.spawn("jgmenu_run")),
]


# Available layouts
layouts = [
    # layout.MonadWide(**layout_defaults),
    # layout.Bsp(**layout_defaults, fair=False, border_on_single=True),
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
    # layout.RatioTile(**layout_defaults),
    # layout.VerticalTile(**layout_defaults),
    # layout.Matrix(**layout_defaults, columns=3),
    # layout.Zoomy(**layout_defaults, columnwidth=250),
    # layout.Slice(**layout_defaults, width=1920, match=Match(wm_class="joplin"), side="right"),
    layout.MonadTall(**layout_defaults),
    # layout.Max(**layout_defaults),
    # layout.Tile(shift_windows=True, **layout_theme),
    layout.Stack(num_stacks=1, **layout_defaults),
    # floating_layout,
]


# TODO remove?
# prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())


# Define functions for bar
def taskwarrior():
    return subprocess.check_output(["taskbar.sh"]).decode("utf-8").strip()


zipcode = subprocess.run(
    ["curl -s ipinfo.io | jq -r '[.postal,.country] | @csv' | tr -d '\"'"],
    capture_output=True,
    shell=True,
    check=True,
).stdout.strip()


def long_name_parse(text):
    "Shorten long application names"
    for string in [
        "Chromium",
        "Firefox",
        "Brave",
        "Ferdi",
        "NVIM",
    ]:  # Add other apps that have long names here
        if string in text:
            text = string
    return text


# Mouse_callback functions
def finish_task():
    "mark task as completed"
    qtile.cmd_spawn('task "$((`cat /tmp/tw_polybar_id`))" done')


# TODO remove?
def todays_date():
    qtile.cmd_spawn("./.config/qtile/calendar.sh")


def template(position):
    "widget templates"
    if position == "r":
        return widget.TextBox(
            text="",
            foreground=colors[14],
            fontsize=28,
        )
    if position == "l":
        return widget.TextBox(
            text="",
            foreground=colors[14],
            fontsize=28,
        )
    return widget.Sep(
        # padding=10,
        foreground=colors[2],
        linewidth=0,
        # size_percent=50,
    )


def bars(monitor):
    widgets = [
        widget.TextBox(
            text="ﮂ",
            foreground=colors[13],
            fontsize=28,
            padding=10,
            mouse_callbacks={"Button3": lambda: qtile.cmd_spawn(TERM)},
        ),
        template("l"),
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
        template("r"),
        template(" "),
        template("l"),
        widget.CurrentLayoutIcon(
            custom_icon_paths=[os.path.expanduser("~/.config/qtile/icons")],
            foreground=colors[2],
            background=colors[14],
            padding=-5,
            scale=0.70,
        ),
        template("r"),
        template(" "),
        template("l"),
        widget.GenPollText(
            func=taskwarrior,
            update_interval=60,
            foreground=colors[11],
            background=colors[14],
            mouse_callbacks={"Button1": finish_task},
        ),
        template("r"),
        widget.Spacer(),
        widget.TextBox(
            text=" ",
            foreground=colors[12],
        ),
        widget.WindowName(
            foreground=colors[12],
            for_current_screen=True,
            width=bar.CALCULATED,
            empty_group_string="零",
            max_chars=20,
            mouse_callbacks={
                "Button2": lambda: qtile.cmd_spawn("xdotool getwindowfocus windowkill")
            },
            parse_text=long_name_parse,
        ),
        widget.CheckUpdates(
            # distro="Arch",
            foreground=colors[3],
            colour_have_updates=colors[3],
            display_format=" {updates}",
            # colour_no_updates=colors[12],
            # no_update_string=" 0",
            mouse_callbacks={
                "Button2": lambda: qtile.cmd_spawn("./.local/bin/checkupd")
            },
            custom_command="paru -Qua ; checkupdates",
            update_interval=600,
            padding=20,
        ),
        widget.Spacer(),
        template("l"),
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
        template("r"),
        template(" "),
        template("l"),
        widget.TextBox(
            text="墳 ",
            foreground=colors[8],
            background=colors[14],
        ),
        widget.PulseVolume(
            foreground=colors[8],
            # emoji=True,
            # get_volume_command=get_volume,
            background=colors[14],
            limit_max_volume="True",
            mouse_callbacks={"Button3": lambda: qtile.cmd_spawn("pavucontrol")},
            update_interval=1,
        ),
        template("r"),
        template(" "),
        template("l"),
        widget.OpenWeather(
            background=colors[14],
            foreground=colors[7],
            app_key="7834197c2338888258f8cb94ae14ef49",
            zip="11215",
            language="en",
            metric=False,
            format="{icon} {temp:.0f}°{units_temperature}",
            # https://github.com/sffjunkie/qtile-openweathermap/blob/master/owm.py#L37
            # NOTE: Missing nf-mdi-weather_partlycloudy_night
            weather_symbols={
                "01d": "\ufa98",  # Clear sky 滛望
                "01n": "\ufa93",
                "02d": "\ufa94",  # Few clouds 杖
                "02n": "\ue37e",
                "03d": "\ufa94",  # Scattered Clouds 杖
                "03n": "\ue37e",
                "04d": "\ufa8f",  # Broken clouds 摒
                "04n": "\ufa8f",
                "09d": "\ufa95",  # Shower Rain 歹
                "09n": "\ufa95",
                "10d": "\ufa95",  # Rain 歹
                "10n": "\ufa95",
                "11d": "\ufb7c",  # Thunderstorm ﭼ
                "11n": "\ufb7c",
                "13d": "\ufa97",  # Snow 流
                "13n": "\ufa97",
                "50d": "\ufa90",  # Mist 敖
                "50n": "\ufa90",
                "sleetd": "\ufb7d",  # Sleet ﭽ
                "sleetn": "\ufb7d",
            },
        ),
        template("r"),
        template(" "),
        template("l"),
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
            mouse_callbacks={"Button3": lambda: qtile.cmd_spawn(TERM + " -e btm")},
        ),
        template("r"),
        template(" "),
        template("l"),
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
        template("r"),
        widget.TextBox(
            text="⏻",
            foreground=colors[13],
            fontsize=28,
            padding=10,
            mouse_callbacks={"Button3": lambda: qtile.cmd_spawn("sysact.sh")},
        ),
    ]
    # Systray can only be displayed on one monitor
    if monitor == "primary":
        return widgets
    del widgets[18]
    return widgets


screens = [
    Screen(
        top=bar.Bar(
            bars("primary"),
            # opacity=0.85,
            size=25,
            margin=[0, 0, 5, 0],
            border_width=[5, 0, 5, 0],
            border_color="#2e3440",
        ),
        bottom=bar.Gap(10),
        left=bar.Gap(10),
        right=bar.Gap(10),
    ),
    Screen(
        top=bar.Bar(
            bars("secondary"),
            # opacity=0.85,
            size=25,
            margin=[0, 0, 5, 0],
            border_width=[5, 0, 5, 0],
            border_color="#2e3440",
        ),
        bottom=bar.Gap(10),
        left=bar.Gap(10),
        right=bar.Gap(10),
    ),
    # etc...
]


@hook.subscribe.startup_once
def start_once():
    "Startup scripts"
    home = os.path.expanduser("~")
    subprocess.call([home + "/.config/qtile/autostart.sh"])


@hook.subscribe.client_new
def _swallow(window):
    "Window swallowing ;)"
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


@hook.subscribe.client_new
def modify_window(client):
    "Go to group when app opens on matched group"
    # if (
    #     client.window.get_wm_transient_for()
    #     or client.window.get_wm_type() in floating_types
    # ):
    #     client.floating = True

    for group in groups:  # follow on auto-move
        match = next((m for m in group.matches if m.compare(client)), None)
        if match:
            targetgroup = client.qtile.groups_map[
                group.name
            ]  # there can be multiple instances of a group
            targetgroup.cmd_toscreen(toggle=False)
            break
