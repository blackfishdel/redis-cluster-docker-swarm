#!/bin/bash

set -ex

echo "Create stand in volume for scripts"
docker create -v /scripts --name scripts alpine:3.6 /bin/true

echo "Moving check_scaling.sh to scripts"
docker cp scripts scripts:/

echo "Starting init tests"
docker run --rm --network redis --volumes-from scripts \
	registry.docker-cn.com/library/redis:4.0.9-alpine sh /scripts/check_scaling.sh 2 2


# docker run --rm --network redis registry.docker-cn.com/library/redis:4.0.9-alpine redis-benchmark -h 10.0.0.12 -p 6379 -c 50 -n 10000
#
# docker run --rm --network redis registry.docker-cn.com/library/redis:4.0.9-alpine redis-benchmark -t set -r 100000 -n 1000000
# docker run --rm --network redis registry.docker-cn.com/library/redis:4.0.9-alpine redis-benchmark -h 10.0.0.12 -r 1000000 -n 2000000 -t get,set,lpush,lpop -P 16 -q > ~/redis-0.log
#
# docker run --rm --network redis registry.docker-cn.com/library/redis:4.0.9-alpine redis-benchmark -h 10.0.0.12 -r 1000000 -n 2000000 -t get,set,lpush,lpop -P 16 -q > ~/redis-1.log
#
# docker run --rm --network redis registry.docker-cn.com/library/redis:4.0.9-alpine redis-benchmark -h 10.0.0.12 -r 1000000 -n 2000000 -t get,set,lpush,lpop -P 16 -q > ~/redis-2.log
# docker run --rm --network redis registry.docker-cn.com/library/redis:4.0.9-alpine redis-benchmark -h 10.0.0.12 -r 1000000 -n 2000000 -t get,set,lpush,lpop -P 16 -q > ~/redis-3.log
