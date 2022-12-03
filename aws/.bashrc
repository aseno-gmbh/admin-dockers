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
    xterm-color|*-256color) color_prompt=yes;;
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

PS1='\[\033[36m\]\u\[\033[m\]@\[\033[1;33m\][$(kubectl config current-context | xargs):$(kubectl config view | grep namespace | cut -f2 -d: | xargs)]:\[\033[1;36m\]{$(git branch 2>/dev/null | grep '^*' | colrm 1 2)} \033[00m\]\w\[\033[m\]\n\$ '

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

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# valentin
alias get_devops='docker run --rm -it -v ~/.aws:/root/.aws -v ~/development:/root/dev -v ~/.kube:/root/.kube -v ~/.bash_history:/root/.bash_history -v ~/.bashrc:/root/.bashrc --network="host" aseno/admin-stuff:latest'

# k8s
### # k8s valentin
# Resource mit einem File anlegen, bzw. modifizieren. Z.B 'kc ./runs/pipeline-run.yaml'
alias kubectl="microk8s.kubectl"
alias kis="microk8s.istioctl"
k() { kubectl $@ ;}
k_c() { kubectl create -f $1 ; }
k_a() { kubectl apply -f $1 ; }
# z.B.: 'ns thf-002-pma' wechselt in den Namespaces leistung
k_ns_ch() {  kubectl config set-context $(kubectl config current-context) --namespace $1 ;}
# Zeigt alle deployments im angegebenen namespace an. Z.B.: 'kdeployments thf-002-pma'
k_depls() { kubectl get deployments -o wide; }
# Zeigt all pods im angegebenen namespace an. Z.B.:  'kpods build-image'
k_pods() { kubectl get pods  --show-labels -o wide; }
# Describe pod. Z.B.: 'kdescribepod kafka-58566d6cd4-2bhv6'
k_des_pod() { kubectl describe pod $1; }
k_ctx(){ kubectl config get-contexts; }
k_pwd(){ kubectl get secrets/$1 --template={{.data.$2}} | base64 --decode;}
#k_pwd(){ kubectl get secret $1 -o jsonpath"{.data.$2}" | base64 --decode;}
# K8s Ereignisse anzeigen
k_events() { kubectl get events  --sort-by=.metadata.creationTimestamp -n $1 ; }
k_specificevents() { kubectl get event --field-selector=involvedObject.name=$1 ; }
# K8s logs
k_logs() { kubectl logs --selector ms=$1 --tail=50 ; }
k_logs_c() { kubectl logs --selector ms=$1 -c $2 --tail=50 ; }
k_logtime() { kubectl logs --selector ms=$1 --all-containers=true -f --since=$2s --timestamps=true ; } #--prefix=true ; }
k_logdead() { kubectl logs --selector ms=$1 --all-containers=true --timestamps=true --previous=true ; }

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
