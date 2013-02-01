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

alias edit='emacsclient --alternate-editor="" --no-wait $*'

##cvs functions 
function      cvslog() { 
    cvs log -h LogFile
}

function  cvswatchers() { 
    cvs watchers 
}

function cvsstatus() { 
    (cvs status * ; cvs status) 2>/dev/null                       |
    grep ^File:                                                   |
    sed -r -e 's/^File:[[:blank:]]+no[[:blank:]]file/File:/g'     |
    sort -rk 4                                                    |
    uniq                                                          |
    sed -r -e 's/Locally[[:blank:]]+(Removed|Added)/Locally-\1/g' |
    sed -r -e 's/Needs[[:blank:]]+Patch/Needs-Patch/g'            |
    sed -r -e 's/Entry[[:blank:]]+Invalid/Entry-Invalid/g'        |
    column.exe -t
}

function cvsrmlocks() {
    find /mnt/i/CVS/CVS-revision-control-repositary -iname "#cvs.rfl.($USERNAME).*" -print0 | 
    xargs -0 rm
}

function _cvstagstuff() {
    logfile="$1"
    comment="$2"
    user=$(echo $USER| tr "." "_")
    time=$(date +%d%m%y_%H%M) 
    echo "logfile: $logfile"            
    echo "comment: $comment"            
    echo "user:    $user"               
    echo "time:    $time"               
    
    module=$(
    cat $logfile |
    grep -E "^Project:" |
    sed -re "s/^Project:(.*)/\1/g"
    )
    echo "module:  $module"             
    
    #cvs commit -f -m "$comment" $logfile
    
    status=$(
    cvs status $logfile
    )

    version=$( 
    echo "$status" | 
    grep -E "^[[:blank:]]+Working revision:" | 
    sed -re "s/^[[:blank:]]+Working revision:[[:blank:]]+([1-9.]+)/\1/g" |
    tr . -
    )
    echo "version: $version"

    branch=$(
    echo "$status" |
    grep -E "^[[:blank:]]+Sticky Tag:" |
    sed -re "s/^[[:blank:]]+Sticky Tag:[[:blank:]]+([^[:blank:]]+).*/\1/g" 
    )
    echo "branch: $branch"
}
function cvstag() {
    (
    set -e
    _cvstagstuff $*
        
    tag="alaris_${user}_${time}_${module}_${version}#${comment}"
    
    echo "setting tag: $tag"           
    cvs tag -R "$tag"
    
    echo "set tag to $tag"               
    )
}

function cvsbranch() {
   (
    set -e
    _cvstagstuff $*
    branch_decoration1="branch" 
    branch_decoration2="branch_base"

    tag1="alaris_${user}_${branch_decoration1}_${time}_${module}_${version}#${comment}"
    tag2="alaris_${user}_${branch_decoration2}_${time}_${module}_${version}#${comment}"

    echo "% setting branch:   $tag1"
    echo "% setting base tag: $tag2"

        echo "% up reving logfile"
    cvs commit -f -m "" $logfile
          
        echo "% applying branch base tag"
    cvs tag    -R "$tag2" 
    echo "% applying branch tag"
    cvs tag -b -R "$tag1"

    echo "% switching to branch"
    cvs update -r "$tag1"

    echo "% up reving logfile"
    cvs commit -f -m "$tag1" $logfile

    echo "% have set branch   to: $tag1"
    echo "% have set base tag to: $tag2"   
    )
}

function cvsgetversion() {
    name=$1
    version=$2
    
    base=$(echo $name | sed -re "s@([^.]*)([.]?.*)@\1@g")
    extn=$(echo $name | sed -re "s@([^.]*)([.]?.*)@\2@g")
    tofile=$base-$version$extn
    echo getting: $name $version "->" $tofile
    cvs update -p -r $version $name > $tofile
}

#below here not usable yet
function cvssync() {
    (
    set -e
    _cvstagstuff $*
    
    tagbranch="alaris_${user}_trunk_pre_sync_${time}_${module}_${version}#${comment}"
        tagtrunk="alaris_${user}_branch_base_${time}_${module}_${version}#${comment}"
    
    echo "not setting tag: $tagbranch on branch"
    echo "not setting tag: $tagtrunk  on trunk"

    )
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
