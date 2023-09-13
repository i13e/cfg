#!/bin/bash
# Install config in your $HOME by running:
# curl -FsSL https://raw.github.com/i13e/cfg/master/.local/bin/install.sh | /bin/sh

# Confirmation prompt
read -p "This script will install my dotfiles. Continue? [Y/n] " confirm
if [[ "$confirm" != [yY] ]]; then
	exit 1
fi

# Safety checks

if [ "$UID" -eq 0 ]; then
	echo "This script should not be run as root"
	exit 1
fi

if ! command -v pacman &>/dev/null; then
	echo "This script is only compatible with Arch Linux."
	exit 1
fi

# Install dependencies
sudo pacman -S --needed --noconfirm base-devel git

# Install paru if not installed
if ! command -v paru &>/dev/null; then
	git clone https://aur.archlinux.org/paru-bin.git /tmp/paru-bin
	(cd /tmp/paru-bin && makepkg -si --noconfirm)
fi

## Install Dotfiles.

# If config directory doesn't exist, make it
[ ! -d "$HOME/.config" ] && mkdir -p "$HOME/.config"

# Clone repo
git clone --bare --branch master --depth 1 --recursive https://github.com/i13e/cfg.git "$HOME/.config/cfg"

function cfg {
	/usr/bin/git --git-dir="$HOME/.config/cfg/" --work-tree="$HOME" "$@"
}

if cfg checkout; then
	echo "Successfully checked out dotfiles."
else
	echo "Backing up pre-existing dotfiles."
	mkdir -p "$HOME/.cfg-backup/"
	cfg checkout 2>&1 | grep -E "\s+\." | awk "{print $1}" | xargs -I{} mv {} "$HOME/.cfg-backup/"
	cfg checkout && echo "Successfully checked out dotfiles."
fi

# Set up repo
cfg config --local status.showUntrackedFiles no

# Offer to set remote origin
read -p "Set git remote origin to push commits? [Y/n] " setremote
if [[ "$setremote" =~ [Yy] ]]; then
	cfg remote set-url origin git@github.com:i13e/cfg.git
fi

# make folders mkdir ~/vids dl ?

## Install Repo's Package List.

# Install packages
# sudo pacman -S --noconfirm $(cat pkglist.txt)
# Install packages from AUR
# git clone https://aur.archlinux.org/paru-bin.git "/tmp/paru-bin"

# paru -S scripts, tools, etc
paru -S --noconfirm ttf-jetbrains-mono neovim zsh ttf-nerd-fonts-symbols-2048-em brave-bin vivid tealdeer fd zoxide picom
# python-psutil mypy python-dbus-next jq
# xwallpaper TRAY
# would you like to use your own package list or install the repo default?
# install pkg list from repo
# switch shell to start using tools

# Change the $USER's shell to Zsh
if command -v zsh >/dev/null 2>&1; then
	echo "Changing default shell to zsh…"
	sudo usermod -s "$(which zsh)" "$USER"
fi

# sudo ln -s ~/.local/bin/hooks/* /etc/pacman.d/hooks
# can also use cp
