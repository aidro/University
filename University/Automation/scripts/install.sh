#!/bin/bash

# Install docker
function docker() {
    # Install docker on host machine
    if ! command -v docker 2>&1 >/dev/null
    then
        sudo apt-get install docker -y && sudo apt-get install docker-compose -y
    fi
}

docker