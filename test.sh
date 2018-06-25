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