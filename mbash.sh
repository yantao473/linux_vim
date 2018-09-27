#!/bin/sh

export PATH=$PATH:/home/yanqing4/bin
# export PS1="[\$(git_branch) \[\e[1;32m\]\w \t\[\e[m\] ] \\$ "
export PS1="[\$(git_branch) \[\e[1;32m\]\W \t \#\[\e[m\] ] \\$ "

alias g='grep --color=auto'
alias p='ps axjfww'
alias use_proxy="systemctl start privoxy.service && export http_proxy=http://127.0.0.1:8118 && export https_proxy=http://127.0.0.1:8118"
alias unuse_proxy="unset http_proxy && unset https_proxy && systemctl stop privoxy.service"


ESC="\033[1;"
GRE="${ESC}32m"
YEL="${ESC}33m"
RED="${ESC}31m"
NOR="${ESC}0m"


# fasd
eval "$(fasd --init auto)"
alias v='f -e vim'
fasd_cd ()
{
 if [ $# -le 1 ]; then
     fasd "$@";
 else
     local _fasd_ret="$(fasd -e 'printf %s' "$@")";
     [ -z "$_fasd_ret" ] && return;
     [ -d "$_fasd_ret" ] && printf %s\\n "$_fasd_ret" && cd "$_fasd_ret";
 fi
}


mkcd()
{
    mkdir $1
    cd $1
}

vun()
{
    cd /usr/share/vim/vimfiles/plug/$1
}

jdk()
{
    cd /usr/java/jdk1.8.0_121
}

git_branch()
{
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ "$branch" = "" ]
    then
        echo ""
    else
        echo -e " \033[33;1m($branch)\033[0m"
    fi
}

export FZF_DEFAULT_COMMAND='ag -g ""'
export HISTIGNORE="y:pwd:ls:cd:ll:clear:history"

# for java
export JAVA_HOME=/usr/java/jdk1.8.0_121
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
