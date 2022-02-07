#!/bin/bash
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
        echo -e '\n'
        echo '# Python'
        echo "alias python3="python$EXTRACT_VERSION""
        echo "alias python="python$EXTRACT_VERSION"
    } >> "$shell_profile"
else
    {
        echo -e '\n'
        echo '# Python'
        echo "alias python3="python$EXTRACT_VERSION""
        echo "alias python="python$EXTRACT_VERSION"
    } >> "$shell_profile"
fi
