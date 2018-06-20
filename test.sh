docker run --rm --network redis registry.int.mimikko.cn/redis-utils:latest \
	redis-sentinel1 redismaster value ip

docker run --rm --network redis registry.int.mimikko.cn/redis-utils:latest \
  	redis-sentinel1 redismaster \
  	value "num-slaves"

docker run --rm --network redis registry.int.mimikko.cn/redis-utils:latest \
	redis-sentinel1 redismaster reset "num-slaves" "$((NUM_OF_REDIS - 1))"  
