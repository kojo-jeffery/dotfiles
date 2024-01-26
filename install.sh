#!/bin/bash

set -o errexit
set -o nounset

# GLOBAL VARIABLES
PACKAGES="php composer node openvpn3 gcloud starship redis-server"

install_php_8_2()
{
  printf "Installing PHP 8.2...\n"

  sudo apt update
  sudo apt --no-install-recommends --yes install software-properties-common

  sudo apt --yes install gpg-agent
  sudo add-apt-repository ppa:ondrej/php
  sudo apt update

  sudo apt install php8.2 --yes
  sudo apt purge apache2* --yes
  sudo apt install --yes php8.2-cli php8.2-common php8.2-opcache php8.2-mysql php8.2-mbstring php8.2-zip php8.2-fpm php8.2-xml php8.2-bcmath php8.2-gd php8.2-curl php8.2-intl php8.2-redis php8.2-imagick php8.2-sqlite3

  php --version

  printf '\n\nPHP 8.2 installed successfully\n\n'
  sleep 3
}

install_php_composer()
{
  printf "Installing Composer...\n"

  sudo apt update
  sudo apt --yes install php-cli unzip

  curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
  HASH=`curl -sS https://composer.github.io/installer.sig`

  printf '\n\nStored Hash\n'
  echo $HASH
  printf '\n\n'

  php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
  sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

  composer

  printf '\n\nComposer installed successfully\n\n'
  sleep 3
}

install_node()
{
  printf "Installing NodeJs...\n"

  curl -sL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh
  sudo bash nodesource_setup.sh
  sudo apt-get install -y nodejs
  sudo npm install -g npm@10.2.0

  sudo apt-get install gcc g++ make
  curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
  echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt-get update && sudo apt-get install yarn

  node --version
  npm --version
  yarn --version

  printf '\n\nNodeJs installed successfully\n\n'
  sleep 3
}

install_openvpn()
{
  printf "Installing OpenVPN-3...\n"

  sudo mkdir -p /etc/apt/keyrings && curl -fsSL https://packages.openvpn.net/packages-repo.gpg | sudo tee /etc/apt/keyrings/openvpn.asc
  sudo echo "deb [signed-by=/etc/apt/keyrings/openvpn.asc] https://packages.openvpn.net/openvpn3/debian jammy main" | sudo tee /etc/apt/sources.list.d/openvpn-packages.list
  sudo apt-get update && sudo apt-get install openvpn3 -y

  printf '\n\nOpenVPN-3 installed successfully\n\n'
  sleep 3
}

install_gcloud()
{
  printf "Installing Google CLI...\n"

  curl -sSL https://sdk.cloud.google.com 

  printf '\n\nGoogle CLI installed successfully\n\n'
  sleep 3
}

install_starship()
{
  printf "Installing Starship...\n"

  curl -sS https://starship.rs/install.sh | sudo sh -s -- -y

  printf '\n\nStarship installed successfully\n\n'
  sleep 3
}

install_redis_server()
{
  printf "Installing Redis...\n"

  sudo apt install lsb-release curl gpg
  curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list

  sudo apt-get update
  sudo apt-get install redis

  printf '\n\nRedis installed successfully\n\n'
  sleep 3
}

run_pre_installs()
{
  cd ~
  sudo apt update
  sudo apt --yes upgrade
  sudo apt --yes --no-install-recommends install net-tools htop build-essential software-properties-common
  printf '\n\nPost-Installation packages installed successfully\n\n'
  sleep 3
}

run_autoremove() {
  sudo apt autoremove --yes
  printf '\n\nPackages removed successfully\n\n'
  sleep 3
}

run_cleanup() {
  sudo apt clean
  printf '\n\nPackages cleaned successfully\n\n'
  sleep 3
}

install_term_apps()
{
  printf "Installing Terminal Apps...\n"

  sudo apt --yes install fish tmux neofetch vim neovim fzf ripgrep fd-find jq
  
  printf '\n\nTerminal Apps installed successfully\n\n'
  sleep 3
  
  printf '\n\nCopying config files...\n\n'
  sudo rm -rf $HOME/.config/fish
  sudo rm -rf $HOME/.config/neofetch
  cp -r fish $HOME/.config/
  cp -r neofetch $HOME/.config/
  cp -r tmux $HOME/.config/
  printf '\n\nConfig files copied successfully\n\n'
  sleep 3
}

init()
{
  printf '\nInstalling pre-requisites...\n\n'
  run_pre_installs
  install_term_apps

  printf '\n\nRunning cleanups...\n\n'
  run_autoremove
  run_cleanup

  printf '\n\nChecking required packages...\n\n'
  for i in $PACKAGES
    do
    if ! which $i > /dev/null; then
      if [ $i == 'php' ]; then
        # PHP
        printf 'PHP 8.2 does not seem to be installed...\n'
        install_php_8_2
      elif [ $i == 'composer' ]; then
        # Composer
        printf '\nComposer does not seem to be installed...\n'
        install_php_composer
      elif [ $i == 'node' ]; then
        # NodeJs
        printf '\nNodeJs does not seem to be installed...\n'
        install_node
      elif [ $i == 'openvpn3' ]; then
        # openvpn3
        printf '\nOpenVPN3 does not seem to be installed...\n'
        install_openvpn
      elif [ $i == 'gcloud' ]; then
        # gcloud
        printf '\nGoogle CLI does not seem to be installed...\n'
        install_gcloud
      elif [ $i == 'starship' ]; then
        # starship
        printf '\nStarship does not seem to be installed...\n'
        install_starship
      elif [ $i == 'redis-server' ]; then
        # redis-server 
        printf '\nRedis does not seem to be installed...\n'
        install_redis_server
      else
        printf "No packages found!\n"
      fi
    else
      printf "${i^^} already installed \n"
    fi
  done

  printf '\n\nRunning cleanups...\n\n'
  run_autoremove
  run_cleanup

  printf '\n\nHappy Coding!\n\'
}

# script starter
init