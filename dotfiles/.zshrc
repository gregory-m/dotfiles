# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="my"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(autojump brew bundler gem git osx rails rake rvm ruby urltools knife vagrant my_completion docker)


# Customize to your needs...
export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

bindkey -e
bindkey '^[[1;9C' forward-word
bindkey '^[[1;9D' backward-word

alias st="subl -n $@"
alias stt="st -n ."
alias gti="git $@"
alias r="rails"

swk() {
  rm -f ~/.chef/knife.rb
  cp ~/.chef/knife.rb."$*" ~/.chef/knife.rb
}

swkn() {
        test $# != 1 && echo "Must pass chef location arg." && return 1
        if [ -d .chef ]; then
                if [ -f .chef/knife-$1.rb ]; then
                        test -L .chef/knife.rb && rm -f .chef/knife.rb
                        ln -s $(pwd)/.chef/knife-$1.rb .chef/knife.rb
                else
                        echo -e "\e[31mknife-${1}.rb does not exist.\e[0m"
                fi
        else
                echo -e "\e[31m.chef directory does not exist in the current working directory\e[0m"
        fi
}

_chef_status() {
  if [[ `cat ~/.chef/knife.rb | grep chef_server_url` == *stage* ]]
  then
    echo "staging";
  else
    echo "production";
  fi
}

kb() {
  knife bootstrap $1 -N $1 -E production_$2 --secret-file .chef/data_bag_secret;
}

curlo() {
  curl -sS -v -o /dev/null $1;
}

purge_all_docker() {
  # Delete all containers
  docker rm $(docker ps -a -q);
  # Delete all images
  docker rmi $(docker images -q);
}

clean_docker () {
  docker rm $(docker ps -aq)
  docker rmi $(docker images --filter dangling=true --quiet)
}

run_bash_docker() {
  docker run -ti --rm $1 /bin/bash;
}

exec_bash_docker() {
  docker exec -ti $1 /bin/bash;
}

export EDITOR='subl -w -n'

export LC_ALL="en_US.UTF-8"

if [[ `boot2docker status` == running ]]
then
  `boot2docker shellinit 2>/dev/null`;
fi

zstyle ':completion:*:*:*:*:*' ignored-patterns 'DOCKER_HOST|DOCKER_CERT_PATH|DOCKER_TLS_VERIFY|LSCOLORS|GREP_COLOR|GREP_OPTIONS|HISTFILE|HISTCHARS|HISTSIZE'

source $ZSH/oh-my-zsh.sh
