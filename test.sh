#!/bin/bash -ex

# docker run --rm --network redis registry.int.mimikko.cn/redis-utils:latest \
# 	redis-sentinel1 redismaster value ip

# docker run --rm --network redis registry.int.mimikko.cn/redis-utils:$TAG \
# 	$REDIS_SENTINEL_NAME $REDIS_MASTER_NAME value ip
# docker run --rm --network redis registry.int.mimikko.cn/redis-utils:latest \
#   	redis-sentinel1 redismaster \
#   	value "num-slaves"

# docker run --rm --network redis registry.int.mimikko.cn/redis-utils:latest \
# 	redis-sentinel1 redismaster reset "num-slaves" "$((NUM_OF_REDIS - 1))"


# redis-cli -h 139.219.142.114 -p 26380 sentinel master redismaster


# mkdir ~/redis1/redis-data ~/redis2/redis-data ~/redis3/redis-data 


redis-cli -h 192.168.199.85 -p 6379 sentinel master redismaster

redis-cli -h $REDIS_MASTER_IP -p 6379 ping

$(redis-cli -h $ip -p $port sentinel master $master_name | grep -A 1 $key | tail -n1)

redis-cli -h 106.14.213.217 -p 26380 ping

docker build -t registry.int.mimikko.cn/redis-sentinel:latest ../redis-sentinel

redis-cli -h 106.14.213.217 -p 26380 sentinel master redismaster | grep -A 1 "ip" | tail -n 1

redis-cli -h 139.219.142.114 -p 26380 sentinel master redismaster | grep -A 1 "ip" | tail -n 1


139.219.142.114


curl -s -S "https://registry.hub.docker.com/v2/repositories/davidcaste/docker-alpine-java-unlimited-jce/tags/" | jq '."results"[]["name"]' |sort


redis-dump -h 139.219.142.114 -p 6381 -d 2 > ~/Downloads/db.txt

cat ~/Downloads/db.txt | redis-cli -h 139.219.142.114 -p 6381 -n 2


docker run -d --hostname my-rabbit --name some-rabbit docker.mirrors.ustc.edu.cn/library/rabbitmq:3

docker run -d --hostname my-rabbit --name some-rabbit -p 15672:15672 -p 5672:5672 docker.mirrors.ustc.edu.cn/library/rabbitmq:3-management

echo "keys token*" | redis-cli -h 106.14.213.217 -p 6381 -n 2 > ~/keys.csv