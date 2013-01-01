# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000
HISTFILE=~/.bash_history.`tty|tr -d "/"`

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

[[ -f /etc/chef/client.rb ]] && export CHEF_ENV=$(awk '/^environment/ {print $2}' /etc/chef/client.rb|tr -d \")

function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1):/'
}

declare -A COLOR_CODES
COLOR_CODES=(
  [BLUE]="\033[0;34m"
  [LIGHT_BLUE]="\033[1;34m"
  [RED]="\033[0;31m"
  [LIGHT_RED]="\033[1;31m"
  [GREEN]="\033[0;32m"
  [LIGHT_GREEN]="\033[1;32m"
  [WHITE]="\033[1;37m"
  [LIGHT_GRAY]="\033[0;37m"
  [RESET]="\033[0m"
)

function colorize {
	echo -en "${COLOR_CODES[$1]}$2${COLOR_CODES[RESET]}"
}

if [[ -n $CHEF_ENV ]]; then
  if echo "$CHEF_ENV"| grep -qi prod ; then
      ENVCOLOR=$(colorize LIGHT_RED "${CHEF_ENV}}")
  else
      ENVCOLOR=$(colorize LIGHT_GREEN "${CHEF_ENV}}")
  fi
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    # PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
   PS1='${ENVCOLOR}$(ret=$?; if [[ $ret -eq "0" ]]; then echo -ne "\[\e[32m\]"; else echo -en "\[${COLOR_CODES[RED]}\][$ret]\[${COLOR_CODES[RESET]}\]"; fi; exit $RET)\[\e[2;33m\]${CLIENT}:$(echo -en "\[${COLOR_CODES[BLUE]}\]$(parse_git_branch)\[${COLOR_CODES[RESET]}\]")\[\e[39;22m\]\u@\h\[\e[00m\]:\[\e[34;1m\]$(if [[ $(pwd|wc -c|tr -d " ") > 18 ]]; then echo "\W"; else echo "\w"; fi)\[\e[0m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'

    #alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
if [ -d ~/.bash_completion.d ]; then
	for file in  ~/.bash_completion.d/*; do
		. $file
	done
fi
complete -C /usr/bin/command_completion_for_rake -o default rake
export SSH_ASKPASS="/usr/bin/ssh-askpass"


export EDITOR=vim
export HISTIGNORE="&:[fb]g"
export PYTHONSTARTUP="$HOME/.pythonrc"

export QUILT_PATCHES=debian/patches
export QUILT_REFRESH_ARGS="-p ab --no-timestamps --no-index"

#ulimit -S -v 2000000
#ulimit -S -m 250000
ulimit -v unlimited
