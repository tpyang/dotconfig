autoload colors
colors
 
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
eval _$color='%{$terminfo[bold]$fg[${(L)color}]%}'
eval $color='$fg[${(L)color}]'
(( count = $count + 1 ))
done
FINISH="%{$terminfo[sgr0]%}"
 
PROMPT=$(echo "$CYAN┌─$MAGENTA%D %T $CYAN%n@$YELLOW%M:$GREEN%~/$CYAN\n└─\$")

local return_code="%(?..%{$fg[RED]%}%?)%{$reset_color%}"
export RPS1="${return_code}"

case $TERM in (*xterm*|*rxvt*|(dt|k|E)term)
precmd () { print -Pn "\e]0;%~\a" }
preexec () { print -Pn "\e]0;%n@%M//%/\ $1\a" }
;;
esac

source ~/.aliasrc
alias mv='nocorrect mv'
alias mkdir='nocorrect mkdir'
alias cp='nocorrect cp -rvi'

unsetopt hup				# don't close background program when exiting shell

export EDITOR="vim"
export XMODIFIERS="@im=ibus"
export QT_MODULE=ibus
export GTK_MODULE=ibus

setopt AUTO_PUSHD			# cd to auto pushd
setopt pushdignoredups
setopt NO_FLOW_CONTROL		# disable Ctrl+s
setopt notify				# show bg jobs status immediately
limit coredumpsize 0		# disable core dumps

setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY      
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_FUNCTIONS
setopt SHARE_HISTORY
export HISTSIZE=100000
export HISTFILE=/home/yang/.bash_history
export SAVEHIST=$HISTSIZE

setopt complete_in_word   # complete /v/c/a/p
setopt nonomatch		  # enhanced bash wildcard completion

bindkey -v
autoload edit-command-line
zle -N edit-command-line
bindkey -M viins '^v' edit-command-line
bindkey '^e' end-of-line
bindkey '^d' beginning-of-line
bindkey '^h' backward-char
bindkey '^l' forward-char
bindkey '^b' backward-word
bindkey '^w' forward-word
bindkey '^u' backward-delete-word
bindkey '\C-w' kill-region
 
autoload zkbd
[[ ! -f ${ZDOTDIR:-$HOME}/.zkbd/$TERM ]] && zkbd
[[ -n ${key[Backspace]} ]] && bindkey "${key[Backspace]}" backward-delete-char
[[ -n ${key[Insert]} ]] && bindkey "${key[Insert]}" overwrite-mode
[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n ${key[PageUp]} ]] && bindkey "${key[PageUp]}" up-line-or-history
[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
[[ -n ${key[PageDown]} ]] && bindkey "${key[PageDown]}" down-line-or-history
[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-search
[[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-search
[[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char
 
# PAGER
export PAGER="/usr/bin/less -s"
export BROWSER="$PAGER"
export LESS_TERMCAP_mb=$YELLOW
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m' 
export SDCV_PAGER="sed 's/\ \ \([1-9]\)/\n\n◆\1/g' |less"

# recognize these as a part of a word
WORDCHARS='*?[]~=&;!#$%^(){}<>'
 
setopt AUTO_LIST
setopt AUTO_MENU
setopt MENU_COMPLETE
 
autoload -U compinit
compinit
 
#zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path .zcache
# ignore the current directory 
zstyle ':completion:*:cd:*' ignore-parents parent pwd
 
zstyle ':completion:*' verbose yes
zstyle ':completion:*' menu select
zstyle ':completion:*:*:default' force-list always
zstyle ':completion:*' select-prompt '%SSelect:  lines: %L  matches: %M  [%p]'
 
zstyle ':completion:*:match:*' original only
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:predict:*' completer _complete
 

# Path Completion
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-shlashes 'yes'
zstyle ':completion::complete:*' '\\'
 
# Colorful Completion
eval $(dircolors -b)
export ZLSCOLORS="${LS_COLORS}"
zmodload zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
 
# Fix case and typo
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*:approximate:*' max-errors 1 numeric
 
#zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate _user_expand
zstyle ':completion:*' completer _complete _prefix _user_expand _prefix _match 

# Grouping Completion
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'
 
# cd ~  Completing order
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
 
#kill completion
compdef pkill=kill
compdef pkill=killall
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:processes' command 'ps -au$USER '


# command highlight
setopt extended_glob
TOKENS_FOLLOWED_BY_COMMANDS=('|' '||' ';' '&' '&&' 'sudo' 'do' 'time' 'strace')
 
recolor-cmd() {
    region_highlight=()
    colorize=true
    start_pos=0
    for arg in ${(z)BUFFER}; do
        ((start_pos+=${#BUFFER[$start_pos+1,-1]}-${#${BUFFER[$start_pos+1,-1]## #}}))
        ((end_pos=$start_pos+${#arg}))
        if $colorize; then
            colorize=false
            res=$(LC_ALL=C builtin type $arg 2>/dev/null)
            case $res in
                *'reserved word'*)   style="fg=magenta";;
                *'alias for'*)       style="fg=cyan";;
                *'shell builtin'*)   style="fg=yellow";;
                *'shell function'*)  style='fg=green';;
                *"$arg is"*)
                    [[ $arg = 'sudo' ]] && style="fg=red" || style="fg=blue,bold";;
                *)                   style='none';;
            esac
            region_highlight+=("$start_pos $end_pos $style")
        fi
        [[ ${${TOKENS_FOLLOWED_BY_COMMANDS[(r)${arg//|/\|}]}:+yes} = 'yes' ]] && colorize=true
        start_pos=$end_pos
    done
}
check-cmd-self-insert() { zle .self-insert && recolor-cmd }
check-cmd-backward-delete-char() { zle .backward-delete-char && recolor-cmd }
zle -N self-insert check-cmd-self-insert
zle -N backward-delete-char check-cmd-backward-delete-char

# ... complete 
user-complete(){
	if [[ $BUFFER =~ "^\.\.\.*$" ]]; then
		BUFFER=`echo "$BUFFER" |sed 's/^/cd\ /g'` 
        zle end-of-line
		user-complete
    elif [[ $BUFFER =~ ".*\.\.\..*$" ]] ;then
		BUFFER=`echo "$BUFFER" |sed 's/\.\.\./\.\.\/\.\./g'`
        zle end-of-line
		user-complete
    fi
    zle expand-or-complete
	recolor-cmd
}
zle -N user-complete
bindkey "\t" user-complete

bg_command(){
	bg_list=(pdf gqview libreoffice)
	alert_list=(mencoder aria2c axel notify-send)
	cmd=`echo $BUFFER | sed 's/^\ *//g' | sed 's/\ .*//g'`
	in_array $cmd "${bg_list[@]}" && BUFFER=`echo $BUFFER |sed 's/$/\ 2>\/dev\/null\ \&/g'`
	in_array $cmd "${alert_list[@]}" && BUFFER=`echo $BUFFER |sed 's/$/\ ;disp finished/g'`
}

path_parse(){
    if [[ $BUFFER = "" ]] ;then
        BUFFER="ls"
        zle end-of-line
    elif [[ $BUFFER =~ ".*\.\.\..*" ]] ;then
		BUFFER=`echo "$BUFFER" |sed 's/\.\.\./\.\.\/\.\./g'`
		path_parse
	elif [[ $BUFFER =~ "^\.\..*" ]]; then
		if [[ -d `echo "$BUFFER" |sed 's/\\\ /\ /g'|sed 's/l$//g' |sed 's/ls$//g'` ]]; then
			BUFFER=`echo "$BUFFER" |sed 's/^/cd\ /g'`
			path_parse
		fi
		zle accept-line
	elif [[ $BUFFER =~ "^cd .*/ls*$" ]] ; then
		BUFFER=`echo "$BUFFER" |sed 's/l[^\/]*$/;ls/g' `
		zle end-of-line
    fi
	recolor-cmd
}

user-ret(){
	path_parse
	bg_command
    zle accept-line
}

zle -N user-ret
bindkey "\r" user-ret
 
zmodload zsh/mathfunc
autoload -U zsh-mime-setup
zsh-mime-setup

setopt EXTENDED_GLOB
autoload -U promptinit
promptinit
#prompt redhat
 
autoload compinstall
 

# add sudo 
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    [[ $BUFFER != sudo\ * ]] && BUFFER="sudo $BUFFER"
    zle end-of-line  
	recolor-cmd
}
zle -N sudo-command-line

function command_not_found_handler() {
  local command="$1"
  [ -n "$command" ] && [ -x /usr/bin/pkgfile ] && {
      echo -e "searching for \"$command\" in repos..."
      local pkgs="$(pkgfile -b -v -- "$command")"
      if [ ! -z "$pkgs" ]; then
        echo -e "\"$command\" may be found in the following packages:\n\n${pkgs}\n"
      fi
  }
  return 1
}

path=(
        $path
        /home/yang/work/hxmt_test/phassdas
        /home/yang/work/hxmt_test/pymath
    )

PYTHONPATH=(
       # $PYTHONPATH
        /home/yang/work/hxmt_test/phassdas
        /home/yang/work/hxmt_test/pymath
        /home/yang/work/ab_i/phonopy-1.9.2-rc4/scripts
    )

