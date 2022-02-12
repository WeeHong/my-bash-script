#!/bin/sh
sudo apt-get -y upgrade && sudo apt-get -y update

sudo add-apt-repository ppa:git-core/ppa -y
sudo apt-get update
sudo apt-get install git -y

git config --global user.email "weehongayden.developer@hotmail.com"
git config --global user.name "Wee Hong KOH"

sudo apt-get -y upgrade && sudo apt-get -y update

sudo apt-get install zsh -y
echo "# Install Oh My Zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
echo
echo "# Install Powerlevel10k"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
echo
echo "# Install Zsh AutoSuggestion"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
echo
echo "# Install Zsh Syntax Highlighting"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
echo
echo "# Download Zshrc"
sudo curl -s https://raw.githubusercontent.com/WeeHong/WSL-Bash-Script/main/zsh/.zshrc > "$HOME/.zshrc"
echo
echo "# Download p10k Configuration"
sudo curl -s https://raw.githubusercontent.com/WeeHong/My-Bash-Script/main/zsh/.p10k.zsh > "$HOME/.p10k.zsh"
echo
chsh -s $(which zsh)
zsh
source "$HOME/.zshrc"
