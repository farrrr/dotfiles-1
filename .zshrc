###############################################################################
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases, functions, options, key bindings, etc.
###############################################################################
echo ".zshrc running"
###############################################################################
# remember your ancestor
###############################################################################
source ~/.bash_profile

###############################################################################
# options!
###############################################################################
setopt autocd autopushd pushdignoredups globcomplete
export DIRSTACKSIZE=10

###############################################################################
# history
###############################################################################
setopt correct histignorealldups incappendhistory extendedhistory histignorespace histreduceblanks

export HISTFILE=~/.zsh_history
export SAVEHIST=$HISTSIZE

###############################################################################
# named directories
###############################################################################
# folder with all my Code
hash -d -- c=$CODE_DIR
# folder with main Repo
hash -d -- r=~c/checkout
# folder where I work the most
hash -d -- w=~r/packages/app/src/next/features

###############################################################################
# completion
###############################################################################
# Do menu-driven completion.
zstyle ':completion:*' menu select

# Color completion for some things.
# converted LSCOLORS using https://geoff.greer.fm/lscolors/
zstyle ':completion:*' list-colors 'di=36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'

# formatting and messages
# http://www.masterzen.fr/2009/04/19/in-love-with-zsh-part-one/
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format "$fg[yellow]%B--- %d%b"
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format "$fg[red]No matches for:$reset_color %d"
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# activate approximate completion, but only after regular completion (_complete)
# zstyle ':completion:::::' completer _complete _approximate
# limit to 1 error
# zstyle ':completion:*:approximate:*' max-errors 1
# case insensitive completion
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'

###############################################################################
# zplug - zsh plugin manager
###############################################################################
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# zplug check returns true if all packages are installed
# Therefore, when it returns false, run zplug install
if ! zplug check; then
    zplug install
fi

# source plugins and add commands to the PATH
zplug load

###############################################################################
# add-ons installed by homebrew
###############################################################################
if [ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [ -d ~/.zsh-git-prompt ]; then
  GIT_PROMPT_EXECUTABLE="haskell"
  source ~/.zsh-git-prompt/zshrc.sh
  ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[cyan]%}%{✚%G%}" # blue is too dark
fi

# fuzzy completion
[ -f ~/.fzf.`basename $SHELL` ] && source ~/.fzf.`basename $SHELL`

# syntax highlighting should be loaded after all widgets, to work with them
if [ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets root)
export ZSH_HIGHLIGHT_STYLES[assign]='bg=18,fg=220' # dark blue background
export ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=219,bg=236' #pink
export ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=27' # muted blue
export ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=94' # brown?
export ZSH_HIGHLIGHT_STYLES[globbing]='fg=99' # lilac
export ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=63' # softer lilac
export ZSH_HIGHLIGHT_STYLES[path]='fg=cyan,underline' # make folders same colors as in ls
export ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=243,underline'
export ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=white,underline'
export ZSH_HIGHLIGHT_STYLES[redirection]='fg=148,bold' # >> yellow-green
export ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=182' # light pink

###############################################################################
# prompt
###############################################################################
PROMPT="%F{106}%22<…<%3~%f%(?..%{$fg[red]%} %?%{$reset_color%})%(1j.%{$fg[cyan]%} %j%{$reset_color%}.)%# "
local git_part='$(git_super_status)'
RPROMPT="${git_part} %F{106}%*%f"

###############################################################################
# fun functions
###############################################################################
function co() {
    local branches branch
    branches=$(git branch -a) &&
    branch=$(echo "$branches" | fzf +s +m) &&
    #git checkout $(echo "$branch" | sed "s/.* //")
    git checkout $(echo "$branch" | sed "s:.* remotes/origin/::" | sed "s:.* ::")
}

function go() {
    local repos repo
    repos=$(find $CODE_DIR -name .git -type d -maxdepth 3 -prune | sed 's#/.git$##') &&
    repo=$(echo "$repos" | fzf +s +m) &&
    cd $(echo "$repo" | sed "s:.* remotes/origin/::" | sed "s:.* ::")
}

# like z, but if there are alternatives show them in fzf
c() {                                                                                                                                  local dir
  dir="$(fasd -Rdl "$1" | fzf -1 -0 --no-sort +m)" && cd "${dir}" || return 1
}

###############################################################################
# keybindings
###############################################################################
bindkey "^P" history-beginning-search-backward
bindkey "^N" history-beginning-search-forward
# make zsh behave like bash for ctrl-u (fine to modify since most others will have bash)
bindkey "^U" backward-kill-line