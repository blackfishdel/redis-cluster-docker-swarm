#!/bin/bash

set -ex

export TAG=${1:-"latest"}
export REDIS_SENTINEL_IP=192.168.199.85
export REDIS_SENTINEL_PORT=26380

echo "Starting redis-zero"
# docker service create --network redis --publish 6379:6379 --name redis-zero registry.docker-cn.com/library/redis:4.0.9-alpine
docker service create --publish 6379:6379 --name redis-zero registry.docker-cn.com/library/redis:4.0.9-alpine

sleep 10

echo "Starting services"
docker stack deploy -c docker-compose.yml cache

sleep 10

until [ "$(redis-cli -h $REDIS_SENTINEL_IP -p $REDIS_SENTINEL_PORT ping)" = "PONG" ]; do
    echo "$REDIS_SENTINEL_IP:$REDIS_SENTINEL_PORT is unavailable - sleeping"
    sleep 2
done

echo "$(redis-cli -h $REDIS_SENTINEL_IP -p $REDIS_SENTINEL_PORT info)"


echo "Removing redis-zero"
docker service rm redis-zero

sleep 10
redis-cli -h $REDIS_SENTINEL_IP -p $REDIS_SENTINEL_PORT sentinel reset $REDIS_MASTER_NAME

