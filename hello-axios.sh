#! /bin/sh
PKG="apt"

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
echo "Downloading and installing packages"
#sudo $pkg -v install curl wget git


#--Packages for Ubuntu--#

#--Packages for Fedora--#

#--Packages for MacOS--#

#--Packages for Windows--#

#--Packages for development--#


#--Packages for design--#
## Ubuntu
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

## Command temporary, change this for the archive on the repo dotfiles
  echo "ZSH_THEME='spaceship'" >> ~/.zshrc
