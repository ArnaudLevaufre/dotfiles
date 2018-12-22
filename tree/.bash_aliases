#!/bin/bash
alias ..="cd ../"
alias cp="cp -v"
alias df="df -h"
alias du="du -h"
alias free="free -h"
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias moc="mocp"
alias make="make -j$(nproc)"
alias mumble="PULSE_PROP=\"filter.want=echo-cancel\" mumble"
alias colors='for x in 0 1 4 5 7 8; do for i in `seq 30 37`; do for a in `seq 40 47`; do echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "; done; echo; done; done; echo "";'
alias grep='grep --color=auto'
alias ls='ls --color=auto'

activate(){
	venv_folder=venv
	if [ -e $venv_folder ]
	then
		source $venv_folder/bin/activate
	else
		echo "No python virtual environment named $venv_folder found."
		return 1
	fi
}
