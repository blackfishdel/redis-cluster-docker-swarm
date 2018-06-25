#!/bin/bash

set -ex

NUM_OF_SENTINELS=3
NUM_OF_REDIS=3

REDIS_SENTINEL_NAME="redis-sentinel"
REDIS_MASTER_NAME="redismaster"

export TAG=${1:-"latest"}
export REDIS_SENTINEL_IP=106.14.213.217
export REDIS_SENTINEL_PORT=26380

echo "Starting redis-zero"
# docker service create --network redis --publish 6379:6379 --name redis-zero docker.mirrors.ustc.edu.cn/library/redis:4.0.9-alpine
docker service create --publish 6379:6379 --name redis-zero docker.mirrors.ustc.edu.cn/library/redis:4.0.9-alpine

sleep 2

echo "Starting services"
docker stack deploy -c docker-compose.yml cache

sleep 2

until [ "$(redis-cli -h $REDIS_SENTINEL_IP -p $REDIS_SENTINEL_PORT ping)" = "PONG" ]; do
	echo "Sentinels not set up yet - sleeping"
	sleep 2
done

until [ "$(redis-cli -h $REDIS_SENTINEL_IP -p $REDIS_SENTINEL_PORT sentinel master redismaster \
 | grep -A 1 "num-other-sentinels" | tail -n 1)" = "$((NUM_OF_SENTINELS - 1))" ]; do
	echo "Sentinels not set up yet - sleeping"
	sleep 2
done

until [ "$(redis-cli -h $REDIS_SENTINEL_IP -p $REDIS_SENTINEL_PORT sentinel master redismaster \
 | grep -A 1 "num-slaves" | tail -n 1)" = "$NUM_OF_REDIS" ]; do
	echo "Slaves not set up yet - sleeping"
	sleep 2
done

old_master=$(redis-cli -h $REDIS_SENTINEL_IP -p $REDIS_SENTINEL_PORT sentinel master redismaster | grep -A 1 "ip" | tail -n 1)
echo "redis-zero ip is ${old_master}"

echo "Removing redis-zero"
docker service rm redis-zero

sleep 2

redis-cli -h $REDIS_SENTINEL_IP -p $REDIS_SENTINEL_PORT sentinel reset $REDIS_MASTER_NAME

