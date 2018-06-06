#!/bin/bash

set -ex

TAG=${1:-"latest"}

echo "Building redis-look"
docker build -t registry.int.mimikko.cn/redis-look:$TAG ../redis-look

echo "Building redis-sentinel"
docker build -t registry.int.mimikko.cn/redis-sentinel:$TAG ../redis-sentinel

echo "Building redis-utils"
docker build -t registry.int.mimikko.cn/redis-utils:$TAG ../redis-utils
