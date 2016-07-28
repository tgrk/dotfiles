# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

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
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# handle mackbook air clipboard
synclient TapButton3=2 ClickFinger3=2 PalmDetect=1

# add color support
export CLICOLOR=1
# for black background
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx # alternative: gxBxhxDxfxhxhxhxhxcxcx

export PS1="\# \W $ "

# run make build jobs in parallel
export MAKEFLAGS=-j10

# prompt coloring
# see http://attachr.com/9288 for full-fledged craziness
if [ `/usr/bin/whoami` = "root" ] ; then
  # root has a red prompt
  export PS1="\[\033[1;31m\]\u@\h \w \$ \[\033[0m\]"
fi

# Source SSH settings, if applicable
SSH_ENV="$HOME/.ssh/environment"
function start_agent {
     echo "Initialising new SSH agent..."
     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
     echo succeeded
     chmod 600 "${SSH_ENV}"
     . "${SSH_ENV}" > /dev/null
     /usr/bin/ssh-add;
}

if [ -f "${SSH_ENV}" ]; then
     . "${SSH_ENV}" > /dev/null
     #ps ${SSH_AGENT_PID} doesn't work under cywgin
     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
         start_agent;
     }
else
     start_agent;
fi

# Erlang specific
#export OTPROOT=/opt/otp
#export ERL_ROOT=/usr/local/lib/erlang
##export OTPROOT="/usr/local/lib/erlang"
#export ERL_ROOT=$OTPROOT
##export ERL_LIBS="$OTPROOT/lib/:/home/wiso/erlang_libs"
##export ERL_TOP=$ERL_ROOT
#export ERL_CFLAGS=" -I$OTPROOT/erl_interface/include -I$OTPROOT/erts-5.10.4/include "

export PATH="$PATH:/opt/rebar/:$OTPROOT/bin::/usr/local/bin/pip"

# PhoneGAP/Android
export JAVA_HOME="/usr/"
export ANT_HOME="/usr/share/ant"
#export ANDROID_HOME="/home/wiso/Projects/libs/android/sdk"
#export ANDROID_TOOLS="$ANDROID_HOME/tools"
#export ANDROID_PLATFORM_TOOLS="$ANDROID_HOME/platform-tools"
#export PATH="$PATH:$JAVA_HOME:$ANT_HOME:$ANDROID_HOME:$ANDROID_TOOLS:$ANDROID_PLATFORM_TOOLS:."
export PATH="$PATH:$JAVA_HOME:$ANT_HOME"

# Brave browser
export PATH="$PATH:/usr/local/lib/Brave-linux-x64/"

# KERL - use R17.4 by default
source ~/erlang/r175/activate
alias erl16='. ~/erlang/r16b031/activate'
alias erl17='. ~/erlang/r175/activate'
alias erl18='. ~/erlang/r183/activate'

# Erlang version check for the enthusiasts
function erl_version {
 echo "$(erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().' -noshell | sed 's/[^a-bA-Z0-9]//g')"
}

# helper for jpm run to pass firefox location
alias jpmr='jpm run -b /usr/bin/firefox' 
alias jpmt='jpm test -b /usr/bin/firefox'
alias jpmrr='jpm post --post-url http://localhost:8888/'

# Elixir 
export PATH="$PATH:/opt/elixir/bin"

# Go lang GVM
[[ -s "/home/wiso/.gvm/scripts/gvm" ]] && source "/home/wiso/.gvm/scripts/gvm"
gvm use go1.6.2

# Path for Golang deps and projects
export GOPATH="$GOPATH:/home/wiso/Projects/personal/golang/"
