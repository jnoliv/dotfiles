# Set up history.
export HISTFILE="$XDG_STATE_HOME/.zhistory"
export HISTSIZE=10000
export SAVEHIST=100000

setopt APPEND_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS
unsetopt SHARE_HISTORY

# Print timing statistics (if taking >5s).
export REPORTTIME=5

# Set up dircolors.
eval "$(dircolors -b)"

# Aliases.
if [ -f "$ZDOTDIR/.zshaliases" ]; then
    source "$ZDOTDIR/.zshaliases"
fi

# Command completion.
fpath=($ZDOTDIR/plugins/zsh-completions/src $fpath)

autoload -Uz compinit; compinit
_comp_options+=(globdots)

# Machine specific settings, thus not versioned.
if [ -f "$ZDOTDIR/.zshpriv" ]; then
    source "$ZDOTDIR/.zshpriv"
fi

# Plugins.
source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZDOTDIR/plugins/command-not-found.zsh"
source "$ZDOTDIR/plugins/key-bindings.zsh"
source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" # Must be last!

# Prompt.
source "$ZDOTDIR/jnoliv.zsh-theme"

# Use gpg-agent for SSH.
# https://opensource.com/article/19/4/gpg-subkeys-ssh
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

# Uncomment to allow profilling using zprof.
#zmodload zsh/zprof

[ -f "/home/jnoliv/.ghcup/env" ] && source "/home/jnoliv/.ghcup/env" # ghcup-env