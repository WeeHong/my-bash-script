#!/bin/bash
golang_installation() {
# Extract the latest Golang version
RESPONSE_BODY=$(curl -s -w "\n%{http_code}" https://go.dev/VERSION\?m=text)
GOLANG_VERSION=$(echo "$RESPONSE_BODY" | sed -E 's/[0-9]{3}$//')

# Download the latest Golang tape archive for Linux
curl -O "https://go.dev/dl/$GOLANG_VERSION.linux-amd64.tar.gz"

# Change the directory and extract the compress the files
sudo rm -rf /usr/local/go && tar -C /usr/local -xzf "$GOLANG_VERSION".linux-amd64.tar.gz

# Add Golang to the Path environment variable
export PATH=$PATH:/usr/local/go/bin

# export GOPATH="/mnt/c/Users/${user}/directory/to/your/golang/workspace"
}

(cd ~ || exit && golang_installation)
