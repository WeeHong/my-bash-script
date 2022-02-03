#!/bin/bash

# Define GOROOT AND GOPATH path
[ -z "$GOROOT" ] && GOROOT="/usr/local/go"
[ -z "$GOPATH" ] && GOPATH="$HOME/workspace/go"

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
if [ -n "$($SHELL -c 'echo $ZSH_VERSION')" ]; then
    shell_profile="$HOME/.zshrc"
elif [ -n "$($SHELL -c 'echo $BASH_VERSION')" ]; then
    shell_profile="$HOME/.bashrc"
elif [ -n "$($SHELL -c 'echo $FISH_VERSION')" ]; then
    shell="fish"
    if [ -d "$XDG_CONFIG_HOME" ]; then
        shell_profile="$XDG_CONFIG_HOME/fish/config.fish"
    else
        shell_profile="$HOME/.config/fish/config.fish"
    fi
fi

# Extract the latest Golang version
RESPONSE_BODY=$(curl -s -w "\n%{http_code}" https://go.dev/VERSION\?m=text)
GOLANG_VERSION=$(echo "$RESPONSE_BODY" | sed -E 's/[0-9]{3}$//')

# Download the latest Golang tape archive for Linux
(cd ~ && curl -OL "https://go.dev/dl/$GOLANG_VERSION.$PLATFORM.tar.gz")

# Change the directory and extract the compress the files
(cd ~ \
  && sudo rm -rf /usr/local/go \
  && tar -C /usr/local -xzf "$GOLANG_VERSION".linux-amd64.tar.gz \
  && sudo rm -rf "$GOLANG_VERSION".linux-amd64.tar.gz)

# Add Golang to the Path environment variable
echo "Configuring shell profile in: $shell_profile"
touch "$shell_profile"
if [ "$shell" == "fish" ]; then
    {
        echo " "
        echo '# GoLang'
        echo "set GOROOT '${GOROOT}'"
        echo "set GOPATH '$GOPATH'"
        echo 'set PATH $GOPATH/bin $GOROOT/bin $PATH'
    } >> "$shell_profile"
else
    {
        echo " "
        echo '# GoLang'
        echo "export GOROOT=${GOROOT}"
        echo 'export PATH=$GOROOT/bin:$PATH'
        echo "export GOPATH=$GOPATH"
        echo 'export PATH=$GOPATH/bin:$PATH'
    } >> "$shell_profile"
fi

mkdir -p "${GOPATH}/"{src, pkg, bin}
