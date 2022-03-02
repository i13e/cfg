#!/bin/sh
#
# Install config in your $HOME by running:
# curl -Lks https://raw.githubusercontent.com/i13e/cfg/master/.local/bin/install | /bin/sh

git clone --bare https://github.com/i13e/cfg.git "$HOME/.config/cfg"

cfg() {
	/usr/bin/git --git-dir="$HOME/.config/cfg/" --work-tree="$HOME" "$@"
}

mkdir -p "$HOME/.cfg-backup/"

if cfg checkout; then
  echo "Successfully checked out dotfiles.";
  else
    echo "Backing up pre-existing dot files.";
    cfg checkout 2>&1 | grep -E "\s+\." | awk {'print $1'} | xargs -I{} mv {} "$HOME/.cfg-backup/"
    cfg checkout
fi;

cfg config status.showUntrackedFiles no

# cfg branch --set-upstream-to=origin/master
# switch to ssh
# make folders mkdir ~/vids dl ?
# submodules: git submodule init && git submodule update
# install paru
# update packages if on arch
# switch shell to start using tools
