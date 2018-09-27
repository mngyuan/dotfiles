source ~/git/dotfiles/aliases
if [ -n "$ADMINSCRIPTS" ]; then
  source "$ADMIN_SCRIPTS"/master.zshrc
fi

# save a shitload of lines
HISTSIZE=130000 SAVEHIST=130000
# for true color
TERM="xterm-256color-italic"
# vi mode
bindkey -v
# make ctrl-h and backspace work after exiting command mode
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
# incremental search backwards with vi mode
bindkey "^R" history-incremental-search-backward
# allow ctrl-a and ctrl-e to move to beginning/end of line
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# =========== fb ===========
# kill stale mosh sessions
if [ -d ~/../engshare ]; then
  kill $(who |grep mosh |grep -v via | gawk 'match($0, /\[([0-9]*)\]/, a) {print a[1]}') > /dev/null 2>&1
fi
if [[ -a "/usr/facebook/ops/rc/master.zshrc" ]]; then
  source /usr/facebook/ops/rc/master.zshrc
fi

function vi_mode_prompt_info() {
  echo "${${KEYMAP/vicmd/$MODE_INDICATOR}/(main|viins)/}"
}

# define right prompt, if it wasn't defined by a theme
if [[ "$RPS1" == "" && "$RPROMPT" == "" ]]; then
  RPS1='$(vi_mode_prompt_info)'
fi

# oh-my-zsh options below
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  # Path to your oh-my-zsh installation.
  export ZSH=$HOME/.oh-my-zsh

  # Set name of the theme to load.
  # Look in ~/.oh-my-zsh/themes/
  # Optionally, if you set this to "random", it'll load a random theme each
  # time that oh-my-zsh is loaded.
  ZSH_THEME="robbyrussell"

  # Uncomment the following line to use case-sensitive completion.
  # CASE_SENSITIVE="true"

  # Uncomment the following line to disable bi-weekly auto-update checks.
  # DISABLE_AUTO_UPDATE="true"

  # Uncomment the following line to change how often to auto-update (in days).
  # export UPDATE_ZSH_DAYS=13

  # Uncomment the following line to disable colors in ls.
  # DISABLE_LS_COLORS="true"

  # Uncomment the following line to disable auto-setting terminal title.
  # DISABLE_AUTO_TITLE="true"

  # Uncomment the following line to enable command auto-correction.
  # ENABLE_CORRECTION="true"

  # Uncomment the following line to display red dots whilst waiting for completion.
  # COMPLETION_WAITING_DOTS="true"

  # Uncomment the following line if you want to disable marking untracked files
  # under VCS as dirty. This makes repository status check for large repositories
  # much, much faster.
  # DISABLE_UNTRACKED_FILES_DIRTY="true"

  # Uncomment the following line if you want to change the command execution time
  # stamp shown in the history command output.
  # The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
  # HIST_STAMPS="mm/dd/yyyy"

  # Would you like to use another custom folder than $ZSH/custom?
  # ZSH_CUSTOM=/path/to/new-custom-folder

  # Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
  # Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
  # Example format: plugins=(rails git textmate ruby lighthouse)
  # Add wisely, as too many plugins slow down shell startup.
  plugins=(
    autojump
    brew
    colored-man
    colorize
    cp
    git
    osx
    sublime
    tmux
    tmuxinator
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting # has to be last
    history-substring-search # has to be after syntax highlighting
  )

  # User configuration
  source $ZSH/oh-my-zsh.sh

  # You may need to manually set your language environment
  # export LANG=en_US.UTF-8

  # Preferred editor for local and remote sessions
  # if [[ -n $SSH_CONNECTION ]]; then
  #   export EDITOR='vim'
  # else
  #   export EDITOR='mvim'
  # fi

  # Compilation flags
  # export ARCHFLAGS="-arch x86_64"

  # ssh
  # export SSH_KEY_PATH="~/.ssh/dsa_id"

  # Set personal aliases, overriding those provided by oh-my-zsh libs,
  # plugins, and themes. Aliases can be placed here, though oh-my-zsh
  # users are encouraged to define aliases within the ZSH_CUSTOM folder.
  # For a full list of active aliases, run `alias`.
  #
  # Example aliases
  # alias zshconfig="mate ~/.zshrc"
  # alias ohmyzsh="mate ~/.oh-my-zsh"
  local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ %s)"
  PROMPT='%{$reset_color%}%{$FG[248]%}%~ %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} ${ret_status}%{$fg_bold[green]%}%p % %{$reset_color%}'
  # nice git rprompt: 8+3-2*
  #setopt PROMPT_SUBST
  #function get_rprompt() {
    #RPROMPT_GIT_SHORTSTAT="$(git diff --shortstat --cached)"
    #RPROMPT_GIT_ADDITIONS="$(echo $RPROMPT_GIT_SHORTSTAT | awk '{print $4}')"
    #RPROMPT_GIT_DELETIONS="$(echo $RPROMPT_GIT_SHORTSTAT | awk '{print $6}')"
    #RPROMPT_GIT_FILESCHAN="$(echo $RPROMPT_GIT_SHORTSTAT | awk '{print $1}')"
    #RPROMPT="(%{$FG[010]%}$RPROMPT_GIT_ADDITIONS+%{$FG[009]%}$RPROMPT_GIT_DELETIONS-%{$FG[011]%}$RPROMPT_GIT_FILESCHAN*%{$reset_color%})"
    #return RPROMPT;
  #}
  #RPROMPT='$(get_rprompt)'

  ZSH_THEME_GIT_PROMPT_PREFIX="⎇ (%{$FG[045]%}"
  ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
  ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})
%{$fg[yellow]%}✗%{$reset_color%}"
  ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})
%{$reset_color%}"
fi

# attach to tmux after starting zsh
# leek

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

