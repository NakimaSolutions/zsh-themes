#!/bin/zsh

## Node and NVM
function node_prompt_version {
  local nvm_prompt
  nvm_prompt=$(node -v 2>/dev/null)
  [[ "${nvm_prompt}x" == "x" ]] && return
  nvm_prompt=${nvm_prompt:1}
  echo "%{$fg[green]%}⬢ ${nvm_prompt}%{$reset_color%}"
}

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

## Return Status
local ret_status="%(?:%{$fg_bold[green]%}%?↵:%{$fg_bold[red]%}%?↵)%{$reset_color%}"

## Current directory information
local current_dir='%B%{$fg[yellow]%}%~%{$reset_color%}'

## Git information
local git_branch='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="$FG[075]($FG[078]"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="$my_orange*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$FG[075])%{$reset_color%}"

## Order of each field
PROMPT="${ret_status} %{${fg_bold[blue]}%}:: ${current_dir}${git_branch} $FG[105]%(!.#.») %{$reset_color%}"
RPS1='$(node_prompt_version)'
