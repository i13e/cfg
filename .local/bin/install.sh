#!/bin/sh
#
# Install config in your $HOME by running:
# curl -FsSL https://raw.github.com/i13e/cfg/master/.local/bin/install.sh | /bin/sh

## Confirmation Dialog.
while true; do
    printf '%b ' "\033[1m":: Do not run this script unless you know EXACTLY what you are doing. It is recommended to be run only on a fresh install of Arch Linux as a non-root, wheel user. Do you wish to continue?  [Y/n]"\033[0m"
    read -r yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer y or n.";;
    esac
done

## Safety Checks.

# check if user is root

# check if user is running Arch
if command -v pacman >/dev/null 2>&1; then
    # Install dependencies
    sudo pacman -S --needed --noconfirm base-devel git
    # Install paru
    git clone https://aur.archlinux.org/paru-bin.git "/tmp/paru-bin"
    cd "/tmp/paru-bin" || exit # exit in case cd fails
    makepkg -si --noconfirm
    cd "$HOME" && rm -rf "/tmp/paru-bin"
else
    echo "This script is only compatible with Arch Linux." ; exit 1
fi

## Install Dotfiles.

# If config directory doesn't exist, make it
[ ! -d "$HOME/.config" ] && mkdir -p "$HOME/.config"

# Clone repo
git clone --bare --branch master --depth 1 https://github.com/i13e/cfg.git "$HOME/.config/cfg"
#--recursive?

cfg() { /usr/bin/git --git-dir="$HOME/.config/cfg/" --work-tree="$HOME" "$@"; }

mkdir -p "$HOME/.cfg-backup/"

if cfg checkout; then
  echo "Successfully checked out dotfiles."
  else
    echo "Backing up pre-existing dotfiles."
    cfg checkout 2>&1 | grep -E "\s+\." | awk "{print $1}" | xargs -I{} mv {} "$HOME/.cfg-backup/"
    cfg checkout && echo "Successfully checked out dotfiles."
fi

cfg config status.showUntrackedFiles no

# are you planning to push to this repository?
# if yes
# cfg remote set-url origin git@github.com:i13e/cfg.git
# git push -u origin/master
# cfg branch --set-upstream-to=origin/master
# else skip

# make folders mkdir ~/vids dl ?

# update submodules
cfg submodule update --init

## Install Repo's Package List.

    # Install packages
    # sudo pacman -S --needed --noconfirm $(cat pkglist.txt)
    # Install packages from AUR
    # git clone https://aur.archlinux.org/paru-bin.git "/tmp/paru-bin"

# paru -S fonts, neovim, symlinks, compositor, scripts, tools, browser, zsh, etc
# would you like to use your own package list or install the repo default?
# install pkg list from repo
# switch shell to start using tools

#printf "Password: " ; read -r myPass ; echo "Password is: $myPass"

## Wrap up.

# Change the $USER's shell to Zsh
if command -v zsh >/dev/null 2>&1; then
    echo "changing default shell to zsh…"
    sudo usermod -s "$(which zsh)" "$USER"
else
    true
fi

# sudo ln -s ~/.local/bin/hooks/* /etc/pacman.d/hooks
# can also use cp
