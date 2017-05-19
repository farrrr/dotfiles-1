###############################################################################
# .bashrc subshells run only this, not .bash_profile
###############################################################################
echo ".bashrc running"
if [ -f /usr/local/opt/nvm/nvm.sh ]; then
  export NVM_DIR="$HOME/.nvm"
  # this command is very slow! 0.93s
  . "/usr/local/opt/nvm/nvm.sh"
fi

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

# history settings
export HISTSIZE=2500
if  [[ $SHELL == *bash ]]; then
  export HISTFILESIZE=99999
  # make sure history is saved
  shopt -s histappend
  # http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
  export HISTFILE=~/.bash_history_not_truncated
  # stop duplicates in history
  export HISTCONTROL=ignoreboth:erasedups
  # and synced https://unix.stackexchange.com/questions/18212/bash-history-ignoredups-and-erasedups-setting-conflict-with-common-history
  PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"
fi
