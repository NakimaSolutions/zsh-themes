#!/bin/zsh

# ----------------------------------------------------------------------- #
# Imports
# ----------------------------------------------------------------------- #

SOURCE="${BASH_SOURCE[0]}"
REL_DIR="$(dirname "$SOURCE")"
THEME_DIR="$(cd "$REL_DIR" && pwd)"

# Hooks
source "${THEME_DIR}/hooks/nvmrc.zsh"

# ----------------------------------------------------------------------- #
# Functions
# ----------------------------------------------------------------------- #

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

## Node and NVM
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

PROMPT="${ret_status} %{${fg_bold[blue]}%}:: ${current_dir}${git_branch} $FG[105]%(!.#.») %{$reset_color%}"
RPS1='$(node_prompt_version)'
