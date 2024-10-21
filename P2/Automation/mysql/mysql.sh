#!/bin/bash

docker network create --driver bridge --subnet 10.0.0.0/24 --gateway 10.0.0.1 network-opdr-1
docker network create --driver bridge --subnet 10.10.0.0/24 --gateway 10.10.0.1 network-opdr-2

docker run -d -p 6379:6379 --name server1 \
  --network network-opdr-1 mysql:latest

docker run -d -p 6444:6444 --name server2 \
  --network network-opdr-2 mysql:latest

docker network connect network-opdr-2 server1
docker network connect network-opdr-1 server2

docker container ls -a