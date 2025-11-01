#!/bin/bash

# Check if the script is run with root privileges
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run with sudo or as root."
    exit 1
fi

# Run the apt update command
apt update
#
# #Installation brave
apt install curl

curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|tee /etc/apt/sources.list.d/brave-browser-release.list

apt install brave-browser

# Add the bitwarden, atsistemas benefits  and json formatter extensions for brave
#
# #Installation git
apt install git
#
#Vi mode configuration in kate

#VS Code
sudo apt-get install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt install apt-transport-https
sudo apt update
sudo apt install code

#GitKraken
wget https://release.gitkraken.com/linux/gitkraken-amd64.deb
sudo apt install ./gitkraken-amd64.deb
sudo rm -r ./gitkraken-amd64.deb

#Ranger
sudo apt install python3-pip
pip install setuptools
git clone https://github.com/hut/ranger.git
cd ranger
sudo apt-get install make git vim -y
sudo make install
sudo rm -r /home/critian/.config/ranger
cp -r ./ranger /home/critian/.config/
chmod 777 /home/critian/.config/ranger

#Fish
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt-get install fish
cp -r ./fish/config.fish /home/critian/.config/fish/
cp -r ./fish/functions/ranger-cd.fish /home/critian/.config/fish/functions
curl -sS https://starship.rs/install.sh | sh


#Customization
# https://www.youtube.com/watch?v=zfOe1Kfb4WE

cp -r /media/critian/Data/OrdenadorFormateo/kdeSetupFiles/wallpapers/ /home/critian/Pictures/

git clone https://github.com/vinceliuice/Orchis-kde.git
./Orchis-kde/install.sh
./Orchis-kde/sddm/install.sh
settings->Login Screen->Orchis dark
rm -r ./Orchis-kde

apt-get install gtk2-engines-murrine

git clone https://github.com/vinceliuice/Orchis-theme.git
./Orchis-theme/install.sh
rm -r ./Orchis-theme

git clone https://github.com/vinceliuice/Tela-circle-icon-theme.git
./Tela-circle-icon-theme/install.sh -a 
rm -r ./Tela-circle-icon-theme

git clone https://github.com/vinceliuice/Vimix-cursors.git
cd Vimix-cursors/
./install.sh
cd ..
rm -r ./Vimix-cursors/

#settings->Apareance->Global Theme->Orchis-dark
#icons->tela circle blue dark
#Cursors->vimix cursors

cp -r ./kdeSetupFiles/fonts /home/critian/.fonts
# Adjust fonts Roboto
# Application style->gnome->orchis dark
# Task switcher->orchis dark

# Kvantum
sudo add-apt-repository ppa:papirus/papirus
sudo apt install qt5-style-kvantum qt6-style-kvantum -y
echo "export QT_STYLE_OVERRIDE=kvantum" >> ~/.profile
# set kvantum orchis dark theme
# application style->kvantum 

# Screen Locking->configure

mkdir -p -m 700 ~/.gnupg
gpg --no-default-keyring --keyring gnupg-ring:/tmp/onlyoffice.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CB2DE8E5
chmod 644 /tmp/onlyoffice.gpg
sudo chown root:root /tmp/onlyoffice.gpg
sudo mv /tmp/onlyoffice.gpg /usr/share/keyrings/onlyoffice.gpg

echo 'deb [signed-by=/usr/share/keyrings/onlyoffice.gpg] https://download.onlyoffice.com/repo/debian squeeze main' | sudo tee -a /etc/apt/sources.list.d/onlyoffice.list
sudo apt-get update
sudo apt-get install onlyoffice-desktopeditors

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc

 git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
 ~/.fzf/install

# Atuin: do not run this as root, root will be asked for if required
bash <(curl https://raw.githubusercontent.com/atuinsh/atuin/main/install.sh)
bash (curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh | psub)

atuin register -u <USERNAME> -e <EMAIL>
atuin import auto
atuin sync
#Add this to config.fish -> atuin init fish | source
#

sudo apt install net-tools
# For ssh connections
sudo apt-get install openssh-server

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim

#For node js download tar and sudo mkdir -p /usr/local/lib/nodejs   sudo tar -xJvf node-$VERSION-$DISTRO.tar.xz -C /usr/local/lib/nodejs 
