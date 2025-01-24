# Scripts don't source .zshrc but they do source this file and we want to make
# local Zsh functions available also to scripts.

# Use my shell configs also from a rootshell
export HOME=/media/fat/rhome
[[ -n $ZDOTDIR ]] || export ZDOTDIR=/media/fat/rhome

# My own little functions to autoload (or not)
typeset -xU fpath=($ZDOTDIR/.local/share/zsh/functions $fpath)

# Similar to builtin 'colors', but do solarized colors instead. Populates a
# bunch of arrays with S_ prefix in names. Also contains a few helper functions
# for choosing colors.
autoload -Uz solarized && solarized

# Enable completion here, so additional completion modules can be sourced in
# .zshrc.local
autoload -Uz compinit
# If running as root, ignore "insecure" directories as local functions on
# $fpath won't be owned by root
(( $(id -u) == 0 )) && compinit -i || compinit

# TERM is set either by the terminal emulator, or by SSH. Use this to always
# know if shell is running inside Tmux.
[[ $TERM[1,5] == "tmux-" ]] && export TMUX=${TMUX:=1}

# MiSTer doesn't know about tmux-* term types, though..
export TERM=xterm-256color

# These are defined at compile time and set automatically, but not exported
typeset -x OSTYPE VENDOR
