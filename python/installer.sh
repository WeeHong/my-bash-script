#!/bin/bash

# Define GOROOT AND GOPATH path
[ -z "$PYTHONROOT" ] && PYTHONROOT="/usr/local/python"

# Define Operating System and Architecture
OS="$(uname -s)"
ARCH="$(uname -m)"

case $OS in
    "Linux")
        case $ARCH in
        "x86_64")
            ARCH=amd64
            ;;
        "aarch64")
            ARCH=arm64
            ;;
        "armv6" | "armv7l")
            ARCH=armv6l
            ;;
        "armv8")
            ARCH=arm64
            ;;
        .*386.*)
            ARCH=386
            ;;
        esac
        PLATFORM="linux-$ARCH"
    ;;
    "Darwin")
        PLATFORM="darwin-amd64"
    ;;
esac

if [ -z "$PLATFORM" ]; then
    echo "Your operating system is not supported by the script."
    exit 1
fi

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
RESPONSE_BODY=$(curl -s -w "\n%{http_code}" https://powerful-ridge-66112.herokuapp.com/python-stable)
PYTHON_VERSION=$(echo "$RESPONSE_BODY" | sed -E 's/[0-9]{3}$//')

# Download Python3
echo "Download Python3"
(cd ~ && curl -OL "https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz")

# Installing Python3
echo "Installing Python3"
(cd ~ \
  && mkdir -p $PYTHONROOT \
  && tar -C $PYTHONROOT -xvf Python-$PYTHON_VERSION.tgz \
  && cd $PYTHONROOT/Python-$PYTHON_VERSION \
  && ./configure --with-ensurepip=install \
  && make -j8 \
  && sudo make install \
  && alias python3=python3.10 \
  && cd ~ \
  && rm -rf Python-$PYTHON_VERSION.tgz)

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
        echo "set PYTHONROOT '${PYTHONROOT}'"
    } >> "$shell_profile"
else
    {
        echo '# Python'
        echo "export PYTHONROOT=${GOROOT}"
        echo 'export PATH=$PYTHONROOT/bin:$PATH'
    } >> "$shell_profile"
fi

# Install Python3 PIP
echo "Installing Python3 PIP"
python3 -m pip install --upgrade pip
