#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#

FIGNORE=".o:~"
HISTFILE=~/.zsh_history_$LOGNAME
HISTSIZE=1500000
SAVEHIST=1000000

# History
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# Job Control
setopt AUTO_RESUME
setopt NOTIFY


# Changing Directories
setopt NO_AUTO_CD
setopt AUTO_PUSHD
setopt CDABLE_VARS
setopt NO_CHASE_DOTS
setopt NO_CHASE_LINKS
setopt PUSHD_IGNORE_DUPS

# Completion & Globbing
setopt GLOB_COMPLETE
setopt LIST_TYPES
setopt MARK_DIRS
setopt NO_NOMATCH

# Zle
setopt NO_BEEP

for alias in $HOME/.aliases*(N) ; do
    source $alias
done


#Prompt Color Table Z shell
fg_black="%{"$'\e[00;30m'"%}"
fg_red="%{"$'\e[00;31m'"%}"
fg_green="%{"$'\e[00;32m'"%}"
fg_yellow="%{"$'\e[00;33m'"%}"
fg_blue="%{"$'\e[00;34m'"%}"
fg_magenta="%{"$'\e[00;35m'"%}"
fg_cyan="%{"$'\e[00;36m'"%}"
fg_lgray="%{"$'\e[00;37m'"%}"
fg_dgray="%{"$'\e[01;30m'"%}"
fg_lred="%{"$'\e[01;31m'"%}"
fg_lgreen="%{"$'\e[01;32m'"%}"
fg_lyellow="%{"$'\e[01;33m'"%}"
fg_lblue="%{"$'\e[01;34m'"%}"
fg_pink="%{"$'\e[01;35m'"%}"
fg_lcyan="%{"$'\e[01;36m'"%}"
fg_white="%{"$'\e[01;37m'"%}"
#Attributes
at_normal="%{"$'\e[00m'"%}"
newline="%{"$'\n'"%}"

# Now for the real prompt
setopt PROMPT_SUBST

#export RPROMPT="%* %D{%Y%m%f}"
#precmd () {print -Pn "\e]0;%n@%m: %~\a"}

export RPROMPT=""

if [ -z "$HOST_ALIAS" ] ; then
    HOST_ALIAS='%2m'
fi
export PROMPT="${fg_magenta}[%D{%F %T %Z}]
%(!.${fg_red}.${fg_green})%n@${HOST_ALIAS}: ${fg_yellow}%~
${at_normal}%# "

# Fix key bindings
bindkey -v
bindkey "^U" backward-kill-line
bindkey "^K" kill-line
bindkey "^R" history-incremental-search-backward
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^[[5~" beginning-of-buffer-or-history
bindkey "^[[6~" end-of-buffer-or-history

zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit
