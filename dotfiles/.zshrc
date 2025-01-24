#############################################################################
#
# Zsh configuration that works across FreeBSD/macOS/Linux as-is.
#
# * Vi-mode, editor (neo)vim
# * Dark background, Solarized colorscheme (set in terminal emulator)
# * Tmux integrations
# * Use same configuration as root when using 'sudo -s'
#
#############################################################################


#############################################################################
#
# Platform/host specific settings configurable via .zshrc.local
#
[[ -f $ZDOTDIR/.zshrc.local ]] && . $ZDOTDIR/.zshrc.local

# Style attribute display with less(1), usually in man pages. These need to
# specify the full escape sequence to change style, not just a color name.
: ${less_md:=$S_bold}           # Bold
: ${less_us:=$S_underline}      # Underline
: ${less_so:=$S_reverse}        # Standout/reverse
# Hostname color in prompt
: ${prompt_h:=default}
# Hostname color in Tmux status line and optional pane title. This needs to
# be exported for Tmux to have access to it.
export ${tmux_title_col:=default}

# Simple prompt with current dir up to four levels deep and root highlight
export PROMPT="%(!.%F{red}%n%f@.)%F{$prompt_h}%m%f:%B%4.%b%# "

# less(1) output styling
export LESS_TERMCAP_mb=$(printf '%s' $S_fg[base2])  # start blink (white)
export LESS_TERMCAP_md=$(printf '%s' $less_md)      # start bold
export LESS_TERMCAP_so=$(printf '%s' $less_so)      # start standout
export LESS_TERMCAP_me=$(printf '%s' $S_normal)     # stop all above
export LESS_TERMCAP_se=$(printf '%s' $S_normal)     # stop standout
export LESS_TERMCAP_us=$(printf '%s' $less_us)      # start underline
export LESS_TERMCAP_ue=$(printf '%s' $S_normal)     # stop underline

# Exports an associative array $terminfo which maps terminfo(5) keyboard
# capability names to their values, eg. $terminfo[kbs] is backspace. This is
# useful for mapping special keys in portable manner.
zmodload zsh/terminfo

# Vi key bindings
bindkey -v
bindkey $terminfo[kbs] backward-delete-char
bindkey '^?' backward-delete-char
bindkey '^W' backward-kill-word

# Print grep matches in green
export GREP_COLOR="$S_color[green]"
# Print colors even when stdout is not a tty
export GREP_OPTIONS='--color=always'

# BSD ls colors for a Solarized palette
export LSCOLORS='exfxcxdxbxgxhxabagacad'
# GNU tools use this, match the above colorscheme
export LS_COLORS='rs=0:di=34:ln=35:so=32:pi=33:ex=31:bd=36:cd=37:su=01;30;41:sg=30;41:tw=30;42:ow=30;43:'

# Allow ANSI colors in less output and use mouse for scrolling
export LESS='-RiM --mouse --wheel-lines=3'
export PAGER=less
export MANPAGER=$PAGER

# Group & world read-only
umask 022

# History lines 2^19
export HISTSIZE=524288
export SAVEHIST=524288
export HISTFILE=~/.history

# Charset is UTF-8
export LANG='en_US.UTF-8'
export LC_CTYPE='en_US.UTF-8'
export LC_ALL=''
export LESSCHARSET='utf-8'

# Use colours, show all directories including "./.." and postfix directories
# with '/', symlinks with '@' etc.
alias ls='ls --color -aF'

# Don't store SSH server hostkey in ~/.ssh/known_hosts file
alias ussh='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias uscp='scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

# Show also dotfiles, colored
alias tree='tree -aRC'

# Rename all files ending .txt to end with .asc: 'mmv *.txt *.asc'
autoload -Uz zmv
alias mmv='noglob zmv -W'

# 10ms delay for key sequences ('Esc' works without delay)
export KEYTIMEOUT=1


# Don't terminate background jobs when shell exits
setopt nohup
# Completion also in middle of a word
setopt completeinword
# Ignore lines beginning with '#'
setopt interactivecomments
# Disable ctrl-s/ctrl-q terminal start/stop
setopt noflowcontrol


##############################################################################
# Changing directories

# Make cd push the old directory onto the directory stack
# Use 'dirs' to inspect, 'cd -<TAB>' for completion
setopt AUTO_PUSHD
# Never print the directory stack after cd
setopt CD_SILENT
# Don't push duplicates to the directory stack
setopt PUSHD_IGNORE_DUPS
# Don't print the directory stack after pushd or popd
setopt PUSHD_SILENT
# No harm in having a longer directory history
export DIRSTACKSIZE=32
# Display numbered list of directory stack (newline separator)
alias dirs='dirs -v'


##############################################################################
# Completion

# Load completion listing extension
zmodload zsh/complist
# Automatically list choices on an amiguous completion
setopt AUTO_LIST
# Automatically use menu completion on second consecutive tab
setopt AUTO_MENU
# Enable completion list navigation
zstyle ':completion:*' menu select
# Completion requires at least one typed character
zstyle ':completion:*' insert-tab true
# Be verbose when possible and reasonable (try: 'echo ${[(<TAB>')
zstyle ':completion:*' verbose yes
zstyle ':completion:*:messages' format %d
zstyle ':completion:*:options' description yes
zstyle ':completion:*:options' auto-description %d
# Use cache for completion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh
# Completion for process IDs with menu selection
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always
# Expand partial paths (/us/sr/<TAB> -> /usr/src/)
zstyle ':completion:*' expand yes
# Expand // as / instead of /*/
zstyle ':completion:*' squeeze-slashes true
# Use ls(1) colors also in file completion menu
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# Don't complete backup files (*~) as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'
# If no exact match is found, match also lowercase to uppercase and vice versa
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# Use vi-style moving in interactive completion selection menu
bindkey -M menuselect 'j' down-line-or-search
bindkey -M menuselect 'k' up-line-or-search
bindkey -M menuselect 'l' forward-char
bindkey -M menuselect 'h' backward-char
# There are only full screen up/down binds available for menu navigation
bindkey -M menuselect '^B' backward-word
bindkey -M menuselect '^F' forward-word
# Bind PgUp and PgDn to ^B and ^F
bindkey -s -M menuselect $terminfo[kpp] '^B'
bindkey -s -M menuselect $terminfo[knp] '^F'

# file-list changes completion menu to look like 'ls -l' output when completing
# file names, but it doesn't work with 'list-colors':
#       https://www.zsh.org/mla/users/2020/msg00229.html
#
# Since screen up/down has good synergy with long list type menu, create a
# custom key binding for invoking file-list.
zle -C file-list-expansion complete-word _generic
bindkey '^B' file-list-expansion
bindkey '^F' file-list-expansion
zstyle ':completion:file-list-expansion:*' file-list all
zstyle ':completion:file-list-expansion:*' completer _files
# PgUp/PgDn also work for invoking the long-list menu
bindkey -s $terminfo[kpp] '^B'
bindkey -s $terminfo[knp] '^F'

# Press ctrl-o in menu select to pick item and continue in menu
bindkey '^O' accept-and-menu-complete


##############################################################################

setopt NO_BEEP            # Just stfu plz
setopt NO_HIST_BEEP       # Don't beep on history misses
setopt LONG_LIST_JOBS     # List jobs in long format by default
setopt APPEND_HISTORY     # Append to history file rather than rewriting it
setopt HIST_IGNORE_SPACE  # Delete cmds starting with whitespace from history
setopt SHARE_HISTORY      # Share history file on the fly between sessions
setopt EXTENDED_HISTORY   # Save cmd start time and duration in history
setopt HIST_IGNORE_DUPS   # Don't store consequtive duplicates of same cmd in history
setopt MULTIOS            # Built-in tee(1)
setopt PIPE_FAIL          # Return exit code of first failed cmd in a pipeline
setopt C_BASES            # Use C-style hex (0x1A) notation
setopt OCTAL_ZEROES       # Use C-style octal (077) notation
setopt C_PRECEDENCES      # Use C-style arithmetic operator precedence
setopt BSD_ECHO           # Don't interpret escape sequences without '-e'

# This may be a little intrusive, since it turns ^ and ~ into special characters
# that need to be escaped if used literally.
setopt EXTENDED_GLOB

# Path completion for files beginning with a dot
setopt GLOBDOTS

# Interactive reverse search through command history. Very useful. Use modified
# Bash bindings; in Bash, ^S changes search direction rather than being
# directly bound to searching forward.
bindkey -M viins '^R' history-incremental-pattern-search-backward
bindkey -M viins '^S' history-incremental-pattern-search-forward

# Vim style undo/redo
bindkey -M vicmd '^R' redo
bindkey -M vicmd 'u' undo

# Edit current command-line in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

# Use a maximum man page width of 112 chars. Easier on the eyes on very wide screens.
man() {
    for p in $(whence -a man); do
        [[ $p[1] == "/" ]] && { local man=$p ; break }
    done
    # Leave four spaces empty on the right side
    if (( $COLUMNS > 116 )); then
        MANWIDTH=112 $man $@
    else
        MANWIDTH=$(($COLUMNS-4)) $man $@
    fi
}

# MiSTer doesn't have man at all..
unfunction man

#############################################################################
#
# Commit line to history without executing it using down arrow (like irssi)
#
down-or-commit-to-history() {
    if (( HISTNO == HISTCMD )) && [[ $RBUFFER != *$'\n'* ]]; then
        print -s ${(z)BUFFER}
        zle send-break
    fi
    zle down-line-or-beginning-search $@
}

# Typing something and then pressing up searches through history for command
# lines with same start.
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N down-or-commit-to-history
bindkey '^[[A' up-line-or-beginning-search      # Arrow up
bindkey '^[[B' down-or-commit-to-history        # Arrow down

# Likewise for vi command mode
bindkey -M vicmd 'k' up-line-or-beginning-search
bindkey -M vicmd 'j' down-or-commit-to-history

#############################################################################
#
# Set cursor to blue when in command mode.
#
# ZLE hook docs:
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Special-Widgets
#
setccol() { printf '\033]12;%s\007' "$1" }

# Get desired color RGB values, requires 'solarized' function
local cmdcolor=$S_color_rgb[blue]
local inscolor=$S_color_rgb[base1]

zle-keymap-select() {
    [[ $KEYMAP == vicmd ]] && setccol $cmdcolor || setccol $inscolor
}

zle-line-finish() { setccol $inscolor }
zle-line-init() { zle -K viins ; setccol $inscolor }

zle -N zle-keymap-select
zle -N zle-line-finish
zle -N zle-line-init

#############################################################################
#
# Little helper functions

settitle() {
    local ptitle="#[fg=$tmux_title_col]$(hostname -s)#[fg=default]"
    (( $(id -u) == 0 )) && ptitle="#[fg=color1]root#[fg=color12]@$ptitle"
    printf '\033]2;%s\007' "$ptitle"
} ; (( ${+TMUX} )) && settitle

ssh() {
    emulate -L zsh
    # In case ssh() shell function is already set, first get a list of all
    # set ssh commands and pick the one that starts with a slash
    for p in $(whence -a ssh); do
        [[ $p[1] == "/" ]] && { local ssh=$p ; break }
    done
    $ssh -o SendEnv="ITERM_SESSION_ID TMUX STY WINDOW" $@
    (( ${+TMUX} )) && settitle
}

# A function instead of an alias simply because an alias breaks completion
sudo() {
    emulate -L zsh
    for p in $(whence -a sudo); do
        [[ $p[1] == "/" ]] && { local sudo=$p ; break }
    done
    $sudo --preserve-env=ZDOTDIR $@
    (( ${+TMUX} )) && settitle
}
# Now we can alias sudo to itself, which will call the above function.
# A trailing space in the alias instructs the shell to consider next
# argument for alias exapnsion, so sudo can be used to call aliased
# commands such as "ussh".
alias sudo='sudo '

alias vim="vim -u $ZDOTDIR/.vim/vimrc"
# Vim macro for behaving like less(1) but with syntax highlighting
alias vless=$(vim -e -T ansi --cmd 'exe "set t_cm=\<C-M>"|echo $VIMRUNTIME|quit' \
    | tr -d '\015')/macros/less.sh

# Use neovim if available
whence nvim &>/dev/null
if (( $? == 0 )) ; then
    alias nvless=$(nvim -es -V1 --cmd ':echo globpath(&rtp, "**/less.sh")|:q!' 2>&1)
    alias nvim="nvim -u $ZDOTDIR/.config/nvim/init.vim"
    export EDITOR=(nvim -u $ZDOTDIR/.config/nvim/init.vim)
    alias nvimdiff="nvim -u $ZDOTDIR/.config/nvim/init.vim -d"
else
    export EDITOR=(vim -u $ZDOTDIR/.vim/vimrc)
fi
export VISUAL=($EDITOR)

if [[ -f /etc/redhat-release ]]; then
    # RHEL based distros want to clear the screen a lot. It's annoying.
    export LESS="$LESS -X"
    print 'setopt norcs' > $ZDOTDIR/.zlogout

    # They also need this for LESS_* coloring to work
    export GROFF_NO_SGR=1
fi

# My own utility functions
autoload -Uz urlencode
autoload -Uz lldp-discovery
autoload -Uz dec2hex
autoload -Uz hex2dec

for p in "/usr/libexec" "/usr/local/libexec" "$ZDOTDIR/.local/bin" ; do
    [[ -d $p ]] && typeset -xU PATH="$PATH:$p"
done
