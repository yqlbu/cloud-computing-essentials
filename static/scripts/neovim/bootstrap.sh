#!/usr/bin/env bash

set -e

echo -e "==> [INFO] Bootstraping container"

COMMAND="vim"
HOME=/home/$USER

if [ "${ADDUSER}" == "true" ]; then
  sudo=""
  if [ "${SUDO}" == "true" ]; then
    sudo="-G sudo"
  fi
  if [ -z "$(getent group ${USER})" ]; then
    /usr/sbin/groupadd -g ${GID} ${USER}
  fi

  if [ -z "$(getent passwd ${USER})" ]; then
    /usr/sbin/useradd -u ${UID} -g ${GID} -G sudo -s ${SHELL} -d ${HOME} -m ${sudo} ${USER} 
    if [ "${SECRET}" == "password" ]; then
      SECRET=$(hex)
      echo "Autogenerated password for user ${USER}: ${SECRET}"
    fi
    echo "${USER}:${SECRET}" | /usr/sbin/chpasswd
    unset SECRET
  fi
fi

echo -e "==> [INFO] Setting up environment"
if grep -Fxq '# BOOTSTRAP ENV' $HOME/.bashrc ; then
  echo "==> [INFO] bashrc already setup, so skipped .."
else
  echo "# BOOTSTRAP ENV" >> $HOME/.bashrc
  echo "alias ..='cd ..'" >> $HOME/.bashrc && echo "alias ...='cd ../../'" >> $HOME/.bashrc
  echo "alias vim='nvim'" >> $HOME/.bashrc
  echo "alias ra='ranger'" >> $HOME/.bashrc
  echo "alias lg='lazygit'" >> $HOME/.bashrc
  echo "export LANG=en_US.UTF-8" >> $HOME/.bashrc
  echo "export EDITOR=nvim" >> $HOME/.bashrc
  echo "export PATH=$HOME/.local/bin:$PATH" >> $HOME/.bashrc
fi

if [[ ! -L "$HOME/.config/nvim" && ! -d "$HOME/.config/nvim" ]]; then
  ln -sf /config $HOME/.config
  git clone https://github.com/yqlbu/neovim-server $HOME/neovim-server > /dev/null 2>&1
  cp -r $HOME/neovim-server/nvim $HOME/.config/
  cp -r $HOME/neovim-server/nvim/ranger $HOME/.config
  [[ ! -d $HOME/.config/ranger/plugins/ranger_devicons  ]] && git clone https://github.com/alexanderjeurissen/ranger_devicons $HOME/.config/ranger/plugins/ranger_devicons
  mkdir -p $HOME/.config/jesseduffield
  cp -r $HOME/neovim-server/nvim/lazygit $HOME/.config/jesseduffield/lazygit
fi

[[ ! -L "$HOME/workspace" && ! -d "$HOME/workspace" ]] && ln -sf /workspace $HOME/workspace

rm -rf $HOME/neovim-server

echo -e "==> [INFO] Setting up neovim"
nvim --headless +PlugInstall +qall > /dev/null 2>&1


# Modify file ownership
chown -R ${USER}:${GID} ${HOME}
chown -R ${USER}:${GID} /config
chown -R ${USER}:${GID} ${HOME}/.config
chown -R ${USER}:${GID} /workspace
chown -R ${USER}:${GID} ${HOME}/workspace

echo -e "==> [INFO] Bootstrap process finished"

echo -e "==> [INFO] Starting container"
if [ "$@" = "vim" ]; then
  echo "==> [INFO] Executing: ${COMMAND}"
  exec ${COMMAND}
else
  echo "==> [INFO] Not executing: ${COMMAND}"
  echo "==> [INFO] Executing: ${@}"
  exec $@
fi
