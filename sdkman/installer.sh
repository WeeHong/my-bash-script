#!bin/bash
![ -z "$(which zip)" ] && sudo apt-get install -y zip
![ -z "$(which unzip)" ] && sudo apt-get install -y unzip

curl -s "https://get.sdkman.io" | bash

source "$HOME/.sdkman/bin/sdkman-init.sh"
