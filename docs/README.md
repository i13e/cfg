# Dotfiles for i13e

## Install

Install config tracking in your $HOME by running:

```
    if command -v curl >/dev/null 2>&1; then
        sh -c "$(curl -fsSL https://raw.github.com/i13e/cfg/master/.local/bin/install.sh)"
    else
        sh -c "$(wget -O- https://raw.github.com/i13e/cfg/master/.local/bin/install.sh)"
    fi
```
The installer backs up existing config files, ... It asks for confirmation on every step so that you are always in control. Running the script requires curl or wget, as it will install necessary dependencies itself (i.e. git, sudo, zsh).

### Notes

- The install script is currently **unfinished** and will break your system if you attempt to use it.
- Update zsh/mpv plugins as submodules with: `cfg submodule update --remote`
