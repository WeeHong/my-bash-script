sudo apt-get update -y
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
sudo curl -s https://gist.githubusercontent.com/WeeHong/4bf71e6f4cdb0efd5b289c89eed7d302/raw/e9531e9db3b2c178c4f0d7de35d94f48f6fe1cb2/.zshrc > "$HOME/.zshrc"
echo
chsh -s $(which zsh)
zsh
source "$HOME/.zshrc"
