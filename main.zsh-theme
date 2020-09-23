#!/bin/zsh

# Return Status
local ret_status="%(?:%{$fg_bold[green]%}%?↵:%{$fg_bold[red]%}%?↵)%{$reset_color%}"

# User information
local user_host='%B%{$fg[red]%}%n%{$fg[yellow]%}@%{$fg[cyan]%}%M%{$reset_color%}'

# Current directory information
local current_dir='%B%{$fg[yellow]%}%~%{$reset_color%}'

# Git information
local git_branch='%B%{$fg[blue]%}$(git_prompt_info)%{$fg[blue]%}%{$reset_color%}'
ZSH_THEME_GIT_PROMPT_PREFIX=" git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

# Node and NVM
function node_prompt_version {
  local nvm_prompt
  nvm_prompt=$(node -v 2>/dev/null)
  [[ "${nvm_prompt}x" == "x" ]] && return
  nvm_prompt=${nvm_prompt:1}
  echo "%{$fg[green]%}⬢ ${nvm_prompt}%{$reset_color%}"
}

# ----------------------------------------------------------------------- #
# Prompts
# ----------------------------------------------------------------------- #

PROMPT="╭─${ret_status} ${user_host} ${current_dir}${git_branch}
╰─%B%(!.#.$)%b %{$reset_color%}"

RPS1='$(node_prompt_version)'

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
