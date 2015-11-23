# git

alias g='git'

alias ls='ls --color=auto'
# "ls" kısayolları.
alias ll='ls -l'
alias la='ls -A'
alias lc='ls -CF'
alias lm='ls -al | less'

alias dud='du -d 1 -h'
alias duf='du -sh *'
alias fd='find . -type d -name'
alias ff='find . -type f -name'

# APT kısayolları.
alias apc='apt-cache'
alias api='apt-iselect';
alias apk='sudo apt-key add'
alias aps='apt-get source'
alias apt='sudo apt-get install'
alias apu='sudo apt-get update'

# Grep kısayolları.
alias egrep='egrep --color=tty -d skip'
alias egrpe='egrep --color=tty -d skip'
alias fgrep='fgrep --color=tty -d skip'
alias fgrpe='fgrep --color=tty -d skip'
alias grep='grep --color=tty -d skip'
alias grpe='grep --color=tty -d skip'
alias -g G='| grep'

# Prosesler.
alias px='ps aux'
alias pg='ps aux | egrep'

# Boyutlar daima "insani" olsun.
alias du='du -kh'
alias df='df -kTh'

# Uzun (ve önerilmeyen) sudo oturumları için.
alias ~='sudo -E -s'

# "cd" kısayolları.
alias ..='cd ..'
alias ...='cd ../..'
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd-='cd -'
zstyle ':completion:*' special-dirs true

# https://github.com/robbyrussell/oh-my-zsh/issues/433
alias rake='noglob rake'

# docker ve docker-compose
alias d='docker'
alias dps='docker ps'
alias drmall='docker rm $(docker ps -a -q)'
alias drmu="docker rmi -f `docker images -q --filter "dangling=true"`"
alias dpsa='docker ps -a'
alias dc='docker-compose'
alias dcu='docker-compose up'
alias dcb='docker-compose build'
alias dcrm='docker-compose rm'
alias dcr='docker-compose run'
alias dcrw='docker-compose run web'
alias dm='docker-machine'
alias dme='eval "$(docker-machine env web)"'
alias dmweb='docker-machine start web &> /dev/null && eval "$(docker-machine env web)"'

# tmux
alias tkill='tmux kill-session -t'
alias tattach='tmux -2 a -t'

# tar & rar
alias untar='tar -xvf'
alias untargz='tar -zxvf'
alias unrar='unrar x'
