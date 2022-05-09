#!/bin/sh
#
# Install config in your $HOME by running:
# curl -Lks https://raw.githubusercontent.com/i13e/cfg/master/.local/bin/install.sh | /bin/sh

sudo pacman -S --needed base-devel git

git clone --bare --depth 1 https://github.com/i13e/cfg.git "$HOME/.config/cfg"

cfg() { /usr/bin/git --git-dir="$HOME/.config/cfg/" --work-tree="$HOME" "$@"; }

mkdir -p "$HOME/.cfg-backup/"

if cfg checkout; then
  echo "Successfully checked out dotfiles.";
  else
    echo "Backing up pre-existing dotfiles.";
    cfg checkout 2>&1 | grep -E "\s+\." | awk "{print $1}" | xargs -I{} mv {} "$HOME/.cfg-backup/"
    cfg checkout && echo "Successfully checked out dotfiles.";
fi;

cfg config status.showUntrackedFiles no

# are you planning to push to this repository?
# if yes
# cfg remote set-url origin git@github.com:i13e/cfg.git
# git push -u origin/master
# cfg branch --set-upstream-to=origin/master
# else skip

# make folders mkdir ~/vids dl ?

# update submodules
cfg submodule init && cfg submodule update


# check that you are on archlinux?
# WARNING: Do not run the rest of this script unless you know EXACTLY what
#you are doing. It is only recommended for a clean install of Arch Linux.
#Do you wish to continue?
# if yes continue
# if no, exit

# install paru
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -si
cd "$HOME" && rm -rf paru-bin

# install from repo's packagelist
# paru -S fonts, neovim, symlinks, compositor, scripts, tools, browser, zsh, etc
# would you like to use your own package list or install the repo default?
# install pkg list from repo
# switch shell to start using tools

echo "changing default shell to zsh…"
chsh -s /bin/zsh
