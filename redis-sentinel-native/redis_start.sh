#!/bin/bash -ex

REDIS_PORT1=6381
REDIS_PORT2=6382
REDIS_PORT3=6383

REDIS_MASTER_NAME=redismaster
REDIS_MASTER_IP=$1
REDIS_MASTER_PORT=$REDIS_PORT1
SENTINEL_QUORUM=2
SENTINEL_DOWN_AFTER=1000
SENTINEL_FAILOVER=1000

sed -i "s/{{ REDIS_PORT }}/$REDIS_PORT1/g" ./redis1.conf
sed -i "s/{{ REDIS_PORT }}/$REDIS_PORT2/g" ./redis2.conf
sed -i "s/{{ REDIS_PORT }}/$REDIS_PORT3/g" ./redis3.conf

/root/redis-4.0.10/src/redis-server ./redis1.conf
/root/redis-4.0.10/src/redis-server ./redis2.conf --slaveof $REDIS_MASTER_IP $REDIS_MASTER_PORT
/root/redis-4.0.10/src/redis-server ./redis3.conf --slaveof $REDIS_MASTER_IP $REDIS_MASTER_PORT



for i in {1..3} ; do
  sed -i "s/{{ SENTINEL_PORT }}/2638$i/g" ./sentinel$i.conf
  sed -i "s/{{ REDIS_MASTER_NAME }}/$REDIS_MASTER_NAME/g" ./sentinel$i.conf
  sed -i "s/{{ REDIS_MASTER_IP }}/$REDIS_MASTER_IP/g" ./sentinel$i.conf
  sed -i "s/{{ REDIS_MASTER_PORT }}/$REDIS_MASTER_PORT/g" ./sentine$i.conf

  sed -i "s/{{ SENTINEL_QUORUM }}/$SENTINEL_QUORUM/g" ./sentine$i.conf
  sed -i "s/{{ SENTINEL_DOWN_AFTER }}/$SENTINEL_DOWN_AFTER/g" ./sentinel$i.conf
  sed -i "s/{{ SENTINEL_FAILOVER }}/$SENTINEL_FAILOVER/g" ./sentinel$i.conf

  /root/redis-4.0.10/src/redis-server ./sentinel$i.conf --sentinel
done