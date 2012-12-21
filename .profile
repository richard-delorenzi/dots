# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$PATH:$HOME/bin"
fi
if [ -d "$HOME/bin/override" ] ; then
    PATH="$HOME/bin/override:$PATH"
fi

export HTML_TIDY=~/.htmltidy

# eiffel
export ISE_EIFFEL=/opt/Eiffel70
export ISE_PLATFORM=linux-x86
export SMARTEIFFEL=/opt/SmartEiffel

export PATH=$SMARTEIFFEL/bin:$PATH #:$ISE_EIFFEL/studio/spec/$ISE_PLATFORM/bin