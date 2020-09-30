#!/bin/zsh

# ----------------------------------------------------------------------- #
# Imports
# ----------------------------------------------------------------------- #

NKM_THEME_DIR="$(dirname "$0")"

# Hooks
source "${NKM_THEME_DIR}/hooks/nvmrc.zsh"

# ----------------------------------------------------------------------- #
# Functions
# ----------------------------------------------------------------------- #

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
