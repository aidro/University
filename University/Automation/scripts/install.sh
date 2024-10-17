#!/bin/bash

function install_docker() {
    # Install docker on host machine
    if ! command -v docker 2>&1 >/dev/null
    then
        apt-get install docker -y && apt-get install docker-compose -y
        cd /home/wp
        docker-compose up -d --build
    fi
}

install_docker