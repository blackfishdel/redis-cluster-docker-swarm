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

sed -i "s/{{ REDIS_PORT }}/$REDIS_PORT1/g" /root/xiepeng/redis-cluster-docker-swarm/redis-sentinel-native/redis1.conf
sed -i "s/{{ REDIS_PORT }}/$REDIS_PORT2/g" /root/xiepeng/redis-cluster-docker-swarm/redis-sentinel-native/redis2.conf
sed -i "s/{{ REDIS_PORT }}/$REDIS_PORT3/g" /root/xiepeng/redis-cluster-docker-swarm/redis-sentinel-native/redis3.conf

/root/redis-4.0.10/src/redis-server /root/xiepeng/redis-cluster-docker-swarm/redis-sentinel-native/redis1.conf
/root/redis-4.0.10/src/redis-server /root/xiepeng/redis-cluster-docker-swarm/redis-sentinel-native/redis2.conf --slaveof $REDIS_MASTER_IP $REDIS_MASTER_PORT
/root/redis-4.0.10/src/redis-server /root/xiepeng/redis-cluster-docker-swarm/redis-sentinel-native/redis3.conf --slaveof $REDIS_MASTER_IP $REDIS_MASTER_PORT



for i in {1..3} ; do
  sed -i "s/{{ SENTINEL_PORT }}/2638$i/g" /root/xiepeng/redis-cluster-docker-swarm/redis-sentinel-native/sentinel$i.conf
  sed -i "s/{{ REDIS_MASTER_NAME }}/$REDIS_MASTER_NAME/g" /root/xiepeng/redis-cluster-docker-swarm/redis-sentinel-native/sentinel$i.conf
  sed -i "s/{{ REDIS_MASTER_IP }}/$REDIS_MASTER_IP/g" /root/xiepeng/redis-cluster-docker-swarm/redis-sentinel-native/sentinel$i.conf
  sed -i "s/{{ REDIS_MASTER_PORT }}/$REDIS_MASTER_PORT/g" /root/xiepeng/redis-cluster-docker-swarm/redis-sentinel-native/sentine$i.conf

  sed -i "s/{{ SENTINEL_QUORUM }}/$SENTINEL_QUORUM/g" /root/xiepeng/redis-cluster-docker-swarm/redis-sentinel-native/sentine$i.conf
  sed -i "s/{{ SENTINEL_DOWN_AFTER }}/$SENTINEL_DOWN_AFTER/g" /root/xiepeng/redis-cluster-docker-swarm/redis-sentinel-native/sentinel$i.conf
  sed -i "s/{{ SENTINEL_FAILOVER }}/$SENTINEL_FAILOVER/g" /root/xiepeng/redis-cluster-docker-swarm/redis-sentinel-native/sentinel$i.conf

  /root/redis-4.0.10/src/redis-server /root/xiepeng/redis-cluster-docker-swarm/redis-sentinel-native/sentinel$i.conf --sentinel
done