#! /bin/sh
PKG="apt"
USE_CONFIG="false"

echo "Hello Axios, starting the setup for your new machine"
#-----------------------#

echo "What system are you using?"
echo "1) Ubuntu"
echo "2) Fedora"
echo "3) MacOS"
echo "4) Windows"
read system

if [ $system == 1 ]
then
    PKG="apt-get"
elif [ $system == 2 ]
then
    PKG="dnf"
elif [ $system == 3 ]
then
    PKG="brew"
elif [ $system == 4 ]
then
    PKG="choco"
else
    echo "Invalid option, exiting..."
    exit 1
fi

#--Packages essential for all systems--#
echo "Please before continue, make sure you have copied your ssh key to github, if you haven't, please do it now"
echo "Press enter to continue"
read enter

echo "Do you have a zsh config file? (y/n)"
read answer

if [ $answer == "y" ]
then
    echo "Please, put your config file in the dotfiles folder and rename it to .zshrc"
    echo "Press enter to continue"
    read enter
    USE_CONFIG="true"
fi

echo "Installing curl, wget, git, and more..."
sudo apt-get update
sudo $pkg -y -v install curl wget git dirmngr gpg gawk build-essential

echo "Setting up git"
git config --global user.name "Elienai Soares"
git config --global user.email "elienay.soares07@gmail.com"


#--Packages for development--#
#-----------Docker-----------#
echo "Installing Docker" 
echo "Removing old versions"
  for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

echo "Installing new version"
  sudo apt-get install ca-certificates curl gnupg;

  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg

  echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Installing Docker Engine and Docker Compose"
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Adding user to docker group"
  sudo groupadd docker
  sudo usermod -aG docker $USER

echo "Installing Docker Completion"

#-----------ASDF-----------#
echo "Install ASDF"
  cd /tmp
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.12.0

  #. "$HOME/.asdf/asdf.sh"
  #. "$HOME/.asdf/completions/asdf.bash"

#-----------Node-----------#
echo "Installing Node"
  asdf plugin-add nodejs
  asdf install nodejs 18.16.1
  asdf global nodejs 18.16.1

#-----------Yarn-----------#
echo "Installing Yarn"
  asdf plugin-add yarn
  asdf install yarn 1.22.10
  asdf global yarn 1.22.10

#-----------Rust-----------#
echo "Installing Rust"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  if [ $USE_CONFIG == "false" ]
  then
    echo "export PATH=$HOME/.cargo/bin:$PATH" >> ~/.zshrc
  fi
  
  echo "Install Rust Shell commands"
  sudo apt -y install bat exa fd-find
  cargo install procs du-dust tokei ytop

  if [ $USE_CONFIG == "false" ]
  then
    echo "alias cat=bat" >> ~/.zshrc
    echo "alias ls=exa --icons" >> ~/.zshrc
    echo "alias fd=fd -c always" >> ~/.zshrc
  fi

#-----------Java-----------#
echo "Installing Java"
  asdf plugin-add java
  asdf install java 17.0.1
  asdf install java 8.0.312-zulu
  asdf global java 8.0.312-zulu

#-----------Python-----------#
echo "Installing Python"
  asdf plugin-add python
  asdf install python 3.10.0
  asdf global python 3.10.0
  python3 -m pip install --upgrade pip

#-----------VSCode-----------#
echo "Installing VSCode"
  sudo apt-get install wget gpg
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
  rm -f packages.microsoft.gpg

  sudo apt install apt-transport-https
  sudo apt update
  sudo apt install code

  cd ~/dotfiles
  mv vscode-settings.js settings.json
  rm -f ~/.config/Code/User/settings.json
  cp settings.json ~/.config/Code/User/

#-----------LunarVim-----------#
echo "Installing LunarVim"
  LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)

  cd ~/dotfiles
  rm -f ~/.config/lvim/config.lua
  cp config.lua ~/.config/lvim/


#--Packages for design--#
echo "Installing ZSH"
  sudo apt-get install zsh

echo "Installing Oh My ZSH"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  cd /tmp

echo "-----------------------"
echo "Installing fonts"
  wget https://github.com/tonsky/FiraCode/archive/refs/tags/6.2.tar.gz && tar -xvf 6.2.tar.gz
  cp FiraCode-6.2/distr/ttf/* ~/usr/local/share/fonts/

  mkdir MesloLGS && cd MesloLGS
  wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
  wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
  wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
  wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
  cd ..

  cp MesloLGS/* ~/usr/local/share/fonts/

echo "Caching fonts"
  fc-cache -f -v

echo "Fonts installed"
echo "-----------------------"

echo "Installing Spaceship theme"
  git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"

  ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

echo "Copying ZSH settings"
  cd ~/dotfiles
  rm -f ~/.zshrc
  cp .zshrc ~/.zshrc


echo "Adding paths to ZSH"
#---------ASDF---------#
  if [ $USE_CONFIG == "false" ]
  then
    echo ". '$HOME/.asdf/asdf.sh'" >> ~/.zshrc
    echo "fpath=(${ASDF_DIR}/completions $fpath)" >> ~/.zshrc
    echo "autoload -Uz compinit && compinit" >> ~/.zshrc
  fi
