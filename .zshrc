# Powerlevel9k theme configs
POWERLEVEL9K_MODE='nerdfont-complete'

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir dir_writable rbenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator command_execution_time time date_joined)

DEFAULT_USER=jnoliveira
POWERLEVEL9K_ALWAYS_SHOW_USER=true

POWERLEVEL9K_DATE_FORMAT=%D{%d/%m/%y}
POWERLEVEL9K_DATE_BACKGROUND=grey0
POWERLEVEL9K_DATE_FOREGROUND=white

POWERLEVEL9K_TIME_BACKGROUND=$POWERLEVEL9K_DATE_BACKGROUND
POWERLEVEL9K_TIME_FOREGROUND=$POWERLEVEL9K_DATE_FOREGROUND

POWERLEVEL9K_VCS_BRANCH_ICON=$'\uE0A0 '
POWERLEVEL9K_VCS_GIT_GITHUB_ICON=$'\uF09B '

# Load zgen
source "${HOME}/.zgen/zgen.zsh"

# If the init scipt doesn't exist
if ! zgen saved; then

  # Specify plugins here
  zgen oh-my-zsh
  zgen oh-my-zsh plugins/command-not-found

  # Apparently these two must be at the end in this order
  zgen load zsh-users/zsh-syntax-highlighting.git
  zgen load zsh-users/zsh-autosuggestions.git

  zgen load bhilburn/powerlevel9k powerlevel9k
  
  # Generate the init script from plugins above
  zgen save
fi

# Aliases
alias zshconfig="subl ~/.zshrc & disown"
alias zshsource="source ~/.zshrc"
