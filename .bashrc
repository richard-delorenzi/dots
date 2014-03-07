# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

##terminal title
title_=""
cmd_=""
PS1="#\!>"
PROMPT_COMMAND=cd_prompt
export PS1 PROMPT_COMMAND

function cd_prompt
{
  if [[ "x${WINDOW_NAME_}" != "x" ]]
  then
    title_=" << ${WINDOW_NAME_} >>"
  else
    title_=""
  fi

  title_="${title_} [$(pwd)]"

  echo -ne "\033]0;${title_}\007"
  
}

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
HISTCONTROL=ignorespace:ignoredups:erasedups
HISTFILESIZE=99999
HISTSIZE=99999
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
# append to the history file, don't overwrite it
shopt -s histappend
#history
shopt -s cmdhist
shopt -s histreedit
shopt -s histverify
shopt -s lithist

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

#case insensative searching
shopt -s nocaseglob
# 
shopt -u nullglob
shopt -s globstar
shopt -s xpg_echo
shopt -s autocd
shopt -s dirspell
shopt -s extglob

#language
export LANG=en_GB.utf8

#don't auto complete hidden files
bind 'set match-hidden-files off'

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

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

if false //no cd prompt
    then
    if [ "$color_prompt" = yes ]; then
      PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    fi
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
    alias      l='ls --color=always -F'
    alias     ll='ls --color=always -F -lh'
    alias      L='ls --color=always -F     -L'
    alias     LL='ls --color=always -F -lh -L'
    alias     la='ls --color=always -F        -a'
    alias    lla='ls --color=always -F -lh    -a'
    alias    ll.='ls --color=always -F -lh    -d .'
    alias  ldots='ls --color=always -F        -A --ignore=\*'
    alias lldots='ls --color=always -F -lh    -A --ignore=\*'


    alias  grep='grep  --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias rmtil='rm *.~+([0-9])~'
alias rotd='pushd +1'

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
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

#alias edit='emacsclient --alternate-editor="" --no-wait $*'
function edit {
    #this method gives a differant emacs server to each X11 virtual desktop
    desktop=$(xprop -id $WINDOWID | sed -rn -e  's/_NET_WM_DESKTOP\(CARDINAL\) = ([^)]+)/\1/pg')
    if test "z${desktop}" != "z"
    then
        server="desktop${desktop}"
    else
        server="server" #use this server if can't find virtual desktop
    fi

    echo server=$server

    emacsclient -s "${server}" $*
    if test  "z$PIPESTATUS" != "z0"
    then
        lisp="(setq server-name '\"${server}\")"
	emacs --daemon --eval "$lisp"
        emacsclient -s "${server}" $*
    fi
}


################################################################
function emacsdoit() {
    emacsclient  --eval "$@"
}

function emacs_setcompilercommand() {
    echo "setting compile-command"
    emacsdoit "(setq compile-command \"cd $(pwd); ./make.bat\")"
    echo "setting grep-find-command"
    emacsdoit "(setq grep-find-command \"find $(pwd) \\\\( \\\\( -name _svn -o -iname object \\\\) -prune \\\\) -o -type f \\\\( -iname '*.cpp' -o -iname '*.c' -o -iname '*.h' \\\\) -print0 | xargs -0 -e grep -inH -E \")" 
    echo "loading highlight config"
    emacsdoit "(ctypes-read-file \"$(pwd)/emacs.ctypes\")"
}

export http_proxy=http://localhost:3128
export https_proxy=$http_proxy

