#!/bin/sh
#
# Install config in your $HOME by running:
# curl -FsSL https://raw.github.com/i13e/cfg/master/.local/bin/install.sh | /bin/sh

sudo pacman -S --needed --asdeps --noconfirm base-devel git

mkdir -p "$HOME/.config"

git clone --bare --branch master --depth 1 https://github.com/i13e/cfg.git "$HOME/.config/cfg"
#--recursive?

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
cfg submodule update --init


# check that you are on archlinux?
# WARNING: Do not run the rest of this script unless you know EXACTLY what
#you are doing. It is only recommended for a clean install of Arch Linux.
#Do you wish to continue?
# if yes continue
# if no, exit

# install paru
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin || exit # exit in case cd fails
makepkg -si --noconfirm
cd "$HOME" && rm -rf paru-bin

# confirm script from hostupd
#while true; do
#    printf '%b ' "\033[1m":: Do you wish to use a custom hosts file? [Y/n]"\033[0m"
#    read -r yn
#    case $yn in
#        [Yy]* ) sudo tee -a /etc/hosts < "$XDG_DATA_HOME/hosts" > /dev/null; exit;;
#        [Nn]* ) exit;;
#        * ) echo "Please answer y or n.";;
#    esac
#done

# install from repo's packagelist
# paru -S fonts, neovim, symlinks, compositor, scripts, tools, browser, zsh, etc
# would you like to use your own package list or install the repo default?
# install pkg list from repo
# switch shell to start using tools

#printf "Password: " ; read -r myPass ; echo "Password is: $myPass"

# if zsh was installed change the shell to zsh
if command -v curl >/dev/null 2>&1; then
    echo "changing default shell to zsh…"
    sudo usermod -s "$(which zsh)" "$USER"
else
    true
fi

# sudo ln -s ~/.local/bin/hooks/* /etc/pacman.d/hooks
# can also use cp
