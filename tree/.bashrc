#!/bin/bash
#
#
# Copyright (C) 2014 Arnaud Levaufre <arnaud@levaufre.name>
#
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


export EDITOR=vim
export PAGER=less
export HISTCONTROL=ignoreboth
export HISTSIZE=-1
export HISTFILESIZE=-1
export NPM_PACKAGES="${HOME}/.npm-packages"
export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
export PATH="$NPM_PACKAGES/bin:$PATH"


# append to the history file, don't overwrite it
shopt -s histappend


# COLORS
black='\e[00;30m'
red='\e[00;31m'
green='\e[00;32m'
yellow='\e[00;33m'
blue='\e[00;34m'
magenta='\e[00;35m'
cyan='\e[00;36m'
grey='\e[00;37m'
dark_grey='\e[01;30m'
light_red='\e[01;31m'
light_green='\e[01;32m'
light_yellow='\e[01;33m'
light_blue='\e[01;34m'
light_magenta='\e[01;35m'
light_cyan='\e[01;36m'
white='\e[01;37m'

# PROMPT
function git_prompt {
	BRANCH=$(/usr/bin/git branch --no-color 2> /dev/null | sed -rn 's/\* //p')
	if [[ $BRANCH ]]; then
		local BRANCH
		local ADDED
		local REMOVED
		local MODIFIED
		local UNTRACKED

		BRANCH=$(/usr/bin/git branch --no-color | sed -rn 's/\* //p')

		# git modifications
		ADDED=$(/usr/bin/git status --porcelain | sed -rn '/^A/p' | wc -l )
		if [ $ADDED -gt 0 ]; then ADDED="${green}A:"$ADDED;
		else ADDED=""; fi

		REMOVED=$(/usr/bin/git status --porcelain | sed -rn '/^D/p' | wc -l )
		if [ $REMOVED -gt 0 ]; then REMOVED="${light_red}D:"$REMOVED;
		else REMOVED=""; fi

		MODIFIED=$(/usr/bin/git status --porcelain | sed -rn '/^ ?M/p' | wc -l )
		if [ $MODIFIED -gt 0 ]; then MODIFIED="${blue}M:"$MODIFIED;
		else MODIFIED=""; fi

		UNTRACKED=$(/usr/bin/git status --porcelain | sed -rn '/^\?\?/p' | wc -l )
		if [ $UNTRACKED -gt 0 ]; then UNTRACKED="${magenta}U:"$UNTRACKED;
		else UNTRACKED=""; fi

		echo "on ${light_yellow}"$BRANCH $ADDED $REMOVED $MODIFIED $UNTRACKED" ${white}"
    else
        $(PAGER=tee git log 2>&1 | grep -i "not a git" &> /dev/null)
        if [ $? -ne 0 ]; then
            echo "on empty git repository"
        fi
	fi
}

function fancy_pwd {
	DIR=$(/bin/pwd | /bin/sed -r "s#$HOME#~#")
	if [ $(grep -o "\/" <<< $DIR | wc -l) -gt 4 ]; then
		local DIR_LIST=( $(echo $DIR | sed -rn 's_/_\n_pg' ) )
		local DIR_ROOT=""
		if [ ${DIR_LIST[0]} != "~" ]; then DIR_ROOT="/"; fi
		echo " "${DIR_ROOT}${DIR_LIST[0]}"/"${DIR_LIST[1]}"/.../"${DIR_LIST[-2]}"/"${DIR_LIST[-1]}
	else
		echo " "$DIR
	fi;
}

function prompt {
	status=$?
	if [ $status -gt 0 ]; then
		echo_last="${white} with error ${light_red}$status${white}"
	fi
	echo -e "${light_green}$(/bin/whoami)${white} at ${light_green}$(/bin/hostname)${echo_last}${white} in${light_blue}$(fancy_pwd)${white} $(git_prompt)\n::::| "
}

PS1='$(prompt)\[\033[0m\]'

# source aliases
if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# source completion
if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi
