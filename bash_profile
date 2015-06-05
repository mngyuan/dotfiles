#!/bin/sh

# a bashrc (bash_profile on OSX)
# also for my 64bit cygwin

# if not interactive, don't setup
[ -z "$PS1" ] && return

# python aliases
alias pt='python3 -m doctest'
alias p='python3'
alias pi='python3 -i'
alias p2='python2.7'
alias p2t='python2.7 -m doctest'
# git aliases
alias gitpull='ssh-add && git pull'
alias gitpullr='ssh-add && git pull --rebase'
# pretty lists and view hidden
alias ll="ls -lsGh"
# prefer vim, duh
export GIT_EDITOR=vim
source ~/git/dotfiles/aliases

# looking for errors
function ptgrep {
    # first param file name
    # second param pattern to look for
    pt $1 | grep -A 10 -n $2 | less
}

# custom prompt with git branch
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWCOLORHINTS=true
GIT_PS1_SHOWUPSTREAM="auto"
source ~/bin/git-prompt.sh
# need to add the virtualenv thing back in
    PURPLE="\[\033[1;34m\]"
    YELLOW="\[\033[1;33m\]"
 LIGHT_RED="\[\033[1;31m\]"
COLOR_NONE="\[\033[0m\]"
# export PS1='\[\e[0;33m\]\u@\h:\W\[\e[0;33m\]$(__git_ps1 " (%s)") \$\[\e[m\] '
function set_prompt_symbol () {
	if test $1 -eq 0 ; then
		PROMPT_SYMBOL="\$"
	else
		PROMPT_SYMBOL="${LIGHT_RED}\$${COLOR_NONE}"
	fi
}
function set_virtualenv () {
	if test -z "$VIRTUAL_ENV" ; then
		PYTHON_VIRTUALENV=""
	else
		PYTHON_VIRTUALENV="${PURPLE}venv ${COLOR_NONE}"
	fi
}

update_terminal_cwd() {
	# Identify the directory using a "file:" scheme URL,
	# including the host name to disambiguate local vs.
	# remote connections. Percent-escape spaces.
	local SEARCH=' '
	local REPLACE='%20'
	local PWD_URL="file://$HOSTNAME${PWD//$SEARCH/$REPLACE}"
	printf '\e]7;%s\a' "$PWD_URL"
}

function set_bash_prompt() {
	# Set the PROMPT_SYMBOL variable. We do this first so we don't lose the
	# return value of the last command.
	set_prompt_symbol $?

	set_virtualenv

	if hostname -s | grep -q "airbears" &>/dev/null ; then
		BASH_PROMPT="${PYTHON_VIRTUALENV}${YELLOW}\u:\w${COLOR_NONE}"
	else
		BASH_PROMPT="${PYTHON_VIRTUALENV}${YELLOW}\u@\h:\w${COLOR_NONE}"
	fi
}
PROMPT_COMMAND='update_terminal_cwd; set_bash_prompt ; __git_ps1 "$BASH_PROMPT" "${YELLOW}${PROMPT_SYMBOL}${COLOR_NONE} "'

# start ssh-agent
SSH_ENV="$HOME/.ssh/environment"
function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}
# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi
# end ssh agent stuff

if [[ "$(uname)" == CYGWIN* ]]; then
	alias subl="/cygdrive/c/Program\ Files/Sublime\ Text\ 3/sublime_text.exe"
else
	# tab completion for git, which is already included in cygwin
	source ~/bin/git-completion.bash
fi
# for vim
stty -ixon
