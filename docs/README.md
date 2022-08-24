# Dotfiles for i13e

## Table of Contents

1. [Info](#info)
2. [Installation](#installation)
3. [Notes](#notes)

## Info

| Component           | Application                   |
| ------------------- | ----------------------------- |
| OS                  | Arch Linux                    |
| WM                  | qtile                         |
| Shell               | zsh                           |
| Terminal            | alacritty                     |
| Bar                 | polybar                       |
| Launcher            | dmenu                         |
| Compositor          | picom                         |
| File Manager        | lf, pcmanfm                   |
| Media Player        | cmus, mpv                     |
| Image Viewer        | imv                           |
| PDF Reader          | zathura                       |
| Text Editor         | neovim                        |
| Browser             | firefox, w3m                  |
| RSS                 | newsboat                      |
| Process Viewer      | btm                           |
| Fetch               | pfetch                        |
| Notification Daemon | dunst                         |
| Color Scheme        | [Nord](https://nordtheme.com) |

## Installation

Install config tracking in your $HOME by running this command in bash, zsh, or
sh:

```shell
if command -v curl >/dev/null 2>&1; then
    sh -c "$(curl -fsSL https://raw.github.com/i13e/cfg/master/.local/bin/install.sh)"
else
    sh -c "$(wget -nv -O - https://raw.github.com/i13e/cfg/master/.local/bin/install.sh)"
fi
```

The installer backs up existing config files, ... It asks for confirmation on every step so that you are always in control. Running the script requires curl or wget, as it will install necessary dependencies itself (i.e. git, sudo, zsh).

## Notes

- The install script is currently **unfinished** and will break your system if you attempt to use it.
- Update zsh/mpv plugins as submodules with: `cfg submodule update --remote`
