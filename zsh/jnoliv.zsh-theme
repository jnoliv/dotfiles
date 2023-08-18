setopt PROMPT_PERCENT

# Icons, separators, colours, etc.
declare -r CSI=$'\033['

declare -r LDIV=$'\Ue0b0'
declare -r RDIV=$'\Ue0b2'

declare -r FG_ZSH='#FFFFFF'
declare -r FG_ANSI='255;255;255'

declare -r CLOCK_BG_ZSH='#263238'
declare -r CLOCK_BG_ANSI='38;50;56'
declare -r CLOCK_ICONS=(
    $'\Uf144b'
    $'\Uf144c'
    $'\Uf144d'
    $'\Uf144e'
    $'\Uf144f'
    $'\Uf1450'
    $'\Uf1451'
    $'\Uf1452'
    $'\Uf1453'
    $'\Uf1454'
    $'\Uf1455'
    $'\Uf1456'
)

declare -r USERHOST_BG='#009999'

declare -r FOLDER_BG='#2487C3'
declare -r FOLDER_HOME_ICON=$'\Uf015'
declare -r FOLDER_FULL_ICON=$'\Ue6ad'
declare -r FOLDER_TRUNC_ICON=$'\Uf07c'

declare -r GIT_BG_CLEAN='#388E3C'
declare -r GIT_BG_DIRTY='#A68D24'
declare -r GIT_NORMAL_ICON=$'\Ue0a0'
declare -r GIT_MERGE_ICON=$'\Uebab'
declare -r GIT_REBASE_ICON=$'\Uebab'
declare -r GIT_AHEAD_ICON=$'\Uf005f'
declare -r GIT_BEHIND_ICON=$'\Uf0047'

declare -r MARKER_BG="$FG_ZSH"

declare -r ERROR_BG='#BF360C'

# Clock segment.
# The clock icon and time are updated every second, unless doing so would
# impact the behaviour of the current widget. To guarantee the prompt will
# show the time at which a command was executed, just before a command is
# executed the prompt is reset.

update_clock () {
    local -r date=$( date +"%H:%M:%S" )

    local hour
    IFS=':' read hour _rest <<< "$date"

    hour=$(( hour % 12 ))
    [ "$hour" -eq 0 ] && hour=12

    psvar[1]="${CLOCK_ICONS[$hour]}"
    psvar[2]="$date"
}

precmd_functions+=( update_clock )

TRAPALRM () {
    update_clock

    CLOCK_UPDATED='true'
    UPDATE_GIT='true'

    case "$WIDGET" in
        expand-or-complete|\
        self-insert|\
        up-line-or-beginning-search|\
        down-line-or-beginning-search|\
        backward-delete-char|\
        .history-incremental-search-backward|\
        .history-incremental-search-forward)
            ;;

        *)
            zle && zle reset-prompt;;
    esac
}

TMOUT=1

reset-prompt-and-accept-line() {
    # No point in resetting prompt if time hasn't changed.
    if [ -n "$CLOCK_UPDATED" ]; then
        zle reset-prompt

        CLOCK_UPDATED=
    fi

    zle accept-line
}

zle -N reset-prompt-and-accept-line

bindkey '^m' reset-prompt-and-accept-line

# User and host segment.
# Only shown if the shell was created by an SSH connection. The goal is to keep the
# prompt small when using the shell locally, where user and host are predictable.
userhost () {
    # -f option is useful for testing.
    if [[ "$1" == "-f" ]] || [ -n "$SSH_CONNECTION" ]; then
        psvar[3]='true'
    fi
}

# Folder segment.
# The icon used at the start of the folder segment depends on the folder. There's an icon
# for the home folder, an icon for paths fully shown in the prompt, and another icon for
# paths which have been shortened due to having too many elements.
update_folder_icon () {
   if [[ "$PWD" == "$HOME" ]]; then
        psvar[4]="$FOLDER_HOME_ICON"
    else
        psvar[4]="$FOLDER_FULL_ICON"
    fi
}

chpwd_functions+=( update_folder_icon )

# Git segment.
# If the current working directory is in a git repo:
# * set the segment's background colour based having local changes
# * set the segment icon based on a merge / rebase being in progress
# * show number of commits ahead of remote branch, if any
# * show number of commits behind the remote branch, if any
#
# This segment is only updated if TRAPALRM has run since the last update.
update_git_dir () {
    psvar[5]="$( git rev-parse --git-dir 2> /dev/null )"
}

chpwd_functions+=( update_git_dir )

update_git_segment () {
    local -r git_dir="${psvar[5]}"

    { [ -z "$git_dir" ] || [ -z "$UPDATE_GIT" ] } && return


    UPDATE_GIT=

    # Set background colour.
    if git diff-index --quiet HEAD --; then
        psvar[6]="$GIT_BG_CLEAN"
    else
        psvar[6]="$GIT_BG_DIRTY"
    fi

    # Set icon.
    if [ -f "$git_dir/MERGE_HEAD" ]; then
        psvar[7]="$GIT_MERGE_ICON"
    elif [ -d "$git_dir/rebase-merge" ] || [ -d "$git_dir/rebase-apply" ]; then
        psvar[7]="$GIT_REBASE_ICON"
    else
        psvar[7]="$GIT_NORMAL_ICON"
    fi

    # Set local branch (and remote used in next block).
    local branch remote_branch

    IFS='/' read _ _ branch < "$git_dir/HEAD"

    read -d '' remote_branch \
        <<< "$( git rev-parse --abbrev-ref --symbolic-full-name @{u} 2> /dev/null )"
    
    psvar[8]="$branch"

    if [ -z "$branch" ] || [ -z "$remote_branch" ]; then
        return
    fi

    # Set number of commits ahead and behind.
    local nahead nbehind

    read nahead nbehind \
        <<< "$( git rev-list --left-right --count $branch...$remote_branch )"

    [ "$nahead" -ne 0 ]  && psvar[9]="$nahead"  || psvar[9]=
    [ "$nbehind" -ne 0 ] && psvar[10]="$nbehind" || psvar[10]=
}

precmd_functions+=( update_git_segment )

# Update data to be included in first prompt display.
UPDATE_GIT='true'

update_clock
userhost
update_folder_icon
update_git_dir
update_git_segment

# Set prompts.
#
# The psvar array contains the following items:
# psvar[1]  - clock segment icon
# psvar[2]  - clock segment time
# psvar[3]  - non-empty if user host segment should be shown
# psvar[4]  - folder segment icon
# psvar[5]  - path to git directory if in a git repo, empty otherwise
# psvar[6]  - git segment background colour
# psvar[7]  - git segment icon
# psvar[8]  - git segment local branch
# psvar[9]  - git segment number of commits ahead of remote
# psvar[10] - git segment number of commits behind remote

# I'm deeply sorry.
PS1=\
"%F{$FG_ZSH}"\
"%K{$CLOCK_BG_ZSH}"\
'%B%1v%b%2v'\
"%F{$CLOCK_BG_ZSH} "\
"%(3V|%K{$USERHOST_BG}$LDIV|%K{$FOLDER_BG}$LDIV)"\
\
"%F{$FG_ZSH}"\
"%(3V|%K{$USERHOST_BG} %n@%m "\
"%F{$USERHOST_BG}%K{$FOLDER_BG}$LDIV"\
'|)'\
\
"%F{$FG_ZSH}"\
"%K{$FOLDER_BG}"\
" %(4~|$FOLDER_TRUNC_ICON.../%2~|%4v%~) "\
"%F{$FOLDER_BG}%K{%(5V/%6v/)}$LDIV"\
\
"%F{$FG_ZSH}"\
'%(5V'\
'| %K{%6v}%7v%8v '\
"%(9V/$GIT_AHEAD_ICON%9v/)"\
"%(10V/$GIT_BEHIND_ICON%10v/)"\
" %F{%6v}%k$LDIV"\
'|)%f%k '

PS2="%K{$MARKER_BG}  %F{$MARKER_BG}%k$LDIV %f"

RPS1="%(0?||%F{$ERROR_BG}%k$RDIV%F{$FG_ZSH}%K{$ERROR_BG} %? %f%k)"
