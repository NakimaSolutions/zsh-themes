# Clean, simple, compatible and meaningful.
# Tested on Linux, Unix and Windows under ANSI colors.
# It is recommended to use with a dark background and the font Inconsolata.
# Colors: black, red, green, yellow, *blue, magenta, cyan, and white.
#
# http://ysmood.org/wp/2013/03/my-ys-terminal-theme/
# Mar 2013 ys

# Machine name.
function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || echo $HOST
}

# Directory info.
local current_dir='${PWD/#$HOME/~}'

# VCS
YS_VCS_PROMPT_PREFIX1=" %{$fg[white]%}(%{$reset_color%}"
YS_VCS_PROMPT_PREFIX2="%{$fg[cyan]%}"
YS_VCS_PROMPT_SUFFIX="%{$reset_color%}"
YS_VCS_PROMPT_DIRTY="%{$fg[white]%})%{$reset_color%} %{$fg[red]%}✘"
YS_VCS_PROMPT_CLEAN="%{$fg[white]%})%{$reset_color%} %{$fg[green]%}✔"

# Git info.
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="${YS_VCS_PROMPT_PREFIX1}${YS_VCS_PROMPT_PREFIX2}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$YS_VCS_PROMPT_SUFFIX"
ZSH_THEME_GIT_PROMPT_DIRTY="$YS_VCS_PROMPT_DIRTY"
ZSH_THEME_GIT_PROMPT_CLEAN="$YS_VCS_PROMPT_CLEAN"

# NVM info
local nvm_info='$(nvm_prompt_info)'
ZSH_THEME_NVM_PROMPT_PREFIX="%{$fg[green]%}⬢ "
ZSH_THEME_NVM_PROMPT_SUFFIX=""

# Python info.
local python_info='🐍 $(pyenv_prompt_info)'

# Prompt format: \n # USER at MACHINE in DIRECTORY on git:BRANCH STATE [TIME] \n $
PROMPT="%{$terminfo[bold]$fg[cyan]%}%n\
%{$fg[white]%}@\
%{$terminfo[bold]$fg[green]%}$(box_name) \
%{$terminfo[bold]$fg[yellow]%}${current_dir}%{$reset_color%}\
${git_info}\

%{$terminfo[bold]$fg[green]%}➜  %{$reset_color%}"

if [[ "$USER" == "root" ]]; then
PROMPT="
%{$terminfo[bold]$fg[cyan]%}%n\
%{$fg[white]%}@\
%{$terminfo[bold]$fg[green]%}$(box_name) \
%{$terminfo[bold]$fg[yellow]%}${current_dir}%{$reset_color%}\
${git_info}\

%{$terminfo[bold]$fg[blue]%}# %{$reset_color%}"
fi

RPROMPT="${nvm_info}, ${python_info}%{$reset_color%}"


# ----------------------------------------------------------------------- #
# Hooks
# ----------------------------------------------------------------------- #

load-nvmrc() {
  [[ -f "$NVM_DIR/nvm.sh" ]] || return

  local curr_node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_version=$(cat "${nvmrc_path}")
    local nvmrc_node_version=$(nvm version "${nvmrc_version}")
    local nvmrc_node_version_remote=$(nvm version-remote "${nvmrc_version}")

    if [ "${nvmrc_node_version}" != "${nvmrc_node_version_remote}" ]; then
      nvm install
    elif [ "$nvmrc_node_version_remote" != "$curr_node_version" ]; then
      nvm use
    fi
  elif [ "$curr_node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd load-nvmrc
