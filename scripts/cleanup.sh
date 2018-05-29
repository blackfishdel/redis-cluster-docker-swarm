#!/bin/bash

set -ex

export TAG=${1:-"latest"}

docker stack rm cache

docker service rm redis-zero 
