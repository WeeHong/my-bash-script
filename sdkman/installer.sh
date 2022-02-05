#!bin/bash
if [ -n "$(which zip)" ]; then
    sudo apt-get install -y zip
fi

if [ -n "$(which unzip)" ]; then
    sudo apt-get install -y unzip
fi

curl -s "https://get.sdkman.io" | bash

source "$HOME/.sdkman/bin/sdkman-init.sh"
