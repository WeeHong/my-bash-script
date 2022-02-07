#!/bin/bash

# Checking Shell
if [ -n "echo $ZSH_VERSION" ]; then
    shell_profile="$HOME/.zshrc"
elif [ -n "echo $BASH_VERSION" ]; then
    shell_profile="$HOME/.bashrc"
elif [ -n "echo $FISH_VERSION" ]; then
    shell="fish"
    if [ -d "$XDG_CONFIG_HOME" ]; then
        shell_profile="$XDG_CONFIG_HOME/fish/config.fish"
    else
        shell_profile="$HOME/.config/fish/config.fish"
    fi
fi

# Install all the require packages
echo "Install require package"
sudo apt-get install wget build-essential zlib1g-dev libssl-dev libncurses5-dev libsqlite3-dev libreadline-dev libtk8.6 libgdm-dev libdb4o-cil-dev libpcap-dev -y

# Extract the latest Python version
RESPONSE_BODY=$(curl -s -w "\n%{http_code}" https://python-version-crawler.herokuapp.com/python-stable)
PYTHON_VERSION=$(echo "$RESPONSE_BODY" | sed -E 's/[0-9]{3}$//')

# Download Python3
echo "Download Python3"
(cd ~ && curl -OL "https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz")
EXTRACT_VERSION=${PYTHON_VERSION%.*}

# Installing Python3
echo "Installing Python3"
(cd ~ \
  && tar -xvf Python-$PYTHON_VERSION.tgz \
  && cd Python-$PYTHON_VERSION \
  && ./configure --with-ensurepip=install \
  && make -j8 \
  && sudo make install \
  && alias python3="python$EXTRACT_VERSION" \
  && alias python="python$EXTRACT_VERSION" \
  && cd ~ \
  && rm -rf Python-$PYTHON_VERSION.tgz Python-$PYTHON_VERSION)

# Checking Shell
echo "Checking Shell"
if [ -n "echo $ZSH_VERSION" ]; then
    shell_profile="$HOME/.zshrc"
elif [ -n "echo $BASH_VERSION" ]; then
    shell_profile="$HOME/.bashrc"
elif [ -n "echo $FISH_VERSION" ]; then
    shell="fish"
    if [ -d "$XDG_CONFIG_HOME" ]; then
        shell_profile="$XDG_CONFIG_HOME/fish/config.fish"
    else
        shell_profile="$HOME/.config/fish/config.fish"
    fi
fi

echo "Configuring shell profile in: $shell_profile"
touch "$shell_profile"
if [ "$shell" == "fish" ]; then
    {
        echo '# Python'
        echo "alias python3=python$EXTRACT_VERSION"
        echo "alias python=python$EXTRACT_VERSION"
    } >> "$shell_profile"
else
    {
        echo '# Python'
        echo "alias python3=python$EXTRACT_VERSION"
        echo "alias python=python$EXTRACT_VERSION"
    } >> "$shell_profile"
fi

# Install Python3 PIP
echo "Installing Python3 PIP"
python3 -m pip install --upgrade pip

chsh -s $(which zsh)
zsh
