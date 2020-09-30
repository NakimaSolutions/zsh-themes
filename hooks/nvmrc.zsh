load-nvmrc() {
  [[ -f "${NVM_DIR}/nvm.sh" ]] || return

  local curr_node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "${nvmrc_path}" ]; then
    local nvmrc_version=$(cat "${nvmrc_path}")
    local nvmrc_node_version=$(nvm version "${nvmrc_version}")
    local nvmrc_node_version_remote=$(nvm version-remote "${nvmrc_version}")

    if [ "${nvmrc_node_version}" != "${nvmrc_node_version_remote}" ]; then
      nvm install
    elif [ "${nvmrc_node_version_remote}" != "${curr_node_version}" ]; then
      nvm use
    fi
  elif [ "${curr_node_version}" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd load-nvmrc
