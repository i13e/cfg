# Dotfiles

These are my personal dotfiles, which I use to customize my terminal and shell setup. Feel free to use and modify them as you see fit.

> A dotfiles directory is a common way for users to store configuration files for their terminal and shell setup. These files typically have names that start with a . (hence the name "dotfiles"), and they can include settings for tools such as bash, vim, git, and others.

## Installation (alpha)

**The install script is currently **unfinished** and will break your system if you attempt to use it.**

To install these dotfiles to your home directory, run this command in any 
POSIX-compliant shell:

```shell
if command -v curl >/dev/null 2>&1; then
    sh -c "$(curl -fsSL https://raw.github.com/i13e/cfg/master/.local/bin/install.sh)"
else
    sh -c "$(wget -nv -O - https://raw.github.com/i13e/cfg/master/.local/bin/install.sh)"
fi
```

The installer backs up existing config files, ... and asks for confirmation on every step so that you are always in control. Running the script requires curl or wget, otherwise the script will install necessary dependencies itself (i.e. git, sudo, zsh).

## Info

- OS: [Arch Linux](https://archlinux.org)
- WM: [Qtile](https://qtile.org)
- Shell: [Zsh](https://zsh.org)
- Terminal: alacritty
- Launcher: dmenu
- Bar: Qtile's internal bar
- Compositor: picom
- Gtk: [Nordic Darker](https://github.com/EliverLara/Nordic/tree/darker)
- Fonts: Jetbrains Mono and Nerd Font for icons
- Media player: spotify, cmus, and mpv
- Image viewer: imv
- Browser: Brave
- RSS: newsboat
- Process Viewer: btm
- Text Editor: neovim
- PDF Reader: zathura
- File Manager: lf, pcmanfm
- Fetch: pfetch
- Notification Daemon: dunst
- Colorscheme: [Nord](https://nordtheme.com) with extra dark color `#242831`

## Notes

- Update zsh/mpv plugins as submodules with: `cfg submodule update --remote`

## Customization

You can customize the dotfiles to your personal preferences by modifying the files in the repository

## Contribute
To contribute to this repository, please create a new branch and make your changes, then submit a pull
request for review.
