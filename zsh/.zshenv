# XDG Base Directory Specification
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html#variables
export XDG_DATA_HOME=$HOME/.local/share;  mkdir -p "$XDG_DATA_HOME"
export XDG_CACHE_HOME=$HOME/.cache;       mkdir -p "$XDG_CACHE_HOME"
export XDG_CONFIG_HOME=$HOME/.config;     mkdir -p "$XDG_CONFIG_HOME"
export XDG_STATE_HOME=$HOME/.local/state; mkdir -p "$XDG_STATE_HOME"

# Zsh
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
