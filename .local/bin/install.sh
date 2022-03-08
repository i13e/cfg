#!/bin/sh
#
# Install config in your $HOME by running:
# curl -Lks https://raw.githubusercontent.com/i13e/cfg/master/.local/bin/install.sh | /bin/sh

git clone --bare --depth 1 https://github.com/i13e/cfg.git "$HOME/.config/cfg"

cfg() { /usr/bin/git --git-dir="$HOME/.config/cfg/" --work-tree="$HOME" "$@" }

mkdir -p "$HOME/.cfg-backup/"

if cfg checkout; then
  echo "Successfully checked out dotfiles.";
  else
    echo "Backing up pre-existing dotfiles.";
    cfg checkout 2>&1 | grep -E "\s+\." | awk {'print $1'} | xargs -I{} mv {} "$HOME/.cfg-backup/"
    cfg checkout
fi;

cfg config status.showUntrackedFiles no

# are you planning to push to this repository?
# if yes
# cfg remote set-url origin git@github.com:i13e/cfg.git
# git push -u origin/master
# cfg branch --set-upstream-to=origin/master
# else skip

# make folders mkdir ~/vids dl ?
# submodules: git submodule init && git submodule update

# Would you like to run the rest of the install script? (Arch Only)
# if yes continue
# if no, exit

# install paru
#sudo pacman -S --needed base-devel
#git clone https://aur.archlinux.org/paru.git
#cd paru
#makepkg -si

# would you like to use your own package list or install the repo default?
# install pkg list from repo
# WARNING: Do not run the rest of this script unless you know EXACTLY what
#you are doing. It is only recommended for a clean install of Arch Linux.
#Do you wish to continue?
# switch shell to start using tools
