docker run --rm --network redis registry.int.mimikko.cn/redis-utils:latest \
	redis-sentinel1 redismaster value ip

docker run --rm --network redis registry.int.mimikko.cn/redis-utils:latest \
  	redis-sentinel1 redismaster \
  	value "num-slaves"

docker run --rm --network redis registry.int.mimikko.cn/redis-utils:latest \
	redis-sentinel1 redismaster reset "num-slaves" "$((NUM_OF_REDIS - 1))"


redis-cli -h 139.219.142.114 -p 26380 sentinel master redismaster
