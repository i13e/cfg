#!/bin/sh
#alacrity
# Simple wrapper to always attempt launching alacritty windows, not instances
# I.e. launch clients while keeping one daemon process
/usr/bin/alacritty msg create-window "$@" || /usr/bin/alacritty "$@"
