#Aliases
alias zshsource="source ~/.zshrc"
alias zshconfig="subl ~/.zshrc & disown"
alias ding="paplay /usr/share/sounds/freedesktop/stereo/complete.oga & disown"

# Powerlevel9k theme configs
POWERLEVEL9K_MODE='nerdfont-complete'

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir dir_writable rbenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs command_execution_time time date_joined)

DEFAULT_USER=jnoliveira
POWERLEVEL9K_ALWAYS_SHOW_USER=true

POWERLEVEL9K_DATE_FORMAT=%D{%d/%m}
POWERLEVEL9K_DATE_BACKGROUND=grey0
POWERLEVEL9K_DATE_FOREGROUND=white

POWERLEVEL9K_TIME_BACKGROUND=$POWERLEVEL9K_DATE_BACKGROUND
POWERLEVEL9K_TIME_FOREGROUND=$POWERLEVEL9K_DATE_FOREGROUND

POWERLEVEL9K_OK_ICON=$'\uF62B'
POWERLEVEL9K_HOME_ICON=$'\uF7DB'
POWERLEVEL9K_TIME_ICON=$'\uE38A '
POWERLEVEL9K_VCS_BRANCH_ICON=$'\uE0A0 '
POWERLEVEL9K_VCS_STASH_ICON=$'\uF48D '
POWERLEVEL9K_VCS_TAG_ICON=$'\uF673 '
POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON=$'\uE340 '
POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON=$'\uE353 '
POWERLEVEL9K_LOCK_ICON=$'\uF456'

# Load zgen
source "${HOME}/.zgen/zgen.zsh"

# If the init script doesn't exist
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

# Don't share history between different ZSH sessions
unsetopt share_history

# Android SDK & NDK paths
ANDROID_HOME=/home/jnoliveira/android/sdk
ANDROID_NDK_HOME=/home/jnoliveira/android/ndk-r12b
PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# QT Toolchain paths
QT_SDK_5_6_3=/home/jnoliveira/Programs/Qt5.6.3/5.6.3/gcc_64
PATH=$PATH:/home/jnoliveira/Programs/Qt5.6.3/5.6.3/gcc_64/bin
