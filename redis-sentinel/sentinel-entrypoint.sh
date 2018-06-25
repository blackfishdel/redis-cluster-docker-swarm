#!/bin/sh

sed -i "s/{{ SENTINEL_QUORUM }}/$SENTINEL_QUORUM/g" /redis/sentinel.conf
sed -i "s/{{ SENTINEL_DOWN_AFTER }}/$SENTINEL_DOWN_AFTER/g" /redis/sentinel.conf
sed -i "s/{{ SENTINEL_FAILOVER }}/$SENTINEL_FAILOVER/g" /redis/sentinel.conf
sed -i "s/{{ REDIS_MASTER_NAME }}/$REDIS_MASTER_NAME/g" /redis/sentinel.conf
sed -i "s/{{ REDIS_MASTER_IP }}/$REDIS_MASTER_IP/g" /redis/sentinel.conf
sed -i "s/{{ REDIS_MASTER_PORT }}/$REDIS_MASTER_PORT/g" /redis/sentinel.conf

until [ "$(redis-cli -h $REDIS_MASTER_IP -p $REDIS_MASTER_PORT ping)" = "PONG" ]; do
	echo "redis-cli -h $REDIS_MASTER_IP -p $REDIS_MASTER_PORT ping"
    echo "$REDIS_MASTER_IP is unavailable - sleeping"
    sleep 1
done


redis-server /redis/sentinel.conf --sentinel
